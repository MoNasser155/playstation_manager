import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';
import 'package:local_erp_system/core/languages/local_keys.g.dart';
import 'package:local_erp_system/core/widgets/sliver_empty_body.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../devices/data/models/device_model.dart';
import '../../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../../../sessions/data/models/session_model.dart';

class ReservedDevicesList extends StatelessWidget {
  final List<SessionModel> sessions;

  const ReservedDevicesList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.currentReservedDevices,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.secondaryFixed,
              fontWeight: FontWeight.w600,
            ),
          ),
          gapH(12),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(AppPadding.pf8),
              decoration: BoxDecoration(
                color: context.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  if (sessions.isEmpty)
                    SliverEmptyBody(title: LocaleKeys.noReservedDevices)
                  else
                    SliverList.separated(
                      itemCount: sessions.length,
                      separatorBuilder: (_, __) => gapH(8),
                      itemBuilder: (context, index) {
                        return _ReservedDeviceCard(session: sessions[index]);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservedDeviceCard extends StatelessWidget {
  final SessionModel session;

  const _ReservedDeviceCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final deviceName = session.device.target?.name;
    final start = session.sessionStartDate ?? session.sessionDate;

    return InkWell(
      onTap: () {
        if (session.device.target?.uuid.isEmpty ?? false) {
          return;
        }
        // Navigate to Sessions tab and select this device
        final mainViewCubit = MainViewCubit.get(context);
        mainViewCubit.setSelectedTap(
          1,
          send: [session.device.target ?? DeviceModel.initial()],
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppPadding.pf8),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${LocaleKeys.deviceName}:  $deviceName",
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  gapHFix(6),
                  Text(
                    "${LocaleKeys.pricePerHour}: ${session.hourlyRate.toStringAsFixed(0)} ${LocaleKeys.pricePerHourHint}",
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.secondaryFixed,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _TickingTimer(startTime: start),
                Text(
                  LocaleKeys.reserved,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.orange,
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

class _TickingTimer extends StatefulWidget {
  final DateTime startTime;

  const _TickingTimer({required this.startTime});

  @override
  State<_TickingTimer> createState() => _TickingTimerState();
}

class _TickingTimerState extends State<_TickingTimer> {
  late Timer _timer;
  late final ValueNotifier<Duration> _elapsedNotifier;

  @override
  void initState() {
    super.initState();
    final initialElapsed = clock.now().difference(widget.startTime);
    _elapsedNotifier = ValueNotifier<Duration>(initialElapsed);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _elapsedNotifier.value = clock.now().difference(widget.startTime);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _elapsedNotifier.dispose();
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
    return ValueListenableBuilder<Duration>(
      valueListenable: _elapsedNotifier,
      builder: (context, elapsed, _) {
        return Text(
          _formatDuration(elapsed),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        );
      },
    );
  }
}
