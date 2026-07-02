import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/theme/app_colors.dart';

@Entity()
class SupplierModel {
  @Id()
  int? id;
  @Unique()
  final String uuid;
  final String name;
  final String phone1;
  final String? phone2;
  final String? address;

  /// Money the customer owes you فلوس ليا عند المورد
  final double receivableAmount;

  /// Money you owe the customer فلوس عليا للمورد
  final double payableAmount;

  SupplierModel({
    this.id,
    required this.uuid,
    required this.name,
    required this.phone1,
    this.phone2,
    this.address,
    required this.receivableAmount,
    required this.payableAmount,
  });

  double get netAmount => receivableAmount - payableAmount;

  Color get color =>
      netAmount > 0 ? AppColors.errorColor : AppColors.successColor;

  String get simpledAmount =>
      netAmount < 0
          ? '${LocaleKeys.toPay}  $netAmount'
          : '${LocaleKeys.toRecieve}  $netAmount';

  SupplierModel copyWith({
    String? name,
    String? phone1,
    String? phone2,
    String? address,
    double? receivableAmount,
    double? payableAmount,
  }) {
    return SupplierModel(
      id: id,
      uuid: uuid,
      name: name ?? this.name,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      address: address ?? this.address,
      receivableAmount: receivableAmount ?? this.receivableAmount,
      payableAmount: payableAmount ?? this.payableAmount,
    );
  }

  factory SupplierModel.initial() {
    return SupplierModel(
      uuid: '',
      name: '',
      phone1: '',
      phone2: '',
      address: '',
      receivableAmount: 0,
      payableAmount: 0,
    );
  }
}
