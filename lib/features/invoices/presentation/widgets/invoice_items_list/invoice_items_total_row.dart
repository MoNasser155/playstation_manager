import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../cubits/cubit/invoice_cubit.dart';

class InvoiceItemsTotalRow extends StatelessWidget {
  const InvoiceItemsTotalRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      buildWhen:
          (previous, current) =>
              previous.totalInvoice != current.totalInvoice ||
              previous.invoiceItems != current.invoiceItems,
      builder: (context, state) {
        if (state.invoiceItems.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.pf16,
            vertical: AppPadding.pf12,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(
              color: context.colorScheme.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: AppSpacing.h8,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: context.colorScheme.primary,
                    size: 24,
                  ),
                  Text(
                    '${LocaleKeys.numberOfItems}: ${state.invoiceItems.length}',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: AppSpacing.h8,
                children: [
                  Text(
                    LocaleKeys.total,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.pf12,
                      vertical: AppPadding.pf6,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                    child: Text(
                      state.totalInvoice.toStringAsFixed(2),
                      style: context.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
