import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/session_model.dart';
import '../repositories/session_repository.dart';

class GetActiveSessionsUseCase {
  final _repository = sl<SessionRepository>();

  Future<Either<Failure, List<SessionModel>>> call() async {
    return await _repository.getActiveSessions();
  }
}
