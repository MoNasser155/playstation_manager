import 'dart:io';

import '../../../../core/errors/exceptions.dart';
import 'package:local_erp_system/core/objectbox/objectbox.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
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

      // add new item if not exists
      if (storageItem == null) {
        return _store.storage.put(addedItem);
      } else {
        // edit existing item
        final updatedItem = storageItem.copyWith(
          quantity: storageItem.quantity + addedItem.quantity,
          buyPrice: addedItem.buyPrice,
          sellPrice: addedItem.sellPrice,
        );
        return _store.storage.put(updatedItem);
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
            .query(TransactionModel_.storageItemUuid.equals(uuid))
            .build();
    final transactions = transactionsQuery.find();
    transactionsQuery.close();

    return StorageDetailsModel(item: item, transactions: transactions);
  }
}
