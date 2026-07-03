import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/custom_button.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.h12,
      children: [
        Expanded(
          child: CustomButton(
            buttonHeight: 44,
            title: LocaleKeys.cancel,
            backgroundColor: context.mapCard,
            borderColor: context.colorScheme.error,
            textColor: context.colorScheme.onPrimary,
            onTap: () {
              Navigator.of(context).pop(false);
            },
          ),
        ),
        Expanded(
          child: CustomButton(
            buttonHeight: 44,
            title: LocaleKeys.save,
            textColor: Colors.white,

            onTap: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
      ],
    );
  }
}
