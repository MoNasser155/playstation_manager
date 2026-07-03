import 'package:flutter/material.dart';

import '../../../../../core/utils/gaps.dart';
import '../session_items_list/session_item_add_button.dart';
import '../session_items_list/session_items_header_row.dart';
import '../session_items_list/session_items_list.dart';
import '../main_session_data_holder.dart';

class DesktopSessionBody extends StatelessWidget {
  const DesktopSessionBody({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
