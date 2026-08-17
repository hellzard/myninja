(() => {
  'use strict';

  function apply(stats) {
    const session = window.NinjaSession?.get?.();
    if (!session || !stats) return;
    const map = { level: 'metric-level', xp: 'metric-xp', gold: 'metric-gold', tokens: 'metric-token' };
    let changed = false;
    for (const [key, id] of Object.entries(map)) {
      const value = stats[key];
      if (value === undefined || value === null || value === '--') continue;
      const el = document.getElementById(id);
      if (el) el.textContent = value;
      session[key] = value;
      changed = true;
    }
    if (changed) {
      window.NinjaSession?.save?.(session);
      window.dispatchEvent(new CustomEvent('ns:account-stats', { detail: { ...stats, char_id: session.char_id } }));
    }
  }

  window.addEventListener('ns:sync-account-stats', event => apply(event.detail));

  window.addEventListener('ns:cloud-status', event => {
    const update = event.detail?.session_update;
    if (update) apply(update);
  });

  window.NinjaAccount = { apply };
})();
