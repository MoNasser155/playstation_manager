import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/session_model.dart';
import '../../data/models/get_session_models.dart';
import '../../../devices/data/models/device_model.dart';

abstract class SessionRepository {
  Future<Either<Failure, GetSessionModels>> getSessionModels();
  Future<Either<Failure, int>> createSession(SessionModel sessionData);
  Future<Either<Failure, List<SessionModel>>> getAllSessions();

  Future<Either<Failure, List<SessionModel>>> getActiveSessions();
  Future<Either<Failure, SessionModel?>> getActiveSessionForDevice(int deviceId);
  Future<Either<Failure, int>> startDeviceSession({
    required SessionModel session,
    required DeviceModel device,
  });
  Future<Either<Failure, void>> updateSessionItems({
    required String sessionUuid,
    required List<SessionItem> items,
  });
  Future<Either<Failure, int>> endDeviceSession({
    required SessionModel completedSession,
    required DeviceModel device,
  });
}
