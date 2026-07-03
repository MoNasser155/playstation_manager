import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/devices/data/models/device_model.dart';
import '../../features/invoices/data/models/create_invoice_model.dart';
import '../../features/storage/data/models/storage_model.dart';
import '../../features/transactions/data/models/transaction_model.dart';
import 'package:local_erp_system/objectbox.g.dart';

class ObjectBoxStore {
  static ObjectBoxStore? _instance;
  late final Store store;

  ObjectBoxStore._create(this.store);

  static Future<ObjectBoxStore> get instance async {
    if (_instance == null) {
      final appDir = await getApplicationSupportDirectory();
      final dbPath = p.join(appDir.path, 'current_db');
      await Directory(dbPath).create(recursive: true);
      _instance = ObjectBoxStore._create(await openStore(directory: dbPath));
    }
    return _instance!;
  }

  static void reset() => _instance = null;

  // One getter per entity — all from the same store
  Box<StorageModel> get storage => store.box<StorageModel>();
  Box<CreateInvoiceModel> get invoices => store.box<CreateInvoiceModel>();
  Box<ItemsInvoice> get invoiceItems => store.box<ItemsInvoice>();
  Box<TransactionModel> get transactions => store.box<TransactionModel>();
  Box<DeviceModel> get devices => store.box<DeviceModel>();
  // add more boxes here as your app grows...
}
