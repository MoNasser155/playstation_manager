import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/transaction_model.dart';
import '../repositories/transactions_repository.dart';

class GetAllTransactionsUseCase {
  final _repository = sl<TransactionsRepository>();
  Future<Either<Failure, List<TransactionModel>>> call({DateTime? from, DateTime? to}) async {
    return await _repository.getAllTransactions(from: from, to: to);
  }
}
