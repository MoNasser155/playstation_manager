import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../data/models/storage_model.dart';
import '../../../domain/usecases/delete_storage_item_usecase.dart';
import '../../../domain/usecases/get_all_storage_items_usecase.dart';
import '../../../domain/usecases/update_storage_item_usecase.dart';

part 'storage_state.dart';

class StorageCubit extends BaseCubit<StorageState> {
  StorageCubit() : super(StorageState.initial());

  static StorageCubit get(context) => BlocProvider.of(context);

  final _getAllStorageItemsUseCase = sl<GetAllStorageItemsUseCase>();
  final _deleteStorageItemUseCase = sl<DeleteStorageItemUseCase>();
  final _updateStorageItemUseCase = sl<UpdateStorageItemUseCase>();

  final searchController = TextEditingController();

  void init() {
    safeEmit(state.copyWith(status: StateStatus.loading));
    _getAllStorageItems();
  }

  Future<void> _getAllStorageItems() async {
    safeEmit(state.copyWith(status: StateStatus.loading));

    final result = await _getAllStorageItemsUseCase();

    result.fold(
      (l) {
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success, storageItems: r));
      },
    );
  }

  Future<void> deleteStorageItem(String uuid, BuildContext context) async {
    safeEmit(state.copyWith(status: StateStatus.loading));

    final result = await _deleteStorageItemUseCase(uuid);

    result.fold(
      (failure) {
        safeEmit(state.copyWith(status: StateStatus.failure));
        CustomSnackBar.top(context: context, msg: failure.message);
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success));
        _getAllStorageItems();
        AppNavigator.pop(result: true);
      },
    );
  }

  Future<void> updateStorageItem(StorageModel storageItem) async {
    safeEmit(state.copyWith(status: StateStatus.loading));

    final result = await _updateStorageItemUseCase(storageItem);

    result.fold(
      (l) {
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success));
      },
    );
  }

  void refresh() {
    _getAllStorageItems();
  }

  void searchOnStorageItems() {
    if (searchController.text.isEmpty) {
      safeEmit(state.copyWith(filteredStorageItems: []));
    } else {
      final filteredStorageItems =
          state.storageItems
              .where(
                (item) => item.itemName.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();
      safeEmit(state.copyWith(filteredStorageItems: filteredStorageItems));
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
