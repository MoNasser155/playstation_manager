import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/transactions_local_data_source.dart';
import '../models/transaction_model.dart';

class TransactionsRepositoryImpl
    with ErrorHandler
    implements TransactionsRepository {
  final _localDataSource = sl<TransactionsLocalDataSource>();

  TransactionsRepositoryImpl();

  @override
  Future<Either<Failure, List<TransactionModel>>> getAllTransactions(
      {DateTime? from, DateTime? to}) async {
    return wrapBoxOperationSync(
        () => _localDataSource.getAllTransactions(from: from, to: to));
  }
}
