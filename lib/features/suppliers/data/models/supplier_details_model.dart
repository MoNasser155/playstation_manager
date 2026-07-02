import 'supplier_model.dart';

class SupplierDetailsModel {
  final SupplierModel supplier;

  SupplierDetailsModel({required this.supplier});

  factory SupplierDetailsModel.initial() =>
      SupplierDetailsModel(supplier: SupplierModel.initial());
}
