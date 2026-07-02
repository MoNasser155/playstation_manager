import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/storage_details_model.dart';
import '../../data/models/storage_model.dart';

abstract class StorageRepository {
  Future<Either<Failure, List<StorageModel>>> getAllStorageItems();
  Future<Either<Failure, int>> addStorageItem(StorageModel storageItem);
  Future<Either<Failure, bool>> deleteStorageItem(String uuid);
  Future<Either<Failure, int>> updateStorageItem(StorageModel storageItem);
  Future<Either<Failure, StorageDetailsModel?>> getStorageItemByUuid(
    String uuid,
  );
}
