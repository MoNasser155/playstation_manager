part of 'add_storage_item_cubit.dart';

class AddStorageItemState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final StorageItemType? selectedUnit;
  final String? itemImagePath;
  final int selectedTabIndex;
  final List<StorageModel> storageItems;
  final StorageModel? selectedStorageItem;

  /// True when the item was pre-set from an external screen (e.g. item
  /// details) and should not be editable by the user.
  final bool itemLocked;

  const AddStorageItemState({
    required this.status,
    this.errMessage,
    this.selectedUnit,
    this.itemImagePath,
    required this.selectedTabIndex,
    required this.storageItems,
    this.selectedStorageItem,
    this.itemLocked = false,
  });
  factory AddStorageItemState.initial() {
    return AddStorageItemState(
      status: StateStatus.initial,
      errMessage: null,
      selectedUnit: null,
      itemImagePath: null,
      selectedTabIndex: 0,
      storageItems: [],
      selectedStorageItem: null,
      itemLocked: false,
    );
  }
  AddStorageItemState copyWith({
    StateStatus? status,
    String? errMessage,
    StorageItemType? selectedUnit,
    String? itemImagePath,
    int? selectedTabIndex,
    List<StorageModel>? storageItems,
    StorageModel? selectedStorageItem,
    bool? itemLocked,
  }) {
    return AddStorageItemState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      itemImagePath: itemImagePath ?? this.itemImagePath,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      storageItems: storageItems ?? this.storageItems,
      selectedStorageItem: selectedStorageItem ?? this.selectedStorageItem,
      itemLocked: itemLocked ?? this.itemLocked,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errMessage,
    selectedUnit,
    itemImagePath,
    selectedTabIndex,
    storageItems,
    selectedStorageItem,
    itemLocked,
  ];
}
