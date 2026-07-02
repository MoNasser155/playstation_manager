import 'package:fpdart/fpdart.dart';
import 'package:local_erp_system/core/shared/di.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/storage_details_model.dart';
import '../repositories/storage_repository.dart';

class GetStorageItemByUuidUseCase {
  final _repository = sl<StorageRepository>();
  Future<Either<Failure, StorageDetailsModel?>> call(String uuid) async {
    return await _repository.getStorageItemByUuid(uuid);
  }
}
