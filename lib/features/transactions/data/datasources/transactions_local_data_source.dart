import 'package:local_erp_system/core/errors/exceptions.dart';

import '../../../../core/enums/transaction_type.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/objectbox/objectbox.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../models/transaction_model.dart';

abstract class TransactionsLocalDataSource {
  int createTransaction(TransactionModel model);
  List<TransactionModel> getAllTransactions({DateTime? from, DateTime? to});
  List<TransactionModel> getTransactionsByUser({
    required UserType type,
    required String uuid,
  });
  List<TransactionModel> getTransactionsByUserType(
    UserType type, {
    DateTime? from,
    DateTime? to,
  });
}

class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  TransactionsLocalDataSourceImpl();

  @override
  int createTransaction(TransactionModel model) {
    // Only process balance updates for customerPayment (1)
    final isCustomerPayment =
        model.transactionType == TransactionType.customerPayment.index;

    if (!isCustomerPayment) {
      // For other transaction types (invoiceProfit), just save
      return _store.transactions.put(model);
    }

    // Step 1: Fetch customer
    final customerQuery =
        _store.customers
            .query(CustomerModel_.uuid.equals(model.userUuid))
            .build();
    final customer = customerQuery.findFirst();
    customerQuery.close();

    if (customer == null) throw CustomerNotFoundException();

    // Calculate balances
    final beginningBalance = customer.netAmount;
    // When a customer pays, their debt (receivable) decreases
    final newReceivable = customer.receivableAmount - model.paymentAmount;
    final endBalance = newReceivable - customer.payableAmount;

    final updatedModel = TransactionModel.create(
      uuid: model.uuid,
      userUuid: model.userUuid,
      userName: customer.name,
      notes: model.notes,
      beginningBalance: beginningBalance,
      paymentAmount: 0,
      paidInvoiceAmount: model.paymentAmount,
      endBalance: endBalance,
      transactionType: model.transactionTypeVal,
      userType: model.userTypeVal,
      createdAt: model.createdAt,
    );

    // Step 2: Save transaction
    final transactionId = _store.transactions.put(updatedModel);

    // Step 3: Update customer balance
    _store.customers.put(customer.copyWith(receivableAmount: newReceivable));

    return transactionId;
  }

  @override
  List<TransactionModel> getAllTransactions({DateTime? from, DateTime? to}) {
    final List<TransactionModel> transactions = [];
    transactions.addAll(
      getTransactionsByUserType(UserType.customer, from: from, to: to),
    );
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  @override
  List<TransactionModel> getTransactionsByUserType(
    UserType type, {
    DateTime? from,
    DateTime? to,
  }) {
    Condition<TransactionModel> condition = TransactionModel_.userType.equals(
      type.index,
    );

    if (from != null) {
      condition =
          condition &
          TransactionModel_.createdAt.greaterOrEqual(
            from.millisecondsSinceEpoch,
          );
    }
    if (to != null) {
      condition =
          condition &
          TransactionModel_.createdAt.lessOrEqual(to.millisecondsSinceEpoch);
    }

    final query = _store.transactions.query(condition).build();
    final transactions = query.find();
    query.close();
    return transactions;
  }

  @override
  List<TransactionModel> getTransactionsByUser({
    required UserType type,
    required String uuid,
  }) {
    //get user
    final userQuery =
        _store.customers.query(CustomerModel_.uuid.equals(uuid)).build();

    final user = userQuery.findFirst();
    userQuery.close();
    if (user == null) {
      throw CustomerNotFoundException();
    }
    // get transactions
    final customerUser = user;
    final transactionsQuery =
        _store.transactions
            .query(TransactionModel_.userUuid.equals(customerUser.uuid))
            .build();
    final transactions = transactionsQuery.find();
    transactionsQuery.close();
    return transactions;
  }
}
