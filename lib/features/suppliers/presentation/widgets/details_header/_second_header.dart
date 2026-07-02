part of 'supplier_details_info_header.dart';

class _SupplierDetailsSecondHeader extends StatelessWidget {
  const _SupplierDetailsSecondHeader();

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
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.supplierDetails.supplier.name,
                    style: context.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  gapH(6),
                  Text(
                    state.supplierDetails.supplier.phone1,
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
                  state.supplierDetails.supplier.simpledAmount,
                  style: context.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: state.supplierDetails.supplier.color,
                  ),
                ),
              ],
            ),
            gapW(12),
            Expanded(
              child: CustomButton(
                title: LocaleKeys.addItem,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AddStorageItemProvider(
                        supplier: state.supplierDetails.supplier,
                      );
                    },
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
                    builder: (context) {
                      return _AddSupplierTransactionProvider(
                        supplier: state.supplierDetails.supplier,
                      );
                    },
                  );
                  if (result == true) {
                    supplierDetailsCubit.refresh();
                  }
                },
              ),
            ),
            gapW(12),
            Expanded(
              child: CustomButton(
                title: LocaleKeys.exportPdf,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SavePdfDialog(
                        supplier: state.supplierDetails.supplier,

                        transactions: state.transactions,
                        totalAmount:
                            state.supplierDetails.supplier.simpledAmount,
                      );
                    },
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

class _AddSupplierTransactionProvider extends StatelessWidget {
  const _AddSupplierTransactionProvider({required this.supplier});
  final SupplierModel supplier;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddTransactionCubit>()..init(supplier: supplier),
      child: const AddCustomerSupplierTransactionDialog(),
    );
  }
}
