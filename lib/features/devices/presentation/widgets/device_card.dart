import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/device_status.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../data/models/device_model.dart';
import '../cubits/devices_cubit/devices_cubit.dart';
import 'add_edit_device_dialog.dart';
import 'custom_delete_device_dialog.dart';

class DeviceCard extends StatefulWidget {
  const DeviceCard({super.key, required this.device});

  final DeviceModel device;

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant DeviceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _startTimerIfNeeded();
  }

  void _startTimerIfNeeded() {
    _timer?.cancel();
    if (widget.device.status == DeviceStatus.reserved) {
      _updateTimer();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _updateTimer();
          });
        }
      });
    }
  }

  void _updateTimer() {
    final devicesCubit = context.read<DevicesCubit>();
    final startDate =
        devicesCubit.state.activeSessionStartDates[widget.device.uuid];
    if (startDate != null) {
      _elapsed = DateTime.now().difference(startDate);
    } else {
      _elapsed = Duration.zero;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    final statusColor = widget.device.status.color;

    return InkWell(
      onTap: () {
        if (widget.device.uuid.isEmpty) return;
        // Navigate to Invoices tab and select this device
        final mainViewCubit = MainViewCubit.get(context);
        mainViewCubit.setSelectedTap(1, send: [widget.device]);
      },
      child: Container(
        padding: EdgeInsets.all(AppRadius.r12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(
            width: 1.3,
            color:
                widget.device.status == DeviceStatus.maintenance
                    ? context.colorScheme.error
                    : Colors.transparent,
          ),
          color: context.primaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.device.type.icon,
                  size: 32.sp,
                  color: context.colorScheme.secondary,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    widget.device.status.localizedName,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            gapH(12),
            Text(
              widget.device.name.isEmpty ? '---' : widget.device.name,
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            gapH(4),
            Text(
              '${widget.device.hourlyRate} ${LocaleKeys.egp}/${LocaleKeys.hour}',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.secondaryFixed,
                fontSize: 13.sp,
              ),
            ),
            const Spacer(),
            if (widget.device.status == DeviceStatus.reserved) ...[
              // Active session indicator
              Center(
                child: StreamBuilder<int>(
                  stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
                  builder: (context, snapshot) {
                    _updateTimer();
                    return Text(
                      _formatDuration(_elapsed),
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 18.sp,
                      ),
                    );
                  },
                ),
              ),
            ],
            gapH(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => AddEditDeviceDialog(device: widget.device),
                    );
                    if (result == true) {
                      if (context.mounted) {
                        DevicesCubit.get(context).refresh();
                      }
                    }
                  },
                  child: Icon(
                    Icons.edit_rounded,
                    color: context.colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final cubit = DevicesCubit.get(context);
                    final result = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => CustomDeleteDeviceDialog(
                            onTap: () {
                              cubit.deleteDevice(widget.device.uuid, context);
                            },
                            device: widget.device,
                          ),
                    );
                    if (result == true) {
                      cubit.refresh();
                    }
                  },
                  child: Icon(
                    Icons.delete_rounded,
                    color: context.colorScheme.error,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
