import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/date_extensions.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../features/transactions/data/models/transaction_model.dart';

class CustomTransactionCardWidget extends StatelessWidget {
  final TransactionModel transaction;
  const CustomTransactionCardWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pf20,
        vertical: AppPadding.pf12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        color: context.primaryContainer,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Text(
              transaction.id.toString(),
              style: context.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 7,
            child: Tooltip(
              message: transaction.notes ?? "",
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.pf12,
                vertical: AppPadding.pf6,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryFixed,
                borderRadius: BorderRadius.circular(AppRadius.r4),
              ),
              textStyle: context.textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    context.theme.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
              ),
              child: Text(
                transaction.notes ?? "",
                style: context.textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction.sessionProfit?.toStringAsFixed(2) ?? '0.00',
              style: context.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction.transactionTypeVal.localizedName,
              style: context.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Tooltip(
              message: transaction.createdAt.toFullFormattedDate,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.pf12,
                vertical: AppPadding.pf6,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryFixed,
                borderRadius: BorderRadius.circular(AppRadius.r4),
              ),
              textStyle: context.textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    context.theme.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
              ),
              child: Text(
                transaction.createdAt.toFullFormattedDate,
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
