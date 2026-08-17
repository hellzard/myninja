(() => {
  'use strict';
  const META_KEY = 'ns_workspace_profiles_v5';
  const CURRENT_KEY = 'ns_workspace_current_v5';
  const sessionKey = id => `ns_workspace_session_${id}`;

  function profiles() {
    try { return JSON.parse(localStorage.getItem(META_KEY) || '[]'); } catch (_) { return []; }
  }
  function saveProfiles(items) { localStorage.setItem(META_KEY, JSON.stringify(items.slice(-12))); }
  function remember(session) {
    if (!session?.char_id) return;
    const id = Number(session.char_id);
    const list = profiles().filter(x => Number(x.char_id) !== id);
    list.push({ char_id: id, char_name: session.char_name || `Ninja ${id}`, level: session.level ?? '--', updated_at: Date.now() });
    saveProfiles(list);
    sessionStorage.setItem(sessionKey(id), JSON.stringify(session));
    localStorage.setItem(CURRENT_KEY, String(id));
    render();
  }
  function activate(id) {
    try {
      const session = JSON.parse(sessionStorage.getItem(sessionKey(id)) || 'null');
      if (!session?.sessionkey) {
        window.NinjaUI?.toast('Session profile ini tidak aktif lagi. Login ulang untuk mengaktifkannya.', 'warn');
        return false;
      }
      localStorage.setItem('ns_session', JSON.stringify(session));
      localStorage.setItem(CURRENT_KEY, String(id));
      location.reload();
      return true;
    } catch (_) { return false; }
  }
  function render() {
    const host = document.querySelector('.profile-id');
    if (!host) return;
    let select = document.getElementById('ns-workspace-select');
    if (!select) {
      select = document.createElement('select');
      select.id = 'ns-workspace-select';
      select.className = 'ns-workspace-select';
      select.title = 'Character Workspace';
      host.insertAdjacentElement('afterend', select);
      select.addEventListener('change', () => activate(select.value));
    }
    const current = window.NinjaSession?.get?.();
    const list = profiles();
    select.innerHTML = list.map(p => `<option value="${p.char_id}">${p.char_name} · Lv.${p.level}</option>`).join('');
    if (current?.char_id) select.value = String(current.char_id);
  }
  window.addEventListener('ns:session', event => { if (event.detail?.char_id) remember(event.detail); });
  window.addEventListener('ns:account-stats', () => { const s = window.NinjaSession?.get?.(); if (s) remember(s); });
  document.addEventListener('DOMContentLoaded', () => { const current = window.NinjaSession?.get?.(); if (current) remember(current); else render(); });
  window.NinjaWorkspace = { profiles, remember, activate };
})();
