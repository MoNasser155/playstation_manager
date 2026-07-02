

import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../shared/models/option_row_model.dart';

class CustomOptionRow extends StatelessWidget {
  const CustomOptionRow({super.key, required this.optionRowModel, this.style});

  final OptionRowModel optionRowModel;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: optionRowModel.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                optionRowModel.title,
                style: style ?? context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
            optionRowModel.suffix ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: context.colorScheme.secondaryFixed,
                ),
          ],
        ),
      ),
    );
  }
}
