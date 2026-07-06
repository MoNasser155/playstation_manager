import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../data/models/session_model.dart';

class ItemsDetailsCard extends StatelessWidget {
  final List<SessionItem> items;

  const ItemsDetailsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.pf12),
      decoration: BoxDecoration(
        color: context.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(
          color: context.colorScheme.secondaryFixed.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.itemsBought,
            style: context.textTheme.bodySmall!.copyWith(
              color: context.colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          gapH(12),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      LocaleKeys.itemName,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      LocaleKeys.quantity,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      LocaleKeys.total,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ...items.map(
                (item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        item.storageItem.target?.itemName ?? '',
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        item.quantity.toStringAsFixed(1),
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "${item.totalItemPrice.toStringAsFixed(2)} ${LocaleKeys.egp}",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
