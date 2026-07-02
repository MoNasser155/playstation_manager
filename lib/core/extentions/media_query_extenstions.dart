import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
  double get safeAreaTop => MediaQuery.of(this).padding.top;

  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
