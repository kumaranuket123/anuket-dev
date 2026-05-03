# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter web portfolio app deployed to GitHub Pages at `anuket.co.in`. Single-package, no workspace. Entrypoint: `lib/main.dart`.

## Flutter Version

Pinned to **3.41.9** via FVM (`.fvmrc`). Dart SDK `^3.11.4`. Use `fvm flutter` if FVM is active, otherwise `flutter` directly.

## Commands

```bash
flutter pub get                          # install dependencies
flutter run -d chrome                    # run locally in Chrome
flutter analyze                          # lint (some existing warnings are known, see below)
flutter test test/widget_test.dart       # run tests (currently boilerplate smoke test only)
flutter build web --release              # production build
```

CI sequence: `flutter clean` → `flutter pub get` → `flutter build web --release`

## Architecture

**No state management framework** — pure StatelessWidget/StatefulWidget composition.

**Routing:** GoRouter with `usePathUrlStrategy()` for clean URLs. Routes:
- `/` → `PortfolioScreen`
- `/project/:id` → `ProjectDetailScreen`
- `/callback` → `AuthCallbackPage`

**Data:** All portfolio content is loaded from `assets/data/portfolio_data.json`. Dart models with `.fromJson()` factories live in `lib/models/portfolio_data.dart`. Every project needs a stable non-empty `id` in JSON for `/project/:id` routing to work; missing fields (`fullDescription`, `features`, `screenshots`) silently degrade on detail pages.

**Responsive:** `Responsive.isMobile/isTablet/isDesktop(context)` from `lib/utils/responsive.dart`. Mobile vs desktop branching is done inline within each widget, not in separate files.

**Styling:** Colors centralized in `lib/theme/app_colors.dart`. Inter font via `google_fonts`.

## Known Issues / State

- `test/widget_test.dart` is the default Flutter counter smoke test — it fails against the real app. Do not treat it as meaningful coverage.
- `flutter analyze` reports existing warnings: `avoid_print`, deprecated `withOpacity` calls, and an explicit `flutter_web_plugins` dependency warning. These are pre-existing; don't treat them as regressions you caused.
- `README.md` is unmodified Flutter boilerplate; ignore it.

## Deploy

GitHub Actions at `.github/workflows/flutter_web_deploy.yml` triggers on pushes to `main`. The workflow copies `build/web/index.html` → `build/web/404.html` (required for GoRouter deep-link fallback on GitHub Pages) and writes `CNAME` before deploying to `gh-pages` branch. Do not remove the 404.html copy step if routing stays path-based.
