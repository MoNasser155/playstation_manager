import 'package:equatable/equatable.dart';

import '../../../../../core/enums/device_status.dart';
import '../../../../../core/enums/device_type.dart';
import '../../../../../core/enums/state_status.dart';

class AddDeviceState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final DeviceType deviceType;
  final DeviceStatus deviceStatus;

  const AddDeviceState({
    required this.status,
    this.errMessage,
    required this.deviceType,
    required this.deviceStatus,
  });

  AddDeviceState copyWith({
    StateStatus? status,
    String? errMessage,
    DeviceType? deviceType,
    DeviceStatus? deviceStatus,
  }) {
    return AddDeviceState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      deviceType: deviceType ?? this.deviceType,
      deviceStatus: deviceStatus ?? this.deviceStatus,
    );
  }

  factory AddDeviceState.initial() => const AddDeviceState(
        status: StateStatus.initial,
        deviceType: DeviceType.ps4,
        deviceStatus: DeviceStatus.available,
      );

  @override
  List<Object?> get props => [status, errMessage, deviceType, deviceStatus];
}
