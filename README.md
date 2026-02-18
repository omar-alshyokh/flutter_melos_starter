# Flutter Melos Starter

A Flutter monorepo starter using **Melos + Dart workspace** with a clean, feature-first package structure.

This repository demonstrates how to keep the app thin, move feature code into reusable packages, and run quality checks from one command at workspace level.

## Highlights

- Monorepo structure with `apps/` and `packages/`
- Melos scripts for workspace automation
- Feature packages: `auth`, `posts`, `more`
- Shared package: `core` (design tokens, network helpers, result/error models, storage wrappers)
- Environment package: `app_config` (`dev` / `stage` / `prod`)
- App composition layer in `apps/app` (bootstrap, DI orchestration, routing, theme)

## Project Structure

```txt
.
├── apps/
│   └── app/                 # Runnable Flutter app
├── packages/
│   ├── app_config/          # Environment/config loading
│   ├── auth/                # Auth feature package
│   ├── core/                # Shared foundation package
│   ├── more/                # More/settings feature package
│   └── posts/               # Posts feature package
├── melos.yaml               # Melos config + scripts
└── pubspec.yaml             # Root Dart workspace
```

## Tech Stack

- Flutter
- Dart workspace (`workspace:` + `resolution: workspace`)
- Melos
- `get_it` + `injectable` (DI)
- `go_router` (routing)
- `flutter_bloc` (feature state management)
- `dio` (networking)

## Prerequisites

- Flutter SDK installed
- Dart SDK compatible with repo constraints
- Melos available (`dart run melos` or globally)

## Getting Started

1. Install workspace dependencies:

```bash
melos run get
```

2. List workspace packages:

```bash
melos list
```

3. Run the app:

```bash
cd apps/app
flutter run -t lib/main_dev.dart
```

You can also run other environments:

- `lib/main_staging.dart`
- `lib/main_prod.dart`

## Workspace Commands

Run from repo root:

```bash
melos run get
melos run analyze
melos run format
melos run test
melos run build_runner
```

Defined in `melos.yaml`:

- `get`: runs `flutter pub get` in all packages
- `analyze`: runs `flutter analyze` in all packages
- `format`: runs `dart format .` in all packages
- `test`: runs `flutter test` in all packages (`--fail-fast`)
- `build_runner`: runs code generation in packages that depend on `build_runner`

## Architecture Notes

- `apps/app` handles app-level composition only:
  - bootstrap (`lib/bootstrap`)
  - dependency wiring (`lib/di`)
  - route composition (`lib/routing`)
  - app theme (`lib/presentation/theme`)
- Feature packages expose focused public APIs from top-level `lib/*.dart`.
- `core` contains cross-feature primitives and design tokens:
  - `AppColors`
  - `AppSpacing`
  - `AppTypography`
  - result/failure and error mapping
  - storage/network utility layers

## Reuse `core` in Another Project

### Option A: Local path dependency

```yaml
dependencies:
  core:
    path: ../path_to_core/core
```

Then:

```bash
flutter pub get
```

Usage:

```dart
import 'package:core/core.dart';
```

### Option B: Git dependency

```yaml
dependencies:
  core:
    git:
      url: https://github.com/<your-org>/<your-repo>.git
      path: packages/core
```

## Add a New Package (Onboarding)

1. Create package:

```bash
flutter create --template=package packages/<your_package_name>
```

2. Add it to root `pubspec.yaml` under `workspace:`.

3. In `packages/<your_package_name>/pubspec.yaml`, set:

```yaml
resolution: workspace
```

4. Add dependency from app or another package:

```yaml
dependencies:
  <your_package_name>:
    path: ../../packages/<your_package_name>
```

5. Run workspace checks:

```bash
melos run get
melos run analyze
melos run test
```

6. Optional wiring (feature package):

- Expose a minimal public API from `lib/<your_package_name>.dart`
- Expose a DI entry point (for example `configure<Feature>Dependencies`)
- Register feature DI from app DI bootstrap
- Register feature routes from app router/registry

## When Melos Is Useful

Use Melos when:

- You have multiple apps/packages
- Shared code is reused across features
- You want one-command workspace automation

Avoid Melos when:

- You only have a small single-package app
- Package boundaries do not add value yet

## License

