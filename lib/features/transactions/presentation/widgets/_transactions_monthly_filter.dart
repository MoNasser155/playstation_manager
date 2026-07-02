part of 'custom_transactions_appbar.dart';

class _TransactionsMonthlyFilter extends StatelessWidget {
  const _TransactionsMonthlyFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      buildWhen: (prev, curr) => prev.selectedMonth != curr.selectedMonth,
      builder: (context, state) {
        final cubit = TransactionsCubit.get(context);
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 36,
                child: CustomTapsRow(
                  selectedIndex: state.selectedMonth,
                  itemsName: cubit.monthNames,
                  itemsCount: 12,
                  onTap: (int index) {
                    cubit.selectMonth(index);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
