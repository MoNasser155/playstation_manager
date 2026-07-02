part of 'custom_profits_appbar.dart';

class _MothlyFilter extends StatelessWidget {
  const _MothlyFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfitCubit, ProfitState>(
      buildWhen: (prev, curr) => prev.selectedMonth != curr.selectedMonth,
      builder: (context, state) {
        final cubit = ProfitCubit.get(context);
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
                  onDoubleTap: (int index) {
                    if (index == state.selectedMonth) {
                      cubit.resetToDefaultDate();
                    }
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
