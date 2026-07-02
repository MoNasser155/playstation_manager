part of 'transactions_cubit.dart';

class TransactionsState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final int selectedTapIndex;
  final List<TransactionModel> transactions;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int selectedMonth;
  final double totalAmount;

  const TransactionsState({
    required this.status,
    required this.selectedTapIndex,
    this.errMessage,
    required this.transactions,
    this.fromDate,
    this.toDate,
    required this.selectedMonth,
    required this.totalAmount,
  });

  factory TransactionsState.initial() {
    final now = DateTime.now();
    return TransactionsState(
      status: StateStatus.initial,
      selectedTapIndex: 0,
      transactions: [],
      fromDate: DateTime(now.year, now.month, now.day),
      toDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
      selectedMonth: -1,
      totalAmount: 0,
    );
  }

  TransactionsState copyWith({
    StateStatus? status,
    String? errMessage,
    int? selectedTapIndex,
    List<TransactionModel>? transactions,
    DateTime? fromDate,
    DateTime? toDate,
    int? selectedMonth,
    bool clearSelectedMonth = false,
    double? totalAmount,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      selectedTapIndex: selectedTapIndex ?? this.selectedTapIndex,
      transactions: transactions ?? this.transactions,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      selectedMonth:
          clearSelectedMonth ? -1 : (selectedMonth ?? this.selectedMonth),
          totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errMessage,
        selectedTapIndex,
        transactions,
        fromDate,
        toDate,
        selectedMonth,
        totalAmount,
      ];
}
