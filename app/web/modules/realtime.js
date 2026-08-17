(() => {
  'use strict';
  let socket = null;
  let reconnectTimer = null;
  let attempts = 0;
  let connected = false;
  let desired = true;

  function session() { return window.NinjaSession?.get?.() || null; }
  function control(id) {
    try { return JSON.parse(localStorage.getItem(`ns_cloud_control_${id}`) || 'null'); } catch (_) { return null; }
  }
  async function ticket(charId, token) {
    const r = await fetch('/api/bot/cloud/ws-ticket', {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, cache: 'no-store',
      body: JSON.stringify({ char_id: charId, control_token: token }),
    });
    const data = await r.json();
    if (!r.ok || data.status !== 'success') throw new Error(data.detail || `HTTP ${r.status}`);
    return data.ticket;
  }
  function scheduleReconnect() {
    if (!desired || reconnectTimer) return;
    const wait = Math.min(30000, 1000 * (2 ** Math.min(attempts++, 5))) + Math.floor(Math.random() * 500);
    reconnectTimer = setTimeout(() => { reconnectTimer = null; connect(); }, wait);
    window.dispatchEvent(new CustomEvent('ns:realtime-state', { detail: { connected: false, reconnect_in_ms: wait } }));
  }
  async function connect() {
    if (!desired || socket?.readyState === WebSocket.OPEN || socket?.readyState === WebSocket.CONNECTING) return;
    const s = session();
    const c = s?.char_id ? control(s.char_id) : null;
    if (!s?.char_id || !c?.token) return;
    try {
      const t = await ticket(s.char_id, c.token);
      const proto = location.protocol === 'https:' ? 'wss:' : 'ws:';
      socket = new WebSocket(`${proto}//${location.host}/api/bot/cloud/ws/${encodeURIComponent(s.char_id)}?ticket=${encodeURIComponent(t)}`);
      socket.addEventListener('open', () => {
        connected = true; attempts = 0;
        window.dispatchEvent(new CustomEvent('ns:realtime-state', { detail: { connected: true } }));
      });
      socket.addEventListener('message', event => {
        try {
          const msg = JSON.parse(event.data);
          if ((msg.type === 'job_status' || msg.type === 'heartbeat') && msg.job) {
            window.dispatchEvent(new CustomEvent('ns:realtime-status', { detail: msg.job }));
          } else if (msg.type === 'job_event' && msg.event) {
            window.dispatchEvent(new CustomEvent('ns:cloud-event', { detail: msg.event }));
          }
        } catch (_) {}
      });
      socket.addEventListener('close', () => { connected = false; socket = null; scheduleReconnect(); });
      socket.addEventListener('error', () => { try { socket?.close(); } catch (_) {} });
    } catch (_) { connected = false; scheduleReconnect(); }
  }
  function disconnect() {
    desired = false;
    if (reconnectTimer) clearTimeout(reconnectTimer);
    reconnectTimer = null;
    try { socket?.close(); } catch (_) {}
    socket = null; connected = false;
  }
  function kick() { desired = true; connect(); }
  window.addEventListener('ns:cloud-control', kick);
  window.addEventListener('ns:session', kick);
  window.addEventListener('online', kick);
  document.addEventListener('visibilitychange', () => { if (!document.hidden) kick(); });
  window.addEventListener('load', kick);
  window.NinjaRealtime = { connect: kick, disconnect, connected: () => connected };
})();
