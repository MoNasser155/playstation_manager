import '../../../transactions/data/models/transaction_model.dart';
import 'storage_model.dart';

class StorageDetailsModel {
  final StorageModel item;
  final List<TransactionModel> transactions;

  StorageDetailsModel({required this.item, required this.transactions});

  StorageDetailsModel copyWith({
    StorageModel? item,
    List<TransactionModel>? transactions,
  }) {
    return StorageDetailsModel(
      item: item ?? this.item,
      transactions: transactions ?? this.transactions,
    );
  }

  factory StorageDetailsModel.initial() {
    return StorageDetailsModel(
      item: StorageModel.initial(),
      transactions: [],
    );
  }
}
