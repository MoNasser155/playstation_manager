part of 'custom_add_transaction.dart';

class _CustomersDropdown extends StatelessWidget {
  const _CustomersDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      buildWhen: (previous, current) {
        return previous.customers != current.customers ||
            previous.customerStatus != current.customerStatus ||
            previous.customer != current.customer;
      },
      builder: (context, state) {
        final cubit = AddTransactionCubit.get(context);
        return ExpandedDropdown<CustomerModel>(
          withSearch:
              state.customerStatus.isSuccess && state.customers.isNotEmpty,
          searchFieldColor: context.mapCard,
          isLoading: state.customerStatus.isLoading,
          hint:
              state.customerStatus.isSuccess && state.customers.isNotEmpty
                  ? LocaleKeys.selectCustomer
                  : LocaleKeys.noCustomers,
          items: state.customers,
          selectedValue: state.customer?.name,
          onChanged: (value) {
            cubit.changeSelectedCustomer(value);
          },
          itemLabelBuilder: (p1) {
            return p1.name;
          },
        );
      },
    );
  }
}
