import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:playstation_manager/core/extentions/media_query_extenstions.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/widgets/vector_icon.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_background.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            CustomSnackBar.top(
              context: context,
              msg: state.errorMessage ?? LocaleKeys.authFailed,
            );
          }
        },
        child: AuthBackground(
          type: AuthBackgroundType.normal,
          child: Center(
            child: SizedBox(
              width: context.width * .3,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppPadding.pf20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                    ),
                    child: Lottie.asset(AppLottie.console),
                  ),
                  gapH(24),
                  Text(
                    LocaleKeys.console,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                  gapHFix(12),
                  Text(
                    LocaleKeys.signInVerifyLicense,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.secondaryFixed,
                    ),
                  ),
                  gapH(40),
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (p, c) {
                      return p.status != c.status;
                    },
                    builder: (context, state) {
                      final cubit = AuthCubit.get(context);
                      final loading = state.status == AuthStatus.loading;
                      return CustomButton(
                        isLoading: loading,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppPadding.pf6),
                              decoration: BoxDecoration(
                                color: context.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: VectorIcon(
                                assetPath: VectorIcons.google,
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              LocaleKeys.continueWithGoogle,
                              style: context.textTheme.headlineLarge!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          cubit.signInWithGoogle();
                        },
                      );
                    },
                  ),

                  gapH(20),
                  Text(
                    LocaleKeys.licenseLockNotice,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.secondaryFixed,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    LocaleKeys.activeLicence,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.secondaryFixed,
                      height: 1.5,
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
