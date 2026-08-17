const CACHE_NAME = 'ns-shadow-cache-v19-autonomous-ops';
const STATIC_ASSETS = [
  '/panel/','/panel/index.html','/panel/style.css?v=9','/panel/cloud.js?v=6','/panel/app.js?v=19',
  '/panel/modules/security.js?v=6',
  '/panel/modules/ui.js?v=6','/panel/modules/sync.js?v=6','/panel/modules/workspace.js?v=6','/panel/modules/auth.js?v=6',
  '/panel/modules/account.js?v=6','/panel/modules/realtime.js?v=6','/panel/modules/history.js?v=6','/panel/modules/analytics.js?v=6',
  '/panel/modules/scheduler.js?v=6','/panel/modules/recipes.js?v=6','/panel/modules/diagnostics.js?v=6','/panel/modules/notifications.js?v=6',
  '/panel/modules/replay.js?v=6','/panel/modules/reliability.js?v=6','/panel/modules/autopilot.js?v=6','/panel/modules/release.js?v=6',
  '/panel/modules/pwa.js?v=6','/panel/modules/navigation.js?v=6',
  '/panel/version.json','/panel/release-manifest.json','/panel/manifest.json','/panel/offline.html',
  '/panel/assets/icon-192.png','/panel/assets/icon-512.png','/panel/assets/apple-touch-icon.png','/panel/assets/favicon.png','/panel/assets/logo.png'
];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(STATIC_ASSETS).catch(() => undefined)));
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
  if (request.mode === 'navigate') return event.respondWith(networkFirst(request, '/panel/offline.html'));
  if (/\.(?:js|css|json)$/.test(url.pathname)) return event.respondWith(networkFirst(request));
  if (/\.(?:png|jpg|jpeg|svg|webp|ico|woff2|woff|ttf)$/.test(url.pathname)) return event.respondWith(cacheFirst(request));
  event.respondWith(networkFirst(request));
});
self.addEventListener('push', event => {
  let data = {};
  try { data = event.data?.json?.() || {}; }
  catch (_) { data = { body: event.data?.text?.() || 'Ninja Sage update' }; }
  const title = data.title || 'Ninja Sage Control Center';
  event.waitUntil(Promise.all([
    self.registration.showNotification(title, {
      body: data.body || 'Automation update',
      icon: '/panel/assets/icon-192.png',
      badge: '/panel/assets/favicon.png',
      tag: `myninja-${data.event || 'event'}`,
      data: { url: data.url || '/panel/' }
    }),
    self.clients.matchAll({ type: 'window', includeUncontrolled: true })
      .then(clients => clients.forEach(client => client.postMessage({ type: 'push-event', data })))
  ]));
});
self.addEventListener('notificationclick', event => {
  event.notification.close();
  const url = event.notification.data?.url || '/panel/';
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then(clients => {
      for (const client of clients) {
        if ('focus' in client) {
          client.navigate?.(url);
          return client.focus();
        }
      }
      return self.clients.openWindow(url);
    })
  );
});
