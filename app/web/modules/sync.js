(() => {
  'use strict';
  const source = crypto.randomUUID?.() || Math.random().toString(36).slice(2);
  const channel = 'BroadcastChannel' in window ? new BroadcastChannel('myninja-control-v5') : null;

  function post(type, detail) {
    try { channel?.postMessage({ source, type, detail, ts: Date.now() }); } catch (_) {}
  }
  channel?.addEventListener('message', event => {
    const msg = event.data || {};
    if (!msg.type || msg.source === source) return;
    window.dispatchEvent(new CustomEvent(`ns:sync-${msg.type}`, { detail: { ...(msg.detail || {}), __sync: true } }));
  });

  window.addEventListener('ns:cloud-status', event => { if (!event.detail?.__sync) post('cloud-status', event.detail); });
  window.addEventListener('ns:account-stats', event => { if (!event.detail?.__sync) post('account-stats', event.detail); });
  window.addEventListener('ns:session', event => { if (!event.detail?.__sync) post('session', event.detail || { logged_out: true }); });
  window.NinjaSync = { post, source };
})();
