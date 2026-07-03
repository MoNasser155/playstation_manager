import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.report_problem_outlined,
          color: context.colorScheme.primary,
          size: 20,
        ),
        gapW(8),
        Text(
          LocaleKeys.confirmEndSession,
          style: context.textTheme.displayMedium!.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
