part of 'profit_cubit.dart';

class ProfitState extends Equatable {
  final StateStatus status;
  final StateStatus passwordStatus;
  final String? errMessage;
  final String? password;
  final ProfitsModel profits;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int selectedMonth;

  const ProfitState({
    required this.status,
    required this.passwordStatus,
    this.errMessage,
    this.password,
    required this.profits,
    this.fromDate,
    this.toDate,
    required this.selectedMonth,
  });

  ProfitState copyWith({
    StateStatus? status,
    String? errMessage,
    StateStatus? passwordStatus,
    String? password,
    ProfitsModel? profits,
    DateTime? fromDate,
    DateTime? toDate,
    int? selectedMonth,
    bool clearSelectedMonth = false,
  }) {
    return ProfitState(
      status: status ?? this.status,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      errMessage: errMessage ?? this.errMessage,
      password: password ?? this.password,
      profits: profits ?? this.profits,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      selectedMonth:
          clearSelectedMonth ? -1 : (selectedMonth ?? this.selectedMonth),
    );
  }

  factory ProfitState.initial() {
    final now = DateTime.now();
    return ProfitState(
      status: StateStatus.initial,
      errMessage: null,
      passwordStatus: StateStatus.initial,
      password: null,
      profits: ProfitsModel(totalProfit: 0, transactions: []),
      fromDate: DateTime(now.year, now.month, now.day),
      toDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
      selectedMonth: -1,
    );
  }

  @override
  List<Object?> get props => [
    status,
    passwordStatus,
    errMessage,
    password,
    profits,
    fromDate,
    toDate,
    selectedMonth,
  ];
}
