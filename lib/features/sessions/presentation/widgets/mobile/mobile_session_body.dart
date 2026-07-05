import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/features/sessions/presentation/widgets/sessions_list_view.dart';

import '../../../../../core/utils/gaps.dart';
import '../../cubits/cubit/session_cubit.dart';
import '../main_session_data_holder.dart';
import '../session_items_list/session_item_add_button.dart';
import '../session_items_list/session_items_header_row.dart';
import '../session_items_list/session_items_list.dart';

class MobileSessionBody extends StatelessWidget {
  const MobileSessionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, int>(
      selector: (state) => state.currentTapIndex,
      builder: (context, currentTapIndex) {
        switch (currentTapIndex) {
          case 0:
            return CustomScrollView(
              slivers: [
                sliverGapHFix(20),
                const MainSessionDataHolder(),
                sliverGapHFix(12),
                const SessionItemsHeaderRow(),
                const SessionItemsList(),
                sliverGapHFix(8),
                const SessionItemAddButton(),
                sliverGapHFix(20),
              ],
            );
          case 1:
            return const SessionsListView();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
