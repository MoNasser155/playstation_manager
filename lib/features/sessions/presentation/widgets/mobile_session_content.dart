import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/device_status.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubits/cubit/session_cubit.dart';
import 'end_session_dialog/end_session_dialog.dart';

class MobileSessionContent extends StatelessWidget {
  const MobileSessionContent({super.key, required this.state});

  final SessionState state;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final cubit = SessionCubit.get(context);
    final device = state.selectedDevice!;

    if (state.isSessionActive) {
      return Container(
        padding: EdgeInsets.all(AppPadding.pf12),
        margin: EdgeInsets.only(top: AppPadding.pf12),
        decoration: BoxDecoration(
          color: context.mapCard,
          borderRadius: BorderRadius.circular(AppRadius.r8),
          border: Border.all(color: Colors.orange, width: 1.2),
        ),
        child: Column(
          spacing: AppSpacing.v8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.sessionDuration,
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  _formatDuration(state.sessionDuration),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            gapH(4),
            CustomButton(
              title: LocaleKeys.endSession,
              backgroundColor: context.colorScheme.error,
              onTap: () async {
                await cubit.endSession(context);
                if (context.mounted) {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => BlocProvider.value(
                          value: cubit,
                          child: const EndSessionDialog(),
                        ),
                  );
                  if (result == true) {
                    if (context.mounted) {
                      await cubit.confirmEndSession(context);
                    }
                  } else {
                    cubit.cancelEndSession();
                  }
                }
              },
            ),
          ],
        ),
      );
    } else if (device.status == DeviceStatus.available) {
      return Container(
        padding: EdgeInsets.all(AppPadding.pf12),
        margin: EdgeInsets.only(top: AppPadding.pf12),
        decoration: BoxDecoration(
          color: context.mapCard,
          borderRadius: BorderRadius.circular(AppRadius.r8),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.5),
            width: 1.2,
          ),
        ),
        child: Column(
          spacing: AppSpacing.v8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.sessionDuration,
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  "00:00:00",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            gapH(4),
            CustomButton(
              title: LocaleKeys.startSession,
              backgroundColor: Colors.green,
              onTap: () {
                cubit.startSession(context);
              },
            ),
          ],
        ),
      );
    } else if (device.status == DeviceStatus.maintenance) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(top: AppPadding.pf12),
        decoration: BoxDecoration(
          color: context.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.r8),
          border: Border.all(color: context.colorScheme.error),
        ),
        child: Text(
          LocaleKeys.maintenance,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
