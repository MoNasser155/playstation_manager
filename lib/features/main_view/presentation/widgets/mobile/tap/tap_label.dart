import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

class TabLabel extends StatelessWidget {
  const TabLabel({super.key, required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style:
          isSelected
              ? context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.primary,
              )
              : context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.secondaryFixed,
              ),
    );
  }
}
