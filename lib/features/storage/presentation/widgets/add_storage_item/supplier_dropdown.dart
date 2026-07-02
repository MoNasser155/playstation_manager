part of 'custom_add_new_storage_item.dart';

class _SupplierDropdown extends StatelessWidget {
  const _SupplierDropdown({required this.cubit});
  final AddStorageItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddStorageItemCubit, AddStorageItemState>(
      buildWhen: (previous, current) {
        return previous.suppliers != current.suppliers ||
            previous.selectedSupplier != current.selectedSupplier ||
            previous.supplierLocked != current.supplierLocked;
      },
      builder: (context, state) {
        return ExpandedDropdown<SupplierModel>(
          prefix: Icon(Icons.person),
          withSearch: true,
          isEnabled: !state.supplierLocked,
          selectedValue: state.selectedSupplier?.name,
          hint: LocaleKeys.selectSupplier,
          items: state.suppliers,
          itemLabelBuilder: (SupplierModel p1) {
            return p1.name;
          },
          onChanged: (value) {
            cubit.setSelectedSupplier(value);
          },
        );
      },
    );
  }
}
