import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/device_model.dart';

abstract class DeviceRepository {
  Future<Either<Failure, List<DeviceModel>>> getAllDevices();
  Future<Either<Failure, int>> addDevice(DeviceModel device);
  Future<Either<Failure, bool>> deleteDevice(String uuid);
  Future<Either<Failure, int>> updateDevice(DeviceModel device);
  Future<Either<Failure, DeviceModel?>> getDeviceByUuid(String uuid);
}
