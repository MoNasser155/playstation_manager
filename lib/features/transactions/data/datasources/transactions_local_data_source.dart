import 'package:local_erp_system/core/objectbox/objectbox.g.dart';

import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../models/transaction_model.dart';

abstract class TransactionsLocalDataSource {
  List<TransactionModel> getAllTransactions({DateTime? from, DateTime? to});
}

class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  TransactionsLocalDataSourceImpl();

  @override
  List<TransactionModel> getAllTransactions({DateTime? from, DateTime? to}) {
    Condition<TransactionModel>? condition;
    if (from != null) {
      condition = TransactionModel_.createdAt.greaterOrEqual(
        from.millisecondsSinceEpoch,
      );
    }
    if (to != null) {
      final toCond = TransactionModel_.createdAt.lessOrEqual(
        to.millisecondsSinceEpoch,
      );
      condition = condition != null ? condition & toCond : toCond;
    }

    final builder =
        condition != null
            ? _store.transactions.query(condition)
            : _store.transactions.query();

    builder.order(TransactionModel_.createdAt, flags: Order.descending);

    final query = builder.build();
    final transactions = query.find();
    query.close();

    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }
}
