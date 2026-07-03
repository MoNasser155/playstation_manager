import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/session_model.dart';
import '../repositories/session_repository.dart';

class GetActiveSessionForDeviceUseCase {
  final _repository = sl<SessionRepository>();

  Future<Either<Failure, SessionModel?>> call(int deviceId) async {
    return await _repository.getActiveSessionForDevice(deviceId);
  }
}
