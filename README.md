# 🎮 PlayStation Manager

A high-performance, **local-first** desktop management system for PlayStation gaming centers, built with **Flutter**. It provides full session tracking, device management, inventory control, financial reporting, and secure cloud-backed authentication — all with a beautifully responsive UI that works across Windows Desktop, Tablet, and Mobile form factors.

---

## 📑 Table of Contents

1. [Overview](#overview)
2. [Tech Stack & Architecture](#tech-stack--architecture)
3. [Project Structure](#project-structure)
4. [Features & Modules](#features--modules)
   - [Authentication & Licensing](#1-authentication--licensing)
   - [Dashboard & Navigation](#2-dashboard--navigation)
   - [Device Management](#3-device-management)
   - [Session Management](#4-session-management)
   - [Storage / Inventory](#5-storage--inventory)
   - [Financial Transactions](#6-financial-transactions)
   - [Profit Analytics](#7-profit-analytics)
   - [Reports](#8-reports)
   - [Settings, Backup & Restore](#9-settings-backup--restore)
5. [Data Models](#data-models)
6. [Clean Architecture Layers](#clean-architecture-layers)
7. [State Management](#state-management)
8. [Dependency Injection](#dependency-injection)
9. [Localization (i18n)](#localization-i18n)
10. [Theming & Responsive Design](#theming--responsive-design)
11. [Core Shared Widgets](#core-shared-widgets)
12. [Developer Tooling & Code Generation](#developer-tooling--code-generation)
13. [Setting Up Locally](#setting-up-locally)
14. [Key Dependencies](#key-dependencies)

---

## Overview

**PlayStation Manager** is an ERP-style system designed specifically for PlayStation gaming centers. It allows operators to:

- Register and manage PS3 / PS4 / PS5 / VR / other gaming devices
- Start, track, and end timed play sessions with live cost calculation
- Sell snacks and accessories from inventory during a session
- Automatically record profit transactions when sessions end
- Manage inventory stock with low-stock alerts
- View profit analytics filtered by date range
- Export financial reports as PDFs
- Backup and restore the local database with a single click

The app operates fully **offline** using a local ObjectBox database. Authentication and licensing are handled through **Supabase**, which also enforces per-device hardware locking to prevent unauthorized use.

---

## Tech Stack & Architecture

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart `^3.7.2`) |
| **Local Database** | ObjectBox `^5.3.2` |
| **Cloud Backend** | Supabase `^2.14.2` (auth & licensing) |
| **State Management** | Flutter BLoC / Cubits `^9.1.1` |
| **Dependency Injection** | GetIt `^9.2.1` |
| **Localization** | easy_localization `^3.0.8` |
| **Responsive Layout** | flutter_screenutil `^5.9.3` |
| **Animations** | flutter_animate `^4.5.2`, Lottie `^3.3.3` |
| **Error Handling** | fpdart `^1.2.0` (`Either` type) |
| **Secure Storage** | flutter_secure_storage `^10.3.1` |
| **Window Management** | window_manager `^0.5.1` |
| **PDF Generation** | Tabular PDF export (reports feature) |

The application follows **Clean Architecture** principles, strictly separating the codebase into `data`, `domain`, and `presentation` layers for every feature. All business logic lives in the `data/datasources/` layer; repositories and use cases act as pure dispatchers.

---

## Project Structure

```
playstation_manager/
├── lib/
│   ├── main.dart                   # App entry point
│   ├── console_app.dart            # Root app widget
│   ├── core/                       # Shared infrastructure
│   │   ├── constants/              # App-wide constants & generated assets
│   │   ├── enums/                  # Shared enumerations
│   │   ├── errors/                 # Exceptions & failure types
│   │   ├── extentions/             # Dart & Flutter extensions
│   │   ├── languages/              # Generated locale keys
│   │   ├── objectbox/              # ObjectBox store & generated code
│   │   ├── services/               # Backup, machine ID, restart services
│   │   ├── shared/                 # DI setup, base cubit, global models
│   │   ├── theme/                  # AppTheme, AppColors, AppTextStyles
│   │   ├── utils/                  # Gaps, BLoC observer utilities
│   │   └── widgets/                # Reusable shared UI widgets
│   └── features/                   # Feature modules (Clean Architecture)
│       ├── auth/                   # Authentication & licensing
│       ├── devices/                # Device CRUD
│       ├── home/                   # Dashboard & settings
│       ├── main_view/              # Responsive shell & navigation
│       ├── profit/                 # Profit analytics
│       ├── reports/                # PDF report generation
│       ├── sessions/               # Session lifecycle management
│       ├── storage/                # Inventory management
│       └── transactions/           # Financial transaction ledger
├── assets/
│   ├── fonts/                      # Al Jazeera Arabic, NotoSansArabic
│   ├── icons/
│   │   ├── svg/                    # Source SVG icons
│   │   └── vec/                    # Compiled .vec icons (auto-generated)
│   ├── images/                     # Static image assets
│   ├── lottie/                     # Lottie animation files
│   └── translations/               # lang.json (source) + en.json, ar.json
├── generate/                       # String/translation generation scripts
├── tool/                           # Asset build tool (SVG → .vec compiler)
├── pubspec.yaml
└── README.md
```

Each feature directory follows this internal structure:

```
features/<feature>/
├── data/
│   ├── datasources/    # All business logic & DB queries live here
│   ├── models/         # ObjectBox @Entity models & mapper classes
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Pure Dart business entities (if needed)
│   ├── repositories/   # Repository interfaces / contracts
│   └── usecases/       # Single-responsibility use case classes
├── presentation/
│   ├── cubits/         # Feature Cubits extending BaseCubit<S>
│   ├── screens/        # Full-screen page widgets
│   └── widgets/        # Feature-specific reusable UI components
└── di.dart             # Feature-level DI registration module
```

---

## Features & Modules

### 1. Authentication & Licensing

**Feature path:** `lib/features/auth/`

The authentication flow is backed by **Supabase** and enforces per-device hardware locking to prevent license sharing.

#### Authentication Pages

| Screen | Description |
|---|---|
| `auth_page.dart` | Google OAuth sign-in entry point |
| `pending_page.dart` | Shown when the account is awaiting admin activation (`is_active = false`) |
| `machine_mismatch_screen.dart` | Displayed when a login is attempted from a non-registered machine |
| `splash_loading_screen.dart` | Initial loading screen during auth state resolution |

#### Key Behaviors

- **Google OAuth**: Sign-in is handled via Supabase with PKCE auth flow. A local HTTP server (`LocalAuthServer`) runs on port `54321` to capture the OAuth redirect code.
- **Hardware Device Locking**: On first successful login, the user's machine hardware GUID (read via `MachineIdService` from `HKLM:\SOFTWARE\Microsoft\Cryptography\MachineGuid` on Windows) is registered against the account in Supabase.
- **Machine Mismatch Check**: Subsequent logins from a different machine are rejected; the user is signed out and routed to `MachineMismatchScreen`.
- **Pending Activation Gate**: New accounts start as `is_active = false`. The app shows `PendingPage` until a system admin activates the account in Supabase.

---

### 2. Dashboard & Navigation

**Feature path:** `lib/features/main_view/`, `lib/features/home/`

The main shell is fully **responsive** and adapts to three form factors:

| Screen | Breakpoint |
|---|---|
| `DesktopMainViewScreen` | Large desktop windows |
| `TabletMainViewScreen` | Medium-size tablets |
| `MobileMainViewScreen` | Small mobile screens |

Navigation is managed by `MainViewCubit` which controls the currently selected tab index and supports a customized overlay view (e.g., Settings screen).

#### Navigation Tabs

| Index | Tab |
|---|---|
| 0 | Home (dashboard shortcuts) |
| 1 | Sessions (device floor view) |
| 2 | Devices |
| 3 | Storage / Inventory |
| 4 | Profit Reports |

#### Dashboard Quick Actions (`HomeCards`)

| Card | Action |
|---|---|
| `addStorageItem` | Opens the Add Storage Item dialog |
| `createSession` | Navigates to the Sessions tab |
| `viewReports` | Navigates to the Profit tab |
| `settings` | Opens the Settings overlay |

The desktop layout includes a **collapsible side drawer** (`CustomMainViewDrawer`) that supports both a collapsed icon-only state and an expanded label state.

---

### 3. Device Management

**Feature path:** `lib/features/devices/`

Manages all physical gaming devices in the center.

#### Device Model Fields

| Field | Type | Description |
|---|---|---|
| `uuid` | `String` | Unique identifier |
| `name` | `String` | Display name (e.g., "PS5 - Room 1") |
| `hourlyRate` | `double` | Rate per hour for single/two-player mode |
| `multiPlayerHourlyRate` | `double` | Rate per hour for multiplayer mode |
| `type` | `DeviceType` | `ps3`, `ps4`, `ps5`, `vr`, `other` |
| `status` | `DeviceStatus` | `available`, `reserved`, `maintenance` |

#### Device Types (`DeviceType`)

- `ps3` — PlayStation 3
- `ps4` — PlayStation 4
- `ps5` — PlayStation 5
- `vr` — Virtual Reality headset
- `other` — Any other device type

#### Device Statuses (`DeviceStatus`)

| Status | Color Indicator |
|---|---|
| `available` | 🟢 Green |
| `reserved` | 🟠 Orange (active session running) |
| `maintenance` | 🔴 Red |

#### Use Cases

| Use Case | Description |
|---|---|
| `AddDeviceUseCase` | Registers a new device |
| `GetAllDevicesUseCase` | Fetches all devices |
| `GetDeviceByUuidUseCase` | Fetches a specific device |
| `UpdateDeviceUseCase` | Updates device info |
| `DeleteDeviceUseCase` | Removes a device |

---

### 4. Session Management

**Feature path:** `lib/features/sessions/`

The core feature of the app. Handles the full lifecycle of a gaming session — from starting a timed session on a device, to adding consumed items, to ending the session and recording the financial transaction.

#### Session Model Fields

| Field | Type | Description |
|---|---|---|
| `uuid` | `String` | Unique session identifier |
| `totalSession` | `double` | Total amount charged for the session |
| `sessionDate` | `DateTime` | Date of the session |
| `isSession` | `bool` | `true` if session is currently active |
| `sessionStartDate` | `DateTime?` | When the active session started |
| `hourlyRate` | `double` | Hourly rate applied |
| `playType` | `PlayType` | `twoPlayers` or `multiPlayer` |
| `device` | `ToOne<DeviceModel>` | Linked device |
| `items` | `ToMany<SessionItem>` | Consumed storage items |

#### Session Item Fields

| Field | Type | Description |
|---|---|---|
| `sellPrice` | `double` | Sell price at time of sale |
| `quantity` | `double` | Quantity consumed |
| `totalItemPrice` | `double` | `sellPrice × quantity` |
| `storageItem` | `ToOne<StorageModel>` | Linked inventory item |

#### Play Types (`PlayType`)

- `twoPlayers` — Standard two-player rate
- `multiPlayer` — Multiplayer rate (uses `multiPlayerHourlyRate`)

#### Session Lifecycle

```
selectDevice() → startDeviceSession() ──────────────────────────────────────────────────┐
                      │                                                                  │
                      ▼                                                                  │
              [Timer runs — live cost calculated every tick]                             │
                      │                                                                  │
                      ▼                                                                  │
              updateSessionItems() ←── [Operator adds consumed items during session]     │
                      │                                                                  │
                      ▼                                                                  │
              endDeviceSession() ───────────────────────────────────────────────────────►┘
                      │
                      ├── Saves session to ObjectBox
                      ├── Deducts quantities from StorageModel
                      ├── Calculates total profit (session time cost + items profit)
                      ├── Creates TransactionModel (type: sessionProfit)
                      └── Sets device status back to `available`
```

#### One-Shot Session (No Device)

A "quick session" mode also exists: create a session directly from the storage items without linking to a specific device. This triggers `createSession()`, which:
1. Saves session items
2. Updates storage quantities
3. Calculates items profit only
4. Creates a `TransactionModel` with type `sessionProfit`

#### Use Cases

| Use Case | Description |
|---|---|
| `CreateSessionUseCase` | Creates a quick (non-device) session |
| `StartDeviceSessionUseCase` | Starts a timed session on a device, sets device to `reserved` |
| `UpdateSessionItemsUseCase` | Updates items attached to an active session |
| `EndDeviceSessionUseCase` | Ends a timed session, records profit, frees device |
| `GetAllSessionsUseCase` | Lists all sessions (sorted newest first) |
| `GetActiveSessionsUseCase` | Lists all currently active sessions |
| `GetActiveSessionForDeviceUseCase` | Gets the active session for a given device |
| `GetAllSessionModelsUseCase` | Fetches sessions with associated storage items |

#### Session Cubit (`SessionCubit`)

The `SessionCubit` orchestrates the entire session UI:
- Holds the currently selected device, storage item, and session state
- Manages a `Timer` that ticks every second to display live session cost
- Provides `TextEditingController`s for sell price and quantity fields
- Handles tab switching between the active session view and sessions list

---

### 5. Storage / Inventory

**Feature path:** `lib/features/storage/`

Manages all physical items available for sale during sessions (snacks, drinks, accessories, etc.).

#### Storage Model Fields

| Field | Type | Description |
|---|---|---|
| `uuid` | `String` | Unique identifier |
| `itemName` | `String` | Product name |
| `itemImage` | `String` | Image asset path |
| `quantity` | `double` | Current stock level |
| `buyPrice` | `double` | Purchase price (cost) |
| `sellPrice` | `double` | Sale price |
| `minAmount` | `double` | Low-stock threshold |
| `paidAmount` | `double` | Amount already paid to supplier |
| `type` | `StorageItemType` | `unit`, `meter`, `weight` |

#### Measurement Types (`StorageItemType`)

- `unit` — Counted in individual units (e.g., cans, items)
- `meter` — Measured in meters (e.g., cable)
- `weight` — Measured by weight (e.g., grams, kg)

#### Low-Stock Alert

The `isLow` computed property returns `true` when `quantity <= minAmount`. Items in a low-stock state are visually highlighted in the UI.

#### Use Cases

| Use Case | Description |
|---|---|
| `AddStorageItemUseCase` | Adds a new item to inventory |
| `GetAllStorageItemsUseCase` | Lists all inventory items |
| `GetStorageItemByUuidUseCase` | Fetches a single item |
| `UpdateStorageItemUseCase` | Updates item details or restocks |
| `DeleteStorageItemUseCase` | Removes an item from inventory |

---

### 6. Financial Transactions

**Feature path:** `lib/features/transactions/`

Maintains an immutable audit trail of all financial events generated by the system.

#### Transaction Model Fields

| Field | Type | Description |
|---|---|---|
| `uuid` | `String` | Unique identifier |
| `sessionProfit` | `double?` | Profit earned from a session |
| `createdAt` | `DateTime` | Timestamp of the transaction |
| `notes` | `String?` | Human-readable breakdown (item names, quantities, prices) |
| `storageItemUuid` | `String?` | Associated inventory item (if applicable) |
| `transactionType` | `TransactionType` | Category of the transaction |
| `userType` | `UserType` | `customer` or other actor |

#### Transaction Types (`TransactionType`)

| Type | Description |
|---|---|
| `sessionProfit` | Profit recorded when a session ends or a quick session is created |

#### Automatic Transaction Generation

Transactions are **automatically created** by the `SessionLocalDataSourceImpl` when:
- A quick session is created (`createSession`) — records items profit
- A device session ends (`endDeviceSession`) — records session time cost + items profit

The `notes` field contains a structured breakdown:
```
جلسة: [Device Name]
الصنف: [Item Name] _|_ الكمية: [Qty] _|_ سعر البيع: [Price]
...
```

#### Use Cases

| Use Case | Description |
|---|---|
| `GetAllTransactionsUseCase` | Retrieves the full transaction history |

---

### 7. Profit Analytics

**Feature path:** `lib/features/profit/`

A password-protected analytics module for viewing aggregated profit data.

#### Profits Model

```dart
class ProfitsModel {
  double totalProfit;              // Sum of all session profits in range
  List<TransactionModel> transactions; // Filtered transactions
}
```

#### Filtering

Profits can be filtered by a custom date range (`from` / `to`) using `GetFilteredProfitsUseCase`. The data source handles all aggregation and filtering logic internally.

---

### 8. Reports

**Feature path:** `lib/features/reports/`

Generates printable financial reports from session and transaction data.

- Produces **A4 Landscape PDF documents** with tabular layouts
- Uses localized Arabic-compatible fonts for correct RTL rendering
- Applies the brand color theme
- Accessible from the main navigation (Profit Reports tab)

---

### 9. Settings, Backup & Restore

**Feature path:** Settings via `lib/features/home/presentation/screens/settings_screen.dart`  
**Service:** `lib/core/services/backup_service.dart`

#### Settings Options

| Option | Description |
|---|---|
| Restore Local Backup | Picks a backup folder, replaces the current database, restarts the app |
| Sign Out | Signs out of the Supabase session |

#### Backup Service (`BackupService`)

| Method | Description |
|---|---|
| `createBackup()` | Closes the ObjectBox store, copies the database directory to `backups/<timestamp>/`, then restarts the app |
| `pickBackupFolder()` | Opens a file picker dialog defaulting to the `backups/` directory |
| `restoreBackup(path)` | Deletes the current database, copies the selected backup, then restarts the app |
| `listBackups()` | Lists all backup directories sorted newest-first |
| `pruneBackups({keepLatest: 10})` | Automatically removes backups beyond the 10 most recent |

Backups are stored next to the executable at:
```
<exe_dir>/backups/<yyyy-MM-dd_HH-mm-ss>/
```

---

## Data Models

### ObjectBox Entities

All entities are annotated with `@Entity()` and registered as boxes in `ObjectBoxStore`:

| Entity | Box Getter | Description |
|---|---|---|
| `StorageModel` | `store.storage` | Inventory items |
| `SessionModel` | `store.sessions` | Gaming sessions |
| `SessionItem` | `store.sessionItems` | Items consumed in a session |
| `TransactionModel` | `store.transactions` | Financial transaction records |
| `DeviceModel` | `store.devices` | Physical gaming devices |

### Relationships

```
DeviceModel ──────────────────► SessionModel (ToOne)
StorageModel ─────────────────► SessionItem  (ToOne)
SessionModel ─────────────────► SessionItem  (ToMany)
```

---

## Clean Architecture Layers

```
Presentation (Cubits / Widgets / Screens)
       │  calls use cases via DI
       ▼
Domain (Use Cases / Repository Interfaces)
       │  delegates to implementations
       ▼
Data (Repository Implementations → Data Sources → ObjectBox / Supabase)
```

### Rules

- **Data Sources** contain all business logic: filtering, calculations, query construction, profit computation, transaction generation.
- **Repositories** are pure bridges: they forward parameters from use cases to the data source and return the result.
- **Use Cases** are single-responsibility classes: each exposes one public method.
- **Cubits** receive ready-to-display models — no data processing in the presentation layer.

---

## State Management

All feature cubits extend `BaseCubit<S>` from `lib/core/shared/cubits/base_cubit_emiter.dart`.

### Rules

- State classes extend `Equatable` and have a `StateStatus` property.
- Use `safeEmit(state.copyWith(...))` instead of `emit(...)` — this prevents emissions on closed cubits.
- `StateStatus` values: `initial`, `loading`, `success`, `failure`.

### Example State Shape

```dart
class SessionState extends Equatable {
  final StateStatus status;
  final DeviceModel? selectedDevice;
  final SessionModel? activeSession;
  final List<DeviceModel> devices;
  final List<SessionItem> sessionItems;
  // ...
}
```

---

## Dependency Injection

The global service locator is `sl` (a `GetIt` instance) defined in `lib/core/shared/di.dart`.

### Initialization Order

`initDI()` runs at app startup and calls each feature's registration function:

```dart
initDI() async {
  await sharedDI();    // ObjectBox, GlobalThemingCubit
  initAuthDI();
  initHomeDI();
  initMainViewDI();
  initStorageDI();
  initDevicesDI();
  initSessionsDI();
  initTransactionsDI();
  initProfitDI();
  initReportsDI();
}
```

Each feature has a `di.dart` file with an `init<FeatureName>DI()` function that registers its data sources, repositories, and use cases.

---

## Localization (i18n)

The app supports **English** and **Arabic** (with automatic LTR/RTL layout switching) via `easy_localization`.

### Translation Workflow

1. Add or update keys in `assets/translations/lang.json`:
   ```json
   "someKey": {
     "en": "Some English translation",
     "ar": "ترجمة عربية"
   }
   ```

2. Run the string compiler to generate `en.json`, `ar.json`, and update `LocaleKeys`:
   ```bash
   fvm dart run generate/strings/main.dart
   ```

3. Use the generated keys in Dart code:
   ```dart
   Text(LocaleKeys.someKey.tr())
   ```

> **Never hardcode user-facing strings in widget files.**

---

## Theming & Responsive Design

### Colors & Typography

- Colors: Always use `context.colorScheme.anyColor` (via `ThemeExtensions` on `BuildContext`).
- Text styles: Always use `context.textTheme.anyStyle`.
- Never reference `AppColors` constants or `AppTextStyles` constants directly in widget code.

### Responsive Units (flutter_screenutil)

| Dimension | Extension |
|---|---|
| Width | `.w` |
| Height | `.h` |
| Font size | `.sp` |
| Border radius | `.r` |

**Minimum window size:** 1000 × 700 px (enforced by `window_manager`).  
**Default window size:** 1200 × 720 px.

### Spacing

Use `gapH(n)` and `gapW(n)` from `lib/core/utils/gaps.dart` for all spacing — never use `Gap` from the `gap` package directly.

---

## Core Shared Widgets

Located in `lib/core/widgets/`. Always prefer these over building ad-hoc UI:

| Widget | Description |
|---|---|
| `VectorIcon` | Renders compiled `.vec` vector graphics using the `vector_graphics` package |
| `CustomButton` | Standard button with `isLoading`, `isEnabled`, color/border/text style support |
| `CustomTextField` | Pre-styled text input with prefix/suffix, custom height, and theme decoration |
| `TextFieldWithLabel` | Wraps `CustomTextField` with an aligned label above |
| `CustomPasswordField` | Password input with visibility toggle |
| `CustomSkeletonizer` | Loading placeholder skeleton wrapper |
| `CustomDialog` | Normalized modal dialog (custom child or simple message) |
| `CustomSnackBar` | Styled toast for success/error messages |
| `CustomOptionRow` | Row layout for settings options (label + control) |
| `ExpandedDropDown` | Standardized dropdown with custom selection state and overlay |
| `DefaultSheetBody` | Standard shell layout container for bottom sheets |
| `SwitchLangButton` | Language toggle button (AR ↔ EN) |
| `ImagePreviewer` | Interactive image gallery modal |
| `CustomSliverAppbar` | Sliver-based app bar with back navigation |
| `CustomTapBar` | Styled tab bar |
| `CustomToggleSwitch` | Styled toggle switch |
| `DashedContainer` | Container with dashed border decoration |

---

## Developer Tooling & Code Generation

### 1. ObjectBox Entity Code Generation

After adding, modifying, or removing any `@Entity()` annotated class:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

This regenerates `lib/core/objectbox/objectbox.g.dart`.

### 2. Translation String Compiler

After modifying `assets/translations/lang.json`:

```bash
fvm dart run generate/strings/main.dart
```

This generates:
- `assets/translations/en.json`
- `assets/translations/ar.json`
- `lib/core/languages/local_keys.g.dart`

### 3. Asset Constants & SVG → Vec Compiler

After adding, renaming, or removing any file under `assets/`:

```bash
fvm dart run tool/build_assets.dart
```

This:
- Compiles SVG icons from `assets/icons/svg/` → `assets/icons/vec/` (as `.vec` files for the `vector_graphics` package)
- Regenerates `lib/core/constants/app_assets.dart` with typed asset reference constants (`VectorIcons`, `AppImages`, `AppLottie`, `AppTranslations`)

---

## Setting Up Locally

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) — version matching `^3.7.2`
- [FVM](https://fvm.app/) (Flutter Version Manager) — recommended
- A Supabase project with the required `users` table schema (contact the project owner for the schema)

### Installation

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate ObjectBox database code
fvm dart run build_runner build --delete-conflicting-outputs

# 3. (Optional) Regenerate translations if lang.json was modified
fvm dart run generate/strings/main.dart

# 4. (Optional) Rebuild asset constants if assets were modified
fvm dart run tool/build_assets.dart

# 5. Run the application (Windows Desktop)
flutter run -d windows
```

### Environment

Supabase credentials are initialized in `lib/main.dart`:

```dart
Supabase.initialize(
  url: '<SUPABASE_URL>',
  publishableKey: '<SUPABASE_PUBLISHABLE_KEY>',
  authOptions: const FlutterAuthClientOptions(
    authFlowType: AuthFlowType.pkce,
  ),
);
```

> ⚠️ Do not commit production Supabase credentials to version control. Move them to a `.env` file or use a secrets manager.

---

## Key Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | `^9.1.1` | BLoC / Cubit state management |
| `equatable` | `^2.0.8` | Value equality for state classes |
| `get_it` | `^9.2.1` | Service locator / DI |
| `objectbox` | `^5.3.2` | High-performance local database |
| `objectbox_flutter_libs` | `^5.3.2` | ObjectBox native libraries |
| `objectbox_generator` | `^5.3.2` | Code generation for ObjectBox entities |
| `supabase_flutter` | `^2.14.2` | Cloud auth & remote data |
| `easy_localization` | `^3.0.8` | i18n & l10n (EN / AR) |
| `flutter_screenutil` | `^5.9.3` | Responsive size scaling |
| `flutter_animate` | `^4.5.2` | Declarative UI animations |
| `lottie` | `^3.3.3` | Lottie animation rendering |
| `fpdart` | `^1.2.0` | Functional programming (`Either`, `Option`) |
| `flutter_secure_storage` | `^10.3.1` | Encrypted local key-value storage |
| `file_picker` | `^11.0.2` | Native file/directory picker dialog |
| `path_provider` | `^2.1.5` | Platform-specific paths |
| `window_manager` | `^0.5.1` | Desktop window configuration |
| `uuid` | `^4.5.3` | UUID v4 generation |
| `skeletonizer` | `^2.1.3` | Skeleton loading placeholders |
| `dropdown_button2` | `^3.1.0` | Enhanced dropdown widget |
| `vector_graphics` | `^1.1.19` | Efficient `.vec` icon rendering |
| `clock` | `^1.1.2` | Testable clock abstraction for timers |
| `build_runner` | `^2.15.0` | Code generation runner |
| `vector_graphics_compiler` | `^1.1.19` | SVG → `.vec` compilation |
