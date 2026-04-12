# AGENTS.md

## Repo Shape
- Single Flutter app; no workspace or multi-package layout.
- App entrypoint is `lib/main.dart`.
- Main screens are `lib/screens/portfolio_screen.dart` for `/` and `lib/screens/project_detail_screen.dart` for `/project/:id`.
- Portfolio content is data-driven from `assets/data/portfolio_data.json`; Dart models live in `lib/models/portfolio_data.dart`.

## Commands
- Install deps: `flutter pub get`
- Run locally: `flutter run -d chrome`
- Analyze: `flutter analyze`
- Run one test file: `flutter test test/widget_test.dart`
- Build web release: `flutter build web --release`
- CI deploy sequence is `flutter clean` -> `flutter pub get` -> `flutter build web --release`.

## Routing And Data Gotchas
- Web routing uses `usePathUrlStrategy()` in `lib/main.dart`, so refresh/deep-link behavior depends on static hosting fallback support.
- GitHub Pages deploy works around this by copying `build/web/index.html` to `build/web/404.html`; keep that behavior if routing stays path-based.
- `ProjectsSection` links case studies with `context.go('/project/${widget.item.id}')`; every project that should open a detail page needs a stable non-empty `id` in `assets/data/portfolio_data.json`.
- `ProjectItem` also supports `fullDescription`, `features`, and `screenshots`; missing fields fall back to empty values, so detail pages silently degrade if JSON omits them.

## Styling / Structure
- Shared colors are centralized in `lib/theme/app_colors.dart`.
- Responsive branching is done with `Responsive.isMobile(context)` from `lib/utils/responsive.dart`; existing sections split mobile vs desktop inline instead of using separate widget trees/files.
- `google_fonts`, `font_awesome_flutter`, `go_router`, and `url_launcher` are core app dependencies, not incidental additions.

## Verification Reality
- `README.md` is Flutter boilerplate and does not describe this app.
- `test/widget_test.dart` is still the default counter smoke test and currently fails against the real app; do not treat it as meaningful coverage until it is replaced.
- `flutter analyze` currently reports existing warnings/info, including an explicit dependency warning for `flutter_web_plugins` and several deprecated `withOpacity` calls.

## Deploy Notes
- GitHub Actions workflow is `.github/workflows/flutter_web_deploy.yml`.
- Deploys on pushes to `main` and writes `build/web/CNAME` with `anuket.co.in` before publishing to `gh-pages`.
