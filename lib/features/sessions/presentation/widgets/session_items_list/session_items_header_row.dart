import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/custom_sliver_padding.dart';

class SessionItemsHeaderRow extends StatelessWidget {
  const SessionItemsHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      child: Container(
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.pf16,
          horizontal: AppPadding.pf8,
        ),
        decoration: BoxDecoration(
          color: context.primaryContainer,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.r16),
            topRight: Radius.circular(AppRadius.r16),
          ),
          border: Border(
            bottom: BorderSide(color: context.colorScheme.secondaryFixed),
          ),
        ),
        child: Row(
          spacing: AppSpacing.h12,
          children: [
            ...List.generate(
              4,
              (index) => _CustomHeaderTitle(
                title: switch (index) {
                  0 => LocaleKeys.itemName,
                  1 => LocaleKeys.price,
                  2 => LocaleKeys.quantity,
                  _ => LocaleKeys.total,
                },
                index: index,
              ),
            ),
            gapWFix(24),
          ],
        ),
      ),
    );
  }
}

class _CustomHeaderTitle extends StatelessWidget {
  const _CustomHeaderTitle({required this.title, required this.index});
  final String title;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: index == 0 ? 3 : 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right:
                index == 3
                    ? BorderSide.none
                    : context.isRtl
                    ? BorderSide.none
                    : BorderSide(
                      color: context.colorScheme.secondaryFixed,
                      width: 1.5,
                    ),
            left:
                index == 3
                    ? BorderSide.none
                    : context.isRtl
                    ? BorderSide(
                      color: context.colorScheme.secondaryFixed,
                      width: 1.5,
                    )
                    : BorderSide.none,
          ),
        ),
        child: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
