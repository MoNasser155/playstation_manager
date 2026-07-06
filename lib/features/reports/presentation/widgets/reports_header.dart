import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';
import 'package:playstation_manager/core/widgets/row_taps/custom_taps_row.dart';

import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../data/models/reports_model.dart';
import '../cubits/cubit/reports_cubit.dart';
import '../cubits/cubit/reports_state.dart';

class ReportsHeader extends StatelessWidget {
  const ReportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      buildWhen: (prev, current) => prev.reportFilter != current.reportFilter,
      builder: (context, state) {
        final cubit = ReportsCubit.get(context);
        return Column(
          children: [
            gapHFix(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    LocaleKeys.reports,
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomTapsRow(
                    itemsName:
                        ReportFilter.values
                            .map((e) => e.localizedName)
                            .toList(),
                    selectedIndex: state.reportFilter.index,
                    itemsCount: ReportFilter.values.length,

                    onTap: (index) {
                      cubit.changeFilter(ReportFilter.values[index]);
                    },
                  ),
                ),
              ],
            ),
            gapHFix(12),
          ],
        );
      },
    );
  }
}
