import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final _repository = sl<AuthRepository>();
  Future<Either<Failure, void>> call() async {
    return await _repository.signOut();
  }
}
