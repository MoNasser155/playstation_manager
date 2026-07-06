import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomSkeletonizer extends StatelessWidget {
  const CustomSkeletonizer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: context.colorScheme.secondaryFixed.withValues(alpha: 0.7),
        highlightColor: context.colorScheme.secondaryFixed.withValues(
          alpha: 0.3,
        ),
      ),
      enabled: enabled,
      child: child,
    );
  }
}
