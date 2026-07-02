import '../../../transactions/data/models/transaction_model.dart';

class ProfitsModel {
  double totalProfit;
  List<TransactionModel> transactions;

  ProfitsModel({required this.totalProfit, required this.transactions});
}
