import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../data/models/home_profit.dart';

class ProfitWidget extends StatelessWidget {
  final HomeProfit profit;

  const ProfitWidget({super.key, required this.profit});

  @override
  Widget build(BuildContext context) {
    final double diff = profit.todayProfit - profit.yesterdayProfit;
    final bool isUp = diff >= 0;
    final double percent =
        profit.yesterdayProfit > 0
            ? (diff.abs() / profit.yesterdayProfit) * 100
            : (profit.todayProfit > 0 ? 100.0 : 0.0);

    return Container(
      constraints: BoxConstraints(maxHeight: 110, minHeight: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.todayIncome,
            style: context.textTheme.displayMedium?.copyWith(
              color: context.colorScheme.secondaryFixed,
              fontWeight: FontWeight.w600,
            ),
          ),
          gapH(16),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(AppPadding.pf12),
              decoration: BoxDecoration(
                color: context.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            profit.todayProfit.toStringAsFixed(2),
                            style: context.textTheme.displayLarge?.copyWith(
                              color: context.colorScheme.onPrimary,
                              fontSize: 96,
                            ),
                          ),
                        ),
                        gapW(8),
                        Text(
                          LocaleKeys.egp,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.secondaryFixed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH(8),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.pf8,
                          vertical: AppPadding.pf4,
                        ),
                        decoration: BoxDecoration(
                          color: (isUp
                                  ? AppColors.successColor
                                  : AppColors.errorColor)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.r6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isUp
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              color:
                                  isUp
                                      ? AppColors.successColor
                                      : AppColors.errorColor,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "${percent.toStringAsFixed(1)}%",
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isUp
                                        ? AppColors.successColor
                                        : AppColors.errorColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      gapW(8),
                      Expanded(
                        child: Text(
                          "${LocaleKeys.comparedToYesterday} (${profit.yesterdayProfit.toStringAsFixed(0)} ${LocaleKeys.egp})",
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.secondaryFixed,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
