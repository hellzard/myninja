(() => {
  'use strict';

  const SESSION_KEY = 'ns_session';
  const QUICK_KEY = 'ns_quick_login';

  function getSession() {
    try { return JSON.parse(localStorage.getItem(SESSION_KEY) || 'null'); }
    catch (_) { return null; }
  }

  function saveSession(session) {
    if (session) localStorage.setItem(SESSION_KEY, JSON.stringify(session));
    else localStorage.removeItem(SESSION_KEY);
    window.dispatchEvent(new CustomEvent('ns:session', { detail: session || null }));
  }

  function hydrate(session) {
    const auth = document.getElementById('auth-view');
    const shell = document.getElementById('app-shell');
    if (!session) {
      auth?.classList.remove('hidden');
      shell?.classList.add('hidden');
      return;
    }

    auth?.classList.add('hidden');
    shell?.classList.remove('hidden');
    const values = {
      'metric-char': session.char_name || 'Unknown',
      'metric-char-id': session.char_id || 'Unknown',
      'metric-level': session.level ?? '--',
      'metric-xp': session.xp ?? '--',
      'metric-gold': session.gold ?? '--',
      'metric-token': session.tokens ?? '--',
    };
    for (const [id, value] of Object.entries(values)) {
      const el = document.getElementById(id);
      if (el) el.textContent = value;
    }
  }

  async function login(username, password) {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      cache: 'no-store',
      body: JSON.stringify({ username, password }),
    });
    const data = await response.json();
    if (!response.ok || data.status !== 'success') {
      throw new Error(data.message || data.detail || `HTTP ${response.status}`);
    }
    const session = {
      sessionkey: data.sessionkey,
      char_id: data.char_id,
      char_name: data.char_name,
      level: data.level ?? '--',
      xp: data.xp ?? '--',
      gold: data.gold ?? '--',
      tokens: data.tokens ?? '--',
    };
    saveSession(session);
    sessionStorage.setItem(QUICK_KEY, JSON.stringify({ user: username, pass: password }));
    localStorage.removeItem(QUICK_KEY);
    hydrate(session);
    return session;
  }

  window.NinjaSession = { get: getSession, save: saveSession, hydrate };


  window.addEventListener('ns:sync-session', event => {
    const remote = event.detail || {};
    if (remote.logged_out) {
      localStorage.removeItem(SESSION_KEY);
      hydrate(null);
      return;
    }
    if (remote.char_id) {
      localStorage.setItem(SESSION_KEY, JSON.stringify(remote));
      hydrate(remote);
    }
  });

  document.addEventListener('DOMContentLoaded', () => {
    localStorage.removeItem(QUICK_KEY);
    hydrate(getSession());

    const form = document.getElementById('login-form');
    const loginBtn = document.getElementById('login-btn');
    const quickBtn = document.getElementById('quick-login-btn');

    form?.addEventListener('submit', async event => {
      event.preventDefault();
      const user = document.getElementById('login-user')?.value?.trim() || '';
      const pass = document.getElementById('login-pass')?.value || '';
      if (!user || !pass) return;

      if (loginBtn) {
        loginBtn.disabled = true;
        loginBtn.textContent = 'Logging in...';
      }
      window.NinjaUI?.log(`Login attempt for ${user}`, 'warn');
      try {
        const session = await login(user, pass);
        window.NinjaUI?.log(`Login successful: ${session.char_name}`, 'info');
      } catch (error) {
        window.NinjaUI?.log(`Login failed: ${error.message}`, 'error');
      } finally {
        if (loginBtn) {
          loginBtn.disabled = false;
          loginBtn.innerHTML = '<i class="fa-solid fa-right-to-bracket"></i> INITIALIZE CONNECTION';
        }
      }
    });

    quickBtn?.addEventListener('click', () => {
      try {
        const creds = JSON.parse(sessionStorage.getItem(QUICK_KEY) || 'null');
        if (!creds?.user || !creds?.pass) {
          window.NinjaUI?.toast('Quick Login tersedia hanya selama sesi browser ini.', 'warn');
          return;
        }
        const user = document.getElementById('login-user');
        const pass = document.getElementById('login-pass');
        if (user) user.value = creds.user;
        if (pass) pass.value = creds.pass;
        form?.dispatchEvent(new Event('submit', { cancelable: true, bubbles: true }));
      } catch (_) {}
    });

    document.getElementById('btn-logout')?.addEventListener('click', () => {
      // cloud.js capture listener handles active cloud jobs first.
      const current = getSession();
      if (!current) return;
      if (confirm('Logout dari panel ini?')) {
        saveSession(null);
        sessionStorage.removeItem(QUICK_KEY);
        location.reload();
      }
    });
  });
})();
