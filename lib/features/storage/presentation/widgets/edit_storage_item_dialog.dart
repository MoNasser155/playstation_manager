part of 'storage_details_info_header.dart';

class _EditStorageItemDialog extends StatelessWidget {
  const _EditStorageItemDialog({required this.cubit});

  final StorageItemDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageItemDetailsCubit, StorageItemDetailsState>(
      buildWhen: (previous, current) => previous.status != current.status,
      bloc: cubit,
      builder: (context, state) {
        return Form(
          key: cubit.formKey,
          child: CustomDialog(
            children: [
              Text(
                LocaleKeys.editStorageItem,
                style: context.textTheme.headlineLarge,
              ),
              gapH(24),
              CustomTextField(
                hint: LocaleKeys.enterItemName,
                controller: cubit.nameController,
                prefix: const Icon(Icons.inventory_2_outlined),
                validate: Validations.validateEmpty,
              ),
              gapH(20),
              _EditItemImagePicker(cubit: cubit),
              gapH(20),
              Row(
                spacing: AppSpacing.h8,
                children: [
                  Expanded(
                    child: CustomTextField(
                      hint: LocaleKeys.enterQuantity,
                      controller: cubit.quantityController,
                      prefix: const Icon(Icons.inventory_2_outlined),
                      validate: Validations.validateEmpty,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<
                      StorageItemDetailsCubit,
                      StorageItemDetailsState
                    >(
                      bloc: cubit,
                      buildWhen: (previous, current) {
                        return previous.updatedUnit != current.updatedUnit;
                      },
                      builder: (context, state) {
                        return ExpandedDropdown<StorageItemType>(
                          prefix: const Icon(Icons.balance_rounded),
                          hint: LocaleKeys.selectUnit,
                          items: StorageItemType.values,
                          selectedValue: state.updatedUnit?.localizedName,
                          itemLabelBuilder: (StorageItemType p1) {
                            return p1.localizedName;
                          },
                          onChanged: (value) {
                            cubit.setSelectedUnit(value);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              gapH(12),
              Row(
                spacing: AppSpacing.h8,
                children: [
                  Expanded(
                    child: CustomTextField(
                      hint: LocaleKeys.enterBuyPrice,
                      controller: cubit.buyPriceController,
                      prefix: const Icon(Icons.money),
                      validate: Validations.validateEmpty,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      hint: LocaleKeys.enterSellPrice,
                      controller: cubit.sellPriceController,
                      prefix: const Icon(Icons.money_sharp),
                      validate: Validations.validateEmpty,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gapH(12),
              CustomTextField(
                hint: LocaleKeys.minAmount,
                controller: cubit.minAmountController,
                prefix: const Icon(Icons.storage_rounded),
                validate: Validations.validateEmpty,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              gapH(20),
              Row(
                spacing: AppSpacing.h12,
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: context.mapCard,
                      borderColor: context.colorScheme.error,
                      textColor: context.colorScheme.onPrimary,
                      title: LocaleKeys.cancel,
                      onTap: () {
                        AppNavigator.pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      isLoading: state.status.isLoading,
                      title: LocaleKeys.save,
                      onTap: () {
                        cubit.updateStorageItem(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EditItemImagePicker extends StatelessWidget {
  const _EditItemImagePicker({required this.cubit});
  final StorageItemDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<StorageItemDetailsCubit, StorageItemDetailsState>(
          bloc: cubit,
          buildWhen: (previous, current) {
            return previous.updatedImage != current.updatedImage ||
                previous.item != current.item;
          },
          builder: (context, state) {
            final imageToShow = state.updatedImage ?? state.item.item.itemImage;
            return InkWell(
              onTap: () {
                cubit.pickImage();
              },
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 200,
                  minWidth: 200,
                  minHeight: 150,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(
                    color: context.colorScheme.secondaryFixed.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                child:
                    imageToShow.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imageToShow),
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.image_not_supported_rounded,
                                  size: 80.sp,
                                ),
                          ),
                        )
                        : Icon(Icons.image_not_supported_rounded, size: 80.sp),
              ),
            );
          },
        ),
      ],
    );
  }
}
