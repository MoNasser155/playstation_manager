import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';

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

class TimingDetailsCard extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? endTime;
  final Duration duration;
  final double roundedCost;
  final double rawCost;

  const TimingDetailsCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.roundedCost,
    required this.rawCost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.pf12),
      decoration: BoxDecoration(
        color: context.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(
          color: context.colorScheme.secondaryFixed.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.sessionDuration,
            style: context.textTheme.bodySmall!.copyWith(
              color: context.colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          gapH(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.startTime,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
              Text(
                _formatTime(startTime),
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          gapH(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.endTime,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
              Text(
                _formatTime(endTime),
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          gapH(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.sessionDurationSummary,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
              Text(
                _formatDuration(duration),
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          gapH(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.sessionCost,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${roundedCost.toStringAsFixed(2)} ${LocaleKeys.egp}",
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (rawCost != roundedCost)
                    Text(
                      "(${rawCost.toStringAsFixed(2)} ${LocaleKeys.egp})",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.secondaryFixed,
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
