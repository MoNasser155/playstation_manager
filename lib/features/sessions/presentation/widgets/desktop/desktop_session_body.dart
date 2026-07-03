import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/utils/gaps.dart';
import '../main_session_data_holder.dart';
import '../session_items_list/session_item_add_button.dart';
import '../session_items_list/session_items_header_row.dart';
import '../session_items_list/session_items_list.dart';
import '../session_timer_and_actions.dart';

class DesktopSessionBody extends StatelessWidget {
  const DesktopSessionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gapHFix(20),
        const MainSessionDataHolder(showTimerAndActions: false),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                    start: AppPadding.pf20,
                    top: AppPadding.pf12,
                    bottom: AppPadding.pf20,
                  ),
                  padding: EdgeInsets.all(AppPadding.pf8),
                  decoration: BoxDecoration(
                    color: context.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                  child: const SessionTimerAndActions(isDesktop: true),
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomScrollView(
                  slivers: [
                    sliverGapHFix(12),
                    const SessionItemsHeaderRow(),
                    const SessionItemsList(),
                    sliverGapHFix(8),
                    const SessionItemAddButton(),
                    sliverGapHFix(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
