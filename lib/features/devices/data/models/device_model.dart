import 'package:objectbox/objectbox.dart';

import '../../../../core/enums/device_status.dart';
import '../../../../core/enums/device_type.dart';

@Entity()
class DeviceModel {
  @Id()
  int? id;
  @Unique()
  final String uuid;
  final String name;
  final double hourlyRate;
  int typeIndex;
  int statusIndex;

  @Transient()
  DeviceType get type => DeviceType.values[typeIndex];
  set type(DeviceType val) => typeIndex = val.index;

  @Transient()
  DeviceStatus get status => DeviceStatus.values[statusIndex];
  set status(DeviceStatus val) => statusIndex = val.index;

  DeviceModel({
    this.id,
    required this.uuid,
    required this.name,
    required this.hourlyRate,
    required this.typeIndex,
    required this.statusIndex,
  });

  factory DeviceModel.create({
    int? id,
    required String uuid,
    required String name,
    required double hourlyRate,
    required DeviceType type,
    required DeviceStatus status,
  }) {
    return DeviceModel(
      id: id,
      uuid: uuid,
      name: name,
      hourlyRate: hourlyRate,
      typeIndex: type.index,
      statusIndex: status.index,
    );
  }

  DeviceModel copyWith({
    String? name,
    double? hourlyRate,
    DeviceType? type,
    DeviceStatus? status,
  }) {
    return DeviceModel(
      id: id,
      uuid: uuid,
      name: name ?? this.name,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      typeIndex: type?.index ?? typeIndex,
      statusIndex: status?.index ?? statusIndex,
    );
  }

  factory DeviceModel.initial() => DeviceModel(
    uuid: '',
    name: '',
    hourlyRate: 0.0,
    typeIndex: DeviceType.ps4.index,
    statusIndex: DeviceStatus.available.index,
  );
}
