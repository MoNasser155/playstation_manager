part of "../../screens/supplier_details_screen.dart";

class _TabletSupplierDetailsBody extends StatelessWidget {
  const _TabletSupplierDetailsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierDetailsCubit, SupplierDetailsState>(
      builder: (context, state) {
        return CustomSkeletonizer(
          enabled: state.status.isLoading,
          child: Column(
            children: [
              const SupplierDetailsInfoHeader(),
              const SupplierDetailsTransactionsSection(),
            ],
          ),
        );
      },
    );
  }
}
