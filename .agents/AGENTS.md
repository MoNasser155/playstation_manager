# Playstation Manager - Agent Rules & Guidelines

This document outlines the coding standards, architecture patterns, build processes, and guidelines for the Playstation Manager project (internal codebase name: `playstation_manager`). All agents working on this project must adhere to these rules.

---

## 1. Architecture Standards (Clean Architecture)

The project follows Clean Architecture principles structured by features under [lib/features/](file:///e:/freelance/playstation_manager/lib/features).

Every feature directory should have:

- `data/`: Models, data sources (local/remote), and repository implementations.
  - `models/`: JSON serialization, ObjectBox entities, and mapper models.
  - `datasources/`: Local data access (ObjectBox) and remote services (Supabase).
  - `repositories/`: Implementations of repositories defined in the domain layer.
- `domain/`: Enterprise business logic, entities, and use cases.
  - `entities/`: Pure Dart business representations.
  - `repositories/`: Interfaces defining data contracts.
  - `usecases/`: Single-responsibility classes implementing user actions.
- `presentation/`: UI components and state management.
  - `bloc/` or `cubit/`: Feature state controllers.
  - `pages/`: Full screen views.
  - `widgets/`: Feature-specific reusable UI components.
- `di.dart`: Local dependency injection registrations module.

---

## 2. Dependency Injection (GetIt)

- Global service locator is defined as `sl` in [di.dart](file:///e:/freelance/playstation_manager/lib/core/shared/di.dart).
- Each feature must have an `init<FeatureName>DI()` function inside its local `di.dart` register module.
- All feature-level DI modules must be registered inside `initDI()` in [di.dart](file:///e:/freelance/playstation_manager/lib/core/shared/di.dart) to be initialized at startup.

---

## 3. Database Layer (ObjectBox)

- Local persistence uses ObjectBox. Models intended for DB storage must be annotated with `@Entity()`.
- All database boxes should be registered and accessed through getters in [objectbox_store.dart](file:///e:/freelance/playstation_manager/lib/core/objectbox/objectbox_store.dart).
- **Code Generation**: After adding, updating, or deleting any database entities, run the builder command:
  ```bash
  fvm dart run build_runner build --delete-conflicting-outputs
  ```

---

## 4. State Management (Cubits) & Business Logic

- **Cubit Base Class**: All custom Cubits must extend `BaseCubit<S>` from [base_cubit_emiter.dart](file:///e:/freelance/playstation_manager/lib/core/shared/cubits/base_cubit_emiter.dart).
- **Cubit States**:
  - Implement a single state class extending `Equatable`.
  - The state class must define a status property of type `StateStatus` from [state_status.dart](file:///e:/freelance/playstation_manager/lib/core/enums/state_status.dart).
  - Use `safeEmit(state.copyWith(...))` rather than direct `emit(...)` to prevent emissions on closed/disposed cubits.
- **Handling Logic in Data Sources**:
  - **Rule**: Do not write calculations, data processing, formatting, list filtering, or database aggregation/sorting inside Cubits, Use Cases, or Repositories.
  - All logic (e.g., query construction, list filtering, mathematical calculations, profit computation) **must be implemented entirely inside the Data Source implementation** (e.g., in `data/datasources/`).
  - Repositories and Use Cases should merely act as dispatchers/bridges, forwarding parameters to the data source and returning the processed result wrapper.
  - Presentation layers and Cubits must receive ready-to-display models from the use cases.

---

## 5. Internationalization & Localization (easy_localization)

- **No Raw UI Text**: Do not hardcode user-facing strings in widget files.
- All translation terms must be defined in [lang.json](file:///e:/freelance/playstation_manager/assets/translations/lang.json) under keys containing both English and Arabic translations:
  ```json
  "someKey": {
      "en": "Some English translation",
      "ar": "ترجمة عربية"
  }
  ```
- **Sync Translations**: After modifying `lang.json`, run the string compiler tool:
  ```bash
  fvm dart run generate/strings/main.dart
  ```
  This script generates the required `en.json`, `ar.json` files, and updates the keys in [local_keys.g.dart](file:///e:/freelance/playstation_manager/lib/core/languages/local_keys.g.dart).
- **Usage**: Access translations in Dart code using:
  ```dart
  LocaleKeys.some_key
  ```

---

## 6. Asset Management & Vector Graphics

- All SVG icons should be placed under `assets/icons/svg/`.
- **Compile Icons & Build Constants**: Run the custom assets build tool to compile SVGs to `.vec` and automatically generate asset helper constants:
  ```bash
  fvm dart run tool/build_assets.dart
  ```
  This compiles the vectors to `assets/icons/vec/` and updates asset reference constants in [app_assets.dart](file:///e:/freelance/playstation_manager/lib/core/constants/app_assets.dart).

---

## 7. UI, Layout & Responsive Standards

- **Responsive Units**: The project uses `flutter_screenutil`. To support desktop responsive scaling, always use ScreenUtil extension methods:
  - Width: `width.w`
  - Height: `height.h`
  - Font Sizes: `fontSize.sp`
  - Border Radius: `radius.r`
  - Padding / Margin: `.w` or `.h` accordingly.
- **Spacing**: Never Use the `Gap` widget from the `gap` package for spaces, instead, Use the `gapH()` or `gapW()` widgets from the `core/utils/gaps.dart` file for spaces, applying ScreenUtil extensions where appropriate: `gapH(16)`.
- **Styling & Themes**:
  - Colors: never Use predefined constants in `AppColors`, always use context.colorScheme.anyColor() from lib\core\theme\app_theme.dart.
  - Typography: never Use predefined styles from [AppTextStyles](file:///e:/freelance/playstation_manager/lib/core/theme/app_text_styles.dart), always use context.textTheme.anyStyle() from lib\core\theme\app_theme.dart.
  - Components theme overrides are configured in [AppTheme](file:///e:/freelance/playstation_manager/lib/core/theme/app_theme.dart). Refer to `context.textTheme` or `context.colorScheme` for colors and typography, or `Theme.of(context)` for general theme configuration.

---

## 8. Core Reusable Widgets (`lib/core/widgets/`)

To keep coding patterns DRY and UI elements aligned, always use the project's pre-configured widgets instead of rebuilding them. Key reusable widgets include:

- **`VectorIcon`**: Custom loader for vector `.vec` graphics compiled from SVGs. Relies on the `vector_graphics` package. Always use this for icons (e.g., `VectorIcons.home` etc.).
- **`CustomButton`**: Standard interactive button featuring support for loading indicators (`isLoading`), enabling/disabling states (`isEnabled`), custom colors, borders, and text styling with `AppTheme` compatibility.
- **`CustomTextField`**: Pre-styled input fields supporting prefixes/suffixes, custom height, borders, and theme decoration alignment.
- **`TextFieldWithLabel`**: Wraps `CustomTextField` and attaches an aligned text label at the top.
- **`CustomPasswordField`**: Custom input field specifically configured for password toggling visibility.
- **`CustomSkeletonizer`**: Layout skeletonizer wrapper to easily render standard loading placeholders for screens.
- **`CustomDialog`**: Normalized pop-up modal dialog helper supporting custom child layouts or simple messages.
- **`CustomSnackBar`**: Normalized toast alerts for showing success/error messages matching the app's styling standards.
- **`CustomOptionRow`**: Reusable row layout showing a setting option label alongside its toggle, select, or text control.
- **`ExpandedDropDown`**: Standardized dropdown menus with custom selection states and overlays.
- **`DefaultSheetBody`**: Standard shell layout container used for consistency across Bottom Sheets.
- **`SwitchLangButton`**: Ready-to-use toggle button to quickly switch application languages (AR/EN).
- **`ImagePreviewer`**: Custom gallery modal to view and preview images interactively.
