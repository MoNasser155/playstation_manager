import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/enums/state_status.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/utils/cashe_storage.dart';
import 'profit_cubit.dart';

mixin PasswordMixin on BaseCubit<ProfitState> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getLocaleSavedPassword() async {
    safeEmit(state.copyWith(passwordStatus: StateStatus.loading));
    final password = await SecureStorage.read(AppConstants.userPasserd);
    if (password != null) {
      safeEmit(
        state.copyWith(passwordStatus: StateStatus.loaded, password: password),
      );
    } else {
      safeEmit(state.copyWith(passwordStatus: StateStatus.failure));
    }
  }

  void saveUserPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    safeEmit(state.copyWith(passwordStatus: StateStatus.loading));
    await SecureStorage.write(
      AppConstants.userPasserd,
      passwordController.text,
    );
    safeEmit(state.copyWith(passwordStatus: StateStatus.success));
  }
}
