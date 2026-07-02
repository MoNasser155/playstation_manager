import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/navigator_helper.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/supplier_model.dart';

class CustomDeleteSupplierDialog extends StatelessWidget {
  const CustomDeleteSupplierDialog({
    super.key,
    this.onTap,
    required this.supplier,
  });

  final void Function()? onTap;
  final SupplierModel supplier;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      maxWidth: context.width * .35,
      children: [
        Text(LocaleKeys.deleteSupplier, style: context.textTheme.displayLarge),
        gapH(12),
        Text(
          LocaleKeys.deleteSupplierExp,
          style: context.textTheme.displaySmall!.copyWith(
            color: context.colorScheme.secondaryFixed,
          ),
        ),
        gapH(20),
        Row(
          spacing: AppSpacing.h12,
          children: [
            Expanded(
              child: CustomButton(
                buttonHeight: 40,
                title: LocaleKeys.cancel,
                textColor: context.colorScheme.onPrimary,
                backgroundColor: context.mapCard,
                borderColor: context.colorScheme.primary,
                onTap: () {
                  AppNavigator.pop();
                },
              ),
            ),
            Expanded(
              child: CustomButton(
                title: LocaleKeys.delete,
                buttonHeight: 40,
                backgroundColor: context.colorScheme.error,
                onTap: onTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
