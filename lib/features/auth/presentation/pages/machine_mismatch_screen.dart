import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/extentions/media_query_extenstions.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gaps.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_background.dart';

class MachineMismatchScreen extends StatelessWidget {
  const MachineMismatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AuthBackground(
        type: AuthBackgroundType.error,
        child: Center(
          child: SizedBox(
            width: context.width * .3,
            child: Container(
              padding: EdgeInsets.all(AppPadding.pf20),
              decoration: BoxDecoration(
                color: context.authCard,
                borderRadius: BorderRadius.circular(AppRadius.r16),
                border: Border.all(
                  color: context.colorScheme.error.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.errorColor.withValues(alpha: 0.08),
                    blurRadius: 60,
                    spreadRadius: 0,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppPadding.pf20),
                    decoration: BoxDecoration(
                      color: AppColors.errorColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.computer_outlined,
                      size: 44,
                      color: AppColors.errorColor,
                    ),
                  ),

                  gapH(28),

                  Text(
                    LocaleKeys.licenseRegisteredToAnotherMachine,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.3,
                    ),
                  ),

                  gapH(14),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.errorColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.errorColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.licenseLockedToDifferentDevice,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.secondaryFixed,
                        height: 1.6,
                      ),
                    ),
                  ),

                  gapH(32),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => AuthCubit.get(context).signOut(),
                      icon: const Icon(Icons.logout, size: 18),
                      label: Text(
                        LocaleKeys.signOut,
                        style: context.textTheme.displayMedium?.copyWith(
                          color: context.colorScheme.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorColor,
                        side: const BorderSide(color: AppColors.errorColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
