part of "../../screens/customer_details_screen.dart";

class _MobileCustomerDetailsBody extends StatelessWidget {
  const _MobileCustomerDetailsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailsCubit, CustomerDetailsState>(
      builder: (context, state) {
        return CustomSkeletonizer(
          enabled: state.status.isLoading,
          child: Column(
            children: [
              const CustomerDetailsInfoHeader(),
              const Expanded(child: CustomScrollView()),
            ],
          ),
        );
      },
    );
  }
}
