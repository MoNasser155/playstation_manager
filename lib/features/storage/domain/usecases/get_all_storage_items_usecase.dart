import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/storage_model.dart';
import '../repositories/storage_repository.dart';

class GetAllStorageItemsUseCase {
  final _repository = sl<StorageRepository>();

  GetAllStorageItemsUseCase();

  Future<Either<Failure, List<StorageModel>>> call() async {
    return await _repository.getAllStorageItems();
  }
}
