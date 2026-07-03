import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/device_model.dart';
import '../repositories/device_repository.dart';

class GetDeviceByUuidUseCase {
  final _repository = sl<DeviceRepository>();

  GetDeviceByUuidUseCase();

  Future<Either<Failure, DeviceModel?>> call(String uuid) async {
    return await _repository.getDeviceByUuid(uuid);
  }
}
