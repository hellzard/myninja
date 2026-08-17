(() => {
  'use strict';

  let nextActionAt = null;

  function ensurePanel() {
    if (document.getElementById('ns-analytics')) return;
    const status = document.getElementById('bot-status-text');
    if (!status) return;

    const panel = document.createElement('section');
    panel.id = 'ns-analytics';
    panel.className = 'ns-analytics';
    panel.innerHTML = `
      <div class="ns-health-row">
        <span id="ns-health-badge" class="ns-health-badge" data-state="IDLE">IDLE</span>
        <span id="ns-health-detail" class="ns-health-detail">No active cloud job</span>
        <span id="ns-next-action" class="ns-next-action"></span>
      </div>
      <div class="ns-metric-grid">
        <div class="ns-mini-stat"><small>XP / hour</small><strong id="ns-xph">0</strong></div>
        <div class="ns-mini-stat"><small>Gold / hour</small><strong id="ns-gph">0</strong></div>
        <div class="ns-mini-stat"><small>Success</small><strong id="ns-success">0</strong></div>
        <div class="ns-mini-stat"><small>Failed</small><strong id="ns-failed">0</strong></div>
        <div class="ns-mini-stat"><small>Actions / hour</small><strong id="ns-aph">0</strong></div>
        <div class="ns-mini-stat"><small>Uptime</small><strong id="ns-uptime">0s</strong></div>
      </div>`;
    status.insertAdjacentElement('afterend', panel);
  }

  function number(value) {
    const n = Number(value) || 0;
    return Math.round(n).toLocaleString();
  }

  function render(job = {}) {
    ensurePanel();
    const health = job.health || {};
    const analytics = job.analytics || {};
    const state = String(health.state || (job.running ? 'RUNNING' : 'IDLE')).toUpperCase();

    const badge = document.getElementById('ns-health-badge');
    if (badge) {
      badge.textContent = state.replaceAll('_', ' ');
      badge.dataset.state = state;
    }
    const detail = document.getElementById('ns-health-detail');
    if (detail) detail.textContent = health.detail || job.last_message || 'No active cloud job';

    const values = {
      'ns-xph': number(analytics.xp_per_hour),
      'ns-gph': number(analytics.gold_per_hour),
      'ns-success': number(analytics.success_count),
      'ns-failed': number(analytics.failure_count),
      'ns-aph': number(analytics.actions_per_hour),
      'ns-uptime': window.NinjaUI?.formatDuration?.(analytics.uptime_seconds || 0) || '0s',
    };
    for (const [id, value] of Object.entries(values)) {
      const el = document.getElementById(id);
      if (el) el.textContent = value;
    }
    nextActionAt = Number(health.next_action_at) || null;
  }

  setInterval(() => {
    const el = document.getElementById('ns-next-action');
    if (!el) return;
    if (!nextActionAt) {
      el.textContent = '';
      return;
    }
    const remaining = nextActionAt - Date.now() / 1000;
    el.textContent = remaining > 0
      ? `Next: ${window.NinjaUI?.formatDuration?.(remaining) || Math.ceil(remaining) + 's'}`
      : 'Next: now';
  }, 1000);

  window.addEventListener('ns:cloud-status', event => render(event.detail || {}));
  document.addEventListener('DOMContentLoaded', ensurePanel);
})();
