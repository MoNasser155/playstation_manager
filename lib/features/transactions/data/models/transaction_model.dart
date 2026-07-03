import 'package:objectbox/objectbox.dart';

import '../../../../core/enums/transaction_type.dart';
import '../../../../core/enums/user_type.dart';

@Entity()
class TransactionModel {
  @Id(assignable: true)
  int? id;
  @Unique()
  final String uuid;
  final double? sessionProfit;
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
    this.sessionProfit,
    required this.transactionType,
    required this.userType,
    required this.createdAt,
    this.notes,
    this.storageItemUuid,
  });

  factory TransactionModel.create({
    int? id,
    required String uuid,
    double? sessionProfit,
    required TransactionType transactionType,
    required UserType userType,
    required DateTime createdAt,
    String? notes,
    String? storageItemUuid,
  }) {
    return TransactionModel(
      id: id,
      uuid: uuid,
      sessionProfit: sessionProfit,
      transactionType: transactionType.index,
      userType: userType.index,
      createdAt: createdAt,
      notes: notes,
      storageItemUuid: storageItemUuid,
    );
  }

  factory TransactionModel.initial() => TransactionModel(
    uuid: '',
    sessionProfit: 0,
    transactionType: TransactionType.sessionProfit.index,
    userType: UserType.customer.index,
    createdAt: DateTime.now(),
    notes: '',
    storageItemUuid: '',
  );
}
