import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/session_model.dart';
import '../repositories/session_repository.dart';

class UpdateSessionItemsUseCase {
  final _repository = sl<SessionRepository>();

  Future<Either<Failure, void>> call({
    required String sessionUuid,
    required List<SessionItem> items,
  }) async {
    return await _repository.updateSessionItems(
      sessionUuid: sessionUuid,
      items: items,
    );
  }
}
