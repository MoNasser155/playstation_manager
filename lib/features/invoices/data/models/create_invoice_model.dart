import 'package:objectbox/objectbox.dart';

import '../../../../core/enums/play_type.dart';
import '../../../devices/data/models/device_model.dart';
import '../../../storage/data/models/storage_model.dart';

@Entity()
class CreateInvoiceModel {
  @Id(assignable: true)
  int? id;
  @Unique()
  final String uuid;
  final double totalInvoice;
  @Property(type: PropertyType.date)
  final DateTime invoiceDate;
  final bool isSession;
  @Property(type: PropertyType.date)
  final DateTime? sessionStartDate;
  final double hourlyRate;
  int playTypeIndex;

  @Transient()
  PlayType get playType => PlayType.values[playTypeIndex];
  set playType(PlayType val) => playTypeIndex = val.index;

  final device = ToOne<DeviceModel>();
  final items = ToMany<ItemsInvoice>();

  CreateInvoiceModel({
    this.id,
    required this.uuid,
    required this.totalInvoice,
    required this.invoiceDate,
    this.isSession = false,
    this.sessionStartDate,
    this.hourlyRate = 0.0,
    this.playTypeIndex = 0,
  });

  factory CreateInvoiceModel.create({
    int? id,
    required String uuid,
    required double totalInvoice,
    required DateTime invoiceDate,
    bool isSession = false,
    DateTime? sessionStartDate,
    double hourlyRate = 0.0,
    PlayType playType = PlayType.twoPlayers,
  }) {
    return CreateInvoiceModel(
      id: id,
      uuid: uuid,
      totalInvoice: totalInvoice,
      invoiceDate: invoiceDate,
      isSession: isSession,
      sessionStartDate: sessionStartDate,
      hourlyRate: hourlyRate,
      playTypeIndex: playType.index,
    );
  }

  factory CreateInvoiceModel.initial() => CreateInvoiceModel(
    uuid: '',
    totalInvoice: 0,
    invoiceDate: DateTime.now(),
    isSession: false,
    sessionStartDate: null,
    hourlyRate: 0.0,
    playTypeIndex: 0,
  );
}

@Entity()
class ItemsInvoice {
  @Id(assignable: true)
  int? id;

  final double sellPrice;
  final double quantity;
  final double totalItemPrice;

  final storageItem = ToOne<StorageModel>();

  ItemsInvoice({
    this.id,
    required this.sellPrice,
    required this.quantity,
    required this.totalItemPrice,
  });
}
