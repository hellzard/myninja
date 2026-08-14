(() => {
  'use strict';

  const CLOUD_ENDPOINT = '/api/bot/cloud';
  const POLL_MS = 3000;

  const botDefinitions = {
    'toggle-autolevel': {
      type: 'auto_level',
      label: 'Auto Leveling',
      params: () => ({
        max_level: parseInt(document.getElementById('auto_level_max')?.value || '0', 10) || null,
      }),
    },
    'toggle-autodaily': { type: 'auto_daily', label: 'Auto Daily', params: () => ({}) },
    'toggle-autohunting': { type: 'auto_hunting', label: 'Auto Hunting', params: () => ({}) },
    'btnAutoEudemon': { type: 'eudemon', label: 'Auto Eudemon', params: () => ({}) },
    'toggle-autocircus': {
      type: 'circus',
      label: 'Circus Event',
      params: () => ({ boss_type: document.getElementById('circus-boss-id')?.value || 'ringmaster' }),
    },
    'toggle-autoyokai': {
      type: 'yokai',
      label: 'Yokai Event',
      params: () => ({ boss_type: document.getElementById('yokai-boss-id')?.value || 'kitsune' }),
    },
    'toggle-autoyokaiminigame': { type: 'yokai_minigame', label: 'Yokai Minigame', params: () => ({}) },
    'toggle-autoshadowwar': { type: 'shadow_war', label: 'Shadow War', params: () => ({}) },
    'toggle-automonster': { type: 'monster', label: 'Monster Hunter', params: () => ({}) },
    'toggle-automissions': { type: 'mission_s', label: 'Mission S', params: () => ({}) },
    'toggle-autoclanwar': { type: 'clan_war', label: 'Clan War', params: () => ({}) },
    'toggle-automission-farmer': {
      type: 'mission',
      label: 'Auto-Mission Farmer',
      params: () => ({ mission_id: document.getElementById('auto_mission_id')?.value?.trim() || '' }),
      validate: (params) => params.mission_id ? null : 'Please choose/enter a mission first.',
    },
  };

  let activeBotType = null;
  let pollTimer = null;
  let lastLogSeq = 0;

  function getSession() {
    try {
      return JSON.parse(localStorage.getItem('ns_session') || 'null');
    } catch (_) {
      return null;
    }
  }

  function controlStorageKey(charId) {
    return `ns_cloud_control_${charId}`;
  }

  function getControl(charId) {
    try {
      return JSON.parse(localStorage.getItem(controlStorageKey(charId)) || 'null');
    } catch (_) {
      return null;
    }
  }

  function saveControl(charId, value) {
    if (!value) localStorage.removeItem(controlStorageKey(charId));
    else localStorage.setItem(controlStorageKey(charId), JSON.stringify(value));
  }

  function appendLog(message, level = 'info') {
    const activityLog = document.getElementById('activity-log');
    if (!activityLog) return;

    const li = document.createElement('li');
    li.className = 'log-entry';

    const timeSpan = document.createElement('div');
    timeSpan.className = 'log-time';
    const now = new Date();
    timeSpan.textContent = [now.getHours(), now.getMinutes(), now.getSeconds()]
      .map(v => String(v).padStart(2, '0')).join(':');

    const dot = document.createElement('div');
    dot.className = `log-dot ${level === 'error' ? 'err' : 'ok'}`;

    const msgDiv = document.createElement('div');
    msgDiv.className = `log-msg ${level === 'error' ? 'error' : ''}`;
    msgDiv.textContent = `[Cloud] ${message}`;

    li.append(timeSpan, dot, msgDiv);
    activityLog.appendChild(li);

    while (activityLog.children.length > 100) activityLog.removeChild(activityLog.firstChild);
    const terminal = document.getElementById('terminal-window');
    if (terminal) terminal.scrollTop = terminal.scrollHeight;
  }

  async function post(path, payload) {
    const res = await fetch(`${CLOUD_ENDPOINT}/${path}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });

    let data = null;
    try { data = await res.json(); } catch (_) { /* ignore */ }

    if (!res.ok) {
      const message = data?.detail || data?.message || `HTTP ${res.status}`;
      throw new Error(message);
    }
    return data;
  }

  function buttonForType(type) {
    const entry = Object.entries(botDefinitions).find(([, def]) => def.type === type);
    return entry ? document.getElementById(entry[0]) : null;
  }

  function resetButtons() {
    Object.keys(botDefinitions).forEach((id) => {
      document.querySelectorAll(`#${CSS.escape(id)}`).forEach((btn) => {
        btn.textContent = 'START';
        btn.style.background = '';
        btn.disabled = false;
      });
    });
  }

  function renderStatus(job) {
    const statusText = document.getElementById('bot-status-text');
    const stopGlobalBtn = document.getElementById('global-stop-btn');

    resetButtons();

    if (job?.running) {
      activeBotType = job.bot_type;
      const btn = buttonForType(job.bot_type);
      if (btn) {
        btn.textContent = 'STOP';
        btn.style.background = '#ff5252';
      }
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

    if (Array.isArray(job?.logs)) {
      for (const entry of job.logs) {
        if ((entry.seq || 0) <= lastLogSeq) continue;
        lastLogSeq = Math.max(lastLogSeq, entry.seq || 0);
        appendLog(entry.message, entry.level === 'error' ? 'error' : 'info');
      }
    }
  }

  async function startCloudBot(def, button) {
    const session = getSession();
    if (!session?.sessionkey || !session?.char_id) {
      appendLog('Please login first.', 'error');
      return;
    }

    const params = def.params ? def.params() : {};
    const validationError = def.validate?.(params);
    if (validationError) {
      appendLog(validationError, 'error');
      return;
    }

    button.disabled = true;
    try {
      const response = await post('start', {
        sessionkey: session.sessionkey,
        char_id: session.char_id,
        bot_type: def.type,
        params,
      });
      const job = response.job;
      saveControl(session.char_id, {
        char_id: session.char_id,
        token: job.control_token,
        bot_type: job.bot_type,
      });
      lastLogSeq = 0;
      renderStatus(job);
      appendLog(`${def.label} handed off to the server. You may close this tab.`);
      beginPolling();
    } catch (err) {
      appendLog(`Failed to start ${def.label}: ${err.message}`, 'error');
    } finally {
      button.disabled = false;
    }
  }

  async function stopCurrentCloudBot() {
    const session = getSession();
    if (!session?.char_id) return;
    const control = getControl(session.char_id);
    if (!control?.token) {
      renderStatus({ running: false, logs: [] });
      return;
    }

    try {
      const response = await post('stop', {
        char_id: session.char_id,
        control_token: control.token,
      });
      renderStatus(response.job);
      appendLog('Cloud bot stopped.');
    } catch (err) {
      appendLog(`Failed to stop cloud bot: ${err.message}`, 'error');
    } finally {
      saveControl(session.char_id, null);
      activeBotType = null;
    }
  }

  async function refreshCloudStatus() {
    const session = getSession();
    if (!session?.char_id) return;
    const control = getControl(session.char_id);
    if (!control?.token) return;

    try {
      const response = await post('status', {
        char_id: session.char_id,
        control_token: control.token,
      });
      renderStatus(response.job);
      if (!response.job?.running) saveControl(session.char_id, null);
    } catch (err) {
      // A 403 usually means the server restarted and lost its in-memory job registry.
      appendLog(`Cloud status unavailable: ${err.message}`, 'error');
      saveControl(session.char_id, null);
      renderStatus({ running: false, logs: [] });
    }
  }

  function beginPolling() {
    if (pollTimer) clearInterval(pollTimer);
    pollTimer = setInterval(refreshCloudStatus, POLL_MS);
  }

  // Capture-phase interception is intentional. It prevents the legacy app.js
  // setInterval/setTimeout handlers from starting browser-owned loops.
  document.addEventListener('click', async (event) => {
    const button = event.target.closest('button');
    if (!button) return;

    const def = botDefinitions[button.id];
    if (def) {
      event.preventDefault();
      event.stopImmediatePropagation();

      const session = getSession();
      const control = session?.char_id ? getControl(session.char_id) : null;
      if (control?.token && activeBotType === def.type) {
        await stopCurrentCloudBot();
      } else {
        await startCloudBot(def, button);
      }
      return;
    }

    if (button.id === 'global-stop-btn') {
      event.preventDefault();
      event.stopImmediatePropagation();
      await stopCurrentCloudBot();
      return;
    }

    if (button.id === 'btn-logout') {
      const session = getSession();
      const control = session?.char_id ? getControl(session.char_id) : null;
      if (!control?.token) return; // Let legacy logout handler run normally.

      event.preventDefault();
      event.stopImmediatePropagation();
      const shouldLogout = confirm('Logout and stop the server-side bot?');
      if (!shouldLogout) return;
      await stopCurrentCloudBot();
      localStorage.removeItem('ns_session');
      window.location.reload();
    }
  }, true);

  window.addEventListener('load', async () => {
    await refreshCloudStatus();
    beginPolling();
  });
})();
