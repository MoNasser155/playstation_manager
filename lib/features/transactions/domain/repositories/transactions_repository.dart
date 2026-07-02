import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/user_type.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/transaction_model.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, int>> createTransaction(TransactionModel transaction);
  Future<Either<Failure, List<TransactionModel>>> getAllTransactions({DateTime? from, DateTime? to});
  Future<Either<Failure, List<TransactionModel>>> getTransactionsByUser({
    required UserType type,
    required String uuid,
  });
  Future<Either<Failure, List<TransactionModel>>> getTransactionsByUserType(
    UserType type, {DateTime? from, DateTime? to}
  );
}
