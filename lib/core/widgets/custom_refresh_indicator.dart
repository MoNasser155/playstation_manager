import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

class CustomRefreshIndicator extends StatelessWidget {
  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });
  final Widget child;
  final Future<void> Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: context.mapCard,
      color: context.colorScheme.primary,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
