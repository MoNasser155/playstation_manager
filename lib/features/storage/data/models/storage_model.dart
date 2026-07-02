import 'package:objectbox/objectbox.dart';

import '../../../../core/enums/storage_item_type.dart';
import '../../../suppliers/data/models/supplier_model.dart';

@Entity()
class StorageModel {
  @Id(assignable: true)
  int? id;
  @Unique()
  final String uuid;
  final String itemName;
  final String itemImage;
  final double quantity;
  final double buyPrice;
  final double sellPrice;
  final double minAmount;
  final double paidAmount;
  int typeIndex;

  @Transient()
  StorageItemType get type => StorageItemType.values[typeIndex];

  final supplier = ToOne<SupplierModel>();

  StorageModel({
    this.id,
    required this.uuid,
    required this.itemName,
    required this.itemImage,
    required this.typeIndex,
    required this.quantity,
    required this.buyPrice,
    required this.sellPrice,
    required this.minAmount,
    required this.paidAmount,
  });

  bool get isLow => quantity <= minAmount;

  factory StorageModel.create({
    int? id,
    required String uuid,
    required String itemName,
    required String itemImage,
    required StorageItemType type,
    required double quantity,
    required double buyPrice,
    required double sellPrice,
    required double minAmount,
    required double paidAmount,
  }) {
    return StorageModel(
      id: id,
      uuid: uuid,
      itemName: itemName,
      itemImage: itemImage,
      typeIndex: type.index,
      quantity: quantity,
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      minAmount: minAmount,
      paidAmount: paidAmount,
    );
  }

  StorageModel copyWith({
    String? itemName,
    String? itemImage,
    StorageItemType? type,
    double? quantity,
    double? buyPrice,
    double? sellPrice,
    SupplierModel? supplier,
    double? minAmount,
    double? paidAmount,
  }) {
    final copy = StorageModel(
      id: id,
      uuid: uuid,
      itemName: itemName ?? this.itemName,
      itemImage: itemImage ?? this.itemImage,
      typeIndex: type?.index ?? typeIndex,
      quantity: quantity ?? this.quantity,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      minAmount: minAmount ?? this.minAmount,
      paidAmount: paidAmount ?? this.paidAmount,
    );
    copy.supplier.target = supplier ?? this.supplier.target;
    return copy;
  }

  factory StorageModel.initial() => StorageModel(
    uuid: '',
    itemName: '',
    itemImage: '',
    typeIndex: StorageItemType.unit.index,
    quantity: 0,
    buyPrice: 0,
    sellPrice: 0,
    minAmount: 0,
    paidAmount: 0,
  );
}
