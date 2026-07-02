import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/repositories/storage_repository.dart';
import '../datasources/storage_locale_data_source.dart';
import '../models/storage_details_model.dart';
import '../models/storage_model.dart';

class StorageRepositoryImpl with ErrorHandler implements StorageRepository {
  final _storageLocaleDataSource = sl<StorageLocaleDataSource>();
  StorageRepositoryImpl();

  @override
  Future<Either<Failure, List<StorageModel>>> getAllStorageItems() async {
    return wrapBoxOperationSync(
      () => _storageLocaleDataSource.getAllStorageItems(),
    );
  }

  @override
  Future<Either<Failure, int>> addStorageItem(StorageModel storageItem) async {
    return wrapBoxOperationSync(
      () => _storageLocaleDataSource.addStorageItem(storageItem),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteStorageItem(String uuid) async {
    return wrapBoxOperationSync(
      () => _storageLocaleDataSource.deleteStorageItem(uuid),
    );
  }

  @override
  Future<Either<Failure, int>> updateStorageItem(
    StorageModel storageItem,
  ) async {
    return wrapBoxOperationSync(
      () => _storageLocaleDataSource.updateStorageItem(storageItem),
    );
  }

  @override
  Future<Either<Failure, StorageDetailsModel?>> getStorageItemByUuid(String uuid) async {
    return wrapBoxOperationSync(
      () => _storageLocaleDataSource.getStorageItemByUuid(uuid),
    );
  }
}
