part of 'storage_item_details_cubit.dart';

class StorageItemDetailsState extends Equatable {
  final StateStatus status;
  final String? errorMessage;
  final StorageDetailsModel item;
  final String itemUuid;
  final String? updatedImage;
  final StorageItemType? updatedUnit;

  const StorageItemDetailsState({
    required this.status,
    this.errorMessage,
    required this.item,
    required this.itemUuid,
    this.updatedImage,
    this.updatedUnit,
  });

  factory StorageItemDetailsState.initial() {
    return StorageItemDetailsState(
      status: StateStatus.initial,
      errorMessage: null,
      item: StorageDetailsModel.initial(),
      itemUuid: '',
      updatedImage: null,
      updatedUnit: null,
    );
  }

  StorageItemDetailsState copyWith({
    StateStatus? status,
    String? errorMessage,
    StorageDetailsModel? item,
    String? itemUuid,
    String? updatedImage,
    StorageItemType? updatedUnit,
  }) {
    return StorageItemDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      item: item ?? this.item,
      itemUuid: itemUuid ?? this.itemUuid,
      updatedImage: updatedImage ?? this.updatedImage,
      updatedUnit: updatedUnit ?? this.updatedUnit,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    item,
    itemUuid,
    updatedImage,
    updatedUnit,
  ];
}
