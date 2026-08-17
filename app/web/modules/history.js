(() => {
  'use strict';

  const DB_NAME = 'myninja-control-center-v5';
  const STORE = 'events';
  const MAX_PER_CHAR = 3000;
  const MAX_TOTAL = 10000;
  const MAX_AGE_DAYS = 30;
  const PRUNE_EVERY = 50;

  let dbPromise = null;
  let writes = 0;
  let quotaWarned = false;

  function openDB() {
    if (!('indexedDB' in window)) return Promise.resolve(null);
    if (dbPromise) return dbPromise;
    dbPromise = new Promise((resolve, reject) => {
      const req = indexedDB.open(DB_NAME, 1);
      req.onupgradeneeded = () => {
        const db = req.result;
        const store = db.createObjectStore(STORE, { keyPath: 'key' });
        store.createIndex('char_ts', ['char_id', 'ts']);
        store.createIndex('ts', 'ts');
        store.createIndex('type', 'type');
      };
      req.onsuccess = () => resolve(req.result);
      req.onerror = () => reject(req.error);
      req.onblocked = () => reject(new Error('IndexedDB upgrade blocked by another tab'));
    });
    return dbPromise;
  }

  function charRange(charId) {
    return IDBKeyRange.bound([Number(charId), 0], [Number(charId), Number.MAX_VALUE]);
  }

  function txDone(tx) {
    return new Promise((resolve, reject) => {
      tx.oncomplete = () => resolve();
      tx.onerror = () => reject(tx.error || new Error('IndexedDB transaction failed'));
      tx.onabort = () => reject(tx.error || new Error('IndexedDB transaction aborted'));
    });
  }

  async function rawPut(event) {
    const db = await openDB();
    if (!db || !event?.key) return;
    const tx = db.transaction(STORE, 'readwrite');
    tx.objectStore(STORE).put(event);
    await txDone(tx);
  }

  async function countForChar(charId) {
    const db = await openDB(); if (!db) return 0;
    return new Promise(resolve => {
      const tx = db.transaction(STORE, 'readonly');
      const req = tx.objectStore(STORE).index('char_ts').count(charRange(charId));
      req.onsuccess = () => resolve(Number(req.result || 0));
      req.onerror = () => resolve(0);
    });
  }

  async function pruneCharacter(charId, aggressive = false) {
    const db = await openDB(); if (!db || !charId) return;
    const count = await countForChar(charId);
    let excess = Math.max(0, count - (aggressive ? Math.floor(MAX_PER_CHAR * 0.7) : MAX_PER_CHAR));
    const cutoff = Date.now() / 1000 - MAX_AGE_DAYS * 86400;

    const tx = db.transaction(STORE, 'readwrite');
    const idx = tx.objectStore(STORE).index('char_ts');
    idx.openCursor(charRange(charId), 'next').onsuccess = event => {
      const cursor = event.target.result;
      if (!cursor) return;
      const expired = Number(cursor.value?.ts || 0) < cutoff;
      if (expired || excess > 0) {
        cursor.delete();
        if (excess > 0) excess -= 1;
      }
      cursor.continue();
    };
    await txDone(tx).catch(() => {});
  }

  async function pruneGlobal() {
    const db = await openDB(); if (!db) return;
    const total = await new Promise(resolve => {
      const tx = db.transaction(STORE, 'readonly');
      const req = tx.objectStore(STORE).count();
      req.onsuccess = () => resolve(Number(req.result || 0));
      req.onerror = () => resolve(0);
    });
    let remove = Math.max(0, total - MAX_TOTAL);
    if (!remove) return;
    const tx = db.transaction(STORE, 'readwrite');
    tx.objectStore(STORE).index('ts').openCursor(null, 'next').onsuccess = event => {
      const cursor = event.target.result;
      if (!cursor || remove <= 0) return;
      cursor.delete();
      remove -= 1;
      cursor.continue();
    };
    await txDone(tx).catch(() => {});
  }

  async function put(event) {
    if (!event?.key) return;
    try {
      await rawPut(event);
    } catch (error) {
      if (error?.name !== 'QuotaExceededError') return;
      await pruneCharacter(event.char_id, true);
      await pruneGlobal();
      try {
        await rawPut(event);
      } catch (_) {
        if (!quotaWarned) {
          quotaWarned = true;
          window.NinjaUI?.toast?.('Flight Recorder storage penuh; event lama sudah dipangkas.', 'warn');
        }
        return;
      }
    }

    writes += 1;
    if (writes % PRUNE_EVERY === 0) {
      await pruneCharacter(event.char_id);
      if (writes % (PRUNE_EVERY * 4) === 0) await pruneGlobal();
    }
  }

  async function recent(charId, limit = 200) {
    const db = await openDB(); if (!db) return [];
    const safeLimit = Math.max(1, Math.min(MAX_PER_CHAR, Number(limit) || 200));
    return new Promise(resolve => {
      const tx = db.transaction(STORE, 'readonly');
      const index = tx.objectStore(STORE).index(charId ? 'char_ts' : 'ts');
      const range = charId ? charRange(charId) : null;
      const result = [];
      index.openCursor(range, 'prev').onsuccess = event => {
        const cursor = event.target.result;
        if (!cursor || result.length >= safeLimit) return resolve(result);
        result.push(cursor.value);
        cursor.continue();
      };
      tx.onerror = () => resolve(result);
    });
  }

  async function levelSamples(charId, limit = 120) {
    const rows = await recent(charId, Math.min(MAX_PER_CHAR, Math.max(500, limit * 10)));
    return rows.filter(x => x.type === 'STAT_SAMPLE' && Number.isFinite(Number(x.data?.level))).slice(0, limit);
  }

  async function clear(charId) {
    const db = await openDB(); if (!db || !charId) return;
    const tx = db.transaction(STORE, 'readwrite');
    const idx = tx.objectStore(STORE).index('char_ts');
    idx.openCursor(charRange(charId), 'next').onsuccess = event => {
      const cursor = event.target.result;
      if (!cursor) return;
      cursor.delete();
      cursor.continue();
    };
    await txDone(tx).catch(() => {});
  }

  async function recordBackend(event, explicitJobStartedAt = null) {
    const s = window.NinjaSession?.get?.();
    if (!s?.char_id || !event) return;
    const seq = Number(event.seq || 0);
    const jobStartedAt = Number(event.job_started_at || explicitJobStartedAt || 0);
    const stamp = jobStartedAt || Number(event.ts || Date.now() / 1000);
    await put({
      key: `backend:${s.char_id}:${stamp}:${seq || event.ts}:${event.type}`,
      char_id: Number(s.char_id),
      ts: Number(event.ts || Date.now() / 1000),
      type: event.type || 'EVENT',
      level: event.level || 'info',
      data: event.data || {},
      job_started_at: jobStartedAt || null,
    });
  }

  async function recordStatus(job) {
    if (!job) return;
    for (const event of job.events || []) await recordBackend(event, job.created_at);
  }

  async function recordStats(stats) {
    const s = window.NinjaSession?.get?.(); if (!s?.char_id) return;
    const ts = Date.now() / 1000;
    await put({
      key: `stats:${s.char_id}:${Math.floor(ts * 1000)}`,
      char_id: Number(s.char_id),
      ts,
      type: 'STAT_SAMPLE',
      level: 'info',
      data: {
        level: Number(stats.level ?? s.level),
        xp: Number(stats.xp ?? s.xp),
        gold: Number(stats.gold ?? s.gold),
        tokens: Number(stats.tokens ?? s.tokens),
      },
    });
  }

  async function storageInfo() {
    if (!navigator.storage?.estimate) return { supported: false };
    const estimate = await navigator.storage.estimate();
    return {
      supported: true,
      usage: Number(estimate.usage || 0),
      quota: Number(estimate.quota || 0),
      persisted: navigator.storage.persisted ? await navigator.storage.persisted() : false,
    };
  }

  async function requestPersistence() {
    if (!navigator.storage?.persist) return false;
    return Boolean(await navigator.storage.persist());
  }

  function bytes(n) {
    const value = Number(n || 0);
    if (value < 1024) return `${value} B`;
    if (value < 1024 ** 2) return `${(value / 1024).toFixed(1)} KB`;
    return `${(value / 1024 ** 2).toFixed(1)} MB`;
  }

  async function ensureUI() {
    if (document.getElementById('modal-history')) return;
    const settings = document.getElementById('btn-settings'); if (!settings) return;

    const btn = document.createElement('button');
    btn.id = 'btn-history';
    btn.className = 'btn btn-toggle';
    btn.title = 'Flight Recorder';
    btn.innerHTML = '<i class="fa-solid fa-timeline"></i>';
    settings.insertAdjacentElement('afterend', btn);

    const modal = document.createElement('div');
    modal.id = 'modal-history';
    modal.className = 'modal-overlay';
    modal.innerHTML = `
      <div class="modal-content glass-panel ns-history-modal">
        <div class="modal-header">
          <h3><i class="fa-solid fa-timeline"></i> Flight Recorder</h3>
          <button class="btn-close" type="button">&times;</button>
        </div>
        <div id="ns-history-storage" class="ns-history-storage">Storage: checking…</div>
        <div class="ns-history-actions">
          <button id="ns-history-persist" class="btn btn-toggle" type="button">Protect History</button>
          <button id="ns-history-export" class="btn btn-toggle" type="button">Export JSON</button>
          <button id="ns-history-clear" class="btn btn-toggle" type="button">Clear</button>
        </div>
        <div id="ns-history-list" class="ns-history-list"></div>
      </div>`;
    document.body.appendChild(modal);

    async function renderStorage() {
      const el = document.getElementById('ns-history-storage');
      if (!el) return;
      const info = await storageInfo().catch(() => ({ supported: false }));
      if (!info.supported) {
        el.textContent = 'Storage estimate unavailable on this browser.';
        return;
      }
      const pct = info.quota ? Math.min(100, (info.usage / info.quota) * 100) : 0;
      el.textContent = `Storage ${bytes(info.usage)} / ${bytes(info.quota)} (${pct.toFixed(1)}%) · ${info.persisted ? 'persistent' : 'best effort'}`;
    }

    async function render() {
      const s = window.NinjaSession?.get?.();
      const rows = await recent(s?.char_id, 180);
      const list = document.getElementById('ns-history-list');
      if (list) {
        list.innerHTML = rows.map(r => `
          <div class="ns-history-row" data-level="${r.level || 'info'}">
            <time>${new Date(r.ts * 1000).toLocaleTimeString()}</time>
            <strong>${r.type}</strong>
            <span>${String(r.data?.message || r.data?.state || r.data?.label || '').slice(0, 160)}</span>
          </div>`).join('') || '<p class="ns-empty">Belum ada event.</p>';
      }
      await renderStorage();
    }

    btn.onclick = async () => { modal.classList.add('show'); await render(); };
    modal.querySelector('.btn-close').onclick = () => modal.classList.remove('show');

    document.getElementById('ns-history-persist').onclick = async () => {
      const granted = await requestPersistence().catch(() => false);
      window.NinjaUI?.toast?.(granted ? 'Browser akan mempertahankan history bila memungkinkan.' : 'Persistent storage belum diberikan browser.', granted ? 'info' : 'warn');
      await renderStorage();
    };

    document.getElementById('ns-history-export').onclick = async () => {
      const s = window.NinjaSession?.get?.();
      const rows = await recent(s?.char_id, MAX_PER_CHAR);
      const payload = {
        exported_at: new Date().toISOString(),
        char_id: s?.char_id || null,
        retention: { max_per_character: MAX_PER_CHAR, max_age_days: MAX_AGE_DAYS },
        events: rows,
      };
      const blob = new Blob([JSON.stringify(payload, null, 2)], { type: 'application/json' });
      const a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = `ninja-history-${s?.char_id || 'profile'}-${Date.now()}.json`;
      a.click();
      setTimeout(() => URL.revokeObjectURL(a.href), 1000);
    };

    document.getElementById('ns-history-clear').onclick = async () => {
      const s = window.NinjaSession?.get?.();
      if (confirm('Hapus history lokal karakter ini?')) {
        await clear(s?.char_id);
        await render();
      }
    };
  }

  window.addEventListener('ns:cloud-event', e => recordBackend(e.detail));
  window.addEventListener('ns:cloud-status', e => recordStatus(e.detail));
  window.addEventListener('ns:account-stats', e => recordStats(e.detail));
  document.addEventListener('DOMContentLoaded', ensureUI);

  window.NinjaHistory = { recent, levelSamples, clear, recordBackend, storageInfo, requestPersistence };
})();