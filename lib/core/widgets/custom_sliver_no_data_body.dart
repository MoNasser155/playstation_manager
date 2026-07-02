import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../constants/app_values.dart';
import 'custom_sliver_padding.dart';

class CustomSliverNoDataBody extends StatelessWidget {
  const CustomSliverNoDataBody({
    super.key,
    required this.title,
    this.applyPadding = false,
    this.verticalPadding,
  });
  final String title;
  final bool applyPadding;
  final double? verticalPadding;
  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      horizontalPadding: applyPadding ? null : 0,
      verticalPadding: verticalPadding ?? 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.v12),
        decoration: BoxDecoration(
          color: context.mapCard,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Center(child: Text(title, style: context.textTheme.titleLarge)),
      ),
    );
  }
}
