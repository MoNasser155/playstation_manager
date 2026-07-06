import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../constants/app_values.dart';

class CustomRowInfoWithIcon extends StatelessWidget {
  const CustomRowInfoWithIcon({
    super.key,
    required this.title,
    this.iconData,
    this.icon,
    this.textColor,
    this.iconColor,
  });
  final String title;
  final IconData? iconData;
  final Widget? icon;
  final Color? textColor, iconColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.h2,
      children: [
        icon == null
            ? Icon(
              iconData,
              color: iconColor ?? context.colorScheme.secondaryFixed,
              size: 16,
            )
            : icon!,
        Text(
          title,
          style: context.textTheme.labelSmall!.copyWith(
            color: textColor ?? context.colorScheme.secondaryFixed,
          ),
        ),
      ],
    );
  }
}
