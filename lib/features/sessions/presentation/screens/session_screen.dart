import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../../core/shared/di.dart';
import '../../../devices/data/models/device_model.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../cubits/cubit/session_cubit.dart';
import '../widgets/desktop/desktop_session_body.dart';
import '../widgets/mobile/mobile_session_body.dart';
import '../widgets/tablet/tablet_session_body.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key, this.device});
  final DeviceModel? device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.toString()),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<SessionCubit>()..init(context, device: device),
          child: BlocBuilder<MainViewCubit, MainViewState>(
            buildWhen: (previous, current) => previous.mode != current.mode,
            builder: (context, state) {
              switch (state.mode) {
                case MainViewMode.mobile:
                  return const MobileSessionBody();
                case MainViewMode.tablet:
                  return const TabletSessionBody();
                case MainViewMode.desktop:
                  return const DesktopSessionBody();
              }
            },
          ),
        ),
      ),
    );
  }
}
