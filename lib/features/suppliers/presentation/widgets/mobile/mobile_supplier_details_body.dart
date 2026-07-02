part of "../../screens/supplier_details_screen.dart";

class _MobileSupplierDetailsBody extends StatelessWidget {
  const _MobileSupplierDetailsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierDetailsCubit, SupplierDetailsState>(
      builder: (context, state) {
        return CustomSkeletonizer(
          enabled: state.status.isLoading,
          child: Column(
            children: [
              SupplierDetailsInfoHeader(),
              Expanded(child: CustomScrollView()),
            ],
          ),
        );
      },
    );
  }
}
