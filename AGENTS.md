# AGENTS.md - MingleTalk Agent App

## Project Overview
Flutter mobile app for video/voice calling agents using **GetX** for state management, dependency injection, and navigation. Follows a Clean Architecture + View-Controller-Binding (VCB) pattern.

## Architecture

### Layer Structure
```
lib/
├── app/              # App entry (GetMaterialApp configuration)
├── core/             # Config, network, services, theme, utils
├── data/             # Models, datasources, repositories
└── presentation/     # Bindings, controllers, pages, widgets, routes
```

### Data Flow
`Page (GetView) → Controller (GetxController) → Repository → DataSource → ApiBaseHelper → API`

## Key Conventions

### State Management (GetX)
- **Always** use `.obs` for reactive variables: `final user = User().obs;`
- **Always** use `Obx(() => ...)` for UI updates, **never** `setState()`
- Controllers use `onInit()` for setup and `onClose()` for cleanup

### Dependency Injection
- Every route must have a **Binding** class (see `lib/presentation/bindings/`)
- Use `Get.lazyPut<T>()` inside Bindings for lazy initialization
- Core dependencies are `permanent: true` in `InitialBinding` (ApiClient, ApiBaseHelper, AuthController)
- Access dependencies via `Get.find<T>()`, **never** instantiate controllers in views
- Pages extend `GetView<Controller>` for automatic controller access via `controller`

### Navigation
- **Always** use `Get.toNamed()` / `Get.offAllNamed()` – **never** `Navigator.of(context)`
- Routes defined in `lib/presentation/routes/app_routes.dart` (constants)
- Page registrations in `lib/presentation/routes/app_pages.dart`
- Pass arguments via `Get.arguments` as typed classes (e.g., `CallingArguments`)

### User Notifications
Use `AppDialog` static methods for all user-facing feedback:
```dart
AppDialog.showToast('message');              // Toast
AppDialog.showSnackBar('title', 'message');  // GetX SnackBar
AppDialog.showBottomSheet(child: Widget);    // Bottom sheet
AppDialog.showAlertDialog(...);              // Confirmation dialog
```

## Network Layer

### API Calls
- `ApiBaseHelper` wraps HTTP methods with interceptors (see `lib/core/network/`)
- Endpoints defined in `ApiEndpoints` class as static constants
- Base URL: `AppConfig.apiBaseUrl`
- All requests use `json` encoding; auth token added by `AppApiInterceptor`

### Real-time Communication
- **LiveKit** for video/voice calls (`LiveKitService`)
- **WebSocket (Pusher Reverb)** for call notifications (`WebSocketService`)
- CallKit integration via `CallkitService` for incoming call UI

## Theming & UI

### Design System
- Colors: `AppColors` (semantic naming: `textPrimary`, `buttonPrimary`, etc.)
- Spacing: `AppSpacings` (s4, s8, s16, s24...)
- Radii: `AppRadii`
- Typography: `AppText` widget with `AppTextType` enum (e.g., `AppTextType.t14sb` = 14sp semibold)

### Responsive Design
- Use `flutter_screenutil` - dimensions via `.sp`, `.w`, `.h` extensions
- Design size: 402×874 (see `app.dart`)

### Common Widgets
Widgets barrel export: `import '../widgets/index.dart';`
- `AppButton`, `AppInputText`, `AppText`, `AppDialog`, `ProfileImage`

## Key Patterns

### Creating a New Feature
1. Create page in `lib/presentation/pages/{feature}/`
2. Create controller in `lib/presentation/controllers/{feature}_controller.dart`
3. Create binding in `lib/presentation/bindings/{feature}_binding.dart`
4. Add route constant in `AppRoutes`
5. Register `GetPage` in `AppPages.pages`

### Model Pattern
Models use `fromMap()` factory + `toMap()` methods for JSON serialization:
```dart
factory User.fromMap(Map<String, dynamic> json) => User(id: json['id'] ?? 0, ...);
```

## Commands

```bash
flutter pub get                  # Install dependencies
flutter analyze                   # Run linter
flutter run                       # Run app (debug)
flutter build apk                 # Build Android APK
flutter build ios                 # Build iOS
```

## Critical Files Reference
- Entry: `lib/main.dart` → `lib/app/app.dart`
- Initial DI: `lib/presentation/bindings/initial_binding.dart`
- Auth flow: `lib/presentation/controllers/auth_controller.dart`
- Calling: `lib/presentation/controllers/calling_controller.dart`, `lib/core/services/livekit_service.dart`
- API config: `lib/core/config/app_config.dart`, `lib/core/network/api_endpoints.dart`

