(() => {
  'use strict';

  const UI = {
    log(message, level = 'info', epochSeconds = null) {
      const list = document.getElementById('activity-log');
      if (!list) return;
      const li = document.createElement('li');
      li.className = 'log-entry';

      const time = document.createElement('div');
      time.className = 'log-time';
      const d = epochSeconds ? new Date(Number(epochSeconds) * 1000) : new Date();
      time.textContent = [d.getHours(), d.getMinutes(), d.getSeconds()]
        .map(v => String(v).padStart(2, '0')).join(':');

      const dot = document.createElement('div');
      dot.className = `log-dot ${level === 'error' ? 'err' : (level === 'warn' ? 'warn' : 'ok')}`;

      const msg = document.createElement('div');
      msg.className = `log-msg ${level === 'error' ? 'error' : ''}`;
      msg.textContent = message;

      li.append(time, dot, msg);
      list.appendChild(li);
      while (list.children.length > 150) list.removeChild(list.firstChild);

      const terminal = document.getElementById('terminal-window');
      if (terminal && !document.hidden) terminal.scrollTop = terminal.scrollHeight;
    },

    toast(message, level = 'info') {
      let host = document.getElementById('ns-toast-host');
      if (!host) {
        host = document.createElement('div');
        host.id = 'ns-toast-host';
        document.body.appendChild(host);
      }
      const item = document.createElement('div');
      item.className = `ns-toast ns-toast-${level}`;
      item.textContent = message;
      host.appendChild(item);
      requestAnimationFrame(() => item.classList.add('show'));
      setTimeout(() => {
        item.classList.remove('show');
        setTimeout(() => item.remove(), 220);
      }, 3500);
    },

    formatDuration(totalSeconds) {
      const sec = Math.max(0, Math.floor(Number(totalSeconds) || 0));
      const h = Math.floor(sec / 3600);
      const m = Math.floor((sec % 3600) / 60);
      const s = sec % 60;
      if (h) return `${h}h ${m}m`;
      if (m) return `${m}m ${s}s`;
      return `${s}s`;
    },
  };

  window.NinjaUI = UI;

  document.addEventListener('DOMContentLoaded', () => {
    // The legacy exploit UI is intentionally not part of the production v4 dashboard.
    const secretCard = document.querySelector('.icon-secret')?.closest('.module-card');
    if (secretCard) secretCard.classList.add('hidden');
    ['modal-secret', 'modal-password'].forEach(id => {
      const modal = document.getElementById(id);
      if (modal) modal.setAttribute('aria-hidden', 'true');
    });
  });
})();
