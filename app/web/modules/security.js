(() => {
  'use strict';

  const SESSION_KEY = 'ns_panel_session_v6';
  const originalFetch = window.fetch.bind(window);

  function sameApi(input) {
    try {
      const url = new URL(typeof input === 'string' ? input : input.url, location.href);
      return url.origin === location.origin && url.pathname.startsWith('/api/');
    } catch (_) { return false; }
  }

  window.fetch = function(input, init = {}) {
    if (!sameApi(input)) return originalFetch(input, init);
    const url = new URL(typeof input === 'string' ? input : input.url, location.href);
    if (url.pathname.startsWith('/api/v6/security/')) return originalFetch(input, init);
    const token = sessionStorage.getItem(SESSION_KEY);
    const headers = new Headers(init.headers || (input instanceof Request ? input.headers : undefined));
    if (token) headers.set('X-Panel-Session', token);
    return originalFetch(input, { ...init, headers });
  };

  function b64ToBuf(value) {
    const padded = value.replace(/-/g, '+').replace(/_/g, '/') + '='.repeat((4 - value.length % 4) % 4);
    const raw = atob(padded);
    return Uint8Array.from(raw, c => c.charCodeAt(0)).buffer;
  }

  function bufToB64(buffer) {
    const bytes = new Uint8Array(buffer || new ArrayBuffer(0));
    let raw = '';
    bytes.forEach(b => raw += String.fromCharCode(b));
    return btoa(raw).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/g, '');
  }

  function prepCreate(options) {
    const o = structuredClone(options);
    o.challenge = b64ToBuf(o.challenge);
    o.user.id = b64ToBuf(o.user.id);
    (o.excludeCredentials || []).forEach(c => c.id = b64ToBuf(c.id));
    return o;
  }

  function prepGet(options) {
    const o = structuredClone(options);
    o.challenge = b64ToBuf(o.challenge);
    (o.allowCredentials || []).forEach(c => c.id = b64ToBuf(c.id));
    return o;
  }

  function serializeCredential(credential) {
    const response = credential.response;
    const base = {
      id: credential.id,
      rawId: bufToB64(credential.rawId),
      type: credential.type,
      authenticatorAttachment: credential.authenticatorAttachment || null,
      clientExtensionResults: credential.getClientExtensionResults?.() || {},
    };
    if ('attestationObject' in response) {
      base.response = {
        attestationObject: bufToB64(response.attestationObject),
        clientDataJSON: bufToB64(response.clientDataJSON),
        transports: response.getTransports?.() || [],
      };
    } else {
      base.response = {
        authenticatorData: bufToB64(response.authenticatorData),
        clientDataJSON: bufToB64(response.clientDataJSON),
        signature: bufToB64(response.signature),
        userHandle: response.userHandle ? bufToB64(response.userHandle) : null,
      };
    }
    return base;
  }

  async function jsonFetch(path, options = {}) {
    const response = await originalFetch(path, {
      cache: 'no-store',
      headers: { 'Content-Type': 'application/json', ...(options.headers || {}) },
      ...options,
    });
    const data = await response.json().catch(() => ({}));
    if (!response.ok) throw new Error(data.detail || `HTTP ${response.status}`);
    return data;
  }

  function ensureOverlay() {
    let overlay = document.getElementById('ns-panel-guard');
    if (overlay) return overlay;
    overlay = document.createElement('div');
    overlay.id = 'ns-panel-guard';
    overlay.className = 'ns-panel-guard';
    overlay.innerHTML = `
      <div class="glass-panel ns-panel-guard-card">
        <div class="ns-guard-icon"><i class="fa-solid fa-fingerprint"></i></div>
        <h2>Control Center Locked</h2>
        <p id="ns-guard-message">Verify your passkey to unlock automation controls.</p>
        <div id="ns-guard-setup" class="hidden">
          <label>One-time setup token</label>
          <input id="ns-guard-token" class="input-field" type="password" autocomplete="off" placeholder="PANEL_SETUP_TOKEN">
          <button id="ns-guard-enroll" class="btn btn-primary" type="button">Enroll Passkey</button>
        </div>
        <button id="ns-guard-unlock" class="btn btn-primary" type="button">Unlock with Passkey</button>
        <small id="ns-guard-status"></small>
      </div>`;
    document.body.appendChild(overlay);
    return overlay;
  }

  function setStatus(text, level = 'info') {
    const el = document.getElementById('ns-guard-status');
    if (el) {
      el.textContent = text;
      el.dataset.level = level;
    }
  }

  async function enroll() {
    const token = document.getElementById('ns-guard-token')?.value || '';
    if (!token) return setStatus('Setup token required.', 'warn');
    try {
      setStatus('Creating passkey…');
      const begin = await jsonFetch('/api/v6/security/register/options', {
        method: 'POST',
        body: JSON.stringify({ setup_token: token }),
      });
      const credential = await navigator.credentials.create({ publicKey: prepCreate(begin.options) });
      const finish = await jsonFetch('/api/v6/security/register/finish', {
        method: 'POST',
        body: JSON.stringify({
          ceremony_id: begin.ceremony_id,
          setup_token: token,
          credential: serializeCredential(credential),
        }),
      });
      sessionStorage.setItem(SESSION_KEY, finish.session);
      location.reload();
    } catch (error) {
      setStatus(`Enrollment failed: ${error.message}`, 'error');
    }
  }

  async function unlock() {
    try {
      setStatus('Waiting for passkey…');
      const begin = await jsonFetch('/api/v6/security/auth/options', { method: 'POST', body: '{}' });
      const credential = await navigator.credentials.get({ publicKey: prepGet(begin.options) });
      const finish = await jsonFetch('/api/v6/security/auth/finish', {
        method: 'POST',
        body: JSON.stringify({
          ceremony_id: begin.ceremony_id,
          credential: serializeCredential(credential),
        }),
      });
      sessionStorage.setItem(SESSION_KEY, finish.session);
      location.reload();
    } catch (error) {
      setStatus(`Unlock failed: ${error.message}`, 'error');
    }
  }

  async function boot() {
    try {
      const data = await jsonFetch('/api/v6/security/status');
      const security = data.security || {};
      window.__nsPanelGuard = security;
      if (!security.enabled) return;

      if (!security.configured) {
        const overlay = ensureOverlay();
        overlay.classList.add('show');
        document.getElementById('ns-guard-message').textContent =
          'Panel Guard is enabled but server configuration is incomplete.';
        document.getElementById('ns-guard-unlock').classList.add('hidden');
        setStatus('Check JOURNAL_DATABASE_URL, PANEL_SESSION_SECRET, PANEL_ALLOWED_ORIGINS and webauthn dependency.', 'error');
        return;
      }

      const current = sessionStorage.getItem(SESSION_KEY);
      if (current) return;

      const overlay = ensureOverlay();
      overlay.classList.add('show');
      document.getElementById('ns-guard-unlock').onclick = unlock;
      document.getElementById('ns-guard-enroll').onclick = enroll;
      if (!security.enrolled) {
        document.getElementById('ns-guard-setup').classList.remove('hidden');
        document.getElementById('ns-guard-unlock').classList.add('hidden');
        document.getElementById('ns-guard-message').textContent =
          'No passkey is enrolled yet. Use the one-time setup token from your server environment.';
      }
    } catch (error) {
      console.warn('[PanelGuard]', error);
    }
  }

  window.NinjaSecurity = {
    session: () => sessionStorage.getItem(SESSION_KEY),
    lock: () => { sessionStorage.removeItem(SESSION_KEY); location.reload(); },
  };

  document.addEventListener('DOMContentLoaded', boot);
})();