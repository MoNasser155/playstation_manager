part of '../../screens/profit_screen.dart';

class _DesktopProfitBody extends StatelessWidget {
  const _DesktopProfitBody();

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
