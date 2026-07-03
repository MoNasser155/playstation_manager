import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/device_model.dart';
import '../repositories/device_repository.dart';

class AddDeviceUseCase {
  final _repository = sl<DeviceRepository>();

  AddDeviceUseCase();

  Future<Either<Failure, int>> call(DeviceModel device) async {
    return await _repository.addDevice(device);
  }
}
