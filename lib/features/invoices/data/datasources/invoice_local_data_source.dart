import 'package:uuid/uuid.dart';

import '../../../../core/enums/device_status.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/objectbox/objectbox.g.dart';
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
  int refundInvoice({
    required String invoiceUuid,
    required List<ItemsInvoice> adjustedItems,
    required double newTotal,
    required double newCashPaid,
    required double newLaterPaid,
  });
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
          userUuid: '',
          userName: 'Walk-in',
          beginningBalance: 0,
          paymentAmount: invoiceData.totalInvoice,
          paidInvoiceAmount: invoiceData.totalInvoice,
          endBalance: 0,
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
  int refundInvoice({
    required String invoiceUuid,
    required List<ItemsInvoice> adjustedItems,
    required double newTotal,
    required double newCashPaid,
    required double newLaterPaid,
  }) {
    return _store.store.runInTransaction(TxMode.write, () {
      // 1. Find original invoice
      final builder = _store.invoices.query(
        CreateInvoiceModel_.uuid.equals(invoiceUuid),
      );
      final query = builder.build();
      final originalInvoice = query.findFirst();
      query.close();

      if (originalInvoice == null) {
        throw InvoiceNotFoundException();
      }

      final oldItems = originalInvoice.items.toList();

      // 2. Create map for quick lookup of adjusted items
      final adjustedItemsMap = <String, ItemsInvoice>{
        for (var item in adjustedItems)
          if (item.storageItem.target != null)
            item.storageItem.target!.uuid: item,
      };

      final noteLines = <String>[];

      // 3. Calculate original profit
      double profitOriginal = 0.0;
      for (final oldItem in oldItems) {
        final storageItem = oldItem.storageItem.target;
        if (storageItem == null) continue;
        profitOriginal +=
            (oldItem.sellPrice - storageItem.buyPrice) * oldItem.quantity;
      }

      // 4. Restore returned items back to storage and validate quantities
      for (final oldItem in oldItems) {
        final storageItem = oldItem.storageItem.target;
        if (storageItem == null) continue;

        final adjustedItem = adjustedItemsMap[storageItem.uuid];
        final oldQty = oldItem.quantity;
        final newQty = adjustedItem?.quantity ?? 0.0;

        // Validate: returned quantity cannot be negative
        if (newQty > oldQty) {
          throw Exception(
            'Invalid quantity for ${storageItem.itemName}. '
            'New quantity ($newQty) cannot exceed original ($oldQty)',
          );
        }

        final returnedQty = oldQty - newQty;

        if (returnedQty > 0) {
          // Add returned items back to storage
          final updatedStorage = storageItem.copyWith(
            quantity: storageItem.quantity + returnedQty,
          );
          _store.storage.put(updatedStorage);

          final sellPrice = oldItem.sellPrice;
          noteLines.add(
            'مرتجع-- الصنف:${storageItem.itemName} _|_ الكمية:$returnedQty _|_ السعر:$sellPrice',
          );
        }
      }

      // 5. Calculate adjusted profit (for remaining items)
      double profitAdjusted = 0.0;
      for (final newItem in adjustedItems) {
        final storageItem = newItem.storageItem.target;
        if (storageItem == null) continue;
        profitAdjusted +=
            (newItem.sellPrice - storageItem.buyPrice) * newItem.quantity;
      }

      // Profit difference: negative means we lost profit (items returned)
      final refundProfit = profitAdjusted - profitOriginal;

      final diffTotalInvoice = originalInvoice.totalInvoice - newTotal;
      final diffCashPaid = originalInvoice.cashPaid - newCashPaid;

      // 6. Create transaction record for the refund
      if (noteLines.isNotEmpty || diffTotalInvoice != 0) {
        _store.transactions.put(
          TransactionModel.create(
            uuid: const Uuid().v4(),
            userUuid: '',
            userName: 'Walk-in',
            beginningBalance: 0,
            paymentAmount: -diffTotalInvoice,
            paidInvoiceAmount: -diffCashPaid,
            endBalance: 0,
            invoiceProfit: refundProfit,
            transactionType: TransactionType.invoiceProfit,
            userType: UserType.customer,
            createdAt: DateTime.now(),
            notes: noteLines.join('\n'),
          ),
        );
      }

      // 7. Remove old invoice items
      final oldItemIds =
          oldItems.map((e) => e.id ?? 0).where((id) => id > 0).toList();
      if (oldItemIds.isNotEmpty) {
        _store.invoiceItems.removeMany(oldItemIds);
      }

      // 8. Save new/adjusted invoice items
      _store.invoiceItems.putMany(adjustedItems);

      // 9. Update the invoice entity
      final updatedInvoice = CreateInvoiceModel.create(
        id: originalInvoice.id,
        uuid: originalInvoice.uuid,
        totalInvoice: newTotal,
        cashPaid: newCashPaid,
        laterPaid: newLaterPaid,
        paymentType: originalInvoice.paymentType,
        invoiceDate: originalInvoice.invoiceDate,
      );

      // Clear old items and add new ones
      updatedInvoice.items.clear();
      updatedInvoice.items.addAll(adjustedItems);

      return _store.invoices.put(updatedInvoice);
    });
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
      final id = _store.invoices.put(completedInvoice);
      final updatedDevice = device.copyWith(status: DeviceStatus.available);
      _store.devices.put(updatedDevice);
      return id;
    });
  }
}
