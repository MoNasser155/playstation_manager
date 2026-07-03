import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/device_model.dart';
import '../repositories/device_repository.dart';

class GetAllDevicesUseCase {
  final _repository = sl<DeviceRepository>();

  GetAllDevicesUseCase();

  Future<Either<Failure, List<DeviceModel>>> call() async {
    return await _repository.getAllDevices();
  }
}
