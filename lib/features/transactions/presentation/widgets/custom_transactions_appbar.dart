import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../../core/widgets/row_taps/custom_taps_row.dart';
import '../cubits/transactions_cubit/transactions_cubit.dart';
import 'transactions_date_range_picker.dart';

part '_transactions_monthly_filter.dart';

class CustomTransactionsAppbar extends StatelessWidget {
  const CustomTransactionsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      buildWhen: (previous, current) {
        return previous.selectedTapIndex != current.selectedTapIndex;
      },
      builder: (context, state) {
        return CustomSliverAppbar(
          applyPadding: true,
          height: 120, // Reduced height because tab row and add button are removed
          flexibleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gapHFix(12),
              Row(
                spacing: AppSpacing.h16,
                children: [
                  Expanded(child: TransactionsDateRangePicker()),
                  Expanded(flex: 4, child: _TransactionsMonthlyFilter()),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),
                  child: Row(
                    children: [
                      const SizedBox(width: 64),
                      Expanded(
                        flex: 7,
                        child: Text(
                          LocaleKeys.notes,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          LocaleKeys.payment,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          LocaleKeys.type,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          LocaleKeys.date,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
