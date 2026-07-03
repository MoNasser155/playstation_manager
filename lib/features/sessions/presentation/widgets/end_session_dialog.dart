import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../data/models/session_model.dart';
import '../cubits/cubit/session_cubit.dart';

part 'end_session_dialog_widgets.dart';

class EndSessionDialog extends StatelessWidget {
  const EndSessionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        final device = state.selectedDevice;
        if (device == null || state.activeSession == null) {
          return const SizedBox.shrink();
        }

        final startTime = state.activeSession!.sessionStartDate;
        final endTime = state.sessionEndTime;
        final duration = state.sessionDuration;
        final roundedCost = state.roundedSessionCost;
        final rawCost = state.sessionCost;
        final items = state.sessionItems;

        final itemsTotal = items.fold<double>(
          0.0,
          (s, e) => s + e.totalItemPrice,
        );
        final grandTotal = roundedCost + itemsTotal;

        return CustomDialog(
          maxWidth: context.width * 0.5,
          children: [
            const _DialogHeader(),
            gapH(16),
            const Divider(),
            gapH(12),
            _TimingDetailsCard(
              startTime: startTime,
              endTime: endTime,
              duration: duration,
              roundedCost: roundedCost,
              rawCost: rawCost,
            ),
            if (items.isNotEmpty) ...[
              gapH(16),
              _ItemsDetailsCard(items: items),
            ],
            gapH(16),
            _TotalsCard(
              roundedCost: roundedCost,
              itemsTotal: itemsTotal,
              grandTotal: grandTotal,
              hasItems: items.isNotEmpty,
            ),
            gapH(20),
            const _ActionButtons(),
          ],
        );
      },
    );
  }
}
