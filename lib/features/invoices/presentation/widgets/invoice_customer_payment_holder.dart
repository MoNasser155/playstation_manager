part of 'main_invoice_data_holder.dart';

class _IvoiceCustomerPaymentHolder extends StatelessWidget {
  const _IvoiceCustomerPaymentHolder();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppPadding.pf8),
        decoration: BoxDecoration(
          color: context.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Column(
          spacing: AppSpacing.v12,
          children: [
            BlocBuilder<InvoiceCubit, InvoiceState>(
              buildWhen: (previous, current) {
                return previous.invoiceModels.customers !=
                        current.invoiceModels.customers ||
                    previous.selectedCustomer != current.selectedCustomer;
              },
              builder: (context, state) {
                final cubit = InvoiceCubit.get(context);
                return InkWell(
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return const AddCustomerProvider();
                      },
                    ); 
                    if (result == true) {
                      if (context.mounted) {
                        cubit.refresh(context);
                      }
                    }
                  },
                  child: ExpandedDropdown<CustomerModel>(
                    prefix:
                        state.invoiceModels.customers.isEmpty
                            ? Icon(Icons.add)
                            : null,
                    withSearch: true,
                    hint:
                        state.invoiceModels.customers.isEmpty
                            ? LocaleKeys.noCustomers
                            : LocaleKeys.selectCustomer,
                    items: state.invoiceModels.customers,
                    isEnabled: state.invoiceModels.customers.isNotEmpty,
                    selectedValue: state.selectedCustomer?.name,
                    backgroundColor: context.mapCard,
                    searchFieldColor: context.mapCard,
                    itemLabelBuilder: (p1) {
                      return p1.name;
                    },
                    onChanged: (value) {
                      if (value != null) {
                        cubit.setCustomer(value);
                      }
                    },
                  ),
                );
              },
            ),
            BlocBuilder<InvoiceCubit, InvoiceState>(
              buildWhen: (previous, current) {
                return previous.paymentType != current.paymentType;
              },
              builder: (context, state) {
                final cubit = InvoiceCubit.get(context);
                return CustomTapsRow(
                  itemsName:
                      PaymentType.values.map((e) => e.localizedName).toList(),
                  selectedIndex: state.paymentType.index,
                  itemsCount: PaymentType.values.length,
                  onTap: (index) {
                    cubit.changePayType(PaymentType.values[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
