import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../data/models/profits_model.dart';
import '../../../domain/usecases/get_filtered_profits_usecase.dart';
import 'password_mixin.dart';

part 'profit_state.dart';

class ProfitCubit extends BaseCubit<ProfitState> with PasswordMixin {
  ProfitCubit() : super(ProfitState.initial()) {
    getLocaleSavedPassword();
  }

  static ProfitCubit get(context) => BlocProvider.of(context);
  final _getFilteredProfitsUsecase = sl<GetFilteredProfitsUsecase>();

  void submitPassword(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    safeEmit(state.copyWith(passwordStatus: StateStatus.loading));
    if (passwordController.text == state.password) {
      safeEmit(state.copyWith(passwordStatus: StateStatus.correct));
      _getProfits();
    } else {
      safeEmit(state.copyWith(passwordStatus: StateStatus.wrong));
      CustomSnackBar.top(context: context, msg: LocaleKeys.wrongPassword);
    }
  }

  Future<void> _getProfits() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final response = await _getFilteredProfitsUsecase.getProfit(
      from: state.fromDate,
      to: state.toDate,
    );
    response.fold(
      (l) {
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success, profits: r));
      },
    );
  }

  void selectMonth(int month) {
    if (state.selectedMonth == month) return;

    final oneBasedMonth = month + 1;
    final year = DateTime.now().year;
    final from = DateTime(year, oneBasedMonth, 1, 0, 0, 0);
    final to = DateTime(year, oneBasedMonth + 1, 0, 23, 59, 59);
    safeEmit(state.copyWith(fromDate: from, toDate: to, selectedMonth: month));
    _getProfits();
  }

  void resetToDefaultDate() {
    final now = DateTime.now();
    safeEmit(
      state.copyWith(
        fromDate: DateTime(now.year, now.month, now.day),
        toDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
        selectedMonth: -1,
      ),
    );
    _getProfits();
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
    _getProfits();
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

  @override
  Future<void> close() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
