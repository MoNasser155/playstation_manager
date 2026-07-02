import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../repositories/storage_repository.dart';

class DeleteStorageItemUseCase {
  final _repository = sl<StorageRepository>();

  DeleteStorageItemUseCase();

  Future<Either<Failure, bool>> call(String uuid) async {
    return await _repository.deleteStorageItem(uuid);
  }
}
