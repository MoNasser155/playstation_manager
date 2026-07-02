import 'package:flutter/material.dart';

import '../constants/app_values.dart';

class CustomSliverPadding extends StatelessWidget {
  const CustomSliverPadding({
    super.key,
    this.child,
    this.sliver,
    this.horizontalPadding,
    this.verticalPadding,
  });
  final Widget? child;
  final double? horizontalPadding, verticalPadding;
  final Widget? sliver;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? AppPadding.pf20,
        vertical: verticalPadding ?? 0,
      ),
      sliver: sliver ?? SliverToBoxAdapter(child: child),
    );
  }
}
