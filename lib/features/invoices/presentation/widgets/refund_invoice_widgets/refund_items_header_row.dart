import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../../cubits/refund_cubit/refund_invoice_cubit.dart';
import 'refund_cell.dart';

class RefundItemsHeaderRow extends StatelessWidget {
  const RefundItemsHeaderRow({super.key});

  List<String> get _labels => [
    LocaleKeys.itemName,
    LocaleKeys.refundPrice,
    LocaleKeys.quantity,
    LocaleKeys.total,
  ];

  @override
  Widget build(BuildContext context) {
    // Only shown when an invoice is selected — driven by parent BlocBuilder.
    return BlocBuilder<RefundInvoiceCubit, RefundInvoiceState>(
      buildWhen: (prev, cur) => prev.selectedInvoice != cur.selectedInvoice,
      builder: (context, state) {
        if (state.selectedInvoice == null) return const SliverToBoxAdapter();
        return CustomSliverPadding(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: AppPadding.pf16,
              horizontal: AppPadding.pf8,
            ),
            decoration: BoxDecoration(
              color: context.primaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.r16),
                topRight: Radius.circular(AppRadius.r16),
              ),
              border: Border(
                bottom: BorderSide(color: context.colorScheme.secondaryFixed),
              ),
            ),
            child: Row(
              spacing: AppSpacing.h12,
              children: [
                ...List.generate(
                  _labels.length,
                  (i) => RefundCell(
                    index: i,
                    child: Text(
                      _labels[i],
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                gapWFix(24), // spacer for delete column
              ],
            ),
          ),
        );
      },
    );
  }
}
