(() => {
  'use strict';

  const botOptions = [
    ['auto_level', 'Auto Leveling'],
    ['auto_daily', 'Auto Daily'],
    ['auto_hunting', 'Auto Hunting'],
    ['eudemon', 'Eudemon'],
    ['shadow_war', 'Shadow War'],
    ['monster', 'Monster Hunter'],
    ['mission_s', 'Mission S'],
    ['clan_war', 'Clan War'],
  ];

  function getSession() {
    return window.NinjaSession?.get?.() || null;
  }

  function getCredentials() {
    try {
      const value = JSON.parse(sessionStorage.getItem('ns_quick_login') || 'null');
      if (!value?.user || !value?.pass) return null;
      return { username: value.user, password: value.pass };
    } catch (_) { return null; }
  }

  function currentParams(type) {
    if (type === 'auto_level') {
      return { max_level: parseInt(document.getElementById('auto_level_max')?.value || '0', 10) || null };
    }
    return {};
  }

  function ensure() {
    if (document.getElementById('modal-scheduler')) return;
    const settingsBtn = document.getElementById('btn-settings');
    if (!settingsBtn) return;

    const button = document.createElement('button');
    button.id = 'btn-scheduler';
    button.className = 'btn btn-toggle';
    button.title = 'Smart Scheduler';
    button.innerHTML = '<i class="fa-solid fa-clock"></i>';
    settingsBtn.insertAdjacentElement('afterend', button);

    const modal = document.createElement('div');
    modal.id = 'modal-scheduler';
    modal.className = 'modal-overlay';
    modal.innerHTML = `
      <div class="modal-content glass-panel ns-scheduler-modal">
        <div class="modal-header">
          <h3><i class="fa-solid fa-clock"></i> Smart Scheduler</h3>
          <button class="btn-close" type="button">&times;</button>
        </div>
        <div class="action-list">
          <div class="action-item cloud-setting-row">
            <span>Bot</span>
            <select id="scheduler-bot" class="input-field">
              ${botOptions.map(([value, label]) => `<option value="${value}">${label}</option>`).join('')}
            </select>
          </div>
          <div class="action-item cloud-setting-row">
            <span>Start at<small>Waktu perangkatmu. Minimal sekitar 1 menit dari sekarang.</small></span>
            <input id="scheduler-at" type="datetime-local" class="input-field" />
          </div>
          <div class="action-item cloud-setting-row">
            <span>Repeat<small>Repeat tidak pernah lebih sering dari 1 jam.</small></span>
            <select id="scheduler-repeat" class="input-field">
              <option value="0">Once</option>
              <option value="21600">Every 6 hours</option>
              <option value="43200">Every 12 hours</option>
              <option value="86400">Daily</option>
            </select>
          </div>
        </div>
        <div class="ns-scheduler-note">
          Scheduler membuat job server-side berstatus <strong>SCHEDULED</strong>. Backoff/rate-limit protection tetap aktif.
        </div>
        <button id="scheduler-save" class="btn btn-primary" type="button" style="width:100%;margin-top:1rem">
          Schedule Job
        </button>
      </div>`;
    document.body.appendChild(modal);

    button.addEventListener('click', () => {
      const at = document.getElementById('scheduler-at');
      if (at && !at.value) {
        const d = new Date(Date.now() + 5 * 60 * 1000);
        d.setMinutes(d.getMinutes() - d.getTimezoneOffset());
        at.value = d.toISOString().slice(0, 16);
      }
      modal.classList.add('show');
    });
    modal.querySelector('.btn-close')?.addEventListener('click', () => modal.classList.remove('show'));

    document.getElementById('scheduler-save')?.addEventListener('click', async () => {
      const active = window.__nsLastCloudJob;
      if (active?.running && !['IDLE', 'STOPPED', 'ERROR'].includes(String(active?.health?.state || '').toUpperCase())) {
        window.NinjaUI?.toast('Hentikan cloud bot aktif sebelum membuat jadwal baru.', 'warn');
        return;
      }

      const session = getSession();
      if (!session?.sessionkey || !session?.char_id) {
        window.NinjaUI?.toast('Login terlebih dahulu.', 'warn');
        return;
      }

      const type = document.getElementById('scheduler-bot')?.value || 'auto_daily';
      const rawAt = document.getElementById('scheduler-at')?.value || '';
      const date = new Date(rawAt);
      if (!rawAt || Number.isNaN(date.getTime()) || date.getTime() < Date.now() + 30_000) {
        window.NinjaUI?.toast('Pilih waktu start yang masih di masa depan.', 'warn');
        return;
      }

      const repeat = parseInt(document.getElementById('scheduler-repeat')?.value || '0', 10) || 0;
      const params = {
        ...currentParams(type),
        schedule_at: Math.floor(date.getTime() / 1000),
        repeat_every_seconds: repeat || 0,
      };

      const saveBtn = document.getElementById('scheduler-save');
      if (saveBtn) saveBtn.disabled = true;
      try {
        const response = await fetch('/api/bot/cloud/start', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          cache: 'no-store',
          body: JSON.stringify({
            sessionkey: session.sessionkey,
            char_id: session.char_id,
            bot_type: type,
            params,
            credentials: getCredentials(),
          }),
        });
        const data = await response.json();
        if (!response.ok || data.status !== 'success') {
          throw new Error(data.detail || data.message || `HTTP ${response.status}`);
        }

        const job = data.job;
        localStorage.setItem(`ns_cloud_control_${session.char_id}`, JSON.stringify({
          char_id: session.char_id,
          token: job.control_token,
          bot_type: type,
        }));
        modal.classList.remove('show');
        window.NinjaUI?.toast('Job scheduled.', 'info');
        window.dispatchEvent(new CustomEvent('ns:cloud-status', { detail: job }));
        window.NinjaCloud?.refreshStatus?.();
      } catch (error) {
        window.NinjaUI?.toast(`Scheduler gagal: ${error.message}`, 'error');
      } finally {
        if (saveBtn) saveBtn.disabled = false;
      }
    });
  }

  document.addEventListener('DOMContentLoaded', ensure);
})();
