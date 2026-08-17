(() => {
  'use strict';

  let socket = null;
  let reconnectTimer = null;
  let pingTimer = null;
  let staleTimer = null;
  let attempts = 0;
  let connected = false;
  let desired = true;
  let generation = 0;
  let lastMessageAt = 0;

  const PING_MS = 20000;
  const STALE_MS = 50000;
  const MAX_RECONNECT_MS = 30000;

  function session() { return window.NinjaSession?.get?.() || null; }
  function control(id) {
    try { return JSON.parse(localStorage.getItem(`ns_cloud_control_${id}`) || 'null'); }
    catch (_) { return null; }
  }
  function emit(detail) {
    window.dispatchEvent(new CustomEvent('ns:realtime-state', {
      detail: { connected, attempts, last_message_at: lastMessageAt || null, ...detail }
    }));
  }
  async function ticket(charId, token) {
    const r = await fetch('/api/bot/cloud/ws-ticket', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      cache: 'no-store',
      body: JSON.stringify({ char_id: charId, control_token: token }),
    });
    const data = await r.json();
    if (!r.ok || data.status !== 'success') throw new Error(data.detail || `HTTP ${r.status}`);
    return data.ticket;
  }
  function clearTimers() {
    if (pingTimer) clearInterval(pingTimer);
    if (staleTimer) clearInterval(staleTimer);
    pingTimer = staleTimer = null;
  }
  function clearReconnect() {
    if (reconnectTimer) clearTimeout(reconnectTimer);
    reconnectTimer = null;
  }
  function scheduleReconnect(reason = 'disconnected') {
    if (!desired || reconnectTimer || !navigator.onLine) return;
    const exp = Math.min(attempts++, 5);
    const wait = Math.min(MAX_RECONNECT_MS, 1000 * (2 ** exp)) + Math.floor(Math.random() * 600);
    reconnectTimer = setTimeout(() => {
      reconnectTimer = null;
      connect();
    }, wait);
    emit({ reason, reconnect_in_ms: wait });
  }
  function closeSocket({ reconnect = false, reason = 'closed' } = {}) {
    generation += 1;
    clearTimers();
    clearReconnect();
    const ws = socket;
    socket = null;
    connected = false;
    if (ws && ws.readyState < WebSocket.CLOSING) {
      try { ws.close(1000, reason.slice(0, 100)); } catch (_) {}
    }
    emit({ reason });
    if (reconnect) scheduleReconnect(reason);
  }
  function startHeartbeat(ws, myGeneration) {
    clearTimers();
    pingTimer = setInterval(() => {
      if (generation !== myGeneration || ws.readyState !== WebSocket.OPEN) return;
      try { ws.send(JSON.stringify({ type: 'ping', ts: Date.now() })); } catch (_) {}
    }, PING_MS);
    staleTimer = setInterval(() => {
      if (generation !== myGeneration || !lastMessageAt) return;
      if (Date.now() - lastMessageAt > STALE_MS) {
        try { ws.close(4000, 'stale connection'); } catch (_) {}
      }
    }, 5000);
  }
  async function connect() {
    if (!desired || !navigator.onLine) return;
    if (socket?.readyState === WebSocket.OPEN || socket?.readyState === WebSocket.CONNECTING) return;

    const s = session();
    const c = s?.char_id ? control(s.char_id) : null;
    if (!s?.char_id || !c?.token) return;

    const myGeneration = ++generation;
    clearReconnect();
    emit({ reason: 'connecting' });

    try {
      const t = await ticket(s.char_id, c.token);
      if (generation !== myGeneration || !desired) return;

      const proto = location.protocol === 'https:' ? 'wss:' : 'ws:';
      const ws = new WebSocket(
        `${proto}//${location.host}/api/bot/cloud/ws/${encodeURIComponent(s.char_id)}?ticket=${encodeURIComponent(t)}`
      );
      socket = ws;

      ws.addEventListener('open', () => {
        if (generation !== myGeneration) return;
        connected = true;
        attempts = 0;
        lastMessageAt = Date.now();
        startHeartbeat(ws, myGeneration);
        emit({ reason: 'connected', reconnect_in_ms: 0 });
      });

      ws.addEventListener('message', event => {
        if (generation !== myGeneration) return;
        lastMessageAt = Date.now();
        try {
          const msg = JSON.parse(event.data);
          if (msg.type === 'pong') {
            emit({ reason: 'healthy' });
            return;
          }
          if ((msg.type === 'job_status' || msg.type === 'heartbeat') && msg.job) {
            window.dispatchEvent(new CustomEvent('ns:realtime-status', { detail: msg.job }));
          } else if (msg.type === 'job_event' && msg.event) {
            window.dispatchEvent(new CustomEvent('ns:cloud-event', { detail: msg.event }));
          }
        } catch (_) {}
      });

      ws.addEventListener('close', event => {
        if (generation !== myGeneration) return;
        clearTimers();
        socket = null;
        connected = false;
        scheduleReconnect(event.code === 1000 ? 'closed' : `closed:${event.code}`);
      });

      ws.addEventListener('error', () => {
        if (generation !== myGeneration) return;
        try { ws.close(); } catch (_) {}
      });
    } catch (error) {
      if (generation !== myGeneration) return;
      connected = false;
      scheduleReconnect(error?.message || 'ticket failed');
    }
  }
  function disconnect() {
    desired = false;
    closeSocket({ reconnect: false, reason: 'manual disconnect' });
  }
  function kick() {
    desired = true;
    connect();
  }

  window.addEventListener('ns:cloud-control', kick);
  window.addEventListener('ns:session', kick);
  window.addEventListener('online', kick);
  window.addEventListener('offline', () => closeSocket({ reconnect: false, reason: 'offline' }));
  document.addEventListener('visibilitychange', () => { if (!document.hidden) kick(); });

  window.addEventListener('pagehide', () => {
    desired = false;
    closeSocket({ reconnect: false, reason: 'pagehide' });
  });
  window.addEventListener('pageshow', () => {
    desired = true;
    connect();
  });
  window.addEventListener('load', kick);

  window.NinjaRealtime = {
    connect: kick,
    disconnect,
    connected: () => connected,
    lastMessageAt: () => lastMessageAt,
  };
})();