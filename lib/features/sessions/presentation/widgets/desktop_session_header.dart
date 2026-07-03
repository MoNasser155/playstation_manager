import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../devices/data/models/device_model.dart';

class DesktopSessionHeader extends StatelessWidget {
  const DesktopSessionHeader({super.key, required this.device});
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            device.name,
            style: context.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.pf12,
            vertical: AppPadding.pf4,
          ),
          decoration: BoxDecoration(
            color: device.status.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: device.status.color, width: 1),
          ),
          child: Text(
            device.status.localizedName,
            style: context.textTheme.titleLarge?.copyWith(
              color: device.status.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
