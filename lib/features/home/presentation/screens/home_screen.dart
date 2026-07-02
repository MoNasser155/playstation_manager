import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../widgets/desktop/desktop_home_body.dart';
import '../widgets/mobile/mobile_home_body.dart';
import '../widgets/tablet/tablet_home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.toString()),
      body: BlocBuilder<MainViewCubit, MainViewState>(
        buildWhen: (previous, current) {
          return previous.mode != current.mode;
        },
        builder: (context, state) {
          switch (state.mode) {
            case MainViewMode.mobile:
              return MobileHomeBody();
            case MainViewMode.tablet:
              return TabletHomeBody();
            case MainViewMode.desktop:
              return DesktopHomeBody();
          }
        },
      ),
    );
  }
}
