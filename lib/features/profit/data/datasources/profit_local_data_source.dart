// profit_local_data_source.dart

import '../../../../core/enums/transaction_type.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../models/profits_model.dart';

abstract class ProfitLocalDataSource {
  ProfitsModel getProfit({DateTime? from, DateTime? to});
}

class ProfitLocalDataSourceImpl implements ProfitLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  @override
  ProfitsModel getProfit({DateTime? from, DateTime? to}) {
    final transactions =
        _store.transactions.getAll().where((e) {
          if (e.transactionType != TransactionType.sessionProfit.index) {
            return false;
          }

          if (from != null && e.createdAt.isBefore(from)) return false;
          if (to != null && e.createdAt.isAfter(to)) return false;

          return true;
        }).toList();

    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final totalProfit = transactions.fold<double>(
      0,
      (previous, element) => previous + (element.sessionProfit ?? 0),
    );

    return ProfitsModel(totalProfit: totalProfit, transactions: transactions);
  }
}
