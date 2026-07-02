import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/row_taps/custom_taps_row.dart';
import '../cubits/cubit/profit_cubit.dart';
import 'date_range_picker.dart';

part '_monthly_filter.dart';

class CustomProfitsAppbar extends StatelessWidget {
  const CustomProfitsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: CustomSliverAppbar(
        height: 128,
        flexibleWidget: Column(
          children: [
            gapHFix(12),
            Row(
              children: [
                Expanded(child: ProfitDateRangePicker()),
                gapWFix(12),
                Expanded(
                  flex: 4,
                  child: Column(
                    spacing: AppSpacing.v4,
                    children: [
                      _MothlyFilter(),
                      Text(
                        LocaleKeys.totalProfit,
                        style: context.textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      BlocBuilder<ProfitCubit, ProfitState>(
                        buildWhen: (previous, current) {
                          return previous.profits.totalProfit !=
                              current.profits.totalProfit;
                        },
                        builder: (context, state) {
                          return Text(
                            state.profits.totalProfit.toStringAsFixed(2),
                            style: context.textTheme.displayLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.successColor,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            gapHFix(12),
            const CustomProfitsHeader(),
            gapHFix(12),
          ],
        ),
      ),
    );
  }
}

class CustomProfitsHeader extends StatelessWidget {
  const CustomProfitsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 64),
        Expanded(
          flex: 7,
          child: Text(LocaleKeys.note, style: context.textTheme.headlineLarge),
        ),
        Expanded(
          flex: 2,
          child: Text(
            LocaleKeys.profit,
            style: context.textTheme.headlineLarge,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(LocaleKeys.type, style: context.textTheme.headlineLarge),
        ),
        Expanded(
          flex: 3,
          child: Text(LocaleKeys.date, style: context.textTheme.headlineLarge),
        ),
      ],
    );
  }
}
