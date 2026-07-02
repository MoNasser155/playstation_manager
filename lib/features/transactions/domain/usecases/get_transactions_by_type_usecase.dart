import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/user_type.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/transaction_model.dart';
import '../repositories/transactions_repository.dart';

class GetTransactionsByTypeUseCase {
  final _repository = sl<TransactionsRepository>();
  Future<Either<Failure, List<TransactionModel>>> call(UserType type, {DateTime? from, DateTime? to}) async {
    return await _repository.getTransactionsByUserType(type, from: from, to: to);
  }
}
