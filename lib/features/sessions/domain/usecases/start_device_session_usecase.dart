import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../../devices/data/models/device_model.dart';
import '../../data/models/session_model.dart';
import '../repositories/session_repository.dart';

class StartDeviceSessionUseCase {
  final _repository = sl<SessionRepository>();

  Future<Either<Failure, int>> call({
    required SessionModel session,
    required DeviceModel device,
  }) async {
    return await _repository.startDeviceSession(
      session: session,
      device: device,
    );
  }
}
