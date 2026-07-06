import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../domain/entities/app_user.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_background.dart';
import '../widgets/info_row.dart';
import '../widgets/pulsing_icon.dart';

class PendingPage extends StatelessWidget {
  final AppUser user;
  const PendingPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {},
      child: Scaffold(
        body: AuthBackground(
          type: AuthBackgroundType.pending,
          child: Center(
            child: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated hourglass icon
                    PulsingIcon(),

                    gapH(24),

                    Text(
                      LocaleKeys.waitingForActivation,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                    gapH(10),
                    Text(
                      LocaleKeys.accountRegisteredPendingActivation,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.secondaryFixed,
                        height: 1.6,
                      ),
                    ),

                    gapH(28),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppPadding.pf16),
                      decoration: BoxDecoration(
                        color: context.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.shadow.withValues(
                              alpha: 0.8,
                            ),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          InfoRow(
                            icon: Icons.email_outlined,
                            label: LocaleKeys.email,
                            value: user.email,
                          ),
                          Divider(
                            height: 24,
                            color: context.colorScheme.secondaryFixed,
                          ),
                          InfoRow(
                            icon: Icons.computer_outlined,
                            label: LocaleKeys.machineId,
                            value: user.machineId,
                            copyable: true,
                          ),
                        ],
                      ),
                    ),
                    gapH(32),
                    TextButton.icon(
                      onPressed: () => AuthCubit.get(context).signOut(),
                      icon: Icon(
                        Icons.logout,
                        size: 16,
                        color: context.colorScheme.error,
                      ),
                      label: Text(
                        LocaleKeys.signOut,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.pf20,
                          vertical: AppPadding.pf12,
                        ),
                        foregroundColor: context.colorScheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
