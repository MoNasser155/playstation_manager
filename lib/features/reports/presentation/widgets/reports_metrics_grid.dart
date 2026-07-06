import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reports_model.dart';
import 'report_metric_card.dart';

class ReportsMetricsGrid extends StatelessWidget {
  final ReportModel report;
  final bool isMobile;

  const ReportsMetricsGrid({
    super.key,
    required this.report,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      ReportMetricCard(
        title: LocaleKeys.totalRevenue,
        value: '${report.totalRevenue.toStringAsFixed(0)} ${LocaleKeys.egp}',
        icon: Icons.attach_money_rounded,
        iconColor: context.colorScheme.primary,
      ),
      ReportMetricCard(
        title: LocaleKeys.totalSessionsCount,
        value: '${report.totalSessions}',
        icon: Icons.show_chart_rounded,
        iconColor: AppColors.successColor,
      ),
      ReportMetricCard(
        title: LocaleKeys.avgSessionValue,
        value: '${report.avgSessionValue.toStringAsFixed(0)} ${LocaleKeys.egp}',
        icon: Icons.trending_up_rounded,
        iconColor: Colors.purple,
      ),
      ReportMetricCard(
        title: LocaleKeys.productsSold,
        value: report.totalProductsSold.toStringAsFixed(0),
        icon: Icons.inventory_2_rounded,
        iconColor: Colors.orange,
      ),
    ];

    if (isMobile) {
      return Column(spacing: AppSpacing.v12, children: cards);
    } else {
      return Row(
        spacing: AppSpacing.h12,
        children: cards.map((card) => Expanded(child: card)).toList(),
      );
    }
  }
}
