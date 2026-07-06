import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/media_query_extenstions.dart';

import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/sliver_empty_body.dart';
import '../../data/models/device_model.dart';
import '../cubits/devices_cubit/devices_cubit.dart';
import '../cubits/devices_cubit/devices_state.dart';
import 'device_card.dart';

class DevicesGrid extends StatelessWidget {
  const DevicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<DevicesCubit, DevicesState>(
        buildWhen:
            (previous, current) =>
                current.devices != previous.devices ||
                previous.filteredDevices != current.filteredDevices ||
                current.status != previous.status,
        builder: (context, state) {
          final isApplyFilter =
              DevicesCubit.get(context).searchController.text.isNotEmpty;
          final length =
              state.status.isLoading
                  ? 8
                  : (isApplyFilter
                      ? state.filteredDevices.length
                      : state.devices.length);

          if (length == 0 && !state.status.isLoading) {
            return SliverEmptyBody(title: LocaleKeys.noDevices);
          }

          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  context.width > 1000
                      ? 5
                      : context.width > 800
                      ? 4
                      : context.width > 600
                      ? 3
                      : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final device =
                  state.status.isLoading
                      ? DeviceModel.initial()
                      : (isApplyFilter
                          ? state.filteredDevices[index]
                          : state.devices[index]);
              return DeviceCard(device: device);
            },
            itemCount: length,
          );
        },
      ),
    );
  }
}
