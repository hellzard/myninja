(() => {
  'use strict';

  window.__nsCloudController = true;

  const CLOUD_ENDPOINT = '/api/bot/cloud';
  const VISIBLE_POLL_MS = 3000;
  const HIDDEN_POLL_MS = 15000;
  const MIN_IDLE_STATS_MS = 30000;

  const botDefinitions = {
    'toggle-autolevel': {
      type: 'auto_level', label: 'Auto Leveling',
      params: () => ({ max_level: parseInt(document.getElementById('auto_level_max')?.value || '0', 10) || null }),
    },
    'toggle-autodaily': { type: 'auto_daily', label: 'Auto Daily', params: () => ({}) },
    'toggle-autohunting': { type: 'auto_hunting', label: 'Auto Hunting', params: () => ({}) },
    'btnAutoEudemon': { type: 'eudemon', label: 'Auto Eudemon', params: () => ({}) },
    'toggle-autocircus': {
      type: 'circus', label: 'Circus Event',
      params: () => ({ boss_type: document.getElementById('circus-boss-id')?.value || 'ringmaster' }),
    },
    'toggle-autoyokai': {
      type: 'yokai', label: 'Yokai Event',
      params: () => ({ boss_type: document.getElementById('yokai-boss-id')?.value || 'kitsune' }),
    },
    'toggle-autoyokaiminigame': { type: 'yokai_minigame', label: 'Yokai Minigame', params: () => ({}) },
    'toggle-autoshadowwar': { type: 'shadow_war', label: 'Shadow War', params: () => ({}) },
    'toggle-automonster': { type: 'monster', label: 'Monster Hunter', params: () => ({}) },
    'toggle-automissions': { type: 'mission_s', label: 'Mission S', params: () => ({}) },
    'toggle-autoclanwar': { type: 'clan_war', label: 'Clan War', params: () => ({}) },
    'toggle-automission-farmer': {
      type: 'mission', label: 'Auto-Mission Farmer',
      params: () => ({ mission_id: document.getElementById('auto_mission_id')?.value?.trim() || '' }),
      validate: params => params.mission_id ? null : 'Please choose/enter a mission first.',
    },
  };

  let activeBotType = null;
  let pollTimer = null;
  let statsTimer = null;
  let lastLogSeq = 0;
  let lastSessionGeneration = -1;
  let lastStatsRefreshAt = 0;
  let statusBusy = false;
  let statsBusy = false;

  function getSession() {
    try { return JSON.parse(localStorage.getItem('ns_session') || 'null'); }
    catch (_) { return null; }
  }

  function saveSession(session) {
    if (session) localStorage.setItem('ns_session', JSON.stringify(session));
  }

  function getQuickLogin() {
    try {
      const value = JSON.parse(sessionStorage.getItem('ns_quick_login') || 'null');
      if (!value) return null;
      const username = value.username || value.user;
      const password = value.password || value.pass;
      return username && password ? { username, password } : null;
    } catch (_) { return null; }
  }

  function controlStorageKey(charId) { return `ns_cloud_control_${charId}`; }
  function getControl(charId) {
    try { return JSON.parse(localStorage.getItem(controlStorageKey(charId)) || 'null'); }
    catch (_) { return null; }
  }

  function saveControl(charId, value) {
    if (!value) localStorage.removeItem(controlStorageKey(charId));
    else localStorage.setItem(controlStorageKey(charId), JSON.stringify(value));
  }


  function formatLogTime(epochSeconds) {
    const date = epochSeconds ? new Date(Number(epochSeconds) * 1000) : new Date();
    if (Number.isNaN(date.getTime())) return '--:--:--';
    return [date.getHours(), date.getMinutes(), date.getSeconds()]
      .map(v => String(v).padStart(2, '0')).join(':');
  }

  function appendLog(message, level = 'info', epochSeconds = null) {
    const activityLog = document.getElementById('activity-log');
    if (!activityLog) return;

    const li = document.createElement('li');
    li.className = 'log-entry';
    const timeSpan = document.createElement('div');
    timeSpan.className = 'log-time';
    timeSpan.textContent = formatLogTime(epochSeconds);

    const dot = document.createElement('div');
    const dotLevel = level === 'error' ? 'err' : (level === 'warn' ? 'warn' : 'ok');
    dot.className = `log-dot ${dotLevel}`;

    const msgDiv = document.createElement('div');
    msgDiv.className = `log-msg ${level === 'error' ? 'error' : ''}`;
    msgDiv.textContent = `[Cloud] ${message}`;

    li.append(timeSpan, dot, msgDiv);
    activityLog.appendChild(li);
    while (activityLog.children.length > 120) activityLog.removeChild(activityLog.firstChild);
    const terminal = document.getElementById('terminal-window');
    if (terminal && !document.hidden) terminal.scrollTop = terminal.scrollHeight;
  }

  async function post(path, payload) {
    const response = await fetch(`${CLOUD_ENDPOINT}/${path}`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload),
    });
    let data = null;
    try { data = await response.json(); } catch (_) {}
    if (!response.ok) {
      const error = new Error(data?.detail || data?.message || `HTTP ${response.status}`);
      error.status = response.status;
      throw error;
    }
    return data;
  }

  function buttonForType(type) {
    const entry = Object.entries(botDefinitions).find(([, def]) => def.type === type);
    return entry ? document.getElementById(entry[0]) : null;
  }

  function resetButtons() {
    Object.keys(botDefinitions).forEach(id => {
      document.querySelectorAll(`#${CSS.escape(id)}`).forEach(btn => {
        btn.textContent = 'START';
        btn.style.background = '';
        btn.disabled = false;
      });
    });
  }

  function updateStatsUI(stats = {}) {
    const mapping = { level: 'metric-level', xp: 'metric-xp', gold: 'metric-gold', tokens: 'metric-token' };
    const session = getSession();
    if (!session) return;
    let changed = false;
    for (const [key, id] of Object.entries(mapping)) {
      const value = stats[key];
      if (value === undefined || value === null || value === '' || value === '--') continue;
      const el = document.getElementById(id);
      if (el) el.textContent = value;
      session[key] = value;
      changed = true;
    }
    if (changed) saveSession(session);
  }

  function updateStatsFromMessage(message) {
    if (!message) return;
    const stats = {};
    const patterns = {
      level: /\bLevel:\s*(\d+)/i,
      xp: /\bTotal XP:\s*([\d,.]+)/i,
      gold: /\bTotal Gold:\s*([\d,.]+)/i,
      tokens: /\bTotal Token:\s*([\d,.]+)/i,
    };
    for (const [key, regex] of Object.entries(patterns)) {
      const match = String(message).match(regex);
      if (match?.[1]) stats[key] = match[1].replace(/[,.]/g, '');
    }
    updateStatsUI(stats);
  }

  function syncRecoveredSession(job) {
    const update = job?.session_update;
    if (!update || !update.sessionkey) return;
    const generation = Number(update.generation ?? job.session_generation ?? 0);
    if (generation <= lastSessionGeneration) return;
    lastSessionGeneration = generation;
    const session = getSession();
    if (!session || Number(session.char_id) !== Number(job.char_id)) return;
    session.sessionkey = update.sessionkey;
    ['level', 'xp', 'gold', 'tokens'].forEach(k => {
      if (update[k] !== undefined && update[k] !== null && update[k] !== '--') session[k] = update[k];
    });
    saveSession(session);
    updateStatsUI(update);
    appendLog('Browser session synchronized with the recovered server session.', 'info');
  }

  function renderStatus(job) {
    const statusText = document.getElementById('bot-status-text');
    const stopGlobalBtn = document.getElementById('global-stop-btn');
    const session = getSession();
    resetButtons();

    if (job?.running) {
      activeBotType = job.bot_type;
      const btn = buttonForType(job.bot_type);
      if (btn) { btn.textContent = 'STOP'; btn.style.background = '#ff5252'; }
      const def = Object.values(botDefinitions).find(d => d.type === job.bot_type);
      if (statusText) {
        statusText.textContent = `Running on server: ${def?.label || job.bot_type}`;
        statusText.style.color = '#10b981';
      }
      if (stopGlobalBtn) stopGlobalBtn.classList.remove('hidden');
    } else {
      activeBotType = null;
      if (statusText) {
        statusText.textContent = 'Idle - No cloud bot is currently running.';
        statusText.style.color = '#eee';
      }
      if (stopGlobalBtn) stopGlobalBtn.classList.add('hidden');
    }

    syncRecoveredSession(job);

    if (Array.isArray(job?.logs)) {
      for (const entry of job.logs) {
        const seq = Number(entry.seq || 0);
        if (seq <= lastLogSeq) continue;
        lastLogSeq = Math.max(lastLogSeq, seq);
        appendLog(entry.message, entry.level || 'info', entry.ts || (entry.ts_ms ? entry.ts_ms / 1000 : null));
        updateStatsFromMessage(entry.message);
      }
    }
  }

  async function startCloudBot(def, button) {
    const session = getSession();
    if (!session?.sessionkey || !session?.char_id) { appendLog('Please login first.', 'error'); return; }
    const params = def.params ? def.params() : {};
    const validation = def.validate?.(params);
    if (validation) { appendLog(validation, 'error'); return; }

    button.disabled = true;
    try {
      const response = await post('start', {
        sessionkey: session.sessionkey,
        char_id: session.char_id,
        bot_type: def.type,
        params,
        credentials: getQuickLogin(),
      });
      const job = response.job;
      saveControl(session.char_id, { char_id: session.char_id, token: job.control_token, bot_type: job.bot_type });
      lastLogSeq = 0;
      renderStatus(job);
      appendLog(`${def.label} handed off to the server. You may close this tab.`);
      restartPolling();
    } catch (error) {
      appendLog(`Failed to start ${def.label}: ${error.message}`, 'error');
    } finally { button.disabled = false; }
  }

  async function stopCurrentCloudBot() {
    const session = getSession();
    if (!session?.char_id) return;
    const control = getControl(session.char_id);
    if (!control?.token) { renderStatus({ running: false, logs: [] }); return; }
    try {
      const response = await post('stop', { char_id: session.char_id, control_token: control.token });
      renderStatus(response.job);
      appendLog('Cloud bot stopped.');
    } catch (error) {
      appendLog(`Failed to stop cloud bot: ${error.message}`, 'error');
    } finally {
      saveControl(session.char_id, null);
      activeBotType = null;
    }
  }

  async function refreshCloudStatus() {
    if (statusBusy) return;
    const session = getSession();
    if (!session?.char_id) return;
    const control = getControl(session.char_id);
    if (!control?.token) return;
    statusBusy = true;
    try {
      const response = await post('status', { char_id: session.char_id, control_token: control.token });
      renderStatus(response.job);
      if (!response.job?.running) saveControl(session.char_id, null);
    } catch (error) {
      if (error?.status === 403 || error?.status === 404) {
        appendLog(`Cloud control expired: ${error.message}`, 'warn');
        saveControl(session.char_id, null);
        renderStatus({ running: false, logs: [] });
      } else {
        appendLog(`Cloud status temporarily unavailable: ${error.message}. Retrying automatically.`, 'warn');
      }
    } finally { statusBusy = false; }
  }

  async function refreshStats(announce = true) {
    if (statsBusy) return;
    const session = getSession();
    if (!session?.sessionkey || !session?.char_id) return;
    statsBusy = true;
    try {
      const response = await fetch('/api/bot/get_stats', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ sessionkey: session.sessionkey, char_id: session.char_id }),
      });
      const data = await response.json();
      if (data.status === 'success') {
        updateStatsUI(data);
        lastStatsRefreshAt = Date.now();
        if (announce) appendLog('Account information refreshed from the server.');
      } else if (announce) {
        appendLog(`Stats refresh failed: ${data.message || 'unknown response'}`, 'warn');
      }
    } catch (error) {
      if (announce) appendLog(`Stats refresh error: ${error.message}`, 'warn');
    } finally { statsBusy = false; }
  }

  function restartPolling() {
    if (pollTimer) clearInterval(pollTimer);
    pollTimer = setInterval(refreshCloudStatus, document.hidden ? HIDDEN_POLL_MS : VISIBLE_POLL_MS);
  }

  function startStatsTimer() {
    if (statsTimer) clearInterval(statsTimer);
    statsTimer = setInterval(() => {
      // Active battles already update totals through cloud logs. Avoid extra AMF traffic then.
      if (activeBotType || document.hidden) return;
      const interval = Math.max(MIN_IDLE_STATS_MS, Number(window.__nsStatsRefreshSeconds || 45) * 1000);
      if (Date.now() - lastStatsRefreshAt >= interval) refreshStats(false);
    }, 5000);
  }

  function createAdvancedSettingRow(label, id, value, min, max, help) {
    const row = document.createElement('div');
    row.className = 'action-item cloud-setting-row';
    const span = document.createElement('span');
    span.textContent = label;
    if (help) {
      const small = document.createElement('small');
      small.style.cssText = 'display:block;color:#aaa;font-size:10px;margin-top:2px';
      small.textContent = help;
      span.appendChild(small);
    }
    const input = document.createElement('input');
    input.type = 'number'; input.id = id; input.value = value; input.min = min; input.max = max;
    input.className = 'input-field'; input.style.cssText = 'width:88px;padding:.5rem';
    row.append(span, input);
    return row;
  }

  function createCheckboxSettingRow(label, id, checked, help) {
    const row = document.createElement('div');
    row.className = 'action-item cloud-setting-row';
    const span = document.createElement('span');
    span.textContent = label;
    if (help) {
      const small = document.createElement('small');
      small.style.cssText = 'display:block;color:#aaa;font-size:10px;margin-top:2px';
      small.textContent = help;
      span.appendChild(small);
    }
    const input = document.createElement('input');
    input.type = 'checkbox'; input.id = id; input.checked = !!checked;
    input.style.cssText = 'width:20px;height:20px;accent-color:var(--primary)';
    row.append(span, input);
    return row;
  }

  function createSelectSettingRow(label, id, options, help) {
    const row = document.createElement('div');
    row.className = 'action-item cloud-setting-row';
    const span = document.createElement('span');
    span.textContent = label;
    if (help) {
      const small = document.createElement('small');
      small.style.cssText = 'display:block;color:#aaa;font-size:10px;margin-top:2px';
      small.textContent = help;
      span.appendChild(small);
    }
    const select = document.createElement('select');
    select.id = id; select.className = 'input-field'; select.style.cssText = 'width:120px;padding:.5rem';
    for (const [value, text] of options) {
      const option = document.createElement('option'); option.value = value; option.textContent = text; select.appendChild(option);
    }
    row.append(span, select);
    return row;
  }

  function ensureAdvancedSettingsUI() {
    const modal = document.getElementById('modal-settings');
    const list = modal?.querySelector('.action-list');
    if (!list || document.getElementById('setting-rate-backoff')) return;

    const levelingLabel = document.getElementById('setting-leveling-delay')?.closest('.action-item')?.querySelector('span');
    if (levelingLabel) levelingLabel.innerHTML = 'Leveling Delay (s)<small style="display:block;color:#aaa;font-size:10px;">Default 5s. Saat server menolak/rate-limit, backoff otomatis akan mengambil alih.</small>';
    const oldShadow = document.getElementById('setting-shadow-wait');
    if (oldShadow) {
      const span = oldShadow.closest('.action-item')?.querySelector('span');
      if (span) span.textContent = 'Shadow War empty-energy wait (minutes)';
      oldShadow.min = '1'; oldShadow.max = '180';
    }

    const divider = document.createElement('div');
    divider.style.cssText = 'padding:.55rem .2rem .15rem;color:var(--primary-light);font-weight:700;font-size:.8rem;text-transform:uppercase;letter-spacing:.08em';
    divider.textContent = 'Stability & Cloud';
    list.appendChild(divider);
    list.appendChild(createCheckboxSettingRow('Automatic session recovery', 'setting-auto-relogin', true, 'Relogin hanya jika validasi menunjukkan session sudah tidak berlaku. Kredensial disimpan di RAM selama job berjalan.'));
    list.appendChild(createAdvancedSettingRow('Battle wait (s)', 'setting-battle-wait', 5, 3, 30, 'Jeda start → finish mission.'));
    list.appendChild(createAdvancedSettingRow('Leveling rest every cycles', 'setting-rest-every', 40, 5, 200, 'Istirahat berkala untuk mengurangi burst request panjang.'));
    list.appendChild(createAdvancedSettingRow('Leveling rest duration (s)', 'setting-rest-duration', 60, 10, 600, 'Default 60 detik.'));
    list.appendChild(createAdvancedSettingRow('Rate-limit backoff (s)', 'setting-rate-backoff', 30, 15, 300, 'Akan meningkat otomatis bila 429/rate limit berulang.'));
    list.appendChild(createAdvancedSettingRow('Circuit cooldown (s)', 'setting-circuit-cooldown', 120, 30, 900, 'Pause, bukan mematikan bot, saat banyak error.'));
    list.appendChild(createAdvancedSettingRow('Auto stats refresh (s)', 'setting-stats-refresh', 45, 30, 300, 'Hanya saat bot idle agar tidak menambah trafik battle.'));
    list.appendChild(createSelectSettingRow('Shadow empty energy', 'setting-shadow-energy-mode', [['wait','Wait'],['stop','Stop'],['buy','Buy refill']], 'Default Wait. Buy dapat memakai token game.'));
    list.appendChild(createAdvancedSettingRow('Shadow battle wait (s)', 'setting-shadow-battle-wait', 20, 10, 60, 'Default konservatif 20 detik.'));
    list.appendChild(createAdvancedSettingRow('Shadow between battles (s)', 'setting-shadow-between', 30, 10, 180, 'Default konservatif 30 detik.'));
    list.appendChild(createAdvancedSettingRow('Clan battle delay (s)', 'setting-clan-delay', 8, 8, 180, 'Minimal 8 detik.'));
  }

  async function loadCloudSettings() {
    ensureAdvancedSettingsUI();
    try {
      const response = await fetch('/api/bot/settings', { cache: 'no-store' });
      const data = await response.json();
      const s = data.settings || {};
      const set = (id, value) => { const el = document.getElementById(id); if (el && value !== undefined) el.value = value; };
      set('setting-leveling-delay', s.leveling_delay_seconds ?? 5);
      set('setting-shadow-wait', s.sage_shadow_war_wait_minutes ?? 30);
      set('setting-battle-wait', s.sage_battle_wait_seconds ?? 5);
      set('setting-rest-every', s.leveling_rest_every_cycles ?? 40);
      set('setting-rest-duration', s.leveling_rest_duration_seconds ?? 60);
      set('setting-rate-backoff', s.rate_limit_backoff_seconds ?? 30);
      set('setting-circuit-cooldown', s.circuit_cooldown_seconds ?? 120);
      set('setting-stats-refresh', s.stats_refresh_seconds ?? 45);
      set('setting-shadow-battle-wait', s.shadow_war_battle_wait_seconds ?? 20);
      set('setting-shadow-between', s.shadow_war_between_battles_seconds ?? 30);
      set('setting-clan-delay', s.clan_war_battle_delay_seconds ?? 8);
      const relogin = document.getElementById('setting-auto-relogin'); if (relogin) relogin.checked = s.sage_auto_relogin_enabled !== false;
      const shadowMode = document.getElementById('setting-shadow-energy-mode'); if (shadowMode) shadowMode.value = s.sage_shadow_war_empty_resource_mode || 'wait';
      const token = document.getElementById('setting-clan-token'); if (token) token.checked = !!s.clan_war_auto_spend_token;
      const refill = document.getElementById('setting-clan-refill'); if (refill && s.clan_war_stamina_refill_source) refill.value = s.clan_war_stamina_refill_source;
      window.__nsStatsRefreshSeconds = Number(s.stats_refresh_seconds || 45);
    } catch (error) { console.warn('Cloud settings load failed', error); }
  }

  async function saveCloudSettings() {
    const num = (id, fallback) => parseInt(document.getElementById(id)?.value || String(fallback), 10) || fallback;
    const payload = {
      leveling_delay_seconds: Math.max(5, num('setting-leveling-delay', 5)),
      sage_shadow_war_wait_minutes: Math.max(1, num('setting-shadow-wait', 30)),
      sage_auto_relogin_enabled: document.getElementById('setting-auto-relogin')?.checked !== false,
      sage_battle_wait_seconds: Math.max(3, num('setting-battle-wait', 5)),
      leveling_rest_every_cycles: Math.max(5, num('setting-rest-every', 40)),
      leveling_rest_duration_seconds: Math.max(10, num('setting-rest-duration', 60)),
      rate_limit_backoff_seconds: Math.max(15, num('setting-rate-backoff', 30)),
      circuit_cooldown_seconds: Math.max(30, num('setting-circuit-cooldown', 120)),
      stats_refresh_seconds: Math.max(30, num('setting-stats-refresh', 45)),
      sage_shadow_war_empty_resource_mode: document.getElementById('setting-shadow-energy-mode')?.value || 'wait',
      shadow_war_battle_wait_seconds: Math.max(10, num('setting-shadow-battle-wait', 20)),
      shadow_war_between_battles_seconds: Math.max(10, num('setting-shadow-between', 30)),
      clan_war_battle_delay_seconds: Math.max(8, num('setting-clan-delay', 8)),
      clan_war_auto_spend_token: !!document.getElementById('setting-clan-token')?.checked,
      clan_war_stamina_refill_source: document.getElementById('setting-clan-refill')?.value || 'auto',
    };
    try {
      const response = await fetch('/api/bot/settings', {
        method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload),
      });
      const data = await response.json();
      if (data.status !== 'success') throw new Error(data.message || 'Failed to save settings');
      window.__nsStatsRefreshSeconds = payload.stats_refresh_seconds;
      document.getElementById('modal-settings')?.classList.remove('show');
      appendLog('Stability settings saved. New cloud cycles will use them.');
    } catch (error) { alert(`Failed to save settings: ${error.message}`); }
  }

  function ensureWarModule() {
    const warIcon = document.querySelector('.icon-war');
    const card = warIcon?.closest('.module-card');
    if (!card || document.getElementById('modal-war')) return;
    card.classList.remove('disabled-card');
    card.style.cursor = 'pointer';
    card.style.opacity = '1';
    card.querySelector('.coming-soon-badge')?.remove();

    const modal = document.createElement('div');
    modal.id = 'modal-war'; modal.className = 'modal-overlay';
    modal.innerHTML = `
      <div class="modal-content glass-panel">
        <div class="modal-header">
          <h3><i class="fa-brands fa-fort-awesome"></i> War Operations</h3>
          <button class="btn-close" type="button">&times;</button>
        </div>
        <div class="action-list">
          <div class="action-item">
            <div class="action-info"><h4>Shadow War</h4><small style="color:var(--text-muted)">Conservative battle timing + configurable empty-energy wait.</small></div>
            <button id="toggle-autoshadowwar" class="btn btn-toggle">START</button>
          </div>
          <div class="action-item">
            <div class="action-info"><h4>Clan War</h4><small style="color:var(--text-muted)">Persistent auth, cached stamina/opponents, 429 backoff.</small></div>
            <button id="toggle-autoclanwar" class="btn btn-toggle">START</button>
          </div>
        </div>
      </div>`;
    document.body.appendChild(modal);
    card.addEventListener('click', () => modal.classList.add('show'));
    modal.querySelector('.btn-close')?.addEventListener('click', () => modal.classList.remove('show'));
  }

  async function registerFreshServiceWorker() {
    if (!('serviceWorker' in navigator)) return;
    try {
      const registration = await navigator.serviceWorker.register('/panel/sw.js', { updateViaCache: 'none' });
      await registration.update();
      registration.addEventListener('updatefound', () => {
        const worker = registration.installing;
        worker?.addEventListener('statechange', () => {
          if (worker.state === 'installed' && navigator.serviceWorker.controller) {
            worker.postMessage({ type: 'SKIP_WAITING' });
          }
        });
      });
      let reloading = false;
      navigator.serviceWorker.addEventListener('controllerchange', () => {
        if (reloading) return;
        reloading = true;
        window.location.reload();
      });
    } catch (error) { console.warn('Service worker update check failed', error); }
  }

  document.addEventListener('visibilitychange', () => {
    restartPolling();
    if (!document.hidden) {
      refreshCloudStatus();
      if (!activeBotType) refreshStats(false);
    }
  });

  document.addEventListener('click', async event => {
    const button = event.target.closest('button');
    if (!button) return;
    const def = botDefinitions[button.id];
    if (def) {
      event.preventDefault(); event.stopImmediatePropagation();
      const session = getSession();
      const control = session?.char_id ? getControl(session.char_id) : null;
      if (control?.token && activeBotType === def.type) await stopCurrentCloudBot();
      else await startCloudBot(def, button);
      return;
    }

    if (button.id === 'global-stop-btn') {
      event.preventDefault(); event.stopImmediatePropagation();
      await stopCurrentCloudBot(); return;
    }

    if (button.id === 'btn-refresh-stats') {
      event.preventDefault(); event.stopImmediatePropagation();
      await refreshStats(true); return;
    }

    if (button.id === 'btn-logout') {
      const session = getSession();
      const control = session?.char_id ? getControl(session.char_id) : null;
      if (!control?.token) return;
      event.preventDefault(); event.stopImmediatePropagation();
      if (!confirm('Logout and stop the server-side bot?')) return;
      await stopCurrentCloudBot();
      localStorage.removeItem('ns_session');
      window.location.reload();
    }
  }, true);

  window.addEventListener('load', async () => {
    ensureWarModule();
    ensureAdvancedSettingsUI();
    await loadCloudSettings();
    window.loadSettings = loadCloudSettings;
    window.saveSettings = saveCloudSettings;
    const session = getSession();
    lastLogSeq = 0; // Replay retained server history with each entry's real timestamp after reopening.
    await refreshCloudStatus();
    if (!activeBotType) await refreshStats(false);
    restartPolling();
    startStatsTimer();
    registerFreshServiceWorker();
  });
})();
