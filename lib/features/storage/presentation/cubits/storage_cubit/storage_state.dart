part of 'storage_cubit.dart';

class StorageState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final List<StorageModel> storageItems;
  final List<StorageModel> filteredStorageItems;

  const StorageState({
    required this.status,
    this.errMessage,
    required this.storageItems,
    required this.filteredStorageItems,
  });

  StorageState copyWith({
    StateStatus? status,
    String? errMessage,
    List<StorageModel>? storageItems,
    List<StorageModel>? filteredStorageItems,
  }) {
    return StorageState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      storageItems: storageItems ?? this.storageItems,
      filteredStorageItems: filteredStorageItems ?? this.filteredStorageItems,
    );
  }

  factory StorageState.initial() {
    return StorageState(status: StateStatus.initial, storageItems: [], filteredStorageItems: []);
  }

  @override
  List<Object?> get props => [status, errMessage, storageItems, filteredStorageItems];
}
