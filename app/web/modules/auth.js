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

  function getQuickCredentials() {
    try {
      const value = JSON.parse(sessionStorage.getItem(QUICK_KEY) || 'null');
      if (!value) return null;
      const user = value.user || value.username;
      const pass = value.pass || value.password;
      return user && pass ? { user, pass } : null;
    } catch (_) { return null; }
  }

  function saveQuickCredentials(username, password) {
    if (!username || !password) return;
    sessionStorage.setItem(QUICK_KEY, JSON.stringify({
      user: String(username),
      pass: String(password),
      saved_at: Date.now(),
    }));
    localStorage.removeItem(QUICK_KEY);
  }

  function clearQuickCredentials() {
    sessionStorage.removeItem(QUICK_KEY);
    localStorage.removeItem(QUICK_KEY);
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
    saveQuickCredentials(username, password);
    hydrate(session);
    return session;
  }

  function updateQuickButton(quickBtn) {
    if (!quickBtn) return;
    const ready = Boolean(getQuickCredentials());
    quickBtn.dataset.ready = ready ? 'true' : 'false';
    quickBtn.title = ready
      ? 'Quick Login siap untuk sesi tab ini'
      : 'Login manual sekali untuk mengaktifkan Quick Login pada sesi tab ini';
    quickBtn.innerHTML = ready
      ? '<i class="fa-solid fa-bolt"></i> QUICK LOGIN — READY'
      : '<i class="fa-solid fa-bolt"></i> QUICK LOGIN';
  }

  window.NinjaSession = { get: getSession, save: saveSession, hydrate };
  window.NinjaQuickLogin = {
    available: () => Boolean(getQuickCredentials()),
    forget: clearQuickCredentials,
  };

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

    updateQuickButton(quickBtn);

    async function performLogin(user, pass, source = 'manual') {
      if (!user || !pass) return;
      const activeButton = source === 'quick' ? quickBtn : loginBtn;
      if (activeButton) {
        activeButton.disabled = true;
        activeButton.innerHTML = source === 'quick'
          ? '<i class="fa-solid fa-spinner fa-spin"></i> QUICK LOGIN...'
          : '<i class="fa-solid fa-spinner fa-spin"></i> LOGGING IN...';
      }

      window.NinjaUI?.log(
        source === 'quick' ? 'Quick Login attempt' : `Login attempt for ${user}`,
        'warn'
      );

      try {
        const session = await login(user, pass);
        window.NinjaUI?.log(`Login successful: ${session.char_name}`, 'info');
      } catch (error) {
        window.NinjaUI?.log(
          `${source === 'quick' ? 'Quick Login' : 'Login'} failed: ${error.message}`,
          'error'
        );
        if (source === 'quick') {
          clearQuickCredentials();
          window.NinjaUI?.toast(
            'Quick Login gagal. Credential sesi dihapus; login manual sekali lagi.',
            'warn'
          );
        }
      } finally {
        if (loginBtn) {
          loginBtn.disabled = false;
          loginBtn.innerHTML = '<i class="fa-solid fa-right-to-bracket"></i> INITIALIZE CONNECTION';
        }
        if (quickBtn) {
          quickBtn.disabled = false;
          updateQuickButton(quickBtn);
        }
      }
    }

    form?.addEventListener('submit', async event => {
      event.preventDefault();
      const user = document.getElementById('login-user')?.value?.trim() || '';
      const pass = document.getElementById('login-pass')?.value || '';
      await performLogin(user, pass, 'manual');
    });

    quickBtn?.addEventListener('click', async () => {
      const creds = getQuickCredentials();
      if (!creds) {
        window.NinjaUI?.toast(
          'Quick Login belum siap. Login manual sekali pada tab ini terlebih dahulu.',
          'warn'
        );
        return;
      }
      await performLogin(creds.user, creds.pass, 'quick');
    });

    document.getElementById('btn-logout')?.addEventListener('click', () => {
      const current = getSession();
      if (!current) return;
      if (confirm('Logout dari panel ini?')) {
        saveSession(null);
        location.reload();
      }
    });
  });
})();
