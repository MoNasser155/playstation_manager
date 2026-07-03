import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../../devices/data/models/device_model.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_local_data_source.dart';
import '../models/get_session_models.dart';
import '../models/session_model.dart';

class SessionRepositoryImpl with ErrorHandler implements SessionRepository {
  final _sessionLocalDataSource = sl<SessionLocalDataSource>();

  @override
  Future<Either<Failure, GetSessionModels>> getSessionModels() async {
    return wrapBoxOperationSync(
      () => _sessionLocalDataSource.getSessionModels(),
    );
  }

  @override
  Future<Either<Failure, int>> createSession(SessionModel sessionData) async {
    return wrapBoxOperationSync(
      () => _sessionLocalDataSource.createSession(sessionData),
    );
  }

  @override
  Future<Either<Failure, List<SessionModel>>> getAllSessions() async {
    return wrapBoxOperationSync(() => _sessionLocalDataSource.getAllSessions());
  }

  @override
  Future<Either<Failure, List<SessionModel>>> getActiveSessions() async {
    return wrapBoxOperationSync(
      () => _sessionLocalDataSource.getActiveSessions(),
    );
  }

  @override
  Future<Either<Failure, SessionModel?>> getActiveSessionForDevice(
    int deviceId,
  ) async {
    return wrapBoxOperationSync(
      () => _sessionLocalDataSource.getActiveSessionForDevice(deviceId),
    );
  }

  @override
  Future<Either<Failure, int>> startDeviceSession({
    required SessionModel session,
    required DeviceModel device,
  }) async {
    return wrapBoxOperationSync(
      () => _sessionLocalDataSource.startDeviceSession(
        session: session,
        device: device,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> updateSessionItems({
    required String sessionUuid,
    required List<SessionItem> items,
  }) async {
    return wrapBoxOperationSync(
      () => _sessionLocalDataSource.updateSessionItems(
        sessionUuid: sessionUuid,
        items: items,
      ),
    );
  }

  @override
  Future<Either<Failure, int>> endDeviceSession({
    required SessionModel completedSession,
    required DeviceModel device,
  }) async {
    return wrapBoxOperationSync(
      () => _sessionLocalDataSource.endDeviceSession(
        completedSession: completedSession,
        device: device,
      ),
    );
  }
}
