import 'package:objectbox/objectbox.dart';

import '../../../../core/enums/play_type.dart';
import '../../../devices/data/models/device_model.dart';
import '../../../storage/data/models/storage_model.dart';

@Entity()
class SessionModel {
  @Id(assignable: true)
  int? id;
  @Unique()
  final String uuid;
  final double totalSession;
  @Property(type: PropertyType.date)
  final DateTime sessionDate;
  final bool isSession;
  @Property(type: PropertyType.date)
  final DateTime? sessionStartDate;
  final double hourlyRate;
  int playTypeIndex;

  @Transient()
  PlayType get playType => PlayType.values[playTypeIndex];
  set playType(PlayType val) => playTypeIndex = val.index;

  final device = ToOne<DeviceModel>();
  final items = ToMany<SessionItem>();

  SessionModel({
    this.id,
    required this.uuid,
    required this.totalSession,
    required this.sessionDate,
    this.isSession = false,
    this.sessionStartDate,
    this.hourlyRate = 0.0,
    this.playTypeIndex = 0,
  });

  factory SessionModel.create({
    int? id,
    required String uuid,
    required double totalSession,
    required DateTime sessionDate,
    bool isSession = false,
    DateTime? sessionStartDate,
    double hourlyRate = 0.0,
    PlayType playType = PlayType.twoPlayers,
  }) {
    return SessionModel(
      id: id,
      uuid: uuid,
      totalSession: totalSession,
      sessionDate: sessionDate,
      isSession: isSession,
      sessionStartDate: sessionStartDate,
      hourlyRate: hourlyRate,
      playTypeIndex: playType.index,
    );
  }

  factory SessionModel.initial() => SessionModel(
    uuid: '',
    totalSession: 0,
    sessionDate: DateTime.now(),
    isSession: false,
    sessionStartDate: null,
    hourlyRate: 0.0,
    playTypeIndex: 0,
  );
}

@Entity()
class SessionItem {
  @Id(assignable: true)
  int? id;

  final double sellPrice;
  final double quantity;
  final double totalItemPrice;

  final storageItem = ToOne<StorageModel>();

  SessionItem({
    this.id,
    required this.sellPrice,
    required this.quantity,
    required this.totalItemPrice,
  });
}
