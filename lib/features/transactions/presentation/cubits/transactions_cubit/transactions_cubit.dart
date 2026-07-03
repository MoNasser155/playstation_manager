import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../data/models/transaction_model.dart';
import '../../../domain/usecases/get_all_transactions_usecase.dart';

part 'transactions_state.dart';

class TransactionsCubit extends BaseCubit<TransactionsState> {
  TransactionsCubit() : super(TransactionsState.initial());

  static TransactionsCubit get(context) => BlocProvider.of<TransactionsCubit>(context);

  final _getAllTransactionsUsecase = sl<GetAllTransactionsUseCase>();

  void init() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    _getAllTransactions();
  }

  void changeTapIndex(int index) {
    if (state.selectedTapIndex != index) {
      safeEmit(state.copyWith(selectedTapIndex: index));
      _getAllTransactions();
    }
  }

  Future<void> _getAllTransactions() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getAllTransactionsUsecase.call(
      from: state.fromDate,
      to: state.toDate,
    );
    result.fold(
      (failure) {
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (transactions) {
        calculateTotalAmount();
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            transactions: transactions,
          ),
        );
      },
    );
  }

  void calculateTotalAmount() {
    final totalAmount = state.transactions.fold<double>(
      0,
      (previous, element) => previous + (element.invoiceProfit ?? 0.0),
    );
    safeEmit(state.copyWith(totalAmount: totalAmount));
  }

  void selectMonth(int month) {
    final oneBasedMonth = month + 1;

    if (state.selectedMonth == month) {
      final now = DateTime.now();
      safeEmit(
        state.copyWith(
          fromDate: DateTime(now.year, now.month, now.day),
          toDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
          selectedMonth: -1,
        ),
      );
      _getAllTransactions();
      return;
    }

    final year = DateTime.now().year;
    final from = DateTime(year, oneBasedMonth, 1, 0, 0, 0);
    final to = DateTime(year, oneBasedMonth + 1, 0, 23, 59, 59);
    safeEmit(state.copyWith(fromDate: from, toDate: to, selectedMonth: month));
    _getAllTransactions();
  }

  void onDateRangeChanged(DateTime from, DateTime to) {
    final normalizedFrom = DateTime(from.year, from.month, from.day, 0, 0, 0);
    final normalizedTo = DateTime(to.year, to.month, to.day, 23, 59, 59);
    safeEmit(
      state.copyWith(
        fromDate: normalizedFrom,
        toDate: normalizedTo,
        selectedMonth: -1,
      ),
    );
    _getAllTransactions();
  }

  List<String> get monthNames => [
    LocaleKeys.january,
    LocaleKeys.february,
    LocaleKeys.march,
    LocaleKeys.april,
    LocaleKeys.may,
    LocaleKeys.june,
    LocaleKeys.july,
    LocaleKeys.august,
    LocaleKeys.september,
    LocaleKeys.october,
    LocaleKeys.november,
    LocaleKeys.december,
  ];

  Future<void> refresh() async {
    safeEmit(
      state.copyWith(
        status: StateStatus.loading,
        selectedTapIndex: 0,
        transactions: [],
      ),
    );
    init();
  }
}
