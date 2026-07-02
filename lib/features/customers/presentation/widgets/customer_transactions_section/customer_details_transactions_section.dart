import 'package:flutter/material.dart';

import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/transactions/custom_details_transaction_header.dart';
import 'customer_details_transactions_list.dart';

class CustomerDetailsTransactionsSection extends StatelessWidget {
  const CustomerDetailsTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          const CustomDetailsTransactionsHeader(),
          const CustomerDetailsTransactionsList(),
          sliverGapHFix(12),
        ],
      ),
    );
  }
}
