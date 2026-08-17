(() => {
  'use strict';

  function control(charId) {
    try { return JSON.parse(localStorage.getItem(`ns_cloud_control_${charId}`) || 'null'); }
    catch (_) { return null; }
  }

  async function recoveryCheck() {
    try {
      const response = await fetch('/api/v6/recovery/candidates', { cache: 'no-store' });
      if (!response.ok) return;
      const data = await response.json();
      const s = window.NinjaSession?.get?.();
      const candidate = (data.candidates || []).find(x =>
        Number(x.char_id) === Number(s?.char_id) && x.recovery_required
      );
      if (!candidate) return;
      const c = control(s.char_id);
      if (!c?.token) return;
      if (!confirm('A previous deployment stopped during an uncertain action. Review and resume from the next safe boundary?')) return;
      const resume = await fetch('/api/v6/recovery/resume', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ job_id: candidate.job_id, char_id: s.char_id, control_token: c.token }),
      });
      const result = await resume.json();
      window.NinjaUI?.toast?.(
        resume.ok ? 'Durable recovery resumed.' : (result.detail || 'Recovery failed'),
        resume.ok ? 'info' : 'error'
      );
    } catch (_) {}
  }

  async function boot() {
    try {
      const response = await fetch('/api/v6/release', { cache: 'no-store' });
      if (!response.ok) return;
      const data = await response.json();
      const readiness = data.readiness || {};
      const version = readiness.version?.version || '6';
      const footer = document.querySelector('footer');
      if (footer && !document.getElementById('ns-build-chip')) {
        const chip = document.createElement('div');
        chip.id = 'ns-build-chip';
        chip.className = 'ns-build-chip';
        chip.textContent = `Control Center v${version} · ${readiness.journal?.configured ? 'Journal ON' : 'Journal optional'} · ${readiness.panel_guard?.enabled ? 'Passkey ON' : 'Passkey optional'}`;
        footer.prepend(chip);
      }
      window.__nsRelease = readiness;
      recoveryCheck();
    } catch (_) {}

    const open = new URLSearchParams(location.search).get('open');
    const map = {
      recipes: 'btn-recipes',
      history: 'btn-history',
      diagnostics: 'btn-diagnostics',
      autopilot: 'btn-autopilot',
      replay: 'btn-replay',
    };
    if (map[open]) setTimeout(() => document.getElementById(map[open])?.click(), 700);
  }

  document.addEventListener('DOMContentLoaded', () => setTimeout(boot, 500));
})();