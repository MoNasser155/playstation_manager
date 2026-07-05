import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_tap_bar.dart';
import '../cubits/cubit/session_cubit.dart';

class SessionTabBarWrapper extends StatelessWidget {
  const SessionTabBarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.pf16,
            vertical: AppPadding.pf12,
          ),
          child: BlocSelector<SessionCubit, SessionState, int>(
            selector: (state) {
              return state.currentTapIndex;
            },
            builder: (context, currentTapIndex) {
              final cubit = SessionCubit.get(context);
              return CustomTapBar(
                isScrollable: false,
                tabAlignment: TabAlignment.fill,
                initialIndex: currentTapIndex,
                tapsTitle: [LocaleKeys.createSession, LocaleKeys.sessions],
                onTap: (index) {
                cubit.changeCurrentTapIndex(index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
