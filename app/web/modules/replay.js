(() => {
  'use strict';

  function ensure() {
    if (document.getElementById('modal-replay')) return;
    const anchor = document.getElementById('btn-history') || document.getElementById('btn-settings');
    if (!anchor) return;

    const btn = document.createElement('button');
    btn.id = 'btn-replay';
    btn.className = 'btn btn-toggle';
    btn.title = 'Replay Simulator';
    btn.innerHTML = '<i class="fa-solid fa-backward-fast"></i>';
    anchor.insertAdjacentElement('afterend', btn);

    const modal = document.createElement('div');
    modal.id = 'modal-replay';
    modal.className = 'modal-overlay';
    modal.innerHTML = `
      <div class="modal-content glass-panel ns-v6-modal">
        <div class="modal-header"><h3><i class="fa-solid fa-backward-fast"></i> Replay Simulator</h3><button class="btn-close">&times;</button></div>
        <p class="ns-v6-note">Offline simulation only — no game requests are sent.</p>
        <div class="ns-v6-grid">
          <label>Base delay<input id="replay-base" class="input-field" type="number" min="5" value="5"></label>
          <label>Soft latency ms<input id="replay-soft" class="input-field" type="number" min="500" value="2500"></label>
          <label>Hard latency ms<input id="replay-hard" class="input-field" type="number" min="500" value="5000"></label>
          <label>Max penalty s<input id="replay-cap" class="input-field" type="number" min="0" value="30"></label>
        </div>
        <button id="replay-run" class="btn btn-primary" type="button">Run Replay</button>
        <pre id="replay-result" class="ns-v6-pre">No replay yet.</pre>
      </div>`;
    document.body.appendChild(modal);

    btn.onclick = () => modal.classList.add('show');
    modal.querySelector('.btn-close').onclick = () => modal.classList.remove('show');
    document.getElementById('replay-run').onclick = async () => {
      const s = window.NinjaSession?.get?.();
      const resultEl = document.getElementById('replay-result');
      try {
        resultEl.textContent = 'Simulating…';
        const events = await window.NinjaHistory?.recent?.(s?.char_id, 3000) || [];
        const response = await fetch('/api/v6/replay/simulate', {
          method: 'POST', headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            events,
            config: {
              base_delay_seconds: Number(document.getElementById('replay-base').value || 5),
              soft_latency_ms: Number(document.getElementById('replay-soft').value || 2500),
              hard_latency_ms: Number(document.getElementById('replay-hard').value || 5000),
              max_penalty_seconds: Number(document.getElementById('replay-cap').value || 30),
            },
          }),
        });
        const data = await response.json();
        if (!response.ok) throw new Error(data.detail || `HTTP ${response.status}`);
        resultEl.textContent = JSON.stringify(data.replay, null, 2);
      } catch (error) {
        resultEl.textContent = `Replay failed: ${error.message}`;
      }
    };
  }

  document.addEventListener('DOMContentLoaded', () => setTimeout(ensure, 250));
})();