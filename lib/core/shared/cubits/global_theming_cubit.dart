import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_constants.dart';
import '../../utils/cashe_storage.dart';

part 'global_theming_state.dart';

class GlobalThemingCubit extends Cubit<GlobalThemingState> {
  GlobalThemingCubit() : super(GlobalThemingState.initial()) {
    _loadTheme();
  }

  static GlobalThemingCubit get(context) => BlocProvider.of(context);

  Future<void> _loadTheme() async {
    final String? savedTheme = await SecureStorage.read(AppConstants.themeKey);
    if (savedTheme != null) {
      final themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.light,
      );
      emit(GlobalThemingState(themeMode: themeMode));
    }
  }

  Future<void> toggleTheme() async {
    final newThemeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await _saveTheme(newThemeMode);
    emit(GlobalThemingState(themeMode: newThemeMode));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _saveTheme(themeMode);
    emit(GlobalThemingState(themeMode: themeMode));
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    await SecureStorage.write(AppConstants.themeKey, themeMode.toString());
  }

  bool get isDarkMode => state.themeMode == ThemeMode.dark;

  bool get isLightMode => state.themeMode == ThemeMode.light;
}
