import 'package:flutter/material.dart';

import '../../../../../core/utils/gaps.dart';
import '../invoice_items_list/invoice_item_add_button.dart';
import '../invoice_items_list/invoice_items_header_row.dart';
import '../invoice_items_list/invoice_items_list.dart';
import '../main_invoice_data_holder.dart';

class DesktopInvoiceBody extends StatelessWidget {
  const DesktopInvoiceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        sliverGapHFix(20),
        const MainInvoiceDataHolder(),
        sliverGapHFix(12),
        const InvoiceItemsHeaderRow(),
        const InvoiceItemsList(),
        sliverGapHFix(8),
        const InvoiceItemAddButton(),
        sliverGapHFix(20),
      ],
    );
  }
}
