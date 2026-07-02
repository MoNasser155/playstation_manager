import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/storage_model.dart';
import '../repositories/storage_repository.dart';

class AddStorageItemUseCase {
  final _repository = sl<StorageRepository>();

  AddStorageItemUseCase();

  Future<Either<Failure, int>> call(StorageModel storageItem) async {
    return await _repository.addStorageItem(storageItem);
  }
}
