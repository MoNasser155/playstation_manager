import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AppUser>> signInWithGoogle();
  Future<Either<Failure, AppUser?>> getCurrentUser();
  Future<Either<Failure, void>> signOut();
}
