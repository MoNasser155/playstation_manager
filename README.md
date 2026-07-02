# Local ERP System (PlayStation Manager)

A beautiful, high-performance desktop and mobile ERP (Enterprise Resource Planning) and inventory management system built with Flutter. It utilizes a local-first architecture powered by **ObjectBox** for database performance, coupled with **Supabase** for secure cloud authentication, licensing, and device locking.

---

## 🌟 Tech Stack & Architecture

- **Core Framework**: Flutter (Dart) with responsive interfaces optimized for Windows Desktop, Tablets, and Mobile.
- **Local Database (Local-first)**: **ObjectBox** — a high-performance database for storing offline-first ERP transactions, customers, suppliers, inventory, and invoices.
- **Cloud Backend**: **Supabase** — handles licensing activation, user verification, and Google OAuth login integration.
- **State Management**: **Flutter BLoC (with Cubits)** for robust, clean, and predictable state control.
- **Localization**: **`easy_localization`** supporting dynamic translations for English and Arabic (supporting dynamic LTR/RTL layouts).
- **Responsive Layout**: **`flutter_screenutil`** for dynamic size scaling.
- **Micro-Animations**: **`flutter_animate`** for UI animations.

---

## 🔑 Core Features & Modules

### 1. Secure Authentication & License Protection
* **Google OAuth**: Fast login via Supabase Google Sign-In with a dedicated local HTTP server (`LocalAuthServer` running on port 54321) to capture redirect auth codes.
* **Hardware Device Locking**: On first login, the user's license/account is bound to their specific Windows hardware identifier (extracted securely via PowerShell querying of `HKLM:\SOFTWARE\Microsoft\Cryptography\MachineGuid`).
* **Machine Mismatch Check**: If a login attempt is detected from a machine other than the registered one, the application denies access, signs out, and shows the **Machine Mismatch Screen**.
* **Pending Activation Gate**: Newly registered accounts start as inactive (`is_active = false`) and display a **Pending Screen** until a system admin activates them in Supabase.

### 2. Multi-Platform Responsive Dashboard
* **Dynamic Desktop, Tablet, and Mobile Adaptations** using responsive layout managers (`MainViewCubit` and `MainViewMode` breakpoints).
* **Collapsible Desktop Side Drawer** supporting shortened and fully-opened navigation states.
* **Dashboard Shortcuts** for common operations (Add User, Add Storage Item, Create Invoice, Record Transaction, View Reports, System Settings).

### 3. Sales & Refund Invoicing
* **Sales Invoice**: Add items from storage, select clients, calculate live totals, and create sales invoices.
* **Refund Invoice**: Issue partial or full refund invoices for any client. Returns refunded quantities back to storage inventory and adjusts receivable/payable balances.
* **Debt / Deferred Payments**: Supports both immediate **Cash** payments and **Later** payment options (which dynamically updates the customer's debt balance).
* **Inventory Control**: Automatically checks stock levels to prevent issuing invoices exceeding current stock limits.

### 4. Customer Management
* **Database Fields**: Store client name, primary phone, secondary phone, address, and UUID.
* **Ledger Synchronization**: Tracks **Receivables** (money owed to the business) and **Payables** (money you owe the client).
* **Dynamic Visual Status**: Color-coded indicators showcasing customer net balance (`to pay` vs `to receive`).
* **Security Checks**: Prevents accidental deletion of customers with non-zero balances.

### 5. Supplier Management
* **Database Fields**: Track supplier details, primary and secondary contacts, and addresses.
* **Balance Tracking**: Tracks receivables and payables associated with each supplier.
* **Integration**: Linked to the inventory module when registering newly bought goods from a supplier.
* **Security Checks**: Prevents deletion of suppliers with active outstanding balances.

### 6. Inventory / Storage Management
* **Item Properties**: Tracks name, image asset, quantity, buying price, selling price, and supplier.
* **Measurement Units**: Supports **Units**, **Meters**, and **Weight** types.
* **Low Stock Alerts**: Define a threshold `minAmount`. If stock drops below this limit, the system highlights the item in red and triggers a low-stock alert status (`isLow`).
* **Stock Refill**: Easily add items to existing stock records, automatically adjusting average buying/selling prices or logging new transactions.

### 7. Financial Transactions Ledger
* Records a full audit trail of money flows inside the database, categorized under:
  * **Invoice Profit**: Earnings generated directly from customer sales.
  * **Customer Payment**: Cash received from customers settling their invoices/debts.
  * **Supplier Purchase**: Goods bought from suppliers, increasing the payable balance.
  * **Supplier Payment**: Cash paid to suppliers to clear debts.
* Tracks beginning balance, payment amount, ending balance, timestamp, custom notes, and associated storage items.

### 8. Analytics & Profit Reports (Password Protected)
* **Security Lock**: Financial statistics and profit screens are protected by a master password. Users can set their custom password on first run, which is saved securely in the device's storage.
* **Profits Analysis**: Computes total revenues and invoice profits.
* **Date Filters**: Filter profits and transaction logs by specific months (January to December) or custom date ranges.

### 9. Export PDF Reports
* Generates professional **A4 Landscape PDF documents** summarizing transaction histories.
* Built using customized tabular layouts, localized fonts for Arabic compatibility, and colored brand themes.
* Directly export and save PDFs from Customers, Suppliers, or General Transactions pages.

### 10. Database Backup & Restore Services
* **Local Database Backup**: Safely closes the ObjectBox database, packages the files, and creates a timestamped clone inside the `backups` directory, then restarts the application.
* **Restore Feature**: Pick an existing backup directory via a file picker dialog, restore records, and automatically restart.
* **Automated Cleanup**: Keeps only the 10 most recent backups, pruning older directories to save disk space.

---

## 🛠️ Setting Up locally

### Prerequisites
* Flutter SDK (Version `>= 3.7.2` matching environment constraint)
* Supabase Client credentials configured in `lib/main.dart`

### Dependencies Install & Codegen
1. Fetch packages:
   ```bash
   flutter pub get
   ```
2. Build local database entities (ObjectBox models):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. Run the application:
   ```bash
   flutter run
   ```
