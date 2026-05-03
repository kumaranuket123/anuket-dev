{{flutter_js}}
{{flutter_build_config}}

// Detect Instagram in-app browser and other restricted WebViews
const ua = navigator.userAgent || '';
const isInstagram = ua.includes('Instagram');
const isRestricted = isInstagram
  || ua.includes('FBAN')       // Facebook
  || ua.includes('FBAV')       // Facebook
  || ua.includes('Twitter')
  || ua.includes('LinkedInApp');

// Always use HTML renderer — CanvasKit requires WASM + heavy JS that
// Instagram and other in-app browsers block or fail to load silently.
const renderer = 'html';

_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({
      renderer: renderer,
      // Disable service worker in restricted WebViews — they often block it
      useColorEmoji: true,
    });
    await appRunner.runApp();
  },
});
