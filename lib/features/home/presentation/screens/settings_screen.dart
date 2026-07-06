import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/services/backup_service.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        sliverGapHFix(12),
        CustomSliverAppbar(
          onBackTap: () {
            final cubit = MainViewCubit.get(context);
            cubit.clearCustomizedView();
          },
        ),
        sliverGapHFix(12),
        CustomSliverPadding(
          child: Column(
            children: [
              BlocBuilder<MainViewCubit, MainViewState>(
                buildWhen: (previous, current) {
                  return previous.isLoading != current.isLoading ||
                      previous.restoreStatus != current.restoreStatus ||
                      previous.backupStatus != current.backupStatus;
                },
                builder: (context, state) {
                  final cubit = MainViewCubit.get(context);
                  return _SettingsButton(
                    title: LocaleKeys.restoreLocalBackup,
                    iconData: Icons.archive,
                    onTap: () async {
                      final backupService = BackupService();
                      final folder = await backupService.pickBackupFolder();
                      if (folder != null) {
                        if (context.mounted) {
                          cubit.runRestore(
                            backupPath: folder,
                            context: context,
                          );
                        }
                      }
                    },
                  );
                },
              ),
              gapHFix(16),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final cubit = AuthCubit.get(context);
                  return _SettingsButton(
                    title: LocaleKeys.signOut,
                    iconData: Icons.logout,
                    isSignOutButton: true,
                    onTap: () async {
                      if (context.mounted) {
                        cubit.signOut();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    required this.title,
    this.onTap,
    this.isSignOutButton = false,
    required this.iconData,
  });

  final String title;
  final void Function()? onTap;
  final bool isSignOutButton;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: context.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Row(
          spacing: AppSpacing.h12,
          children: [
            Icon(
              iconData,
              color: isSignOutButton ? context.colorScheme.error : null,
            ),
            Text(
              title,
              style: context.textTheme.displayLarge!.copyWith(
                fontSize: 24.sp,
                color:
                    isSignOutButton
                        ? context.colorScheme.error
                        : context.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
