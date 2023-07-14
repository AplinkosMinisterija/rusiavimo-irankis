'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "f2a054b04d5c1558331f242a10a47332",
"index.html": "41ab6522ebd850c5d2f6b064b158b319",
"/": "41ab6522ebd850c5d2f6b064b158b319",
"main.dart.js": "53676e579a88e02fdd4ad44749fea575",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "6da6b342a0308c244876f1c2a7b457a7",
"assets/AssetManifest.json": "ab231382b83288f844ee44eed6b4ed32",
"assets/NOTICES": "997fca32597a24ab102ff99487df2129",
"assets/FontManifest.json": "b9bc23072c65d0d123f8e31881d94840",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "9cda082bd7cc5642096b56fa8db15b45",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "0a94bab8e306520dc6ae14c2573972ad",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b00363533ebe0bfdb95f3694d7647f6d",
"assets/packages/easy_localization/i18n/ar-DZ.json": "acc0a8eebb2fcee312764600f7cc41ec",
"assets/packages/easy_localization/i18n/en.json": "5f5fda8715e8bf5116f77f469c5cf493",
"assets/packages/easy_localization/i18n/en-US.json": "5f5fda8715e8bf5116f77f469c5cf493",
"assets/packages/easy_localization/i18n/ar.json": "acc0a8eebb2fcee312764600f7cc41ec",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/images/logo_old_2.png": "31fdfa292d1f134d08ee2f57ffeba455",
"assets/assets/images/norway_logo.png": "616a7f96427a87b8f65b645ca19e492e",
"assets/assets/images/logo_old.png": "293d6f14e43c68b323c74bba69c258bd",
"assets/assets/images/waste_sorting_monochrome.png": "c2d1ae45dada7d606bf696ccb87d1a3c",
"assets/assets/images/logo_monochrome.png": "55be2f4b3d9a188f9712e8832d860595",
"assets/assets/images/logo_monochrome_old_2.png": "2a7fdf478636475f706c28c570ac4971",
"assets/assets/images/logo.png": "55be2f4b3d9a188f9712e8832d860595",
"assets/assets/images/waste_sorting.png": "0bb0e12768daaa37e590b12340e82639",
"assets/assets/images/symbols/Explosive1-6.gif": "a32e915a7e57fffb382f8e28665bec91",
"assets/assets/images/symbols/Oxidizers.gif": "9e1a7748d129cec4a010b913fda68466",
"assets/assets/images/symbols/InfectiousSubstance.jpg": "d491d0b9a67e5ce3b25fc015c8d0caec",
"assets/assets/images/symbols/FlammableSolids.gif": "b884cc4e767fca58c088c779638d597d",
"assets/assets/images/symbols/C_monochrome.gif": "83bfa21abd4d26140f3a1347f1b6d025",
"assets/assets/images/symbols/Explosive1-5.gif": "24e7175861003d106bb33fa11a616a6e",
"assets/assets/images/symbols/Explosive1-4.gif": "bf98d1b0568f5676d5dbfa41d6b845ef",
"assets/assets/images/symbols/HealthHazard.gif": "616e4138d21027c2ba69e2314dc3bc7f",
"assets/assets/images/symbols/E_monochrome.gif": "9cdc4df9cf7a7395ee2ec70ce9f41e7a",
"assets/assets/images/symbols/GasesUnderPressure_monochrome.gif": "c76d091d47ba0a6a17a40eb4d82f94b3",
"assets/assets/images/symbols/Explosive1-1.gif": "5faa39caf7f5fb56b77d1f561e058a78",
"assets/assets/images/symbols/Explosive1-3.gif": "8dbca550925c0cc130eccde728aa75ef",
"assets/assets/images/symbols/FlammableAerosolsGases.gif": "be005cd08afc509856a072a13699fe5d",
"assets/assets/images/symbols/Non-FlammableGas.jpg": "060fcf92d875bc5c75fca4fbd3e9e71f",
"assets/assets/images/symbols/Explosives.gif": "680ee8c5c837b5918b1c070345be398a",
"assets/assets/images/symbols/Explosive1-2.gif": "95d7e906301d2a672416995e5fda926c",
"assets/assets/images/symbols/Class9.jpg": "9d536b68dc0351f70ca8a3dff00bfec9",
"assets/assets/images/symbols/Radioactive_4.jpg": "8cad7bcdc28aeec57f9f36ba4d65e53c",
"assets/assets/images/symbols/C.gif": "fd73a9798ffc3ac52753864ae84a8191",
"assets/assets/images/symbols/T.gif": "de4144cc6c0955a4830f4449f1d37ae6",
"assets/assets/images/symbols/HealthHazard_monochrome.gif": "3c949a10d34d1620e80daf1ccfcd5991",
"assets/assets/images/symbols/O_monochrome.gif": "9a9e06c5bdb84b9ff783c578eaa7da62",
"assets/assets/images/symbols/ExclamationMark.gif": "0c9247ece3c4c958a01fb8ae6045cc4f",
"assets/assets/images/symbols/N_monochrome.gif": "a670b4d30929441b25920d07889b3552",
"assets/assets/images/symbols/Radioactive_2.jpg": "2929a5417e71b08de1764c43fa762d66",
"assets/assets/images/symbols/Radioactive_3.jpg": "6bf6d5ec2edbb9d7a29bb31189488442",
"assets/assets/images/symbols/F_monochrome.gif": "01f3352500dfb4ac16c95452a06907aa",
"assets/assets/images/symbols/E.gif": "88075a5727ccc545bacf7e1b2194db3f",
"assets/assets/images/symbols/CorrosiveTransport.jpg": "47cfe46ca1a9f39282520c0e66c55cd7",
"assets/assets/images/symbols/Radioactive_1.jpg": "51b0beb8ffbdd1682e18c06b331a4959",
"assets/assets/images/symbols/PoisonGas.jpg": "25ea7416b666fdc33bc8bbb6d9308aea",
"assets/assets/images/symbols/F.gif": "495d007a74e41f37c5db88b1efda9afe",
"assets/assets/images/symbols/Poison.jpg": "06fe8e950164d6dc4d93df7c7ef95857",
"assets/assets/images/symbols/AcuteToxicity.gif": "98423f3927f5c2a6051df25e1b9226e7",
"assets/assets/images/symbols/Explosives_monochrome.gif": "bc884cf96199c89deb8fb1c5639cca96",
"assets/assets/images/symbols/Flammables.gif": "b8469efa07c7215d06f7090fe57ad17f",
"assets/assets/images/symbols/Flammables_monochrome.gif": "389e002d2b25ff9a60ee5f21add42b47",
"assets/assets/images/symbols/GasesUnderPressure.gif": "5af8b12e33377e31739cbdd0b6e68972",
"assets/assets/images/symbols/EnvironmentalToxicity.gif": "5745edea6d5b77f84f7243f936f11690",
"assets/assets/images/symbols/ExclamationMark_monochrome.gif": "9854d550fa33423147b9568e7dcec459",
"assets/assets/images/symbols/N.gif": "26fcc06370d692dbac6b6d2afba94cf3",
"assets/assets/images/symbols/T_monochrome.gif": "28254558748ad574f27d42e461570ba7",
"assets/assets/images/symbols/O.gif": "2837b00a2a7e3b59b44283a78c8b6a23",
"assets/assets/images/symbols/AcuteToxicity_monochrome.gif": "031a7ffeea5cfc8872a46f44f719f769",
"assets/assets/images/symbols/X.gif": "d937201c31745bc9b57b8457bddb3f90",
"assets/assets/images/symbols/Corrosives.gif": "f2d9f16055b73e8ae6b9a8eddbbb79e0",
"assets/assets/images/symbols/OxidizerTransport.jpg": "268b8aa9831b49cedb2fc0a4ba55f800",
"assets/assets/images/symbols/EnvironmentalToxicity_monochrome.gif": "00f026234b9ddbffa165d9f0088473a6",
"assets/assets/images/symbols/FlammableLiquids.gif": "3aa66440871725a629f74b450ba95dc8",
"assets/assets/images/symbols/X_monochrome.gif": "1b78d217fdb61e1cbca06edd56bae84a",
"assets/assets/images/symbols/SpontaneouslyCombustible.jpg": "5bd4eb5d96911fa7dea20ce9fbe681aa",
"assets/assets/images/symbols/DangerousWhenWet.gif": "5e433a1863f2efd54980a58660df5e5e",
"assets/assets/images/symbols/OrganicPeroxides.jpg": "b2534af5408183f14df97e5169f1b5eb",
"assets/assets/images/symbols/PoisonInhalationHazard.jpg": "2a513f280558953c3fd2b89825ad7576",
"assets/assets/images/symbols/Oxidizers_monochrome.gif": "906d8e5a5306bc520d0f6c3716ffd62d",
"assets/assets/images/symbols/Corrosives_monochrome.gif": "bdecfc4a6aa5471127f5cbc61a083208",
"assets/assets/images/logo_old2.png": "2991e23e60a2ebe78e10f7b95c3c207e",
"assets/assets/images/am_logo.png": "2a49eae3d8bf73bd6553f25a8dbdc26b",
"assets/assets/lang/lt.json": "778109ef5c89a0fe3ff7129233a275f8",
"assets/assets/lang/en.json": "1af230e29a971e38175ce8e083689a69",
"assets/assets/icons/question_mark_monochrome.png": "3dccb8520e9e128b6d00e0631ed65d86",
"assets/assets/icons/question_mark.png": "a7985cde96af1f3600b8713753fca7a3",
"assets/assets/icons/bussiness.png": "652bbf5e22d641613c527885d3f96d5f",
"assets/assets/icons/others.png": "9df83578e75d1dd5826d3c156a7ea26b",
"assets/assets/icons/household_waste.png": "7aa828d4c7bffa4aea8e6d981bddd8b6",
"assets/assets/icons/approved_mark_monochrome.png": "598f23c5033a7218d6c5572f230ea541",
"assets/assets/icons/residents.png": "e7283db2381f923ee69c106848dd839e",
"assets/assets/icons/automotive.png": "8b3d8e75aa5b349f0e8d11946f5bd3a4",
"assets/assets/icons/health_care.png": "07df0617b84c747efc548943532436b7",
"assets/assets/icons/pills.png": "710046396fecfb796c9ed616889c53b0",
"assets/assets/icons/approved_mark.png": "c3c65fcfd3712b1201ed1d2e25cba7cd",
"assets/assets/icons/red_exclemation_mark_monochrome.png": "6206fb2fe24dd52b3ac77797e9e1d91c",
"assets/assets/icons/construction.png": "3015a3c461eaaa573717d5cfe6cc4e97",
"assets/assets/icons/red_exclemation_mark.png": "a0e412d3804d30c55c03aef090fe0162",
"assets/assets/icons/car-battery.png": "e720b89f1e77a5dfc9c424ff64db558a",
"assets/assets/db/third_stage.json": "74d2ea1af065e76bb2793ef383d7b797",
"assets/assets/db/data.json": "4342bec895270e7b572aa457226dad5b",
"assets/assets/db/second_stage_questions.json": "2e4b5ea71eb1690c552b5a208cc4a58d",
"assets/assets/fonts/founders_grotesk/FoundersGrotesk-Regular.ttf": "294831bfe52117029ce5000b4cd1d9d2",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
