(() => {
  'use strict';
  const DB_NAME = 'myninja-control-center-v5';
  const STORE = 'events';
  const MAX_EVENTS = 5000;
  let dbPromise = null;
  let writes = 0;

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
    });
    return dbPromise;
  }
  async function put(event) {
    const db = await openDB(); if (!db || !event?.key) return;
    await new Promise(resolve => {
      const tx = db.transaction(STORE, 'readwrite');
      tx.objectStore(STORE).put(event);
      tx.oncomplete = resolve; tx.onerror = resolve;
    });
    writes += 1;
    if (writes % 100 === 0) {
      const count = await new Promise(resolve => { const tx=db.transaction(STORE,'readonly'); const req=tx.objectStore(STORE).count(); req.onsuccess=()=>resolve(req.result||0); req.onerror=()=>resolve(0); });
      let remove = Math.max(0, count - MAX_EVENTS);
      if (remove) await new Promise(resolve => { const tx=db.transaction(STORE,'readwrite'); const idx=tx.objectStore(STORE).index('ts'); idx.openCursor().onsuccess=e=>{const c=e.target.result;if(!c||remove<=0)return;c.delete();remove--;c.continue();};tx.oncomplete=resolve;tx.onerror=resolve; });
    }
  }
  async function recent(charId, limit = 200) {
    const db = await openDB(); if (!db) return [];
    return new Promise(resolve => {
      const tx = db.transaction(STORE, 'readonly');
      const index = tx.objectStore(STORE).index('ts');
      const result = [];
      index.openCursor(null, 'prev').onsuccess = e => {
        const c = e.target.result;
        if (!c || result.length >= limit) return resolve(result);
        if (!charId || Number(c.value.char_id) === Number(charId)) result.push(c.value);
        c.continue();
      };
    });
  }
  async function levelSamples(charId, limit = 100) {
    return (await recent(charId, 1000)).filter(x => x.type === 'STAT_SAMPLE' && Number.isFinite(Number(x.data?.level))).slice(0, limit);
  }
  async function clear(charId) {
    const db = await openDB(); if (!db) return;
    const rows = await recent(charId, MAX_EVENTS + 1000);
    await new Promise(resolve => {
      const tx = db.transaction(STORE, 'readwrite');
      const store = tx.objectStore(STORE); rows.forEach(r => store.delete(r.key));
      tx.oncomplete = resolve; tx.onerror = resolve;
    });
  }
  async function recordBackend(event) {
    const s = window.NinjaSession?.get?.(); if (!s?.char_id || !event) return;
    const seq = Number(event.seq || 0);
    await put({ key: `backend:${s.char_id}:${seq || event.ts}:${event.type}`, char_id: Number(s.char_id), ts: Number(event.ts || Date.now()/1000), type: event.type || 'EVENT', level: event.level || 'info', data: event.data || {} });
  }
  async function recordStatus(job) {
    if (!job) return;
    for (const event of job.events || []) await recordBackend(event);
  }
  async function recordStats(stats) {
    const s = window.NinjaSession?.get?.(); if (!s?.char_id) return;
    const ts = Date.now()/1000;
    await put({ key: `stats:${s.char_id}:${Math.floor(ts)}`, char_id: Number(s.char_id), ts, type: 'STAT_SAMPLE', level: 'info', data: { level: Number(stats.level ?? s.level), xp: Number(stats.xp ?? s.xp), gold: Number(stats.gold ?? s.gold) } });
  }
  async function ensureUI() {
    if (document.getElementById('modal-history')) return;
    const settings = document.getElementById('btn-settings'); if (!settings) return;
    const btn = document.createElement('button'); btn.id='btn-history'; btn.className='btn btn-toggle'; btn.title='Flight Recorder'; btn.innerHTML='<i class="fa-solid fa-timeline"></i>';
    settings.insertAdjacentElement('afterend', btn);
    const modal=document.createElement('div'); modal.id='modal-history'; modal.className='modal-overlay';
    modal.innerHTML=`<div class="modal-content glass-panel ns-history-modal"><div class="modal-header"><h3><i class="fa-solid fa-timeline"></i> Flight Recorder</h3><button class="btn-close">&times;</button></div><div class="ns-history-actions"><button id="ns-history-export" class="btn btn-toggle">Export JSON</button><button id="ns-history-clear" class="btn btn-toggle">Clear</button></div><div id="ns-history-list" class="ns-history-list"></div></div>`;
    document.body.appendChild(modal);
    async function render(){ const s=window.NinjaSession?.get?.(); const rows=await recent(s?.char_id,150); const list=document.getElementById('ns-history-list'); if(list) list.innerHTML=rows.map(r=>`<div class="ns-history-row"><time>${new Date(r.ts*1000).toLocaleTimeString()}</time><strong>${r.type}</strong><span>${String(r.data?.message || r.data?.state || r.data?.label || '').slice(0,120)}</span></div>`).join('') || '<p class="ns-empty">Belum ada event.</p>'; }
    btn.onclick=async()=>{modal.classList.add('show'); await render();}; modal.querySelector('.btn-close').onclick=()=>modal.classList.remove('show');
    document.getElementById('ns-history-export').onclick=async()=>{const s=window.NinjaSession?.get?.(); const rows=await recent(s?.char_id,MAX_EVENTS); const blob=new Blob([JSON.stringify(rows,null,2)],{type:'application/json'}); const a=document.createElement('a'); a.href=URL.createObjectURL(blob); a.download=`ninja-history-${s?.char_id||'profile'}.json`; a.click(); setTimeout(()=>URL.revokeObjectURL(a.href),1000);};
    document.getElementById('ns-history-clear').onclick=async()=>{const s=window.NinjaSession?.get?.(); if(confirm('Hapus history lokal karakter ini?')){await clear(s?.char_id); await render();}};
  }
  window.addEventListener('ns:cloud-event', e=>recordBackend(e.detail));
  window.addEventListener('ns:cloud-status', e=>recordStatus(e.detail));
  window.addEventListener('ns:account-stats', e=>recordStats(e.detail));
  document.addEventListener('DOMContentLoaded', ensureUI);
  window.NinjaHistory={recent,levelSamples,clear,recordBackend};
})();
