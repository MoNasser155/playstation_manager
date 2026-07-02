import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../constants/app_values.dart';
import '../utils/gaps.dart';
import '../languages/local_keys.g.dart';

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
  });
  final String title;
  final String? detailsTitle;
  final bool isViewAll;
  final Function()? onTap;
  final bool applyPadding;
  final Widget? trailingWidget;
  final String? subtitle;
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
                  style: context.textTheme.headlineMedium!.copyWith(),
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
                            size: 16,
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
