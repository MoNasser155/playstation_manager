import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/shared/di.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../cubits/cubit/profit_cubit.dart';
import '../widgets/custom_profits_appbar.dart';
import '../widgets/password_body/passwrd_body.dart';
import '../widgets/profits_list.dart';

part '../widgets/desktop/_desktop_profit_body.dart';
part '../widgets/mobile/_mobile_profit_body.dart';
part '../widgets/tablet/_tablet_profit_body.dart';

class ProfitScreen extends StatelessWidget {
  const ProfitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfitCubit>(),
      child: BlocBuilder<ProfitCubit, ProfitState>(
        buildWhen: (previous, current) {
          return previous.passwordStatus != current.passwordStatus;
        },
        builder: (context, state) {
          if (state.passwordStatus.isCorrect ||
              state.passwordStatus.isSuccess) {
            return Scaffold(
              key: ValueKey(context.locale.toString()),
              body: BlocBuilder<MainViewCubit, MainViewState>(
                buildWhen: (previous, current) {
                  return previous.mode != current.mode;
                },
                builder: (context, state) {
                  switch (state.mode) {
                    case MainViewMode.mobile:
                      return const _MobileProfitBody();
                    case MainViewMode.tablet:
                      return const _TabletProfitBody();
                    case MainViewMode.desktop:
                      return const _DesktopProfitBody();
                  }
                },
              ),
            );
          }
          return const PasswordBody();
        },
      ),
    );
  }
}
