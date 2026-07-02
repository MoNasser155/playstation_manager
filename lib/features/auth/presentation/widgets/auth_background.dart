import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/shared/cubits/global_theming_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_toggle_switch.dart';

enum AuthBackgroundType { normal, error, pending }

class AuthBackground extends StatelessWidget {
  final AuthBackgroundType type;
  final Widget child;

  const AuthBackground({super.key, required this.type, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    List<Color> gradientColors;

    switch (type) {
      case AuthBackgroundType.normal:
        gradientColors =
            gradientColors =
                isDark
                    ? [
                      AppColors.darkNavy,
                      AppColors.darkTeal,
                      AppColors.darkContainer,
                    ]
                    : [
                      AppColors.softPink,
                      AppColors.tertiaryColor,
                      AppColors.deepSea,
                    ];
        break;
      case AuthBackgroundType.error:
        gradientColors =
            isDark
                ? [
                  AppColors.darkScaffoldBackgroundColor,
                  const Color(0xFF2D0A0A),
                  AppColors.darkScaffoldBackgroundColor,
                ]
                : [
                  AppColors.lightScaffoldBackgroundColor,
                  AppColors.errorColor.withValues(alpha: 0.05),
                  AppColors.lightScaffoldBackgroundColor,
                ];
        break;
      case AuthBackgroundType.pending:
        gradientColors =
            isDark
                ? [
                  AppColors.darkScaffoldBackgroundColor,
                  AppColors.darkTeal.withValues(alpha: 0.4),
                  AppColors.darkScaffoldBackgroundColor,
                ]
                : [
                  AppColors.lightScaffoldBackgroundColor,
                  AppColors.tertiaryColor.withValues(alpha: 0.2),
                  AppColors.lightScaffoldBackgroundColor,
                ];

        break;
    }
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: context.isRtl ? Alignment.topLeft : Alignment.topRight,
              end: context.isRtl ? Alignment.bottomRight : Alignment.bottomLeft,
              colors: gradientColors,
            ),
          ),
        ),
        // big background circle (outer arc, teal-ish)
        Positioned(
          bottom: -context.width * 0.55,
          left: context.width * 0.05,
          child: Container(
            width: context.width * 1.3,
            height: context.width * 1.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isDark ? AppColors.deepSea : AppColors.tertiaryColor)
                  .withValues(alpha: isDark ? 0.6 : 0.55),
            ),
          ),
        ),

        // middle circle (warm tone)
        Positioned(
          bottom: -context.width * 0.5,
          left: -context.width * 0.05,
          child: Container(
            width: context.width * 1.1,
            height: context.width * 1.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isDark ? AppColors.darkSurface : AppColors.salmon)
                  .withValues(alpha: isDark ? 0.7 : 0.6),
            ),
          ),
        ),

        // front circle (matches container/scaffold color)
        Positioned(
          bottom: -context.width * 0.55,
          left: context.width * 0.02,
          child: Container(
            width: context.width * 1.25,
            height: context.width * 1.25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isDark
                      ? AppColors.darkContainer.withValues(alpha: 0.95)
                      : AppColors.lightContainer.withValues(alpha: 0.95),
            ),
          ),
        ),

        Positioned(
          top: 20,
          left: context.isRtl ? 20 : null,
          right: context.isRtl ? null : 20,
          child: Container(
            width: 200,
            height: 260,
            padding: EdgeInsets.all(AppPadding.pf12),
            decoration: BoxDecoration(
              color: context.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.r12),
              border: Border.all(color: context.colorScheme.secondaryFixed),
            ),
            child: Column(
              children: [
                Text(LocaleKeys.contactUs, style: theme.textTheme.titleLarge),
                Expanded(child: Image.asset(AppImages.contactQr)),
                gapHFix(12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.darkMode,
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                    CustomToggle(
                      initialValue:
                          context.read<GlobalThemingCubit>().state.themeMode ==
                          ThemeMode.dark,
                      onChanged: (value) {
                        context.read<GlobalThemingCubit>().toggleTheme();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
