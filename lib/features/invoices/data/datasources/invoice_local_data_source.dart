import 'package:uuid/uuid.dart';

import '../../../../core/enums/payment_type.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/objectbox/objectbox.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../models/create_invoice_model.dart';
import '../models/get_invoice_models.dart';

abstract class InvoiceLocalDataSource {
  GetInvoiceModels getInvoiceModels();
  int createInvoice(CreateInvoiceModel invoiceData);
  List<CreateInvoiceModel> getCustomerInvoices(String customerUuid);
  int refundInvoice({
    required String invoiceUuid,
    required List<ItemsInvoice> adjustedItems,
    required double newTotal,
    required double newCashPaid,
    required double newLaterPaid,
  });
}

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  @override
  GetInvoiceModels getInvoiceModels() {
    final customersQuery = _store.customers.getAll();
    final storageItemsQuery = _store.storage.getAll();
    if (customersQuery.isEmpty && storageItemsQuery.isEmpty) {
      throw NoCustomersAndStorageItemsFoundException();
    }
    if (customersQuery.isEmpty) {
      return GetInvoiceModels(
        customers: [],
        storageItems: storageItemsQuery,
        warnings: [NoCustomersExeption()],
      );
    }
    if (storageItemsQuery.isEmpty) {
      return GetInvoiceModels(
        customers: customersQuery,
        storageItems: [],
        warnings: [NoStorageItemsExeption()],
      );
    }

    return GetInvoiceModels(
      customers: customersQuery,
      storageItems: storageItemsQuery,
      warnings: [],
    );
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

      final customer = invoiceData.customer.target;
      final isLater = invoiceData.paymentType == PaymentType.later;

      // Snapshot beginning balance for transaction record
      final beginningBalance = customer?.netAmount ?? 0.0;

      // Calculate amounts
      final paidAmount =
          isLater ? invoiceData.cashPaid : invoiceData.totalInvoice;

      // The amount that will be added to the customer's debt
      final remainingAmount =
          isLater ? invoiceData.totalInvoice - invoiceData.cashPaid : 0.0;

      double endBalance = beginningBalance;

      // 3. Update customer balance
      if (customer != null && isLater) {
        // ✅ Correct: Increase receivableAmount directly
        final newReceivable = customer.receivableAmount + remainingAmount;

        final updatedCustomer = customer.copyWith(
          receivableAmount: newReceivable,
        );

        _store.customers.put(updatedCustomer);

        // Update endBalance to match the new state
        endBalance = updatedCustomer.netAmount;
      }

      // 4. Calculate invoice profit
      // Fixed: Use 0.0 for explicit double type
      final profit = invoiceData.items.fold<double>(0.0, (sum, item) {
        final storageItem = item.storageItem.target;
        if (storageItem == null) return sum;

        return sum + ((item.sellPrice - storageItem.buyPrice) * item.quantity);
      });

      // 5. Generate transaction note
      final note = invoiceData.items
          .map((item) {
            final itemName = item.storageItem.target?.itemName ?? '';
            return 'الصنف: $itemName _|_ الكمية: ${item.quantity} _|_ سعر البيع: ${item.sellPrice}';
          })
          .join('\n');

      // 6. Create transaction
      if (customer != null) {
        _store.transactions.put(
          TransactionModel.create(
            uuid: const Uuid().v4(),
            userUuid: customer.uuid,
            userName: customer.name,
            beginningBalance: beginningBalance,
            paymentAmount: invoiceData.totalInvoice,
            paidInvoiceAmount: paidAmount,
            endBalance: endBalance,
            invoiceProfit: profit,
            transactionType: TransactionType.invoiceProfit,
            userType: UserType.customer,
            createdAt: DateTime.now(),
            notes: note,
          ),
        );
      }

      // 7. Save invoice
      return _store.invoices.put(invoiceData);
    });
  }

  @override
  List<CreateInvoiceModel> getCustomerInvoices(String customerUuid) {
    final builder = _store.invoices.query();
    builder.link(
      CreateInvoiceModel_.customer,
      CustomerModel_.uuid.equals(customerUuid),
    );

    final query = builder.build();
    final results = query.find();
    query.close();

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

      final customer = originalInvoice.customer.target;
      if (customer == null) {
        throw CustomerNotFoundException();
      }

      final oldItems = originalInvoice.items.toList();
      final isLater = originalInvoice.paymentType == PaymentType.later;

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

      // 6. Update customer balance
      final beginningBalance = customer.netAmount;
      double endBalance = beginningBalance;

      if (isLater) {
        // Original later amount owed
        final oldLaterAmount =
            originalInvoice.totalInvoice - originalInvoice.cashPaid;

        // New later amount owed after refund
        final newLaterAmount = newTotal - newCashPaid;

        // Difference: how much the debt decreased
        final diffLaterAmount = oldLaterAmount - newLaterAmount;

        // ✅ Correct: Decrease receivableAmount directly
        final newReceivable = customer.receivableAmount - diffLaterAmount;

        final updatedCustomer = customer.copyWith(
          receivableAmount: newReceivable,
        );

        _store.customers.put(updatedCustomer);

        // Update endBalance to match the new state exactly
        endBalance = updatedCustomer.netAmount;
      }

      // 7. Calculate differences for transaction record
      final diffTotalInvoice = originalInvoice.totalInvoice - newTotal;
      final diffCashPaid = originalInvoice.cashPaid - newCashPaid;

      // 8. Create transaction record for the refund
      if (noteLines.isNotEmpty || diffTotalInvoice != 0) {
        _store.transactions.put(
          TransactionModel.create(
            uuid: const Uuid().v4(),
            userUuid: customer.uuid,
            userName: customer.name,
            beginningBalance: beginningBalance,
            // Negative because it's a refund (money going back)
            paymentAmount: -diffTotalInvoice,
            // Negative cash refunded to customer
            paidInvoiceAmount: -diffCashPaid,
            endBalance: endBalance,
            // Negative profit means loss from returned items
            invoiceProfit: refundProfit,
            transactionType: TransactionType.invoiceProfit,
            userType: UserType.customer,
            createdAt: DateTime.now(),
            notes: noteLines.join('\n'),
          ),
        );
      }

      // 9. Remove old invoice items
      final oldItemIds =
          oldItems.map((e) => e.id ?? 0).where((id) => id > 0).toList();
      if (oldItemIds.isNotEmpty) {
        _store.invoiceItems.removeMany(oldItemIds);
      }

      // 10. Save new/adjusted invoice items
      _store.invoiceItems.putMany(adjustedItems);

      // 11. Update the invoice entity
      final updatedInvoice = CreateInvoiceModel.create(
        id: originalInvoice.id,
        uuid: originalInvoice.uuid,
        totalInvoice: newTotal,
        cashPaid: newCashPaid,
        laterPaid: newLaterPaid,
        paymentType: originalInvoice.paymentType, // Preserve payment type
        invoiceDate: originalInvoice.invoiceDate,
        // paymentIndex: originalInvoice.paymentIndex,
      );

      // Set relations properly
      updatedInvoice.customer.target = customer;

      // Clear old items and add new ones
      updatedInvoice.items.clear();
      updatedInvoice.items.addAll(adjustedItems);

      return _store.invoices.put(updatedInvoice);
    });
  }
}
