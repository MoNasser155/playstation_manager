import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubit/session_cubit.dart';
import 'desktop_session_content.dart';
import 'device_not_selected_placeholder.dart';
import 'mobile_session_content.dart';

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
            return const DeviceNotSelectedPlaceholder();
          }
          return const SizedBox.shrink();
        }

        if (isDesktop) {
          return DesktopSessionContent(state: state);
        }

        return MobileSessionContent(state: state);
      },
    );
  }
}

