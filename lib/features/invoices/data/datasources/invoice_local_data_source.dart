import 'package:uuid/uuid.dart';

import '../../../../core/enums/device_status.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:local_erp_system/core/objectbox/objectbox.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../../../devices/data/models/device_model.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../models/create_invoice_model.dart';
import '../models/get_invoice_models.dart';

abstract class InvoiceLocalDataSource {
  GetInvoiceModels getInvoiceModels();
  int createInvoice(CreateInvoiceModel invoiceData);
  List<CreateInvoiceModel> getAllInvoices();
  List<CreateInvoiceModel> getActiveSessions();
  CreateInvoiceModel? getActiveSessionForDevice(int deviceId);
  int startDeviceSession({
    required CreateInvoiceModel sessionInvoice,
    required DeviceModel device,
  });
  void updateSessionItems({
    required String sessionUuid,
    required List<ItemsInvoice> items,
  });
  int endDeviceSession({
    required CreateInvoiceModel completedInvoice,
    required DeviceModel device,
  });
}

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  @override
  GetInvoiceModels getInvoiceModels() {
    final storageItemsQuery = _store.storage.getAll();
    if (storageItemsQuery.isEmpty) {
      throw NoStorageItemsExeption();
    }

    return GetInvoiceModels(storageItems: storageItemsQuery, warnings: []);
  }

  @override
  int createInvoice(CreateInvoiceModel invoiceData) {
    return _store.store.runInTransaction(TxMode.write, () {
      // 1. Save invoice items
      _store.invoiceItems.putMany(invoiceData.items.toList());

      // 2. Update storage quantities
      for (final invoiceItem in invoiceData.items) {
        final storageItem = invoiceItem.storageItem.target;
        if (storageItem == null) continue;

        _store.storage.put(
          storageItem.copyWith(
            quantity: storageItem.quantity - invoiceItem.quantity,
          ),
        );
      }

      // 3. Calculate invoice profit
      final profit = invoiceData.items.fold<double>(0.0, (sum, item) {
        final storageItem = item.storageItem.target;
        if (storageItem == null) return sum;

        return sum + ((item.sellPrice - storageItem.buyPrice) * item.quantity);
      });

      // 4. Generate transaction note
      final note = invoiceData.items
          .map((item) {
            final itemName = item.storageItem.target?.itemName ?? '';
            return 'الصنف: $itemName _|_ الكمية: ${item.quantity} _|_ سعر البيع: ${item.sellPrice}';
          })
          .join('\n');

      // 5. Create transaction
      _store.transactions.put(
        TransactionModel.create(
          uuid: const Uuid().v4(),
          invoiceProfit: profit,
          transactionType: TransactionType.invoiceProfit,
          userType: UserType.customer,
          createdAt: DateTime.now(),
          notes: note,
        ),
      );

      // 6. Save invoice
      return _store.invoices.put(invoiceData);
    });
  }

  @override
  List<CreateInvoiceModel> getAllInvoices() {
    final results = _store.invoices.getAll();
    if (results.isEmpty) {
      throw NoInvoicesFoundException();
    }
    return results;
  }

  @override
  List<CreateInvoiceModel> getActiveSessions() {
    final query =
        _store.invoices
            .query(CreateInvoiceModel_.isSession.equals(true))
            .build();
    final results = query.find();
    query.close();
    return results;
  }

  @override
  CreateInvoiceModel? getActiveSessionForDevice(int deviceId) {
    final query =
        _store.invoices
            .query(
              CreateInvoiceModel_.isSession
                  .equals(true)
                  .and(CreateInvoiceModel_.device.equals(deviceId)),
            )
            .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  int startDeviceSession({
    required CreateInvoiceModel sessionInvoice,
    required DeviceModel device,
  }) {
    return _store.store.runInTransaction(TxMode.write, () {
      final id = _store.invoices.put(sessionInvoice);
      final updatedDevice = device.copyWith(status: DeviceStatus.reserved);
      _store.devices.put(updatedDevice);
      return id;
    });
  }

  @override
  void updateSessionItems({
    required String sessionUuid,
    required List<ItemsInvoice> items,
  }) {
    _store.store.runInTransaction(TxMode.write, () {
      final query =
          _store.invoices
              .query(CreateInvoiceModel_.uuid.equals(sessionUuid))
              .build();
      final invoice = query.findFirst();
      query.close();

      if (invoice != null) {
        invoice.items.clear();
        invoice.items.addAll(items);
        _store.invoices.put(invoice);
      }
    });
  }

  @override
  int endDeviceSession({
    required CreateInvoiceModel completedInvoice,
    required DeviceModel device,
  }) {
    return _store.store.runInTransaction(TxMode.write, () {
      // 1. Save invoice items
      _store.invoiceItems.putMany(completedInvoice.items.toList());

      // 2. Update storage quantities
      for (final invoiceItem in completedInvoice.items) {
        final storageItem = invoiceItem.storageItem.target;
        if (storageItem == null) continue;

        _store.storage.put(
          storageItem.copyWith(
            quantity: storageItem.quantity - invoiceItem.quantity,
          ),
        );
      }

      // 3. Calculate session time cost
      final start =
          completedInvoice.sessionStartDate ?? completedInvoice.invoiceDate;
      final duration = completedInvoice.invoiceDate.difference(start);
      final sessionCost =
          (duration.inSeconds / 3600.0) * completedInvoice.hourlyRate;

      // 4. Calculate items profit
      final itemsProfit = completedInvoice.items.fold<double>(0.0, (sum, item) {
        final storageItem = item.storageItem.target;
        if (storageItem == null) return sum;
        return sum + ((item.sellPrice - storageItem.buyPrice) * item.quantity);
      });

      final totalProfit = sessionCost + itemsProfit;

      // 5. Generate transaction note
      final sessionNote = 'جلسة: ${device.name}';
      final itemsNote = completedInvoice.items
          .map((item) {
            final itemName = item.storageItem.target?.itemName ?? '';
            return 'الصنف: $itemName _|_ الكمية: ${item.quantity} _|_ سعر البيع: ${item.sellPrice}';
          })
          .join('\n');
      final note = itemsNote.isEmpty ? sessionNote : '$sessionNote\n$itemsNote';

      // 6. Create transaction
      _store.transactions.put(
        TransactionModel.create(
          uuid: const Uuid().v4(),
          invoiceProfit: totalProfit,
          transactionType: TransactionType.invoiceProfit,
          userType: UserType.customer,
          createdAt: DateTime.now(),
          notes: note,
        ),
      );

      // 7. Save completed invoice
      final id = _store.invoices.put(completedInvoice);

      // 8. Update device status
      final updatedDevice = device.copyWith(status: DeviceStatus.available);
      _store.devices.put(updatedDevice);

      return id;
    });
  }
}
