import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl with ErrorHandler implements AuthRepository {
  AuthRepositoryImpl();
  final _remoteDataSource = sl<AuthRemoteDataSource>();

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    return wrapSupaBaseOperation(() => _remoteDataSource.signInWithGoogle());
  }

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    return wrapSupaBaseOperation(() => _remoteDataSource.getCurrentUser());
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return wrapSupaBaseOperation(() => _remoteDataSource.signOut());
  }
}
