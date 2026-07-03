import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';

class TotalsCard extends StatelessWidget {
  final double roundedCost;
  final double itemsTotal;
  final double grandTotal;
  final bool hasItems;

  const TotalsCard({
    super.key,
    required this.roundedCost,
    required this.itemsTotal,
    required this.grandTotal,
    required this.hasItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.pf12),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.sessionTimeCost,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
              Text(
                "${roundedCost.toStringAsFixed(2)} ${LocaleKeys.egp}",
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (hasItems) ...[
            gapH(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.itemsCost,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${itemsTotal.toStringAsFixed(2)} ${LocaleKeys.egp}",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.totalCost,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${grandTotal.toStringAsFixed(2)} ${LocaleKeys.egp}",
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
