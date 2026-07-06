# Playstation Manager - Agent Rules & Guidelines

This document outlines the coding standards, architecture patterns, build processes, and guidelines for the Playstation Manager project (internal codebase name: `playstation_manager`). All agents working on this project must adhere to these rules.

---

## 1. Architecture Standards (Clean Architecture)

The project follows Clean Architecture principles structured by features under [lib/features/](file:///e:/freelance/playstation_manager/lib/features).

Every feature directory should have:
*   `data/`: Models, data sources (local/remote), and repository implementations.
    *   `models/`: JSON serialization, ObjectBox entities, and mapper models.
    *   `datasources/`: Local data access (ObjectBox) and remote services (Supabase).
    *   `repositories/`: Implementations of repositories defined in the domain layer.
*   `domain/`: Enterprise business logic, entities, and use cases.
    *   `entities/`: Pure Dart business representations.
    *   `repositories/`: Interfaces defining data contracts.
    *   `usecases/`: Single-responsibility classes implementing user actions.
*   `presentation/`: UI components and state management.
    *   `bloc/` or `cubit/`: Feature state controllers.
    *   `pages/`: Full screen views.
    *   `widgets/`: Feature-specific reusable UI components.
*   `di.dart`: Local dependency injection registrations module.

---

## 2. Dependency Injection (GetIt)

*   Global service locator is defined as `sl` in [di.dart](file:///e:/freelance/playstation_manager/lib/core/shared/di.dart).
*   Each feature must have an `init<FeatureName>DI()` function inside its local `di.dart` register module.
*   All feature-level DI modules must be registered inside `initDI()` in [di.dart](file:///e:/freelance/playstation_manager/lib/core/shared/di.dart) to be initialized at startup.

---

## 3. Database Layer (ObjectBox)

*   Local persistence uses ObjectBox. Models intended for DB storage must be annotated with `@Entity()`.
*   All database boxes should be registered and accessed through getters in [objectbox_store.dart](file:///e:/freelance/playstation_manager/lib/core/objectbox/objectbox_store.dart).
*   **Code Generation**: After adding, updating, or deleting any database entities, run the builder command:
    ```bash
    fvm dart run build_runner build --delete-conflicting-outputs
    ```

---

## 4. Internationalization & Localization (easy_localization)

*   **No Raw UI Text**: Do not hardcode user-facing strings in widget files.
*   All translation terms must be defined in [lang.json](file:///e:/freelance/playstation_manager/assets/translations/lang.json) under keys containing both English and Arabic translations:
    ```json
    "some_key": {
        "en": "Some English translation",
        "ar": "ترجمة عربية"
    }
    ```
*   **Sync Translations**: After modifying `lang.json`, run the string compiler tool:
    ```bash
    fvm dart run generate/strings/main.dart
    ```
    This script generates the required `en.json`, `ar.json` files, and updates the keys in [local_keys.g.dart](file:///e:/freelance/playstation_manager/lib/core/languages/local_keys.g.dart).
*   **Usage**: Access translations in Dart code using:
    ```dart
    LocaleKeys.some_key.tr()
    ```

---

## 5. Asset Management & Vector Graphics

*   All SVG icons should be placed under `assets/icons/svg/`.
*   **Compile Icons & Build Constants**: Run the custom assets build tool to compile SVGs to `.vec` and automatically generate asset helper constants:
    ```bash
    fvm dart run tool/build_assets.dart
    ```
    This compiles the vectors to `assets/icons/vec/` and updates asset reference constants in [app_assets.dart](file:///e:/freelance/playstation_manager/lib/core/constants/app_assets.dart).

---

## 6. UI, Layout & Responsive Standards

*   **Responsive Units**: The project uses `flutter_screenutil`. To support desktop responsive scaling, always use ScreenUtil extension methods:
    *   Width: `width.w`
    *   Height: `height.h`
    *   Font Sizes: `fontSize.sp`
    *   Border Radius: `radius.r`
    *   Padding / Margin: `.w` or `.h` accordingly.
*   **Spacing**: Use the `Gap` widget from the `gap` package for spaces, applying ScreenUtil extensions where appropriate: `Gap(16.h)`.
*   **Styling & Themes**:
    *   Colors: Use predefined constants in `AppColors`.
    *   Typography: Use predefined styles from [AppTextStyles](file:///e:/freelance/playstation_manager/lib/core/theme/app_text_styles.dart) which default to the 'Al Jazeera Arabic' family.
    *   Components theme overrides are configured in [AppTheme](file:///e:/freelance/playstation_manager/lib/core/theme/app_theme.dart). Refer to `Theme.of(context)` configuration.
