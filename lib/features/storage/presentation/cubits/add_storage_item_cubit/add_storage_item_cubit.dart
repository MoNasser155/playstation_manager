import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/enums/storage_item_type.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../data/models/storage_model.dart';
import '../../../domain/usecases/add_storage_item_usecase.dart';
import '../../../domain/usecases/get_all_storage_items_usecase.dart';

part 'add_storage_item_state.dart';

class AddStorageItemCubit extends BaseCubit<AddStorageItemState> {
  AddStorageItemCubit() : super(AddStorageItemState.initial());

  static AddStorageItemCubit get(context) =>
      BlocProvider.of<AddStorageItemCubit>(context);

  final _addStorageItemUseCase = sl<AddStorageItemUseCase>();
  final _getAllStorageItemsUseCase = sl<GetAllStorageItemsUseCase>();

  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final buyPriceController = TextEditingController();
  final sellPriceController = TextEditingController();
  final minAmountController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void init(StorageModel? item) {
    final isFromStorageDetails = item != null;
    safeEmit(
      state.copyWith(
        selectedStorageItem: item,
        itemLocked: isFromStorageDetails,
        selectedTabIndex: isFromStorageDetails ? 1 : 0,
      ),
    );
    if (isFromStorageDetails) {
      _getStorageItems();
    }
  }

  void changeSelectedTab(int index) {
    if (state.selectedTabIndex == index) return;
    clearControllers();
    if (index == 1) {
      safeEmit(
        state.copyWith(
          selectedTabIndex: index,
          storageItems: [],
          selectedStorageItem: null,
        ),
      );
      _getStorageItems();
    } else {
      safeEmit(
        state.copyWith(
          selectedTabIndex: index,
          storageItems: [],
          selectedStorageItem: null,
        ),
      );
    }
  }

  Future<void> _getStorageItems() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getAllStorageItemsUseCase.call();
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
      },
      (storageItems) {
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            storageItems: storageItems,
          ),
        );
      },
    );
  }

  void setSelectedStorageItem(StorageModel? storageItem) {
    safeEmit(state.copyWith(selectedStorageItem: storageItem));
  }

  Future pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final String filePath = result.files.single.path!;
        safeEmit(state.copyWith(itemImagePath: filePath));
        return;
      }
    } catch (e) {
      safeEmit(
        state.copyWith(status: StateStatus.failure, errMessage: e.toString()),
      );
    }
  }

  void setSelectedUnit(StorageItemType? unit) {
    safeEmit(state.copyWith(selectedUnit: unit));
  }

  StorageModel _getStorageModel(String itemImage) {
    final StorageModel model;
    if (state.selectedTabIndex == 1 && state.selectedStorageItem != null) {
      final existing = state.selectedStorageItem!;
      model = existing.copyWith(
        quantity: double.parse(quantityController.text),
        buyPrice: double.parse(buyPriceController.text),
        sellPrice: double.parse(sellPriceController.text),
      );
    } else {
      model = StorageModel.create(
        uuid: const Uuid().v4(),
        itemName: nameController.text,
        itemImage: itemImage,
        type: state.selectedUnit!,
        quantity: double.parse(quantityController.text),
        buyPrice: double.parse(buyPriceController.text),
        sellPrice: double.parse(sellPriceController.text),
        minAmount: double.parse(minAmountController.text),
        paidAmount: 0,
      );
    }

    return model;
  }

  Future<void> addStorageItem(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (state.selectedTabIndex == 0) {
      if (state.selectedUnit == null) {
        CustomSnackBar.top(context: context, msg: LocaleKeys.selectUnit);
        return;
      }
    } else {
      if (state.selectedStorageItem == null) {
        CustomSnackBar.top(context: context, msg: LocaleKeys.selectItem);
        return;
      }
    }

    safeEmit(state.copyWith(status: StateStatus.loading));

    String finalImagePath = '';
    if (state.selectedTabIndex == 0 &&
        state.itemImagePath != null &&
        state.itemImagePath!.isNotEmpty) {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final directory = Directory('${appDir.path}/StorageItem_images');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        final extension = path.extension(state.itemImagePath!);
        final sanitizedName = nameController.text.replaceAll(
          RegExp(r'[\\/:*?"<>|]'),
          '_',
        );
        final targetFileName = '$sanitizedName$extension';
        final savedImagePath = path.join(directory.path, targetFileName);
        final normalizedPath = savedImagePath.replaceAll('\\', '/');

        if (state.itemImagePath != normalizedPath) {
          final imageFile = File(state.itemImagePath!);
          if (await imageFile.exists()) {
            await imageFile.copy(normalizedPath);
          }
        }
        finalImagePath = normalizedPath;
      } catch (e) {
        // ignore or log
      }
    } else if (state.selectedTabIndex == 1 &&
        state.selectedStorageItem != null) {
      finalImagePath = state.selectedStorageItem!.itemImage;
    }

    final result = await _addStorageItemUseCase(
      _getStorageModel(finalImagePath),
    );
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
        CustomSnackBar.top(context: context, msg: failure.message);
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success));
        AppNavigator.pop(result: true);
      },
    );
  }

  void clearControllers() {
    nameController.clear();
    quantityController.clear();
    buyPriceController.clear();
    sellPriceController.clear();
    minAmountController.clear();
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
