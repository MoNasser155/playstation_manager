import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../constants/app_values.dart';
import '../languages/local_keys.g.dart';
import 'custom_button.dart';

class CustomBottomSheetButton extends StatelessWidget {
  const CustomBottomSheetButton({
    super.key,
    this.onTap,
    this.isLoading = false,
  });
  final void Function()? onTap;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pf20,
        vertical: AppPadding.pf16,
      ),
      decoration: BoxDecoration(
        color: context.mapCard,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border(
          top: BorderSide(color: context.colorScheme.secondaryFixed),
        ),
      ),
      child: CustomButton(
        isLoading: isLoading,
        title: LocaleKeys.next,
        onTap: onTap,
      ),
    );
  }
}
