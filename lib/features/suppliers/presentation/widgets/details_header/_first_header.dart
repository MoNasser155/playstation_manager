part of 'supplier_details_info_header.dart';

class _SupplierDetialsFirstHeader extends StatelessWidget {
  const _SupplierDetialsFirstHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierDetailsCubit, SupplierDetailsState>(
      buildWhen: (previous, current) {
        return previous.supplierDetails.supplier !=
            current.supplierDetails.supplier;
      },
      builder: (context, state) {
        final supplierDetailsCubit = SupplierDetailsCubit.get(context);
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
            Spacer(),
            InkWell(
              onTap: () async {
                supplierDetailsCubit.setupControllers();
                showDialog(
                  context: context,
                  builder:
                      (_) =>
                          CustomEditSupplierDialog(cubit: supplierDetailsCubit),
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
                      (_) => CustomDeleteSupplierDialog(
                        onTap: () {
                          supplierDetailsCubit.deleteSupplier(context);
                          AppNavigator.pop();
                        },
                        supplier: state.supplierDetails.supplier,
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
