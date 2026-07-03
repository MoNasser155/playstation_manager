import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../cubits/cubit/session_cubit.dart';

class EndSessionDialog extends StatelessWidget {
  const EndSessionDialog({super.key});

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final hourVal =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minuteStr = time.minute.toString().padLeft(2, '0');
    final timeAmPm = time.hour >= 12 ? LocaleKeys.pm : LocaleKeys.am;
    return "$hourVal:$minuteStr $timeAmPm";
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        final device = state.selectedDevice;
        if (device == null || state.activeSession == null) {
          return const SizedBox.shrink();
        }

        final startTime = state.activeSession!.sessionStartDate;
        final endTime = state.sessionEndTime;
        final duration = state.sessionDuration;
        final roundedCost = state.roundedSessionCost;
        final rawCost = state.sessionCost;
        final items = state.sessionItems;

        final itemsTotal = items.fold<double>(
          0.0,
          (s, e) => s + e.totalItemPrice,
        );
        final grandTotal = roundedCost + itemsTotal;

        return CustomDialog(
          maxWidth: context.width * 0.5,
          children: [
            Row(
              children: [
                Icon(
                  Icons.report_problem_outlined,
                  color: context.colorScheme.primary,
                  size: 28,
                ),
                gapW(8),
                Text(
                  LocaleKeys.confirmEndSession,
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            gapH(16),
            const Divider(),
            gapH(12),
            // Timing details
            Container(
              padding: EdgeInsets.all(AppPadding.pf12),
              decoration: BoxDecoration(
                color: context.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                border: Border.all(
                  color: context.colorScheme.secondaryFixed.withValues(
                    alpha: 0.2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.sessionDuration,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  gapH(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.startTime),
                      Text(
                        _formatTime(startTime),
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  gapH(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.endTime),
                      Text(
                        _formatTime(endTime),
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  gapH(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.sessionDurationSummary),
                      Text(
                        _formatDuration(duration),
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  gapH(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.sessionCost),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${roundedCost.toStringAsFixed(2)} ${LocaleKeys.egp}",
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          if (rawCost != roundedCost)
                            Text(
                              "(${rawCost.toStringAsFixed(2)} ${LocaleKeys.egp})",
                              style: context.textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: context.colorScheme.secondaryFixed,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            gapH(16),
            // Items details
            if (items.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(AppPadding.pf12),
                decoration: BoxDecoration(
                  color: context.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(
                    color: context.colorScheme.secondaryFixed.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.itemsBought,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    gapH(12),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1.5),
                      },
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                LocaleKeys.itemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                LocaleKeys.quantity,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                LocaleKeys.total,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...items.map(
                          (item) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  item.storageItem.target?.itemName ?? '',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Text(item.quantity.toStringAsFixed(1)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  "${item.totalItemPrice.toStringAsFixed(2)} ${LocaleKeys.egp}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              gapH(16),
            ],
            // Totals
            Container(
              padding: EdgeInsets.all(AppPadding.pf12),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.r12),
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.sessionTimeCost,
                        style: context.textTheme.titleMedium,
                      ),
                      Text(
                        "${roundedCost.toStringAsFixed(2)} ${LocaleKeys.egp}",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (items.isNotEmpty) ...[
                    gapH(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.itemsCost,
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          "${itemsTotal.toStringAsFixed(2)} ${LocaleKeys.egp}",
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.totalCost,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${grandTotal.toStringAsFixed(2)} ${LocaleKeys.egp}",
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            gapH(20),
            Row(
              spacing: AppSpacing.h12,
              children: [
                Expanded(
                  child: CustomButton(
                    buttonHeight: 44,
                    title: LocaleKeys.cancel,
                    backgroundColor: context.mapCard,
                    borderColor: context.colorScheme.primary,
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    buttonHeight: 44,
                    title: LocaleKeys.save,
                    textColor: Colors.white,
                    backgroundColor: Colors.green,
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
