import 'package:flutter/material.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../refund_invoice_widgets/refund_items_header_row.dart';
import '../refund_invoice_widgets/refund_items_list.dart';
import '../refund_invoice_widgets/refund_save_button.dart';
import '../refund_invoice_widgets/refund_selectors_card.dart';
import '../refund_invoice_widgets/refund_summary_card.dart';

class TabletRefundInvoiceBody extends StatelessWidget {
  const TabletRefundInvoiceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        sliverGapHFix(20),
        CustomSliverPadding(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.h12,
            children: const [
              Expanded(child: RefundSelectorsCard()),
              Expanded(child: RefundSummaryCard()),
            ],
          ),
        ),
        sliverGapHFix(16),
        const RefundItemsHeaderRow(),
        const RefundItemsList(),
        sliverGapHFix(20),
        const RefundSaveButton(),
        sliverGapHFix(20),
      ],
    );
  }
}
