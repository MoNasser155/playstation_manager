import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../../../core/enums/transaction_type.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/objectbox/objectbox.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../models/storage_details_model.dart';
import '../models/storage_model.dart';

abstract class StorageLocaleDataSource {
  List<StorageModel> getAllStorageItems();
  int addStorageItem(StorageModel storageItem);
  bool deleteStorageItem(String uuid);
  int updateStorageItem(StorageModel storageItem);
  StorageDetailsModel? getStorageItemByUuid(String uuid);
}

class StorageLocaleDataSourceImpl implements StorageLocaleDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  StorageLocaleDataSourceImpl();

  @override
  List<StorageModel> getAllStorageItems() {
    return _store.storage.getAll();
  }

  @override
  int addStorageItem(StorageModel addedItem) {
    return _store.store.runInTransaction(TxMode.write, () {
      final storageQuery =
          _store.storage
              .query(StorageModel_.uuid.equals(addedItem.uuid))
              .build();
      final storageItem = storageQuery.findFirst();
      storageQuery.close();

      final supplierTarget = addedItem.supplier.target;
      if (supplierTarget == null) {
        throw SupplierNotFoundException();
      }

      final supplierQuery =
          _store.suppliers
              .query(SupplierModel_.uuid.equals(supplierTarget.uuid))
              .build();
      final supplier = supplierQuery.findFirst();
      supplierQuery.close();

      // add new item if not exists
      if (storageItem == null) {
        if (supplier == null) {
          throw SupplierNotFoundException();
        } else {
          final totalPaid = addedItem.buyPrice * addedItem.quantity;
          final updatedSupplier = supplier.copyWith(
            payableAmount:
                supplier.payableAmount + totalPaid - addedItem.paidAmount,
          );
          _store.suppliers.put(updatedSupplier);
          _store.transactions.put(
            TransactionModel.create(
              uuid: const Uuid().v4(),
              userUuid: supplier.uuid,
              userName: supplier.name,
              beginningBalance: supplier.netAmount,
              paymentAmount: totalPaid,
              paidInvoiceAmount: addedItem.paidAmount,
              endBalance: supplier.netAmount - totalPaid + addedItem.paidAmount,
              transactionType: TransactionType.supplierPurchase,
              userType: UserType.supplier,
              createdAt: DateTime.now(),
              notes:
                  '${addedItem.itemName} _|_ ${LocaleKeys.quantity}: ${addedItem.quantity} _|_ ${LocaleKeys.total}: $totalPaid _|_ ${LocaleKeys.paidAmount}: ${addedItem.paidAmount}',
              storageItemUuid: addedItem.uuid,
            ),
          );
          return _store.storage.put(addedItem);
        }
      } else {
        // edit existing item
        final updatedItem = storageItem.copyWith(
          quantity: storageItem.quantity + addedItem.quantity,
          buyPrice: addedItem.buyPrice,
          sellPrice: addedItem.sellPrice,
        );

        if (supplier == null) {
          throw SupplierNotFoundException();
        } else {
          final totalCost = addedItem.buyPrice * addedItem.quantity;
          final remainingDebt = totalCost - addedItem.paidAmount;
          final newPayableAmount = supplier.payableAmount + remainingDebt;
          final updatedSupplier = supplier.copyWith(
            payableAmount: newPayableAmount,
          );
          _store.suppliers.put(updatedSupplier);
          _store.transactions.put(
            TransactionModel.create(
              uuid: const Uuid().v4(),
              userUuid: supplier.uuid,
              userName: supplier.name,
              beginningBalance: supplier.netAmount,
              paymentAmount: totalCost,
              paidInvoiceAmount: addedItem.paidAmount,
              endBalance: updatedSupplier.netAmount,
              transactionType: TransactionType.supplierPurchase,
              userType: UserType.supplier,
              createdAt: DateTime.now(),
              notes:
                  '${storageItem.itemName} _|_ ${LocaleKeys.quantity}: ${addedItem.quantity} _|_ ${LocaleKeys.total}: $totalCost _|_ ${LocaleKeys.paidAmount}: ${addedItem.paidAmount}',
              storageItemUuid: addedItem.uuid,
            ),
          );

          return _store.storage.put(updatedItem);
        }
      }
    });
  }

  @override
  bool deleteStorageItem(String uuid) {
    final query = _store.storage.query(StorageModel_.uuid.equals(uuid)).build();
    final item = query.findFirst();
    query.close();

    if (item != null) {
      if (item.itemImage.isNotEmpty) {
        try {
          final file = File(item.itemImage);
          if (file.existsSync()) {
            file.deleteSync();
          }
        } catch (e) {
          // ignore
        }
      }
      return _store.storage.remove(item.id!);
    }
    return false;
  }

  @override
  int updateStorageItem(StorageModel storageItem) {
    return _store.storage.put(storageItem);
  }

  @override
  StorageDetailsModel? getStorageItemByUuid(String uuid) {
    final itemQuery =
        _store.storage.query(StorageModel_.uuid.equals(uuid)).build();
    final item = itemQuery.findFirst();
    itemQuery.close();

    if (item == null) {
      throw NoStorageItemsExeption();
    }
    final transactionsQuery =
        _store.transactions
            .query(
              TransactionModel_.storageItemUuid.equals(uuid) &
                  TransactionModel_.transactionType.equals(
                    TransactionType.supplierPurchase.index,
                  ),
            )
            .build();
    final transactions = transactionsQuery.find();
    transactionsQuery.close();

    return StorageDetailsModel(item: item, transactions: transactions);
  }
}
