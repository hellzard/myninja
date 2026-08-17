(() => {
  'use strict';

  let currentPlan = null;

  function quickLogin() {
    try {
      const v = JSON.parse(sessionStorage.getItem('ns_quick_login') || 'null');
      if (!v) return null;
      const username = v.username || v.user;
      const password = v.password || v.pass;
      return username && password ? { username, password } : null;
    } catch (_) { return null; }
  }

  function ensure() {
    if (document.getElementById('modal-autopilot')) return;
    const anchor = document.getElementById('btn-recipes') || document.getElementById('btn-settings');
    if (!anchor) return;

    const btn = document.createElement('button');
    btn.id = 'btn-autopilot';
    btn.className = 'btn btn-toggle';
    btn.title = 'Autonomous Operations';
    btn.innerHTML = '<i class="fa-solid fa-route"></i>';
    anchor.insertAdjacentElement('afterend', btn);

    const modal = document.createElement('div');
    modal.id = 'modal-autopilot';
    modal.className = 'modal-overlay';
    modal.innerHTML = `
      <div class="modal-content glass-panel ns-v6-modal">
        <div class="modal-header"><h3><i class="fa-solid fa-route"></i> Autonomous Operations</h3><button class="btn-close">&times;</button></div>
        <p class="ns-v6-note">Deterministic planner. Premium-resource automation is forbidden and every plan requires confirmation.</p>
        <div class="ns-v6-grid">
          <label>Target level<input id="auto-goal-level" class="input-field" type="number" min="2" max="200" placeholder="Optional"></label>
          <label>Max runtime (hours)<input id="auto-goal-hours" class="input-field" type="number" min="0.1" max="12" step="0.5" value="4"></label>
        </div>
        <label class="ns-v6-check"><input id="auto-goal-daily" type="checkbox" checked> Complete Daily first</label>
        <label class="ns-v6-check"><input id="auto-goal-shadow" type="checkbox"> Include one Shadow War resource-aware check</label>
        <div class="ns-v6-actions">
          <button id="auto-plan" class="btn btn-toggle" type="button">Build Plan</button>
          <button id="auto-start" class="btn btn-primary" type="button" disabled>Confirm & Start</button>
        </div>
        <pre id="auto-plan-result" class="ns-v6-pre">No plan yet.</pre>
      </div>`;
    document.body.appendChild(modal);

    btn.onclick = () => modal.classList.add('show');
    modal.querySelector('.btn-close').onclick = () => modal.classList.remove('show');

    document.getElementById('auto-plan').onclick = async () => {
      currentPlan = null;
      document.getElementById('auto-start').disabled = true;
      const levelRaw = document.getElementById('auto-goal-level').value;
      const goals = {
        target_level: levelRaw ? Number(levelRaw) : null,
        run_daily: document.getElementById('auto-goal-daily').checked,
        include_shadow_war: document.getElementById('auto-goal-shadow').checked,
        max_runtime_seconds: Math.round(Number(document.getElementById('auto-goal-hours').value || 4) * 3600),
        allow_premium_resources: false,
      };
      try {
        const response = await fetch('/api/v6/policy/plan', {
          method: 'POST', headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ goals }),
        });
        const data = await response.json();
        if (!response.ok) throw new Error(data.detail || `HTTP ${response.status}`);
        currentPlan = data.plan;
        document.getElementById('auto-plan-result').textContent = JSON.stringify(currentPlan, null, 2);
        document.getElementById('auto-start').disabled = false;
      } catch (error) {
        document.getElementById('auto-plan-result').textContent = `Plan failed: ${error.message}`;
      }
    };

    document.getElementById('auto-start').onclick = async () => {
      if (!currentPlan) return;
      const s = window.NinjaSession?.get?.();
      if (!s?.sessionkey || !s?.char_id) return window.NinjaUI?.toast?.('Login first.', 'warn');
      if (!confirm('Start this deterministic plan now?')) return;
      try {
        const response = await fetch('/api/bot/cloud/start', {
          method: 'POST', headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            sessionkey: s.sessionkey,
            char_id: s.char_id,
            bot_type: 'recipe',
            params: { recipe: currentPlan.recipe },
            credentials: quickLogin(),
          }),
        });
        const data = await response.json();
        if (!response.ok) throw new Error(data.detail || `HTTP ${response.status}`);
        localStorage.setItem(`ns_cloud_control_${s.char_id}`, JSON.stringify({
          char_id: s.char_id,
          token: data.job.control_token,
          bot_type: 'recipe',
        }));
        window.dispatchEvent(new CustomEvent('ns:cloud-control', { detail: { char_id: s.char_id } }));
        window.dispatchEvent(new CustomEvent('ns:cloud-status', { detail: data.job }));
        modal.classList.remove('show');
      } catch (error) {
        window.NinjaUI?.toast?.(`Autonomous plan failed: ${error.message}`, 'error');
      }
    };
  }

  document.addEventListener('DOMContentLoaded', () => setTimeout(ensure, 350));
})();