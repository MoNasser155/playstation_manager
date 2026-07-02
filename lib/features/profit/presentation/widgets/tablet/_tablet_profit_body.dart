part of '../../screens/profit_screen.dart';

class _TabletProfitBody extends StatelessWidget {
  const _TabletProfitBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CustomProfitsAppbar(),
        const ProfitsList(),
        sliverGapHFix(20),
      ],
    );
  }
}
