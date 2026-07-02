import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/enums/storage_item_type.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../../data/models/storage_details_model.dart';
import '../../../data/models/storage_model.dart';
import '../../../domain/usecases/delete_storage_item_usecase.dart';
import '../../../domain/usecases/get_storage_item_by_uuid_usecase.dart';
import '../../../domain/usecases/update_storage_item_usecase.dart';

part 'storage_item_details_state.dart';

class StorageItemDetailsCubit extends BaseCubit<StorageItemDetailsState> {
  StorageItemDetailsCubit() : super(StorageItemDetailsState.initial());

  static StorageItemDetailsCubit get(context) => BlocProvider.of(context);

  final _getStorageItemByUuidUsecase = sl<GetStorageItemByUuidUseCase>();
  final _deleteStorageItemUseCase = sl<DeleteStorageItemUseCase>();
  final _updateStorageItemUseCase = sl<UpdateStorageItemUseCase>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController buyPriceController = TextEditingController();
  final TextEditingController sellPriceController = TextEditingController();
  final TextEditingController minAmountController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setControllers() {
    nameController.text = state.item.item.itemName;
    quantityController.text = state.item.item.quantity.toStringAsFixed(2);
    buyPriceController.text = state.item.item.buyPrice.toStringAsFixed(2);
    sellPriceController.text = state.item.item.sellPrice.toStringAsFixed(2);
    minAmountController.text = state.item.item.minAmount.toStringAsFixed(2);
    safeEmit(
      state.copyWith(
        updatedUnit: state.item.item.type,
        updatedImage:
            state.item.item.itemImage.isEmpty
                ? null
                : state.item.item.itemImage,
      ),
    );
  }

  void init(String storageItemUuid) {
    safeEmit(
      state.copyWith(status: StateStatus.loading, itemUuid: storageItemUuid),
    );
    _getStorageItemDetails(storageItemUuid);
  }

  Future<void> _getStorageItemDetails(String storageItemUuid) async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getStorageItemByUuidUsecase(storageItemUuid);
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (item) {
        safeEmit(state.copyWith(status: StateStatus.success, item: item));
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
        final cubit = MainViewCubit.get(context);
        cubit.clearCustomizedView();
      },
    );
  }

  StorageModel _getStorageModel(String itemImage) {
    final updatedItem = state.item.item.copyWith(
      itemName: nameController.text,
      quantity: double.tryParse(quantityController.text) ?? 0.0,
      buyPrice: double.tryParse(buyPriceController.text) ?? 0.0,
      sellPrice: double.tryParse(sellPriceController.text) ?? 0.0,
      minAmount: double.tryParse(minAmountController.text) ?? 0.0,
      itemImage: itemImage,
      type: state.updatedUnit,
    );
    return updatedItem;
  }

  void setSelectedUnit(StorageItemType? unit) {
    safeEmit(state.copyWith(updatedUnit: unit));
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final String filePath = result.files.single.path!;
        safeEmit(state.copyWith(updatedImage: filePath));
        return;
      }
    } catch (e) {
      safeEmit(
        state.copyWith(status: StateStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateStorageItem(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    safeEmit(state.copyWith(status: StateStatus.loading));

    String finalImagePath = state.updatedImage ?? '';
    try {
      final oldPath = state.item.item.itemImage;
      final oldName = state.item.item.itemName;
      final newName = nameController.text;

      // Case 1: Name changed
      if (newName != oldName) {
        // Did they pick a new image or are they using the old one?
        if (state.updatedImage != null && state.updatedImage != oldPath && state.updatedImage!.isNotEmpty) {
          // They picked a new image and changed the name.
          // Copy new image to target with new name, and delete the old file if exists.
          final appDir = await getApplicationDocumentsDirectory();
          final directory = Directory('${appDir.path}/StorageItem_images');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          final extension = path.extension(state.updatedImage!);
          final sanitizedNewName = newName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
          final targetFileName = '$sanitizedNewName$extension';
          final savedImagePath = path.join(directory.path, targetFileName);
          final normalizedPath = savedImagePath.replaceAll('\\', '/');

          if (state.updatedImage != normalizedPath) {
            final imageFile = File(state.updatedImage!);
            if (await imageFile.exists()) {
              await imageFile.copy(normalizedPath);
            }
          }
          finalImagePath = normalizedPath;

          // Delete old image file
          if (oldPath.isNotEmpty) {
            final oldFile = File(oldPath);
            if (await oldFile.exists()) {
              await oldFile.delete();
            }
          }
        } else if (oldPath.isNotEmpty) {
          // They did not pick a new image, but the name changed.
          // We rename the old image file to the new name.
          final oldFile = File(oldPath);
          if (await oldFile.exists()) {
            final extension = path.extension(oldPath);
            final sanitizedNewName = newName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
            final appDir = await getApplicationDocumentsDirectory();
            final targetFileName = '$sanitizedNewName$extension';
            final newPath = path.join(appDir.path, 'StorageItem_images', targetFileName).replaceAll('\\', '/');
            if (oldFile.path != newPath) {
              await oldFile.rename(newPath);
            }
            finalImagePath = newPath;
          }
        }
      } else {
        // Name did not change. Did they pick a new image?
        if (state.updatedImage != null && state.updatedImage != oldPath && state.updatedImage!.isNotEmpty) {
          // Copy new image to target with the current name, and delete old one if different.
          final appDir = await getApplicationDocumentsDirectory();
          final directory = Directory('${appDir.path}/StorageItem_images');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          final extension = path.extension(state.updatedImage!);
          final sanitizedName = newName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
          final targetFileName = '$sanitizedName$extension';
          final savedImagePath = path.join(directory.path, targetFileName);
          final normalizedPath = savedImagePath.replaceAll('\\', '/');

          if (state.updatedImage != normalizedPath) {
            final imageFile = File(state.updatedImage!);
            if (await imageFile.exists()) {
              await imageFile.copy(normalizedPath);
            }
          }
          finalImagePath = normalizedPath;

          // Delete old image file if it's different from the new path
          if (oldPath.isNotEmpty && oldPath != normalizedPath) {
            final oldFile = File(oldPath);
            if (await oldFile.exists()) {
              await oldFile.delete();
            }
          }
        }
      }
    } catch (e) {
      // ignore
    }

    final result = await _updateStorageItemUseCase(_getStorageModel(finalImagePath));

    result.fold(
      (l) {
        safeEmit(state.copyWith(status: StateStatus.failure));
        CustomSnackBar.top(
          context: context,
          msg: l.message,
          color: AppColors.errorColor,
        );
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success));
        CustomSnackBar.top(
          context: context,
          msg: LocaleKeys.updatedSuccessfully,
          color: AppColors.successColor,
        );
        refresh();
        AppNavigator.pop();
      },
    );
  }

  void refresh() {
    safeEmit(state.copyWith(status: StateStatus.loading));
    _getStorageItemDetails(state.itemUuid);
  }

  @override
  Future<void> close() {
    nameController.dispose();
    quantityController.dispose();
    buyPriceController.dispose();
    sellPriceController.dispose();
    minAmountController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
