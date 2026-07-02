import 'package:objectbox/objectbox.dart';

import '../../../../core/enums/transaction_type.dart';
import '../../../../core/enums/user_type.dart';

@Entity()
class TransactionModel {
  @Id(assignable: true)
  int? id;
  @Unique()
  final String uuid;
  final String userUuid;
  final String? userName;
  final double? beginningBalance;
  final double paymentAmount;
  final double? paidInvoiceAmount;
  final double? endBalance;
  final double? invoiceProfit;
  @Property(type: PropertyType.date)
  final DateTime createdAt;
  final String? notes;
  final String? storageItemUuid;

  final int transactionType;
  final int userType;

  @Transient()
  TransactionType get transactionTypeVal =>
      TransactionType.values[transactionType];

  @Transient()
  UserType get userTypeVal => UserType.values[userType];

  TransactionModel({
    this.id,
    required this.uuid,
    required this.userUuid,
    this.userName,
    this.beginningBalance,
    required this.paymentAmount,
    this.paidInvoiceAmount,
    this.endBalance,
    this.invoiceProfit,
    required this.transactionType,
    required this.userType,
    required this.createdAt,
    this.notes,
    this.storageItemUuid,
  });

  factory TransactionModel.create({
    int? id,
    required String uuid,
    required String userUuid,
    String? userName,
    double? beginningBalance,
    required double paymentAmount,
    double? paidInvoiceAmount,
    double? endBalance,
    double? invoiceProfit,
    required TransactionType transactionType,
    required UserType userType,
    required DateTime createdAt,
    String? notes,
    String? storageItemUuid,
  }) {
    return TransactionModel(
      id: id,
      uuid: uuid,
      userUuid: userUuid,
      userName: userName,
      beginningBalance: beginningBalance,
      paymentAmount: paymentAmount,
      paidInvoiceAmount: paidInvoiceAmount,
      endBalance: endBalance,
      invoiceProfit: invoiceProfit,
      transactionType: transactionType.index,
      userType: userType.index,
      createdAt: createdAt,
      notes: notes,
      storageItemUuid: storageItemUuid,
    );
  }

  factory TransactionModel.initial() => TransactionModel(
    uuid: '',
    userUuid: '',
    userName: '',
    beginningBalance: 0,
    paymentAmount: 0,
    paidInvoiceAmount: 0,
    endBalance: 0,
    invoiceProfit: 0,
    transactionType: TransactionType.invoiceProfit.index,
    userType: UserType.customer.index,
    createdAt: DateTime.now(),
    notes: '',
    storageItemUuid: '',
  );
}
