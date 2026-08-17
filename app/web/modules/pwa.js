(() => {
  'use strict';

  let registration = null;
  let deferredPrompt = null;
  window.NinjaPWA = window.NinjaPWA || {};

  function ensureBanner() {
    let banner = document.getElementById('ns-update-banner');
    if (banner) return banner;
    banner = document.createElement('div');
    banner.id = 'ns-update-banner';
    banner.className = 'ns-update-banner hidden';
    banner.innerHTML = `
      <div>
        <strong id="ns-update-title">Update tersedia</strong>
        <small id="ns-update-notes"></small>
      </div>
      <div class="ns-update-actions">
        <button id="ns-update-later" class="btn btn-toggle" type="button">Later</button>
        <button id="ns-update-now" class="btn btn-primary" type="button">Update</button>
      </div>`;
    document.body.appendChild(banner);
    return banner;
  }

  async function versionInfo() {
    const response = await fetch('/panel/version.json', { cache: 'no-store' });
    if (!response.ok) return null;
    return response.json();
  }

  async function checkVersion() {
    const info = await versionInfo();
    if (!info?.version) return;
    const current = localStorage.getItem('ns_build_version');
    if (!current) {
      localStorage.setItem('ns_build_version', info.version);
      return;
    }
    if (current === info.version) return;

    const banner = ensureBanner();
    banner.classList.remove('hidden');
    document.getElementById('ns-update-title').textContent = `Ninja Sage v${info.version} tersedia`;
    document.getElementById('ns-update-notes').textContent =
      Array.isArray(info.changelog) ? info.changelog.slice(0, 2).join(' • ') : 'Build baru tersedia.';

    document.getElementById('ns-update-later').onclick = () => banner.classList.add('hidden');
    document.getElementById('ns-update-now').onclick = async () => {
      localStorage.setItem('ns_build_version', info.version);
      try {
        await registration?.update();
        if (registration?.waiting) registration.waiting.postMessage({ type: 'SKIP_WAITING' });
        else location.reload();
      } catch (_) {
        location.reload();
      }
    };
  }

  async function register() {
    if (!('serviceWorker' in navigator)) return;
    registration = await navigator.serviceWorker.register('/panel/sw.js', { updateViaCache: 'none' });
    window.NinjaPWA.registration = registration;
    await registration.update();

    registration.addEventListener('updatefound', () => {
      const worker = registration.installing;
      worker?.addEventListener('statechange', () => {
        if (worker.state === 'installed' && navigator.serviceWorker.controller) {
          checkVersion();
        }
      });
    });

    let reloading = false;
    navigator.serviceWorker.addEventListener('controllerchange', () => {
      if (reloading) return;
      reloading = true;
      location.reload();
    });
  }

  function installUI() {
    const button = document.getElementById('btn-install-pwa');
    if (!button) return;
    const standalone = window.matchMedia('(display-mode: standalone)').matches || window.navigator.standalone;
    if (standalone) {
      button.innerHTML = '<i class="fa-solid fa-circle-check"></i> Installed';
      button.disabled = true;
      return;
    }

    window.addEventListener('beforeinstallprompt', event => {
      event.preventDefault();
      deferredPrompt = event;
    });

    button.addEventListener('click', async () => {
      if (deferredPrompt) {
        deferredPrompt.prompt();
        await deferredPrompt.userChoice;
        deferredPrompt = null;
        return;
      }
      document.getElementById('modal-install-guide')?.classList.add('show');
    });
  }

  document.addEventListener('DOMContentLoaded', installUI);
  window.addEventListener('load', async () => {
    try {
      await register();
      await checkVersion();
    } catch (error) {
      console.warn('[PWA v5]', error);
    }
  });
})();
