import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/sliver_empty_body.dart';
import '../../../../transactions/data/models/transaction_model.dart';

class LatestTransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const LatestTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.5,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.latestTodayTransactions,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.secondaryFixed,
              fontWeight: FontWeight.w600,
            ),
          ),
          gapH(12),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(AppPadding.pf8),
              decoration: BoxDecoration(
                color: context.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  if (transactions.isEmpty)
                    SliverEmptyBody(title: LocaleKeys.noTransactionsYet)
                  else
                    SliverList.separated(
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => gapH(8),
                      itemBuilder: (context, index) {
                        return _TransactionCard(
                          transaction: transactions[index],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final notes = transaction.notes ?? "";
    final firstLine = notes.split('\n').first;

    return Container(
      padding: EdgeInsets.all(AppPadding.pf12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstLine,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      gapHFix(6),
                      Text(
                        transaction.createdAt.shortenFormattedDate,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.secondaryFixed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          gapW(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "+${transaction.sessionProfit?.toStringAsFixed(0) ?? '0'}",
                style: context.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              Text(
                LocaleKeys.egp,
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.secondaryFixed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
