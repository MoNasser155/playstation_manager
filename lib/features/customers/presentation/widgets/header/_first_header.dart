part of 'customer_details_info_header.dart';

class _FirstCustomerDetailsHeader extends StatelessWidget {
  const _FirstCustomerDetailsHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailsCubit, CustomerDetailsState>(
      buildWhen: (previous, current) {
        return previous.customerDetails.customer !=
            current.customerDetails.customer;
      },
      builder: (context, state) {
        final customerCubit = CustomerDetailsCubit.get(context);
        return Row(
          children: [
            InkWell(
              onTap: () {
                final cubit = MainViewCubit.get(context);
                cubit.clearCustomizedView();
              },
              child: Container(
                padding: EdgeInsets.all(AppPadding.pf8),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
            gapW(12),
            const Spacer(),
            InkWell(
              onTap: () async {
                customerCubit.setupControllers();
                showDialog(
                  context: context,
                  builder: (_) {
                    return CustomEditCustomerDialog(cubit: customerCubit);
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(AppPadding.pf8),
                child: Icon(
                  Icons.edit_note_rounded,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
            gapW(8),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => CustomDeleteCustomerDialog(
                        customer: state.customerDetails.customer,
                        onTap: () {
                          customerCubit.deleteCustomer(
                            state.customerDetails.customer.uuid,
                            context,
                          );
                          AppNavigator.pop();
                        },
                      ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(AppPadding.pf8),
                child: Icon(
                  Icons.delete_rounded,
                  color: context.colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
