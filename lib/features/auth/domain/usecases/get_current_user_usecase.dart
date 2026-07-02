import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final _repository = sl<AuthRepository>();
  Future<Either<Failure, AppUser?>> call() async {
    return await _repository.getCurrentUser();
  }
}


