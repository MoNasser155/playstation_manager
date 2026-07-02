import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

extension ThemeExtensions on BuildContext {
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  IconThemeData get iconTheme => Theme.of(this).iconTheme;

  /// Access container colors from theme
  AppContainerColors get containerColors =>
      Theme.of(this).extension<AppContainerColors>()!;

  /// Quick access to common container colors
  Color get primaryContainer => containerColors.primary;
  Color get mapCard => containerColors.mapCard;
  Color get authCard => containerColors.authCard;
  Color get idleGlowColor => containerColors.idleGlowColor;
  Color get idleGlowColor2 => containerColors.idleGlowColor2;
  Color get errorGlowColor => containerColors.errorGlowColor;
}
