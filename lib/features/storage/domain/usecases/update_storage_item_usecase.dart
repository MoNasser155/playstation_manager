import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/storage_model.dart';
import '../repositories/storage_repository.dart';

class UpdateStorageItemUseCase {
  final _repository = sl<StorageRepository>();

  UpdateStorageItemUseCase();

  Future<Either<Failure, int>> call(StorageModel storageItem) async {
    return await _repository.updateStorageItem(storageItem);
  }
}
