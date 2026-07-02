import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../invoices/data/models/create_invoice_model.dart';

class CustomInvoiceCard extends StatelessWidget {
  const CustomInvoiceCard({super.key, required this.invoice});
  final CreateInvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${invoice.invoiceDate.day}/${invoice.invoiceDate.month}/${invoice.invoiceDate.year}';

    return Container(
      decoration: BoxDecoration(
        color: context.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: context.colorScheme.secondaryFixed),
      ),
      child: Column(
        children: [
          // ── Header: UUID + Date ────────────────────────────────────────
          _InvoiceHeader(uuid: invoice.uuid, date: formattedDate),

          Divider(height: 0, color: context.colorScheme.secondaryFixed),

          // ── Items column titles ────────────────────────────────────────
          _ItemsHeaderRow(),

          Divider(height: 0, color: context.colorScheme.secondaryFixed),

          // ── Items list ─────────────────────────────────────────────────
          ...invoice.items.map(
            (item) => Column(
              children: [
                _ItemRow(item: item),
                Divider(height: 0, color: context.colorScheme.secondaryFixed),
              ],
            ),
          ),

          // ── Footer: totals ─────────────────────────────────────────────
          _InvoiceFooter(invoice: invoice),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _InvoiceHeader extends StatelessWidget {
  const _InvoiceHeader({required this.uuid, required this.date});
  final String uuid;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pf12,
        vertical: AppPadding.pf10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '#${uuid.length > 8 ? uuid.substring(0, 8).toUpperCase() : uuid.toUpperCase()}',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 14,
                color: context.colorScheme.onSurfaceVariant,
              ),
              gapWFix(4),
              Text(
                date,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Items header row ──────────────────────────────────────────────────────────

class _ItemsHeaderRow extends StatelessWidget {
  const _ItemsHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.pf8,
        horizontal: AppPadding.pf8,
      ),
      child: Row(
        spacing: AppSpacing.h12,
        children: List.generate(
          4,
          (index) => _RowCell(
            text: switch (index) {
              0 => 'الصنف',
              1 => 'السعر',
              2 => 'الكمية',
              _ => 'الإجمالي',
            },
            index: index,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Item row ──────────────────────────────────────────────────────────────────

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final ItemsInvoice item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.pf10,
        horizontal: AppPadding.pf8,
      ),
      child: Row(
        spacing: AppSpacing.h12,
        children: List.generate(
          4,
          (index) => _RowCell(
            text: switch (index) {
              0 => item.storageItem.target?.itemName ?? '—',
              1 => item.sellPrice.toStringAsFixed(2),
              2 =>
                item.quantity % 1 == 0
                    ? item.quantity.toInt().toString()
                    : item.quantity.toStringAsFixed(2),
              _ => item.totalItemPrice.toStringAsFixed(2),
            },
            index: index,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared cell ───────────────────────────────────────────────────────────────

class _RowCell extends StatelessWidget {
  const _RowCell({required this.text, required this.index, this.style});
  final String text;
  final int index;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isLast = index == 3;

    return Expanded(
      flex: index == 0 ? 3 : 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right:
                isLast
                    ? BorderSide.none
                    : context.isRtl
                    ? BorderSide.none
                    : BorderSide(
                      color: context.colorScheme.secondaryFixed,
                      width: 1.5,
                    ),
            left:
                isLast
                    ? BorderSide.none
                    : context.isRtl
                    ? BorderSide(
                      color: context.colorScheme.secondaryFixed,
                      width: 1.5,
                    )
                    : BorderSide.none,
          ),
        ),
        child: Text(text, style: style),
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _InvoiceFooter extends StatelessWidget {
  const _InvoiceFooter({required this.invoice});
  final CreateInvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final hasDebt = invoice.laterPaid > 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pf12,
        vertical: AppPadding.pf12,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryFixed.withValues(alpha: 0.3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r16),
          bottomRight: Radius.circular(AppRadius.r16),
        ),
      ),
      child: Column(
        children: [
          _FooterAmountRow(
            label: 'إجمالي الفاتورة',
            amount: invoice.totalInvoice,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          gapHFix(6),
          _FooterAmountRow(
            label: 'المدفوع نقداً',
            amount: invoice.cashPaid,
            amountColor: Colors.green,
          ),
          if (hasDebt) ...[
            gapHFix(6),
            _FooterAmountRow(
              label: 'المتبقي (آجل)',
              amount: invoice.laterPaid,
              amountColor: context.colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }
}

class _FooterAmountRow extends StatelessWidget {
  const _FooterAmountRow({
    required this.label,
    required this.amount,
    this.style,
    this.amountColor,
  });

  final String label;
  final double amount;
  final TextStyle? style;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = context.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
    );
    final resolvedStyle = style ?? defaultStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: resolvedStyle),
        Text(
          '${amount.toStringAsFixed(2)} ج',
          style: resolvedStyle?.copyWith(color: amountColor),
        ),
      ],
    );
  }
}
