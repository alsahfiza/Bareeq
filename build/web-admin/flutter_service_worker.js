'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/assets/icon.png": "774d8315358d7ba7024e70d90a50dc52",
"assets/assets/computer.jpg": "ff922f36cb04b0b5cd281870461dbe34",
"assets/assets/bag.jpg": "21362347daded525ad9aeb6d887a7b01",
"assets/assets/images/connection_error.svg": "8f728f51195f90a2f02f19ba94353a49",
"assets/assets/images/profile_placeholder.jpg": "0b9235c3b9875ba7995fef1d5b4b287a",
"assets/assets/images/empty_wishlist.png": "5316e6aa5db0d65a39e1afba8bb7caae",
"assets/assets/images/categories/beauty.png": "fc931cc6c93d5669add91d04b26436f3",
"assets/assets/images/categories/clothes.png": "c5bb3a05b8d0a3f945dfb571df368574",
"assets/assets/images/categories/sport.png": "6e75fbe760e941edef6a3b47e844e08c",
"assets/assets/images/categories/computer.png": "afed2f48e355a67b7dfe8b6477eb9964",
"assets/assets/images/categories/electronic.png": "562dd033a775bf7baf799bf20c231165",
"assets/assets/images/categories/phone.png": "87556490b11980c5915578e03b1cf416",
"assets/assets/images/categories/drinks.png": "8614d9452463a1361c2e608fcd6b3a07",
"assets/assets/images/categories/shoes.png": "db3b21354c47a737f82b509627f40574",
"assets/assets/images/categories/add.png": "f6c7353cdc5e7ece2761b105399ca2c4",
"assets/assets/images/categories/food.png": "1870972a1527e8256a88549e0be6103b",
"assets/assets/images/google_100px.png": "941f8791ce0c6488f1857af3f52ac55a",
"assets/assets/images/empty_cart.png": "c4230db1697508105bac947cd1b7f562",
"assets/assets/images/search.svg": "0d49cba5417e7982fa45b867f2ed130f",
"assets/assets/images/facebook.png": "24e40e2ade35f36ecd35286a86be3d4a",
"assets/assets/images/carousels/carousel_2.png": "78fff965cafd3b9dc1f43d8de9625f14",
"assets/assets/images/carousels/carousel_6.png": "43d7094613ff7bd119e7c11cd6870034",
"assets/assets/images/carousels/carousel_1.png": "fef0f5a7d44d604a45b0d3c960100c69",
"assets/assets/images/carousels/carousel_3.png": "5768ab1ee60e23a4436a0b17ee5959a4",
"assets/assets/images/carousels/carousel_5.png": "423f8507c7f8b3af50069a47ab98d8d5",
"assets/assets/images/carousels/carousel_4.png": "f8693b79531e009bbb7e02cff0128362",
"assets/assets/images/google.png": "941f8791ce0c6488f1857af3f52ac55a",
"assets/assets/shoes.jpg": "705637d1d703dd91cbcbb960c65f9c49",
"assets/assets/dress.jpg": "7d4e3074daf8aea691581121ff309e5d",
"assets/assets/phone.jpg": "34082e45edba3f9607f67a3bb115a537",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "282bb63bb33061b44d535c2c693a7dca",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "1fcba7a59e49001aa1b4409a25d425b0",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/NOTICES": "6d4edfbac17569ad6d39e5a3be4f005a",
"assets/fonts/MaterialIcons-Regular.otf": "862d83f270ca0f301d84b863573d0814",
"assets/AssetManifest.bin": "c32ac02f2ce405acdad12c8d2d7f0ae8",
"assets/AssetManifest.bin.json": "72cc20cec0c0b38977994be91ec793de",
"assets/FontManifest.json": "c75f7af11fb9919e042ad2ee704db319",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"index.html": "b09814d2427b2439afe55c483c3c1f0d",
"/": "b09814d2427b2439afe55c483c3c1f0d",
"main.dart.js": "418e69e75ec01532235fa0704e7aa77e",
"flutter_bootstrap.js": "086159552ea28549b07655d905077943",
"version.json": "3f237a2684dffa10bb51d4ccae6924fd",
"manifest.json": "bf24c84c3bf99672a631c4f84464e793",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
