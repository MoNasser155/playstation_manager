import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_values.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

// Custom Theme Extension for Container Colors
class AppContainerColors extends ThemeExtension<AppContainerColors> {
  final Color primary;
  final Color mapCard;
  final Color authCard;
  final Color idleGlowColor;
  final Color idleGlowColor2;
  final Color errorGlowColor;

  const AppContainerColors({
    required this.primary,
    required this.mapCard,
    required this.authCard,
    required this.idleGlowColor,
    required this.idleGlowColor2,
    required this.errorGlowColor,
  });

  @override
  AppContainerColors copyWith({
    Color? primary,
    Color? mapCard,
    Color? authCard,
    Color? idleGlowColor,
    Color? idleGlowColor2,
    Color? errorGlowColor,
  }) {
    return AppContainerColors(
      primary: primary ?? this.primary,
      mapCard: mapCard ?? this.mapCard,
      authCard: authCard ?? this.authCard,
      idleGlowColor: idleGlowColor ?? this.idleGlowColor,
      idleGlowColor2: idleGlowColor2 ?? this.idleGlowColor2,
      errorGlowColor: errorGlowColor ?? this.errorGlowColor,
    );
  }

  @override
  AppContainerColors lerp(ThemeExtension<AppContainerColors>? other, double t) {
    if (other is! AppContainerColors) {
      return this;
    }
    return AppContainerColors(
      primary: Color.lerp(primary, other.primary, t)!,
      mapCard: Color.lerp(mapCard, other.mapCard, t)!,
      authCard: Color.lerp(authCard, other.authCard, t)!,
      idleGlowColor: Color.lerp(idleGlowColor, other.idleGlowColor, t)!,
      idleGlowColor2: Color.lerp(idleGlowColor2, other.idleGlowColor2, t)!,
      errorGlowColor: Color.lerp(errorGlowColor, other.errorGlowColor, t)!,
    );
  }
}

class AppTheme {
  static const double borderRadius = 12;

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required Color scaffoldBg,
    required bool isDark,
  }) {
    // ignore: unused_local_variable
    final radius = BorderRadius.circular(borderRadius.r);
    return ThemeData(
      brightness: scheme.brightness,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: scaffoldBg,
      useMaterial3: true,
      colorScheme: scheme,

      //icons
      iconTheme: IconThemeData(
        color: scheme.secondaryFixed.withValues(alpha: 0.6),
      ),
      // Custom Extensions
      extensions: [
        AppContainerColors(
          primary: isDark ? AppColors.darkContainer : AppColors.lightContainer,
          mapCard:
              isDark
                  ? AppColors.darkScaffoldBackgroundColor
                  : AppColors.lightScaffoldBackgroundColor,
          authCard:
              isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.6)
                  : AppColors.white.withValues(alpha: 0.35),
          idleGlowColor:
              isDark
                  ? AppColors.deepSea.withValues(alpha: 0.5)
                  : AppColors.tertiaryColor.withValues(alpha: 0.7),
          idleGlowColor2:
              isDark
                  ? AppColors.steelBlue.withValues(alpha: 0.4)
                  : AppColors.salmon.withValues(alpha: 0.5),
          errorGlowColor:
              isDark
                  ? AppColors.salmon.withValues(alpha: 0.3)
                  : AppColors.salmon.withValues(alpha: 0.4),
        ),
      ],

      // App Bar Theme
      appBarTheme: _appBarTheme(scheme, isDark),

      // Tab Bar Theme
      tabBarTheme: _tabBarTheme(scheme, isDark),

      // Input Decoration Theme
      inputDecorationTheme: _inputDecorationTheme(scheme: scheme),

      //text theme
      textTheme: _textTheme(isDark),

      //textButton theme
      textButtonTheme: _textButtonTheme(isDark),

      //dropdown theme
      dropdownMenuTheme: _dropdownMenuTheme(isDark),

      //chip theme
      chipTheme: _chipTheme(isDark),

      //bottom sheet theme
      bottomSheetTheme: _bottomSheetTheme(isDark),

      //ListTile theme
      listTileTheme: _listTileTheme(scheme),

      //expansion tile theme
      expansionTileTheme: _expansionTileTheme(isDark, scheme),

      //checkbox theme
      checkboxTheme: _checkboxTheme(scheme),
    );
  }

  //light theme
  static ThemeData get lightTheme => _buildTheme(
    scheme: _lightColorScheme,
    scaffoldBg: AppColors.grey50,
    isDark: false,
  );

  //dark theme
  static ThemeData get darkTheme => _buildTheme(
    scheme: _darkColorScheme,
    scaffoldBg: AppColors.darkScaffoldBackgroundColor,
    isDark: true,
  );

  //light theme color scheme
  static const _lightColorScheme = ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: AppColors.black,
    shadow: AppColors.grey300,
    primaryContainer: AppColors.lightContainer,
    onPrimaryContainer: AppColors.black,
    onSecondaryContainer:
        AppColors.orange, // for text color upove secondaryContainer
    secondaryContainer: AppColors.salmon,
    surfaceContainerLowest: AppColors.grey50,
    surfaceContainerHigh: AppColors.lightContainer,
    secondaryFixed: AppColors.grey600,
    surfaceContainer: AppColors.grey500,
    error: AppColors.errorColor,
    tertiary: Colors.orange,
    surface: AppColors.lightScaffoldBackgroundColor,
  );

  //dark theme color scheme
  static const _darkColorScheme = ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppColors.primaryColor,
    onPrimary: AppColors.white,
    shadow: AppColors.grey700,
    primaryContainer: AppColors.darkContainer,
    onPrimaryContainer: AppColors.darkContainer,
    onSecondaryContainer:
        AppColors.secondaryColor, // for text color upove secondaryContainer
    secondaryContainer: AppColors.salmon,
    secondaryFixed: AppColors.grey400,
    surfaceContainerLowest: AppColors.darkScaffoldBackgroundColor,
    surfaceContainerHigh: AppColors.darkContainer,
    surfaceContainer: AppColors.grey400,
    error: AppColors.errorColor,
    tertiary: Colors.deepOrangeAccent,
    surface: AppColors.darkScaffoldBackgroundColor,
  );

  // App Bar Theme
  static AppBarTheme _appBarTheme(ColorScheme colorScheme, bool isDark) {
    return AppBarTheme(
      toolbarHeight: AppSize.appbarHeight,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            isDark
                ? AppColors.darkScaffoldBackgroundColor
                : AppColors.lightScaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor:
          isDark ? AppColors.darkScaffoldBackgroundColor : AppColors.grey50,
      elevation: 0,
      shadowColor: isDark ? AppColors.black : AppColors.white,
      scrolledUnderElevation: 8,
      centerTitle: true,
    );
  }

  // Tab Bar Theme
  static TabBarThemeData _tabBarTheme(ColorScheme colorScheme, bool isDark) {
    return TabBarThemeData(
      indicatorColor: colorScheme.primary.withValues(alpha: 0.2),

      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.secondaryFixed,
      labelStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
      ),
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30.r),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
      tabAlignment: TabAlignment.center,
    );
  }

  // Input Decoration Theme
  static InputDecorationTheme _inputDecorationTheme({
    required ColorScheme scheme,
  }) {
    return InputDecorationTheme(
      errorStyle: TextStyle(color: scheme.error),
      filled: true,
      fillColor: scheme.primaryContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      prefixIconConstraints: const BoxConstraints(minWidth: 40, maxWidth: 40),
      prefixIconColor: scheme.secondaryFixed,
      suffixIconConstraints: const BoxConstraints(
        minWidth: 44,
        maxWidth: 44,
        minHeight: 44,
        maxHeight: 44,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: scheme.error,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Colors.transparent,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: AppColors.primaryColor,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: scheme.secondaryFixed,
        ),
      ),
      visualDensity: VisualDensity(
        vertical: VisualDensity.minimumDensity,
        horizontal: VisualDensity.minimumDensity,
      ),
      hintStyle: AppTextStyles.medium18.copyWith(color: scheme.secondaryFixed),
    );
  }

  // Text Theme
  static TextTheme _textTheme(bool isDark) {
    return TextTheme(
      //display
      displayLarge: AppTextStyles.bold24,
      displayMedium: AppTextStyles.bold20,
      displaySmall: AppTextStyles.bold18,
      //headline
      headlineLarge: AppTextStyles.semiBold18,
      headlineMedium: AppTextStyles.semiBold16,
      headlineSmall: AppTextStyles.semiBold14,
      //title
      titleLarge: AppTextStyles.medium20,
      titleMedium: AppTextStyles.medium18,
      titleSmall: AppTextStyles.regular16,
      //body
      bodyLarge: AppTextStyles.regular16,
      bodyMedium: AppTextStyles.regular14,
      bodySmall: AppTextStyles.regular12,
      //label
      labelLarge: AppTextStyles.regular14,
      labelMedium: AppTextStyles.regular12,
      labelSmall: AppTextStyles.regular10,
    );
  }

  //textButton theme
  static TextButtonThemeData _textButtonTheme(bool isDark) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity(
          vertical: VisualDensity.minimumDensity,
          horizontal: VisualDensity.minimumDensity,
        ),
      ),
    );
  }

  //dropdown theme
  static DropdownMenuThemeData _dropdownMenuTheme(bool isDark) {
    return DropdownMenuThemeData(
      disabledColor: isDark ? AppColors.grey500 : AppColors.grey800,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      menuStyle: MenuStyle(
        alignment: Alignment.center,
        elevation: WidgetStatePropertyAll(0),
        backgroundColor:
            isDark
                ? WidgetStatePropertyAll(AppColors.darkContainer)
                : WidgetStatePropertyAll(AppColors.white),
      ),
    );
  }

  //chip theme
  static ChipThemeData _chipTheme(bool isDark) {
    return ChipThemeData(
      padding: EdgeInsets.all(AppPadding.p4),
      labelPadding: EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p2,
      ),
      labelStyle: AppTextStyles.medium12.copyWith(
        color: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
      side: BorderSide(color: AppColors.primaryColor.withValues(alpha: 0.6)),
      disabledColor: isDark ? AppColors.grey500 : AppColors.grey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }

  //bottom sheet theme
  static BottomSheetThemeData _bottomSheetTheme(bool isDark) {
    return BottomSheetThemeData(backgroundColor: Colors.transparent);
  }

  static ListTileThemeData _listTileTheme(ColorScheme scheme) {
    return ListTileThemeData(
      horizontalTitleGap: AppPadding.p8,
      tileColor: scheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      titleTextStyle: AppTextStyles.regular16.copyWith(
        color: scheme.onPrimary,
        fontWeight: FontWeight.w600,
      ),

      subtitleTextStyle: AppTextStyles.regular12.copyWith(
        color: scheme.secondaryFixed,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p4,
      ),
      minVerticalPadding: AppPadding.p4,
      iconColor: scheme.onPrimary,
      visualDensity: VisualDensity(
        vertical: VisualDensity.minimumDensity,
        horizontal: VisualDensity.minimumDensity,
      ),
    );
  }

  static ExpansionTileThemeData _expansionTileTheme(
    bool isDark,
    ColorScheme scheme,
  ) {
    return ExpansionTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        side: BorderSide(color: scheme.secondaryContainer),
      ),
      backgroundColor: scheme.primaryContainer,
      collapsedIconColor: scheme.onSecondaryContainer,
      collapsedBackgroundColor: scheme.secondaryContainer,
      collapsedTextColor: scheme.secondaryFixed,
      iconColor: scheme.onSecondaryContainer,
      textColor: scheme.onSecondaryContainer,
      tilePadding: EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p4,
      ),
      childrenPadding: EdgeInsets.symmetric(
        horizontal: AppPadding.pf12,
        vertical: AppPadding.pf12,
      ),
    );
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme scheme) {
    return CheckboxThemeData(
      fillColor: WidgetStatePropertyAll(scheme.secondaryContainer),
      checkColor: WidgetStatePropertyAll(scheme.onSecondaryContainer),
      side: BorderSide(color: scheme.onSecondaryContainer),
      visualDensity: VisualDensity(
        vertical: VisualDensity.minimumDensity,
        horizontal: VisualDensity.minimumDensity,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r4),
      ),
    );
  }
}
