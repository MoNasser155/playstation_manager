import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../../core/shared/di.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../cubits/devices_cubit/devices_cubit.dart';
import '../widgets/desktop/desktop_devices_body.dart';
import '../widgets/mobile/mobile_devices_body.dart';
import '../widgets/tablet/tablet_devices_body.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DevicesCubit>()..init(),
      child: Scaffold(
        key: ValueKey(context.locale.toString()),
        body: BlocBuilder<MainViewCubit, MainViewState>(
          buildWhen: (previous, current) {
            return previous.mode != current.mode;
          },
          builder: (context, state) {
            switch (state.mode) {
              case MainViewMode.mobile:
                return const MobileDevicesBody();
              case MainViewMode.tablet:
                return const TabletDevicesBody();
              case MainViewMode.desktop:
                return const DesktopDevicesBody();
            }
          },
        ),
      ),
    );
  }
}
