import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/transaction_model.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, List<TransactionModel>>> getAllTransactions({DateTime? from, DateTime? to});
}
