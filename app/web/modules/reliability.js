(() => {
  'use strict';

  let lastFetch = 0;
  let busy = false;

  function control(charId) {
    try { return JSON.parse(localStorage.getItem(`ns_cloud_control_${charId}`) || 'null'); }
    catch (_) { return null; }
  }

  function ensureBadge() {
    const row = document.querySelector('.ns-health-row');
    if (!row || document.getElementById('ns-reliability')) return;
    const badge = document.createElement('button');
    badge.id = 'ns-reliability';
    badge.type = 'button';
    badge.className = 'ns-reliability';
    badge.textContent = 'Reliability --';
    badge.title = 'Reliability score';
    row.appendChild(badge);
    badge.onclick = () => refresh(true);
  }

  async function refresh(force = false) {
    if (busy || (!force && Date.now() - lastFetch < 45000)) return;
    const s = window.NinjaSession?.get?.();
    const c = s?.char_id ? control(s.char_id) : null;
    if (!s?.char_id || !c?.token) return;
    busy = true;
    try {
      const response = await fetch('/api/v6/reliability', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ char_id: s.char_id, control_token: c.token, journal_limit: 1500 }),
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.detail || `HTTP ${response.status}`);
      ensureBadge();
      const el = document.getElementById('ns-reliability');
      const r = data.reliability || {};
      if (el) {
        el.textContent = `${r.label || 'HEALTH'} ${Number(r.score || 0).toFixed(0)}/100`;
        el.dataset.label = r.label || '';
        el.title = JSON.stringify(r.signals || {});
      }
      window.__nsReliability = r;
      lastFetch = Date.now();
    } catch (_) {
      // Reliability is supplemental; do not disturb the main control loop.
    } finally { busy = false; }
  }

  window.addEventListener('ns:cloud-status', () => {
    ensureBadge();
    refresh(false);
  });
  document.addEventListener('DOMContentLoaded', ensureBadge);
})();