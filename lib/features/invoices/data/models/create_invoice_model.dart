import 'package:objectbox/objectbox.dart';

import '../../../../core/enums/payment_type.dart';
import '../../../customers/data/models/customer_model.dart';
import '../../../devices/data/models/device_model.dart';
import '../../../storage/data/models/storage_model.dart';

@Entity()
class CreateInvoiceModel {
  @Id(assignable: true)
  int? id;
  @Unique()
  final String uuid;
  final double totalInvoice;
  final double cashPaid;
  final double laterPaid;
  @Property(type: PropertyType.date)
  final DateTime invoiceDate;
  final int paymentIndex;
  final bool isSession;
  @Property(type: PropertyType.date)
  final DateTime? sessionStartDate;
  final double hourlyRate;

  @Transient()
  PaymentType get paymentType => PaymentType.values[paymentIndex];

  final customer = ToOne<CustomerModel>();
  final device = ToOne<DeviceModel>();
  final items = ToMany<ItemsInvoice>();

  CreateInvoiceModel({
    this.id,
    required this.uuid,
    required this.totalInvoice,
    required this.cashPaid,
    required this.laterPaid,
    required this.invoiceDate,
    required this.paymentIndex,
    this.isSession = false,
    this.sessionStartDate,
    this.hourlyRate = 0.0,
  });

  factory CreateInvoiceModel.create({
    int? id,
    required String uuid,
    required double totalInvoice,
    required double cashPaid,
    required double laterPaid,
    required DateTime invoiceDate,
    required PaymentType paymentType,
    bool isSession = false,
    DateTime? sessionStartDate,
    double hourlyRate = 0.0,
  }) {
    return CreateInvoiceModel(
      id: id,
      uuid: uuid,
      totalInvoice: totalInvoice,
      cashPaid: cashPaid,
      laterPaid: laterPaid,
      invoiceDate: invoiceDate,
      paymentIndex: paymentType.index,
      isSession: isSession,
      sessionStartDate: sessionStartDate,
      hourlyRate: hourlyRate,
    );
  }

  factory CreateInvoiceModel.initial() => CreateInvoiceModel(
    uuid: '',
    totalInvoice: 0,
    cashPaid: 0,
    laterPaid: 0,
    invoiceDate: DateTime.now(),
    paymentIndex: PaymentType.cash.index,
    isSession: false,
    sessionStartDate: null,
    hourlyRate: 0.0,
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
