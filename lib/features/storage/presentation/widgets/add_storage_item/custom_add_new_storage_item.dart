import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';
import 'package:playstation_manager/core/widgets/row_taps/custom_taps_row.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/enums/add_storage_item_enum.dart';
import '../../../../../core/enums/state_status.dart';
import '../../../../../core/enums/storage_item_type.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/utils/validations.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_dialog.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/expanded_drop_down.dart';
import '../../../data/models/storage_model.dart';
import '../../cubits/add_storage_item_cubit/add_storage_item_cubit.dart';

part 'action_buttons.dart';
part 'item_image_picker.dart';
part 'prices_fields.dart';
part 'quantity_and_unit_fields.dart';
part 'storage_item_dropdown.dart';

class AddStorageItemProvider extends StatelessWidget {
  const AddStorageItemProvider({super.key, this.item});
  final StorageModel? item;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddStorageItemCubit>()..init(item),
      child: CustomAddNewStorageItem(),
    );
  }
}

class CustomAddNewStorageItem extends StatelessWidget {
  const CustomAddNewStorageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AddStorageItemCubit,
      AddStorageItemState,
      (StateStatus, int)
    >(
      selector: (state) => (state.status, state.selectedTabIndex),
      builder: (context, state) {
        final cubit = AddStorageItemCubit.get(context);
        return Form(
          key: cubit.formKey,
          child: CustomDialog(
            children: [
              CustomTapsRow(
                selectedIndex: state.$2,
                itemsCount: AddStorageItemEnum.values.length,
                onTap: cubit.changeSelectedTab,
                itemsName: [
                  AddStorageItemEnum.newItem.localizedName,
                  AddStorageItemEnum.existingItem.localizedName,
                ],
              ),
              gapHFix(12),
              state.$2 == 0
                  ? _AddNewStorageItemFields()
                  : _UseExistingStorageItemFields(),
            ],
          ),
        );
      },
    );
  }
}

class _AddNewStorageItemFields extends StatelessWidget {
  const _AddNewStorageItemFields();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddStorageItemCubit, AddStorageItemState>(
      buildWhen: (previous, current) {
        return previous.selectedTabIndex != current.selectedTabIndex ||
            previous.status != current.status;
      },
      builder: (context, state) {
        final cubit = AddStorageItemCubit.get(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.addNewStorageItem,
              style: context.textTheme.headlineLarge,
            ),
            gapH(24),
            CustomTextField(
              hint: LocaleKeys.enterItemName,
              controller: cubit.nameController,
              prefix: Icon(Icons.inventory_2_outlined),
              validate: Validations.validateEmpty,
            ),
            gapH(12),

            gapH(20),
            _ItemImagePicker(cubit: cubit),
            gapH(20),
            _QuantityAndUnitFields(cubit: cubit),
            gapH(12),
            _PricesFields(cubit: cubit),
            gapH(12),
            CustomTextField(
              hint: LocaleKeys.minAmount,
              controller: cubit.minAmountController,
              prefix: Icon(Icons.storage_rounded),
              validate: Validations.validateEmpty,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            gapH(20),
            _ActionButtons(cubit: cubit, status: state.status),
          ],
        );
      },
    );
  }
}

class _UseExistingStorageItemFields extends StatelessWidget {
  const _UseExistingStorageItemFields();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddStorageItemCubit, AddStorageItemState>(
      builder: (context, state) {
        final cubit = AddStorageItemCubit.get(context);
        final itemSelected = state.selectedStorageItem != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.addToExistingItem,
              style: context.textTheme.headlineLarge,
            ),
            gapH(24),
            _StorageItemDropdown(cubit: cubit),
            gapH(12),

            gapH(12),
            _DisabledWrapper(
              isDisabled: !itemSelected,
              child: Column(
                children: [
                  _QuantityAndUnitFields(
                    cubit: cubit,
                    viewUnitSelection: false,
                  ),
                  gapH(12),
                  _PricesFields(cubit: cubit),
                ],
              ),
            ),
            gapH(20),
            _ActionButtons(cubit: cubit, status: state.status),
          ],
        );
      },
    );
  }
}

/// Wraps [child] in an [IgnorePointer] + [AnimatedOpacity] to visually
/// communicate that the section is not interactive yet.
class _DisabledWrapper extends StatelessWidget {
  const _DisabledWrapper({required this.isDisabled, required this.child});
  final bool isDisabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isDisabled ? 0.35 : 1.0,
      child: IgnorePointer(ignoring: isDisabled, child: child),
    );
  }
}
