import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';

class ReportSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const ReportSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.v8,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pf4),
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.secondaryFixed,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
