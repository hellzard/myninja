const CACHE_NAME = 'ns-shadow-cache-v16-cloud-engine';
const STATIC_ASSETS = [
  '/panel/',
  '/panel/index.html',
  '/panel/style.css?v=6',
  '/panel/cloud.js?v=4',
  '/panel/app.js?v=16',
  '/panel/modules/ui.js?v=4',
  '/panel/modules/auth.js?v=4',
  '/panel/modules/account.js?v=4',
  '/panel/modules/analytics.js?v=4',
  '/panel/modules/scheduler.js?v=4',
  '/panel/modules/pwa.js?v=4',
  '/panel/version.json',
  '/panel/manifest.json',
  '/panel/offline.html',
  '/panel/assets/icon-192.png',
  '/panel/assets/icon-512.png',
  '/panel/assets/apple-touch-icon.png',
  '/panel/assets/favicon.png',
  '/panel/assets/logo.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(STATIC_ASSETS).catch(() => undefined))
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('message', event => {
  if (event.data?.type === 'SKIP_WAITING') self.skipWaiting();
});

async function networkFirst(request, fallback) {
  try {
    const response = await fetch(request, { cache: 'no-store' });
    if (response?.ok) {
      const cache = await caches.open(CACHE_NAME);
      cache.put(request, response.clone());
    }
    return response;
  } catch (_) {
    return (await caches.match(request)) || (fallback ? await caches.match(fallback) : undefined);
  }
}

async function cacheFirst(request) {
  const cached = await caches.match(request);
  if (cached) return cached;
  const response = await fetch(request);
  if (response?.ok) {
    const cache = await caches.open(CACHE_NAME);
    cache.put(request, response.clone());
  }
  return response;
}

self.addEventListener('fetch', event => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== 'GET' || url.pathname.startsWith('/api/')) return;

  if (request.mode === 'navigate') {
    event.respondWith(networkFirst(request, '/panel/offline.html'));
    return;
  }

  if (/\.(?:js|css|json)$/.test(url.pathname)) {
    event.respondWith(networkFirst(request));
    return;
  }

  if (/\.(?:png|jpg|jpeg|svg|webp|ico|woff2|woff|ttf)$/.test(url.pathname)) {
    event.respondWith(cacheFirst(request));
    return;
  }

  event.respondWith(networkFirst(request));
});
