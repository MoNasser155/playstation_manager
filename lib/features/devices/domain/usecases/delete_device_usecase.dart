import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../repositories/device_repository.dart';

class DeleteDeviceUseCase {
  final _repository = sl<DeviceRepository>();

  DeleteDeviceUseCase();

  Future<Either<Failure, bool>> call(String uuid) async {
    return await _repository.deleteDevice(uuid);
  }
}
