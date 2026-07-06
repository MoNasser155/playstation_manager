import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../constants/app_values.dart';
import '../languages/local_keys.g.dart';
import '../utils/gaps.dart';

class CustomSectionHeader extends StatelessWidget {
  const CustomSectionHeader({
    super.key,
    required this.title,
    this.detailsTitle,
    this.isViewAll = false,
    this.onTap,
    this.applyPadding = false,
    this.trailingWidget,
    this.subtitle,
    this.titleStyle,
  });
  final String title;
  final String? detailsTitle;
  final bool isViewAll;
  final Function()? onTap;
  final bool applyPadding;
  final Widget? trailingWidget;
  final String? subtitle;
  final TextStyle? titleStyle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: applyPadding ? AppPadding.pf20 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style:
                      titleStyle ??
                      context.textTheme.displayMedium?.copyWith(
                        color: context.colorScheme.secondaryFixed,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              isViewAll == true
                  ? InkWell(
                    onTap: onTap,
                    child: Row(
                      children: [
                        Text(
                          detailsTitle ?? LocaleKeys.viewAll,
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        gapW(2),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          fontWeight: FontWeight.w700,
                          color: context.colorScheme.primary,
                        ),
                      ],
                    ),
                  )
                  : trailingWidget ?? const SizedBox(),
            ],
          ),
          if (subtitle != null) ...[
            gapH(4),
            Text(
              subtitle!,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.secondaryFixed,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
