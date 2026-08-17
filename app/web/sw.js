const CACHE_NAME = 'ns-shadow-cache-v17-control-center';
const STATIC_ASSETS = [
  '/panel/','/panel/index.html','/panel/style.css?v=7','/panel/cloud.js?v=5','/panel/app.js?v=17',
  '/panel/modules/ui.js?v=5','/panel/modules/sync.js?v=5','/panel/modules/workspace.js?v=5','/panel/modules/auth.js?v=5',
  '/panel/modules/account.js?v=5','/panel/modules/realtime.js?v=5','/panel/modules/history.js?v=5','/panel/modules/analytics.js?v=5',
  '/panel/modules/scheduler.js?v=5','/panel/modules/recipes.js?v=5','/panel/modules/diagnostics.js?v=5','/panel/modules/notifications.js?v=5',
  '/panel/modules/pwa.js?v=5','/panel/modules/navigation.js?v=5','/panel/version.json','/panel/manifest.json','/panel/offline.html',
  '/panel/assets/icon-192.png','/panel/assets/icon-512.png','/panel/assets/apple-touch-icon.png','/panel/assets/favicon.png','/panel/assets/logo.png'
];
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE_NAME).then(c=>c.addAll(STATIC_ASSETS).catch(()=>undefined))));
self.addEventListener('activate',e=>e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE_NAME).map(k=>caches.delete(k)))).then(()=>self.clients.claim())));
self.addEventListener('message',e=>{if(e.data?.type==='SKIP_WAITING')self.skipWaiting();});
async function networkFirst(request,fallback){try{const r=await fetch(request,{cache:'no-store'});if(r?.ok){const c=await caches.open(CACHE_NAME);c.put(request,r.clone());}return r;}catch(_){return(await caches.match(request))||(fallback?await caches.match(fallback):undefined);}}
async function cacheFirst(request){const cached=await caches.match(request);if(cached)return cached;const r=await fetch(request);if(r?.ok){const c=await caches.open(CACHE_NAME);c.put(request,r.clone());}return r;}
self.addEventListener('fetch',e=>{const r=e.request,u=new URL(r.url);if(r.method!=='GET'||u.pathname.startsWith('/api/'))return;if(r.mode==='navigate')return e.respondWith(networkFirst(r,'/panel/offline.html'));if(/\.(?:js|css|json)$/.test(u.pathname))return e.respondWith(networkFirst(r));if(/\.(?:png|jpg|jpeg|svg|webp|ico|woff2|woff|ttf)$/.test(u.pathname))return e.respondWith(cacheFirst(r));e.respondWith(networkFirst(r));});
self.addEventListener('push',event=>{let data={};try{data=event.data?.json?.()||{};}catch(_){data={body:event.data?.text?.()||'Ninja Sage update'};}const title=data.title||'Ninja Sage Control Center';event.waitUntil(Promise.all([self.registration.showNotification(title,{body:data.body||'Automation update',icon:'/panel/assets/icon-192.png',badge:'/panel/assets/favicon.png',tag:`myninja-${data.event||'event'}`,data:{url:data.url||'/panel/'}}),self.clients.matchAll({type:'window',includeUncontrolled:true}).then(clients=>clients.forEach(c=>c.postMessage({type:'push-event',data}))) ]));});
self.addEventListener('notificationclick',event=>{event.notification.close();const url=event.notification.data?.url||'/panel/';event.waitUntil(self.clients.matchAll({type:'window',includeUncontrolled:true}).then(clients=>{for(const c of clients){if('focus'in c){c.navigate?.(url);return c.focus();}}return self.clients.openWindow(url);}));});
