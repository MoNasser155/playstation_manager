import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../languages/local_keys.g.dart';

class ClearFiltersButton extends StatelessWidget {
  const ClearFiltersButton({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: onTap,
          icon: Icon(Icons.clear, size: 18, color: context.colorScheme.error),
          label: Text(
            LocaleKeys.clear,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
