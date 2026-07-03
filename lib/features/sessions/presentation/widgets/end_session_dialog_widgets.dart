part of 'end_session_dialog.dart';

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

class _DialogHeader extends StatelessWidget {
  const _DialogHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.report_problem_outlined,
          color: context.colorScheme.primary,
          size: 28,
        ),
        gapW(8),
        Text(
          LocaleKeys.confirmEndSession,
          style: context.textTheme.bodySmall!.copyWith(
            color: context.colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TimingDetailsCard extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? endTime;
  final Duration duration;
  final double roundedCost;
  final double rawCost;

  const _TimingDetailsCard({
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

class _ItemsDetailsCard extends StatelessWidget {
  final List<SessionItem> items;

  const _ItemsDetailsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: context.textTheme.bodySmall!.copyWith(
              color: context.colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      LocaleKeys.quantity,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      LocaleKeys.total,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurface,
                        fontSize: 16,
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
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                      ),
                      child: Text(
                        item.quantity.toStringAsFixed(1),
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                      ),
                      child: Text(
                        "${item.totalItemPrice.toStringAsFixed(2)} ${LocaleKeys.egp}",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  final double roundedCost;
  final double itemsTotal;
  final double grandTotal;
  final bool hasItems;

  const _TotalsCard({
    required this.roundedCost,
    required this.itemsTotal,
    required this.grandTotal,
    required this.hasItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
              Text(
                "${roundedCost.toStringAsFixed(2)} ${LocaleKeys.egp}",
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (hasItems) ...[
            gapH(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.itemsCost,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${itemsTotal.toStringAsFixed(2)} ${LocaleKeys.egp}",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontSize: 18,
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
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${grandTotal.toStringAsFixed(2)} ${LocaleKeys.egp}",
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
