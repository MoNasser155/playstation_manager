import 'package:fpdart/fpdart.dart';

import 'exceptions.dart';
import 'failure.dart';

mixin ErrorHandler {
  Future<Either<Failure, T>> wrapBoxOperation<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } on MachineMismatchException catch (e) {
      return Left(MachineMismatchFailure(e.messageKey));
    } on AppException catch (e) {
      return Left(LocalDatabaseFailure(e.messageKey));
    } catch (e) {
      if (e.toString().contains('Unique constraint')) {
        return Left(DuplicateEntryFailure('Entry already exists'));
      }
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  Either<Failure, T> wrapBoxOperationSync<T>(T Function() operation) {
    try {
      final result = operation();
      return Right(result);
    } on MachineMismatchException catch (e) {
      return Left(MachineMismatchFailure(e.messageKey));
    } on AppException catch (e) {
      return Left(LocalDatabaseFailure(e.messageKey));
    } catch (e) {
      if (e.toString().contains('Unique constraint')) {
        return Left(DuplicateEntryFailure('Entry already exists'));
      }
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  Future<Either<Failure, T>> wrapSupaBaseOperation<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } on MachineMismatchException catch (e) {
      return Left(MachineMismatchFailure(e.messageKey));
    } on AppException catch (e) {
      return Left(SupabaseDatabaseFailure(e.messageKey));
    } catch (e) {
      if (e.toString().contains('Unique constraint')) {
        return Left(DuplicateEntryFailure('Entry already exists'));
      }
      return Left(SupabaseDatabaseFailure(e.toString()));
    }
  }
}
