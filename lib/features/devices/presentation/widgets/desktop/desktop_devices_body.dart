import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_skeletonizer.dart';
import '../../cubits/devices_cubit/devices_cubit.dart';
import '../../cubits/devices_cubit/devices_state.dart';
import '../custom_devices_body_appbar.dart';
import '../devices_grid.dart';

class DesktopDevicesBody extends StatelessWidget {
  const DesktopDevicesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevicesCubit, DevicesState, StateStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, status) {
        return CustomSkeletonizer(
          enabled: status.isLoading,
          child: CustomScrollView(
            slivers: [
              const CustomDevicesBodyAppbar(),
              sliverGapH(16),
              const DevicesGrid(),
              sliverGapH(20),
            ],
          ),
        );
      },
    );
  }
}
