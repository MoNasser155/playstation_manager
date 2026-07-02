import 'package:flutter/material.dart';

import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/transactions/custom_details_transaction_header.dart';
import 'supplier_details_transactions_list.dart';

class SupplierDetailsTransactionsSection extends StatelessWidget {
  const SupplierDetailsTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          const CustomDetailsTransactionsHeader(),
          const SupplierDetailsTransactionsList(),
          sliverGapHFix(12),
        ],
      ),
    );
  }
}
