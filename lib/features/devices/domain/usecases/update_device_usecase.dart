import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/device_model.dart';
import '../repositories/device_repository.dart';

class UpdateDeviceUseCase {
  final _repository = sl<DeviceRepository>();

  UpdateDeviceUseCase();

  Future<Either<Failure, int>> call(DeviceModel device) async {
    return await _repository.updateDevice(device);
  }
}
