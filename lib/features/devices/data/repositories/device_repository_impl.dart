import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_local_data_source.dart';
import '../models/device_model.dart';

class DeviceRepositoryImpl with ErrorHandler implements DeviceRepository {
  final _deviceLocalDataSource = sl<DeviceLocalDataSource>();

  DeviceRepositoryImpl();

  @override
  Future<Either<Failure, List<DeviceModel>>> getAllDevices() async {
    return wrapBoxOperationSync(
      () => _deviceLocalDataSource.getAllDevices(),
    );
  }

  @override
  Future<Either<Failure, int>> addDevice(DeviceModel device) async {
    return wrapBoxOperationSync(
      () => _deviceLocalDataSource.addDevice(device),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteDevice(String uuid) async {
    return wrapBoxOperationSync(
      () => _deviceLocalDataSource.deleteDevice(uuid),
    );
  }

  @override
  Future<Either<Failure, int>> updateDevice(DeviceModel device) async {
    return wrapBoxOperationSync(
      () => _deviceLocalDataSource.updateDevice(device),
    );
  }

  @override
  Future<Either<Failure, DeviceModel?>> getDeviceByUuid(String uuid) async {
    return wrapBoxOperationSync(
      () => _deviceLocalDataSource.getDeviceByUuid(uuid),
    );
  }
}
