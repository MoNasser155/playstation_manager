part of "../../screens/customer_details_screen.dart";

class _TabletCustomerDetailsBody extends StatelessWidget {
  const _TabletCustomerDetailsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailsCubit, CustomerDetailsState>(
      buildWhen: (p, c) {
        return p.currentTapIndex != c.currentTapIndex || p.status != c.status;
      },
      builder: (context, state) {
        return CustomSkeletonizer(
          enabled: state.status.isLoading,
          child: Column(
            children: [
              const CustomerDetailsInfoHeader(),
              state.currentTapIndex == 0
                  ? const CustomerDetailsTransactionsSection()
                  : const CustomerDetailsInvoicesSection(),
            ],
          ),
        );
      },
    );
  }
}
