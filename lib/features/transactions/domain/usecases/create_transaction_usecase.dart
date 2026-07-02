import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/transaction_model.dart';
import '../repositories/transactions_repository.dart';

class CreateTransactionUseCase {
  final _repository = sl<TransactionsRepository>();

  Future<Either<Failure, int>> call(TransactionModel transaction) async {
    return await _repository.createTransaction(transaction);
  }
}
