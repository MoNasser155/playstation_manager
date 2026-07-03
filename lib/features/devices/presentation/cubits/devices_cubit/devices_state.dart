import 'package:equatable/equatable.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../data/models/device_model.dart';

class DevicesState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final List<DeviceModel> devices;
  final List<DeviceModel> filteredDevices;
  final Map<String, DateTime> activeSessionStartDates; // uuid -> startDate

  const DevicesState({
    required this.status,
    this.errMessage,
    required this.devices,
    required this.filteredDevices,
    required this.activeSessionStartDates,
  });

  DevicesState copyWith({
    StateStatus? status,
    String? errMessage,
    List<DeviceModel>? devices,
    List<DeviceModel>? filteredDevices,
    Map<String, DateTime>? activeSessionStartDates,
  }) {
    return DevicesState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      devices: devices ?? this.devices,
      filteredDevices: filteredDevices ?? this.filteredDevices,
      activeSessionStartDates: activeSessionStartDates ?? this.activeSessionStartDates,
    );
  }

  factory DevicesState.initial() {
    return const DevicesState(
      status: StateStatus.initial,
      devices: [],
      filteredDevices: [],
      activeSessionStartDates: {},
    );
  }

  @override
  List<Object?> get props => [status, errMessage, devices, filteredDevices, activeSessionStartDates];
}
