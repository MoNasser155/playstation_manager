import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/shared/cubits/global_theming_cubit.dart';
import 'core/shared/di.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/design_size.dart';
import 'core/utils/navigator_helper.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/auth/presentation/pages/machine_mismatch_screen.dart';
import 'features/auth/presentation/pages/pending_page.dart';
import 'features/auth/presentation/pages/splash_loading_screen.dart';
import 'features/main_view/presentation/screens/responsive_main_view_screen.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GlobalThemingCubit>(),
      child: ScreenUtilInit(
        designSize: setDesignSize(context),
        builder: (context, child) {
          return BlocBuilder<GlobalThemingCubit, GlobalThemingState>(
            buildWhen:
                (previous, current) => previous.themeMode != current.themeMode,
            builder: (context, themeState) {
              return MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                navigatorKey: AppNavigator.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                home: BlocProvider(
                  create: (_) => sl<AuthCubit>()..checkCurrentUser(),
                  child: const AppGate(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder:
          (context, state) => switch (state.status) {
            AuthStatus.initial => const SplashScreen(),
            AuthStatus.loading => const SplashScreen(),
            AuthStatus.unAuthenticated => const AuthPage(),
            AuthStatus.pending => PendingPage(user: state.user!),
            AuthStatus.machineMismatch => const MachineMismatchScreen(),
            AuthStatus.authenticated => const ResponsiveMainViewScreen(),
            AuthStatus.error => const AuthPage(),
          },
    );
  }
}
