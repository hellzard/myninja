const CACHE_NAME = 'ns-shadow-cache-v13-cloud';

const STATIC_ASSETS = [
  '/panel/',
  '/panel/index.html',
  '/panel/style.css?v=3',
  '/panel/cloud.js?v=1',
  '/panel/app.js?v=14',
  '/panel/manifest.json',
  '/panel/offline.html',
  '/panel/assets/icon-192.png',
  '/panel/assets/icon-512.png',
  '/panel/assets/apple-touch-icon.png',
  '/panel/assets/favicon.png',
  '/panel/assets/logo.png'
];

self.addEventListener('install', event => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(STATIC_ASSETS).catch(err => {
        console.warn('[SW] Cache addAll partial warning:', err);
      });
    })
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.map(key => {
          if (key !== CACHE_NAME) {
            console.log('[SW] Clearing deprecated cache:', key);
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const req = event.request;
  const url = new URL(req.url);

  if (req.method !== 'GET' || url.pathname.startsWith('/api/')) {
    return;
  }

  if (req.mode === 'navigate') {
    event.respondWith(
      fetch(req).catch(() => {
        return caches.match('/panel/index.html').then(cached => {
          return cached || caches.match('/panel/offline.html');
        });
      })
    );
    return;
  }

  if (url.pathname.match(/\.(png|jpg|jpeg|svg|css|js|woff2|woff|ttf|ico)$/)) {
    event.respondWith(
      caches.match(req).then(cached => {
        if (cached) return cached;
        return fetch(req).then(networkRes => {
          if (networkRes && networkRes.status === 200) {
            const clone = networkRes.clone();
            caches.open(CACHE_NAME).then(cache => cache.put(req, clone));
          }
          return networkRes;
        }).catch(() => caches.match('/panel/offline.html'));
      })
    );
    return;
  }

  event.respondWith(
    fetch(req).then(res => {
      if (res && res.status === 200) {
        const clone = res.clone();
        caches.open(CACHE_NAME).then(cache => cache.put(req, clone));
      }
      return res;
    }).catch(() => caches.match(req))
  );
});
