part of "../../screens/customer_details_screen.dart";

class _DesktopCustomerDetailsBody extends StatelessWidget {
  const _DesktopCustomerDetailsBody();

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
