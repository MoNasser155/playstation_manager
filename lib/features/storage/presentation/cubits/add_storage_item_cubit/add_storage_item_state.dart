part of 'add_storage_item_cubit.dart';

class AddStorageItemState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final List<SupplierModel> suppliers;
  final SupplierModel? selectedSupplier;
  final StorageItemType? selectedUnit;
  final String? itemImagePath;
  final int selectedTabIndex;
  final List<StorageModel> storageItems;
  final StorageModel? selectedStorageItem;

  /// True when the supplier was pre-set from an external screen (e.g. supplier
  /// details) and should not be editable by the user.
  final bool supplierLocked;
  /// True when the item was pre-set from an external screen (e.g. item
  /// details) and should not be editable by the user.
  final bool itemLocked;

  const AddStorageItemState({
    required this.status,
    this.errMessage,
    required this.suppliers,
    this.selectedSupplier,
    this.selectedUnit,
    this.itemImagePath,
    required this.selectedTabIndex,
    required this.storageItems,
    this.selectedStorageItem,
    this.supplierLocked = false,
    this.itemLocked = false,
  });
  factory AddStorageItemState.initial() {
    return AddStorageItemState(
      status: StateStatus.initial,
      errMessage: null,
      suppliers: [],
      selectedSupplier: null,
      selectedUnit: null,
      itemImagePath: null,
      selectedTabIndex: 0,
      storageItems: [],
      selectedStorageItem: null,
      supplierLocked: false,
      itemLocked: false,
    );
  }
  AddStorageItemState copyWith({
    StateStatus? status,
    String? errMessage,
    List<SupplierModel>? suppliers,
    SupplierModel? selectedSupplier,
    StorageItemType? selectedUnit,
    String? itemImagePath,
    int? selectedTabIndex,
    List<StorageModel>? storageItems,
    StorageModel? selectedStorageItem,
    bool? supplierLocked,
    bool? itemLocked,
  }) {
    return AddStorageItemState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      suppliers: suppliers ?? this.suppliers,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      itemImagePath: itemImagePath ?? this.itemImagePath,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      storageItems: storageItems ?? this.storageItems,
      selectedStorageItem: selectedStorageItem ?? this.selectedStorageItem,
      supplierLocked: supplierLocked ?? this.supplierLocked,
      itemLocked: itemLocked ?? this.itemLocked,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errMessage,
    suppliers,
    selectedSupplier,
    selectedUnit,
    itemImagePath,
    selectedTabIndex,
    storageItems,
    selectedStorageItem,
    supplierLocked,
    itemLocked,
  ];
}
