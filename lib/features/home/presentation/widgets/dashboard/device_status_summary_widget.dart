import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/enums/device_status.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../devices/data/models/device_model.dart';

class DeviceStatusSummaryWidget extends StatelessWidget {
  final List<DeviceModel> devices;

  const DeviceStatusSummaryWidget({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    int availableCount = 0;
    int reservedCount = 0;
    int maintenanceCount = 0;

    for (final device in devices) {
      switch (device.status) {
        case DeviceStatus.available:
          availableCount++;
          break;
        case DeviceStatus.reserved:
          reservedCount++;
          break;
        case DeviceStatus.maintenance:
          maintenanceCount++;
          break;
      }
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 110, minHeight: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LocaleKeys.devicesStatus}:  ${devices.length}',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.secondaryFixed,
              fontWeight: FontWeight.w600,
            ),
          ),
          gapH(16),
          Expanded(
            child: Row(
              spacing: AppSpacing.h16,
              children: [
                Expanded(
                  child: _StatusItem(
                    count: availableCount,
                    status: DeviceStatus.available,
                  ),
                ),
                Expanded(
                  child: _StatusItem(
                    count: reservedCount,
                    status: DeviceStatus.reserved,
                  ),
                ),
                Expanded(
                  child: _StatusItem(
                    count: maintenanceCount,
                    status: DeviceStatus.maintenance,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final int count;
  final DeviceStatus status;

  const _StatusItem({required this.count, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.pf16),
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                count.toString(),
                style: context.textTheme.displayLarge?.copyWith(
                  fontSize: 96,
                  color: status.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          gapH(6),
          Text(
            status.localizedName,
            style: context.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}
