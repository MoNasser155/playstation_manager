import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../sessions/domain/usecases/get_active_sessions_usecase.dart';
import '../../../domain/usecases/delete_device_usecase.dart';
import '../../../domain/usecases/get_all_devices_usecase.dart';
import 'devices_state.dart';

class DevicesCubit extends BaseCubit<DevicesState> {
  DevicesCubit() : super(DevicesState.initial());

  static DevicesCubit get(context) => BlocProvider.of<DevicesCubit>(context);

  final _getAllDevicesUseCase = sl<GetAllDevicesUseCase>();
  final _deleteDeviceUseCase = sl<DeleteDeviceUseCase>();
  final _getActiveSessionsUseCase = sl<GetActiveSessionsUseCase>();

  final searchController = TextEditingController();

  void init() {
    safeEmit(state.copyWith(status: StateStatus.loading));
    getAllDevices();
  }

  Future<void> getAllDevices() async {
    safeEmit(state.copyWith(status: StateStatus.loading));

    final result = await _getAllDevicesUseCase();

    result.fold(
      (failure) {
        safeEmit(state.copyWith(status: StateStatus.failure, errMessage: failure.message));
      },
      (devicesList) async {
        final Map<String, DateTime> startDates = {};
        final sessionResult = await _getActiveSessionsUseCase();

        sessionResult.fold(
          (_) {},
          (activeSessions) {
            for (final inv in activeSessions) {
              final dev = inv.device.target;
              if (dev != null && inv.sessionStartDate != null) {
                startDates[dev.uuid] = inv.sessionStartDate!;
              }
            }
          },
        );

        safeEmit(state.copyWith(
          status: StateStatus.success,
          devices: devicesList,
          activeSessionStartDates: startDates,
        ));
        searchOnDevices();
      },
    );
  }

  Future<void> deleteDevice(String uuid, BuildContext context) async {
    safeEmit(state.copyWith(status: StateStatus.loading));

    final result = await _deleteDeviceUseCase(uuid);

    result.fold(
      (failure) {
        safeEmit(state.copyWith(status: StateStatus.failure));
        CustomSnackBar.top(context: context, msg: failure.message);
      },
      (success) {
        safeEmit(state.copyWith(status: StateStatus.success));
        getAllDevices();
        AppNavigator.pop(result: true);
      },
    );
  }

  void refresh() {
    getAllDevices();
  }

  void searchOnDevices() {
    if (searchController.text.isEmpty) {
      safeEmit(state.copyWith(filteredDevices: []));
    } else {
      final filtered = state.devices
          .where(
            (device) => device.name.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
          )
          .toList();
      safeEmit(state.copyWith(filteredDevices: filtered));
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
