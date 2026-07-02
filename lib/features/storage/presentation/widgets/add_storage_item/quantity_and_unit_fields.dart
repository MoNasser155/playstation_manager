part of 'custom_add_new_storage_item.dart';

class _QuantityAndUnitFields extends StatelessWidget {
  const _QuantityAndUnitFields({
    required this.cubit,
    this.viewUnitSelection = true,
  });
  final AddStorageItemCubit cubit;
  final bool viewUnitSelection;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.h8,
      children: [
        Expanded(
          child: CustomTextField(
            hint: LocaleKeys.enterQuantity,
            controller: cubit.quantityController,
            prefix: Icon(Icons.inventory_2_outlined),
            validate: Validations.validateEmpty,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
        ),
        Expanded(
          child: Visibility(
            visible: viewUnitSelection,
            child: BlocBuilder<AddStorageItemCubit, AddStorageItemState>(
              buildWhen: (previous, current) {
                return previous.selectedUnit != current.selectedUnit;
              },
              builder: (context, state) {
                return ExpandedDropdown<StorageItemType>(
                  prefix: Icon(Icons.balance_rounded),
                  hint: LocaleKeys.selectUnit,
                  items: StorageItemType.values,
                  selectedValue: state.selectedUnit?.localizedName,
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
        ),
      ],
    );
  }
}
