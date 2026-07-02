part of 'customer_details_info_header.dart';

class _SecondCustomerDetailsHeader extends StatelessWidget {
  const _SecondCustomerDetailsHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailsCubit, CustomerDetailsState>(
      buildWhen: (previous, current) {
        return previous.customerDetails.customer !=
            current.customerDetails.customer;
      },
      builder: (context, state) {
        final customerDetailsCubit = CustomerDetailsCubit.get(context);
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.customerDetails.customer.name,
                    style: context.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  gapH(6),
                  Text(
                    state.customerDetails.customer.phone1,
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.colorScheme.secondaryFixed,
                    ),
                  ),
                ],
              ),
            ),
            gapW(12),
            Column(
              children: [
                Text(
                  LocaleKeys.total,
                  style: context.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.colorScheme.secondaryFixed,
                  ),
                ),
                gapH(6),
                Text(
                  state.customerDetails.customer.simpledAmount,
                  style: context.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: state.customerDetails.customer.color,
                  ),
                ),
              ],
            ),
            gapW(12),
            Expanded(
              child: CustomButton(
                title: LocaleKeys.createInvoice,
                onTap: () {
                  final cubit = MainViewCubit.get(context);
                  log(
                    '=============${state.customerDetails.customer}==========',
                  );
                  cubit.setSelectedTap(
                    1,
                    send: [state.customerDetails.customer],
                  );
                },
              ),
            ),
            gapW(12),
            Expanded(
              child: CustomButton(
                title: LocaleKeys.addTransaction,
                onTap: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) {
                      return _AddCustomerTransactionProvider(
                        customer: state.customerDetails.customer,
                      );
                    },
                  );
                  if (result == true) {
                    customerDetailsCubit.refresh();
                  }
                },
              ),
            ),
            gapW(12),
            Expanded(
              child: CustomButton(
                title: LocaleKeys.exportPdf,
                onTap: () {
                  showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => SavePdfDialog(
                          transactions: state.transactions,
                          customer: state.customerDetails.customer,
                          totalAmount:
                              state.customerDetails.customer.simpledAmount,
                        ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AddCustomerTransactionProvider extends StatelessWidget {
  const _AddCustomerTransactionProvider({required this.customer});
  final CustomerModel customer;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddTransactionCubit>()..init(customer: customer),
      child: const AddCustomerSupplierTransactionDialog(),
    );
  }
}
