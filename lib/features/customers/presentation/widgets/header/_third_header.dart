part of 'customer_details_info_header.dart';

class _ThirdCustomerDetailsHeader extends StatelessWidget {
  const _ThirdCustomerDetailsHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailsCubit, CustomerDetailsState>(
      buildWhen: (previous, current) {
        return previous.currentTapIndex != current.currentTapIndex ||
            previous.invoicesStatus != current.invoicesStatus ||
            previous.transactionsStatus != current.transactionsStatus;
      },
      builder: (context, state) {
        final cubit = CustomerDetailsCubit.get(context);
        return Row(
          children: [
            Expanded(
              child: CustomTapsRow(
                selectedIndex: state.currentTapIndex,
                itemsCount: 2,
                itemsName: [LocaleKeys.transactions, LocaleKeys.invoices],
                onTap: (int index) {
                  cubit.changeTapIndex(index);
                },
              ),
            ),
            Spacer(flex: 2),
          ],
        );
      },
    );
  }
}
