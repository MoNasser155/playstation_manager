import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/get_session_models.dart';
import '../repositories/session_repository.dart';

class GetAllSessionModelsUseCase {
  final _repository = sl<SessionRepository>();

  Future<Either<Failure, GetSessionModels>> call() async {
    return await _repository.getSessionModels();
  }
}
