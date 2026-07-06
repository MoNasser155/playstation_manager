import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/media_query_extenstions.dart';

import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_dialog.dart';
import '../../cubits/cubit/session_cubit.dart';
import 'action_buttons.dart';
import 'dialog_header.dart';
import 'items_details_card.dart';
import 'timing_details_card.dart';
import 'totals_card.dart';

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
            const DialogHeader(),
            gapH(16),
            const Divider(),
            gapH(12),
            TimingDetailsCard(
              startTime: startTime,
              endTime: endTime,
              duration: duration,
              roundedCost: roundedCost,
              rawCost: rawCost,
            ),
            if (items.isNotEmpty) ...[gapH(16), ItemsDetailsCard(items: items)],
            gapH(16),
            TotalsCard(
              roundedCost: roundedCost,
              itemsTotal: itemsTotal,
              grandTotal: grandTotal,
              hasItems: items.isNotEmpty,
            ),
            gapH(20),
            const ActionButtons(),
          ],
        );
      },
    );
  }
}
