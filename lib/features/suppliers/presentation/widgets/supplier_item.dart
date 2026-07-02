part of 'suppliers_list.dart';

class _SupplierItem extends StatelessWidget {
  final SupplierModel supplier;
  const _SupplierItem({required this.supplier});

  @override
  Widget build(BuildContext context) {
    final mainViewCubit = MainViewCubit.get(context);
    return InkWell(
      onTap: () {
        mainViewCubit.setCustomizedView(
          SupplierDetailsScreen(supplierUuid: supplier.uuid),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
        child: Row(
          spacing: AppSpacing.h12,
          children: [
            Expanded(
              child: Text(
                supplier.id.toString(),
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                supplier.name,
                style: context.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                supplier.simpledAmount,
                style: context.textTheme.titleLarge!.copyWith(
                  color: supplier.color,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                supplier.phone1,
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
                final cubit = SuppliersCubit.get(context);
                showDialog(
                  context: context,
                  builder: (_) {
                    return CustomDeleteSupplierDialog(
                      onTap: () => cubit.deleteSupplier(supplier.uuid, context),
                      supplier: supplier,
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
