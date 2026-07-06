import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/charts/custom_bar_chart.dart';
import '../../../../../core/widgets/charts/custom_line_chart.dart';
import '../../../../../core/widgets/charts/custom_pie_chart.dart';
import '../../../../../core/widgets/custom_skeletonizer.dart';
import '../../../data/models/reports_model.dart';
import '../../cubits/cubit/reports_cubit.dart';
import '../../cubits/cubit/reports_state.dart';
import '../report_section_card.dart';
import '../reports_header.dart';
import '../reports_metrics_grid.dart';

class MobileReportsBody extends StatelessWidget {
  const MobileReportsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
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
                spacing: AppSpacing.v12,
                children: [
                  const ReportsHeader(),
                  BlocBuilder<ReportsCubit, ReportsState>(
                    buildWhen:
                        (previous, current) =>
                            previous.reportData != current.reportData ||
                            previous.status != current.status,
                    builder: (context, state) {
                      final reportData =
                          state.reportData ?? ReportModel.initial();
                      return ReportsMetricsGrid(
                        report: reportData,
                        isMobile: true,
                      );
                    },
                  ),
                  BlocBuilder<ReportsCubit, ReportsState>(
                    buildWhen:
                        (previous, current) =>
                            previous.reportData?.dailyRevenueThisWeek !=
                                current.reportData?.dailyRevenueThisWeek ||
                            previous.status != current.status,
                    builder: (context, state) {
                      final reportData =
                          state.reportData ?? ReportModel.initial();
                      return ReportSectionCard(
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
                          tooltipLabel: LocaleKeys.revenue,
                          isArabic: context.isRtl,
                        ),
                      );
                    },
                  ),
                  BlocBuilder<ReportsCubit, ReportsState>(
                    buildWhen:
                        (previous, current) =>
                            previous.reportData?.topDevices !=
                                current.reportData?.topDevices ||
                            previous.status != current.status,
                    builder: (context, state) {
                      final reportData =
                          state.reportData ?? ReportModel.initial();
                      return ReportSectionCard(
                        title: LocaleKeys.mostUsedDevices,
                        child: CustomBarChart(
                          devices: reportData.topDevices,
                          tooltipLabel: LocaleKeys.sessions,
                          isArabic: context.isRtl,
                        ),
                      );
                    },
                  ),
                  BlocBuilder<ReportsCubit, ReportsState>(
                    buildWhen:
                        (previous, current) =>
                            previous.reportData?.topProducts !=
                                current.reportData?.topProducts ||
                            previous.status != current.status,
                    builder: (context, state) {
                      final reportData =
                          state.reportData ?? ReportModel.initial();
                      return ReportSectionCard(
                        title: LocaleKeys.bestSellingProducts,
                        child: CustomPieChart(
                          products: reportData.topProducts,
                          isArabic: context.isRtl,
                        ),
                      );
                    },
                  ),
                  BlocBuilder<ReportsCubit, ReportsState>(
                    buildWhen:
                        (previous, current) =>
                            previous.reportData?.monthlyIncome !=
                                current.reportData?.monthlyIncome ||
                            previous.status != current.status,
                    builder: (context, state) {
                      final reportData =
                          state.reportData ?? ReportModel.initial();
                      return ReportSectionCard(
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
                          isArabic: context.isRtl,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
