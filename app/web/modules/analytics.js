(() => {
  'use strict';

  let nextActionAt = null;
  let etaRequest = 0;

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
        <span id="ns-realtime-indicator" class="ns-realtime-indicator" data-state="offline">LIVE: --</span>
        <span id="ns-next-action" class="ns-next-action"></span>
      </div>
      <div class="ns-metric-grid ns-metric-grid-pro">
        <div class="ns-mini-stat"><small>XP / hour</small><strong id="ns-xph">0</strong></div>
        <div class="ns-mini-stat"><small>Gold / hour</small><strong id="ns-gph">0</strong></div>
        <div class="ns-mini-stat"><small>Success</small><strong id="ns-success">0</strong></div>
        <div class="ns-mini-stat"><small>Success rate</small><strong id="ns-success-rate">0%</strong></div>
        <div class="ns-mini-stat"><small>Actions / hour</small><strong id="ns-aph">0</strong></div>
        <div class="ns-mini-stat"><small>p95 latency</small><strong id="ns-latency">0 ms</strong></div>
        <div class="ns-mini-stat"><small>Effective delay</small><strong id="ns-delay">--</strong></div>
        <div class="ns-mini-stat"><small>Relogin / Rate limit</small><strong id="ns-recovery">0 / 0</strong></div>
        <div class="ns-mini-stat"><small>Uptime</small><strong id="ns-uptime">0s</strong></div>
        <div class="ns-mini-stat"><small>Data confidence</small><strong id="ns-confidence">Warming</strong></div>
        <div class="ns-mini-stat ns-mini-stat-wide"><small>Target ETA</small><strong id="ns-eta">Learning…</strong></div>
      </div>`;
    status.insertAdjacentElement('afterend', panel);
  }

  const num = value => Math.round(Number(value) || 0).toLocaleString();

  function targetLevel(job) {
    const direct = Number(job?.params?.max_level);
    return direct > 0 ? direct : null;
  }

  function median(values) {
    const sorted = values.filter(Number.isFinite).sort((a, b) => a - b);
    if (!sorted.length) return null;
    const mid = Math.floor(sorted.length / 2);
    return sorted.length % 2 ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
  }

  async function eta(job) {
    const requestId = ++etaRequest;
    const el = document.getElementById('ns-eta');
    if (!el) return;

    const target = targetLevel(job);
    const s = window.NinjaSession?.get?.();
    const level = Number(s?.level);
    if (!target || !level) { el.textContent = '—'; return; }
    if (target <= level) { el.textContent = 'Reached'; return; }

    const samples = await window.NinjaHistory?.levelSamples?.(s.char_id, 120) || [];
    if (requestId !== etaRequest) return;

    const chronological = [...samples]
      .filter(x => Number.isFinite(Number(x.ts)) && Number.isFinite(Number(x.data?.level)))
      .sort((a, b) => a.ts - b.ts);

    const changes = [];
    let previousLevel = null;
    for (const row of chronological) {
      const current = Number(row.data.level);
      if (current !== previousLevel) {
        changes.push({ ts: Number(row.ts), level: current });
        previousLevel = current;
      }
    }
    if (changes.length < 2) { el.textContent = 'Learning (need level-up)'; return; }

    const observation = changes[changes.length - 1].ts - changes[0].ts;
    if (observation < 120) { el.textContent = 'Learning…'; return; }

    const secondsPerLevel = [];
    for (let i = 1; i < changes.length; i++) {
      const dl = changes[i].level - changes[i - 1].level;
      const dt = changes[i].ts - changes[i - 1].ts;
      if (dl > 0 && dt > 0) secondsPerLevel.push(dt / dl);
    }
    const typical = median(secondsPerLevel);
    if (!typical || !Number.isFinite(typical)) { el.textContent = 'Learning…'; return; }

    const seconds = Math.max(0, target - level) * typical;
    el.textContent = `≈ ${window.NinjaUI?.formatDuration?.(seconds) || Math.ceil(seconds / 60) + 'm'}`;
  }

  async function render(job = {}) {
    ensurePanel();
    const health = job.health || {};
    const a = job.analytics || {};
    const state = String(health.state || (job.running ? 'RUNNING' : 'IDLE')).toUpperCase();

    const badge = document.getElementById('ns-health-badge');
    if (badge) {
      badge.textContent = state.replaceAll('_', ' ');
      badge.dataset.state = state;
    }
    const detail = document.getElementById('ns-health-detail');
    if (detail) detail.textContent = health.detail || job.last_message || 'No active cloud job';

    const values = {
      'ns-xph': num(a.xp_per_hour),
      'ns-gph': num(a.gold_per_hour),
      'ns-success': num(a.success_count),
      'ns-success-rate': `${Number(a.success_rate || 0).toFixed(1)}%`,
      'ns-aph': num(a.actions_per_hour),
      'ns-latency': `${num(a.network_p95_ms)} ms`,
      'ns-delay': a.pacing_effective_seconds ? `${Number(a.pacing_effective_seconds).toFixed(1)}s` : '--',
      'ns-recovery': `${num(a.relogin_count)} / ${num(a.rate_limit_count)}`,
      'ns-uptime': window.NinjaUI?.formatDuration?.(a.uptime_seconds || 0) || '0s',
      'ns-confidence': String(a.confidence || 'warming').replaceAll('_', ' '),
    };
    for (const [id, value] of Object.entries(values)) {
      const node = document.getElementById(id);
      if (node) node.textContent = value;
    }
    nextActionAt = Number(health.next_action_at) || null;
    eta(job);
  }

  setInterval(() => {
    const el = document.getElementById('ns-next-action');
    if (!el) return;
    if (!nextActionAt) { el.textContent = ''; return; }
    const remaining = nextActionAt - Date.now() / 1000;
    el.textContent = remaining > 0
      ? `Next: ${window.NinjaUI?.formatDuration?.(remaining) || Math.ceil(remaining) + 's'}`
      : 'Next: now';
  }, 1000);

  window.addEventListener('ns:realtime-state', event => {
    ensurePanel();
    const el = document.getElementById('ns-realtime-indicator');
    if (!el) return;
    const online = Boolean(event.detail?.connected);
    el.dataset.state = online ? 'online' : 'offline';
    el.textContent = online ? 'LIVE: WS' : 'LIVE: fallback';
    el.title = event.detail?.reason || '';
  });

  window.addEventListener('ns:cloud-status', event => render(event.detail || {}));
  document.addEventListener('DOMContentLoaded', ensurePanel);
})();