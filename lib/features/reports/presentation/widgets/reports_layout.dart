import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/charts/custom_bar_chart.dart';
import '../../../../core/widgets/charts/custom_line_chart.dart';
import '../../../../core/widgets/charts/custom_pie_chart.dart';
import '../../../../core/widgets/custom_skeletonizer.dart';
import '../../../../core/widgets/expanded_drop_down.dart';
import '../../data/models/reports_model.dart';
import '../cubits/cubit/reports_cubit.dart';
import '../cubits/cubit/reports_state.dart';

class ReportsLayout extends StatelessWidget {
  const ReportsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final cubit = ReportsCubit.get(context);

        final reportData =
            state.status.isLoading || state.reportData == null
                ? ReportModel.initial()
                : state.reportData;

        return CustomSkeletonizer(
          enabled: state.status.isLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pf16,
              vertical: AppPadding.pf16,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  // Filter header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.reports,
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ExpandedDropdown<ReportFilter>(
                        hint: LocaleKeys.filters,
                        items: ReportFilter.values,
                        selectedValue: state.reportFilter.localizedName,
                        itemLabelBuilder: (f) => f.localizedName,
                        onChanged: (f) {
                          if (f != null) {
                            cubit.changeFilter(f);
                          }
                        },
                      ),
                    ],
                  ),

                  // Cards Summary Grid/Row
                  if (isMobile)
                    Column(
                      spacing: 12,
                      children: _buildMetricCards(
                        context,
                        reportData,
                        state.reportFilter,
                        isArabic,
                      ),
                    )
                  else
                    Row(
                      spacing: 12,
                      children:
                          _buildMetricCards(
                            context,
                            reportData,
                            state.reportFilter,
                            isArabic,
                          ).map((card) => Expanded(child: card)).toList(),
                    ),

                  // Revenue Overview weekly line chart
                  _ReportCard(
                    title: LocaleKeys.revenueOverview,
                    child: CustomLineChart(
                      values:
                          reportData.dailyRevenueThisWeek
                              .map((e) => e.revenue)
                              .toList(),
                      labels:
                          reportData.dailyRevenueThisWeek
                              .map((e) => e.dayName)
                              .toList(),
                      tooltipLabel: isArabic ? 'الإيرادات' : 'Revenue',
                      isArabic: isArabic,
                    ),
                  ),

                  // Top Devices and Best Selling Products (Flex Row)
                  if (isMobile) ...[
                    _ReportCard(
                      title: LocaleKeys.mostUsedDevices,
                      child: CustomBarChart(
                        devices: reportData.topDevices,
                        tooltipLabel: isArabic ? 'جلسات' : 'Sessions',
                        isArabic: isArabic,
                      ),
                    ),
                    _ReportCard(
                      title: LocaleKeys.bestSellingProducts,
                      child: CustomPieChart(
                        products: reportData.topProducts,
                        isArabic: isArabic,
                      ),
                    ),
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _ReportCard(
                            title: LocaleKeys.mostUsedDevices,
                            child: CustomBarChart(
                              devices: reportData.topDevices,
                              tooltipLabel: isArabic ? 'جلسات' : 'Sessions',
                              isArabic: isArabic,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _ReportCard(
                            title: LocaleKeys.bestSellingProducts,
                            child: CustomPieChart(
                              products: reportData.topProducts,
                              isArabic: isArabic,
                            ),
                          ),
                        ),
                      ],
                    ),

                  // Monthly Income 6 months line chart
                  _ReportCard(
                    title: LocaleKeys.monthlyIncome,
                    child: CustomLineChart(
                      values:
                          reportData.monthlyIncome
                              .map((e) => e.income)
                              .toList(),
                      labels:
                          reportData.monthlyIncome
                              .map((e) => e.monthName)
                              .toList(),
                      highlightIndex: reportData.monthlyIncome.indexWhere(
                        (m) => m.isCurrentMonth,
                      ),
                      tooltipLabel: LocaleKeys.income,
                      isArabic: isArabic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildMetricCards(
    BuildContext context,
    ReportModel report,
    ReportFilter filter,
    bool isArabic,
  ) {
    return [
      _MetricCard(
        title: LocaleKeys.totalRevenue,
        value: '${report.totalRevenue.toStringAsFixed(0)} ${LocaleKeys.egp}',
        changePercentage: report.revenueChangePercentage,
        compareLabel: LocaleKeys.comparedToPrevious,
      ),
      _MetricCard(
        title: LocaleKeys.totalSessionsCount,
        value: '${report.totalSessions}',
      ),
      _MetricCard(
        title: LocaleKeys.avgSessionValue,
        value: '${report.avgSessionValue.toStringAsFixed(0)} ${LocaleKeys.egp}',
      ),
      _MetricCard(
        title: LocaleKeys.productsSold,
        value: report.totalProductsSold.toStringAsFixed(0),
      ),
    ];
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final double? changePercentage;
  final String? compareLabel;

  const _MetricCard({
    required this.title,
    required this.value,
    this.changePercentage,
    this.compareLabel,
  });

  @override
  Widget build(BuildContext context) {
    final hasChange = changePercentage != null;
    final isPositive = (changePercentage ?? 0.0) >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;
    final changeIcon = isPositive ? '▲' : '▼';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (hasChange)
            Row(
              children: [
                Text(
                  '$changeIcon ${changePercentage!.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    compareLabel ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ReportCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
