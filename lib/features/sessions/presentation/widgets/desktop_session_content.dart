import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/device_status.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubits/cubit/session_cubit.dart';
import 'desktop_session_header.dart';
import 'end_session_dialog.dart';
import 'session_timer_display.dart';

class DesktopSessionContent extends StatelessWidget {
  const DesktopSessionContent({super.key, required this.state});

  final SessionState state;

  @override
  Widget build(BuildContext context) {
    final cubit = SessionCubit.get(context);
    final device = state.selectedDevice!;

    return Padding(
      padding: EdgeInsets.all(AppPadding.pf4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DesktopSessionHeader(device: device),
          const Divider(height: 32),
          Expanded(
            child: Center(
              child: Builder(
                builder: (context) {
                  if (state.isSessionActive) {
                    return SessionTimerDisplay(
                      duration: state.sessionDuration,
                      label: LocaleKeys.sessionDuration,
                    );
                  } else if (device.status == DeviceStatus.available) {
                    return SessionTimerDisplay(
                      duration: Duration.zero,
                      label: LocaleKeys.sessionDuration,
                    );
                  } else if (device.status == DeviceStatus.maintenance) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.build_outlined,
                          size: 64,
                          color: context.colorScheme.error.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        gapH(16),
                        Text(
                          LocaleKeys.maintenance,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          const Divider(height: 32),
          if (state.isSessionActive)
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
            )
          else if (device.status == DeviceStatus.available)
            CustomButton(
              title: LocaleKeys.startSession,
              backgroundColor: Colors.green,
              onTap: () {
                cubit.startSession(context);
              },
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
