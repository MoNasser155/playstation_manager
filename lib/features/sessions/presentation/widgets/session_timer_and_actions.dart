import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/device_status.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubits/cubit/session_cubit.dart';
import 'end_session_dialog.dart';

class SessionTimerAndActions extends StatelessWidget {
  const SessionTimerAndActions({super.key, this.isDesktop = false});
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen: (previous, current) {
        return previous.selectedDevice != current.selectedDevice ||
            previous.isSessionActive != current.isSessionActive ||
            previous.sessionDuration != current.sessionDuration ||
            previous.sessionCost != current.sessionCost;
      },
      builder: (context, state) {
        if (state.selectedDevice == null) {
          if (isDesktop) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppPadding.pf16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_esports_outlined,
                      size: 48,
                      color: context.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    gapH(16),
                    Text(
                      LocaleKeys.selectDevice,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final cubit = SessionCubit.get(context);
        final device = state.selectedDevice!;

        if (isDesktop) {
          return Padding(
            padding: EdgeInsets.all(AppPadding.pf4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        device.name,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.pf8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: device.status.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                        border: Border.all(
                          color: device.status.color,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        device.status.localizedName,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: device.status.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Expanded(
                  child: Center(
                    child: Builder(
                      builder: (context) {
                        if (state.isSessionActive) {
                          String formatDuration(Duration duration) {
                            String twoDigits(int n) =>
                                n.toString().padLeft(2, '0');
                            final hours = twoDigits(duration.inHours);
                            final minutes = twoDigits(
                              duration.inMinutes.remainder(60),
                            );
                            final seconds = twoDigits(
                              duration.inSeconds.remainder(60),
                            );
                            return "$hours:$minutes:$seconds";
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.sessionDuration,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              gapH(8),
                              Text(
                                formatDuration(state.sessionDuration),
                                style: context.textTheme.headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontFamily: 'monospace',
                                    ),
                              ),
                            ],
                          );
                        } else if (device.status == DeviceStatus.available) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                size: 64,
                                color: Colors.green.withValues(alpha: 0.8),
                              ),
                              gapH(16),
                              Text(
                                LocaleKeys.available,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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

        // Compact mobile/tablet style
        if (state.isSessionActive) {
          String formatDuration(Duration duration) {
            String twoDigits(int n) => n.toString().padLeft(2, '0');
            final hours = twoDigits(duration.inHours);
            final minutes = twoDigits(duration.inMinutes.remainder(60));
            final seconds = twoDigits(duration.inSeconds.remainder(60));
            return "$hours:$minutes:$seconds";
          }

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
                      formatDuration(state.sessionDuration),
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
          return Column(
            children: [
              gapH(12),
              CustomButton(
                title: LocaleKeys.startSession,
                backgroundColor: Colors.green,
                onTap: () {
                  cubit.startSession(context);
                },
              ),
            ],
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
      },
    );
  }
}
