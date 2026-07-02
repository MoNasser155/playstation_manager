import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../constants/app_values.dart';

class CustomTapBlurWidget extends StatelessWidget {
  const CustomTapBlurWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(AppPadding.pf4),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer.withValues(alpha: 0.2),
            border: Border.all(color: context.colorScheme.secondaryFixed),
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: child,
        ),
      ),
    );
  }
}
