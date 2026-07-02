import 'package:fpdart/fpdart.dart';
import 'package:local_erp_system/core/enums/user_type.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/transaction_model.dart';
import '../repositories/transactions_repository.dart';

class GetAllUserTransactionsUseCase {
  final _repository = sl<TransactionsRepository>();
  Future<Either<Failure, List<TransactionModel>>> call({
    required UserType type,
    required String uuid,
  }) async {
    return await _repository.getTransactionsByUser(type: type, uuid: uuid);
  }
}