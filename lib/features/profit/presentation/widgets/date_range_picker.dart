import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../cubits/cubit/profit_cubit.dart';

class ProfitDateRangePicker extends StatelessWidget {
  const ProfitDateRangePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfitCubit, ProfitState>(
      buildWhen:
          (prev, curr) =>
              prev.fromDate != curr.fromDate || prev.toDate != curr.toDate,
      builder: (context, state) {
        return Column(
          children: [
            _DatePickerField(
              label: '${LocaleKeys.from}:',
              date: state.fromDate ?? DateTime.now(),
              onPick: (picked) {
                if (picked == null) return;
                final newTo =
                    picked.isAfter(state.toDate ?? DateTime.now())
                        ? picked
                        : state.toDate;
                ProfitCubit.get(
                  context,
                ).onDateRangeChanged(picked, newTo ?? DateTime.now());
              },
              lastDate: state.toDate,
            ),
            gapHFix(12),
            _DatePickerField(
              label: '${LocaleKeys.to}:',
              date: state.toDate ?? DateTime.now(),
              onPick: (picked) {
                if (picked == null) return;
                final newFrom =
                    picked.isBefore(state.fromDate ?? DateTime.now())
                        ? picked
                        : state.fromDate ?? DateTime.now();
                ProfitCubit.get(context).onDateRangeChanged(newFrom, picked);
              },
              firstDate: state.fromDate ?? DateTime.now(),
            ),
          ],
        );
      },
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onPick,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime date;
  final ValueChanged<DateTime?> onPick;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: firstDate ?? DateTime(2000),
                lastDate: lastDate ?? DateTime(2100),
              );
              onPick(picked);
            },
            borderRadius: BorderRadius.circular(AppRadius.r8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                gapWFix(8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.pf12,
                      vertical: AppPadding.pf4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline),
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                    child: Text(
                      date.defaultFormattedDate,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
