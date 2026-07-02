part of 'custom_add_transaction.dart';

class _SuppliersDropdown extends StatelessWidget {
  const _SuppliersDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      buildWhen: (previous, current) {
        return previous.suppliers != current.suppliers ||
            previous.supplierStatus != current.supplierStatus ||
            previous.supplier != current.supplier;
      },
      builder: (context, state) {
        final cubit = AddTransactionCubit.get(context);
        return ExpandedDropdown<SupplierModel>(
          withSearch:
              state.supplierStatus.isSuccess && state.suppliers.isNotEmpty,
          searchFieldColor: context.mapCard,
          isLoading: state.supplierStatus.isLoading,
          hint:
              state.supplierStatus.isSuccess && state.suppliers.isNotEmpty
                  ? LocaleKeys.selectSupplier
                  : LocaleKeys.noSuppliers,
          items: state.suppliers,
          selectedValue: state.supplier?.name,
          onChanged: (value) {
            cubit.changeSelectedSupplier(value);
          },
          itemLabelBuilder: (p1) {
            return p1.name;
          },
        );
      },
    );
  }
}
