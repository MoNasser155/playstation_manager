import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/enums/payment_type.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../cubits/refund_cubit/refund_invoice_cubit.dart';

class RefundSummaryCard extends StatelessWidget {
  const RefundSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundInvoiceCubit, RefundInvoiceState>(
      buildWhen:
          (prev, cur) =>
              prev.selectedInvoice != cur.selectedInvoice ||
              prev.totalRefundAmount != cur.totalRefundAmount ||
              prev.newLaterPaid != cur.newLaterPaid,
      builder: (context, state) {
        final cubit = RefundInvoiceCubit.get(context);
        final invoice = state.selectedInvoice;

        return Container(
          padding: EdgeInsets.all(AppPadding.pf12),
          decoration: BoxDecoration(
            color: context.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          child: Column(
            spacing: AppSpacing.v8,
            children: [
              _SummaryRow(
                label: LocaleKeys.date,
                value:
                    invoice != null
                        ? invoice.invoiceDate.toFullFormattedDate
                        : DateTime.now().toFullFormattedDate,
              ),
              _SummaryRow(
                label: LocaleKeys.total,
                value:
                    invoice != null
                        ? invoice.totalInvoice.toStringAsFixed(2)
                        : '0.00',
              ),
              if (invoice != null &&
                  invoice.paymentType == PaymentType.later) ...[
                _SummaryRow(
                  label: LocaleKeys.paidAmount,
                  value: invoice.cashPaid.toStringAsFixed(2),
                ),
                _SummaryRow(
                  label: LocaleKeys.laterAmount,
                  value: invoice.laterPaid.toStringAsFixed(2),
                ),
              ],
              if (invoice != null) ...[
                Divider(color: context.colorScheme.secondaryFixed),
                _SummaryRow(
                  label: LocaleKeys.refundAmount,
                  value: state.totalRefundAmount.toStringAsFixed(2),
                  valueColor: context.colorScheme.error,
                ),
                if (invoice.paymentType == PaymentType.later) ...[
                  gapH(4),
                  CustomTextField(
                    controller: cubit.paidCashController,
                    inputType: TextInputType.number,
                    hint: LocaleKeys.paidNow,
                    onChange: (_) => cubit.updateCashPaid(),
                    fillColor: context.mapCard,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.pf8,
                      vertical: AppPadding.pf8,
                    ),
                    decoration: BoxDecoration(
                      color: context.mapCard,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      border: Border.all(
                        color: context.colorScheme.secondaryFixed,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.laterAmount,
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          state.newLaterPaid.toStringAsFixed(2),
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

// ── Private summary row ────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: context.textTheme.titleLarge)),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(AppPadding.pf8),
            decoration: BoxDecoration(
              color: context.primaryContainer,
              border: Border.all(color: context.colorScheme.secondaryFixed),
              borderRadius: BorderRadius.circular(AppRadius.r4),
            ),
            child: Text(
              value,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor ?? context.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
