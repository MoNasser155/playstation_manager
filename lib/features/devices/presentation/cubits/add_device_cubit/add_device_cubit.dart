import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/enums/device_status.dart';
import '../../../../../core/enums/device_type.dart';
import '../../../../../core/enums/state_status.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../data/models/device_model.dart';
import '../../../domain/usecases/add_device_usecase.dart';
import '../../../domain/usecases/update_device_usecase.dart';
import 'add_device_state.dart';

class AddDeviceCubit extends BaseCubit<AddDeviceState> {
  AddDeviceCubit() : super(AddDeviceState.initial());

  static AddDeviceCubit get(context) => BlocProvider.of<AddDeviceCubit>(context);

  final _addDeviceUseCase = sl<AddDeviceUseCase>();
  final _updateDeviceUseCase = sl<UpdateDeviceUseCase>();

  final nameController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final multiPlayerHourlyRateController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setInitialValues(DeviceModel? device) {
    if (device != null) {
      nameController.text = device.name;
      hourlyRateController.text = device.hourlyRate.toString();
      multiPlayerHourlyRateController.text = device.multiPlayerHourlyRate.toString();
      safeEmit(state.copyWith(
        deviceType: device.type,
        deviceStatus: device.status,
      ));
    }
  }

  void changeDeviceType(DeviceType type) {
    safeEmit(state.copyWith(deviceType: type));
  }

  void changeDeviceStatus(DeviceStatus status) {
    safeEmit(state.copyWith(deviceStatus: status));
  }

  Future<void> submit({DeviceModel? existingDevice}) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final double hourlyRate = double.tryParse(hourlyRateController.text) ?? 0.0;
    final double multiPlayerHourlyRate = double.tryParse(multiPlayerHourlyRateController.text) ?? 0.0;

    safeEmit(state.copyWith(status: StateStatus.loading));

    if (existingDevice != null) {
      // Edit mode
      final updatedDevice = DeviceModel(
        id: existingDevice.id,
        uuid: existingDevice.uuid,
        name: nameController.text.trim(),
        hourlyRate: hourlyRate,
        multiPlayerHourlyRate: multiPlayerHourlyRate,
        typeIndex: state.deviceType.index,
        statusIndex: state.deviceStatus.index,
      );

      final result = await _updateDeviceUseCase(updatedDevice);
      result.fold(
        (failure) {
          safeEmit(state.copyWith(status: StateStatus.failure, errMessage: failure.message));
        },
        (r) {
          safeEmit(state.copyWith(status: StateStatus.success));
          AppNavigator.pop(result: true);
        },
      );
    } else {
      // Add mode
      final newDevice = DeviceModel.create(
        uuid: const Uuid().v4(),
        name: nameController.text.trim(),
        hourlyRate: hourlyRate,
        multiPlayerHourlyRate: multiPlayerHourlyRate,
        type: state.deviceType,
        status: state.deviceStatus,
      );

      final result = await _addDeviceUseCase(newDevice);
      result.fold(
        (failure) {
          safeEmit(state.copyWith(status: StateStatus.failure, errMessage: failure.message));
        },
        (r) {
          safeEmit(state.copyWith(status: StateStatus.success));
          AppNavigator.pop(result: true);
        },
      );
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    hourlyRateController.dispose();
    multiPlayerHourlyRateController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
