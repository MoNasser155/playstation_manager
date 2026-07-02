part of 'customers_list.dart';

class _CustomerItem extends StatelessWidget {
  final CustomerModel customer;
  const _CustomerItem({required this.customer});

  @override
  Widget build(BuildContext context) {
    final mainViewCubit = MainViewCubit.get(context);
    return InkWell(
      onTap: () {
        mainViewCubit.setCustomizedView(
          CustomerDetailsScreen(customerUuid: customer.uuid),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
        child: Row(
          spacing: AppSpacing.h12,
          children: [
            Expanded(
              child: Text(
                customer.id.toString(),
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                customer.name,
                style: context.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                customer.simpledAmount,
                style: context.textTheme.titleLarge!.copyWith(
                  color: customer.color,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                customer.phone1,
                style: context.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: () {
                final cubit = CustomersCubit.get(context);
                showDialog(
                  context: context,
                  builder: (_) {
                    return CustomDeleteCustomerDialog(
                      onTap: () => cubit.deleteCustomer(customer.uuid, context),
                      customer: customer,
                    );
                  },
                );
              },
              hoverColor: context.colorScheme.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.r8),
              child: Padding(
                padding: EdgeInsets.all(AppPadding.pf8),
                child: Icon(
                  Icons.delete_rounded,
                  color: context.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
