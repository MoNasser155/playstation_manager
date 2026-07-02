import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/features/invoices/presentation/widgets/invoice_items_list/invoice_items_total_row.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../cubits/cubit/invoice_cubit.dart';

class InvoiceItemAddButton extends StatelessWidget {
  const InvoiceItemAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      buildWhen:
          (previous, current) => previous.canAddItem != current.canAddItem,
      builder: (context, state) {
        final cubit = InvoiceCubit.get(context);
        final enabled = state.canAddItem;

        return CustomSliverPadding(
          verticalPadding: AppSpacing.h8,
          child: Row(
            spacing: AppSpacing.h12,
            children: [
              Expanded(flex: 3, child: InvoiceItemsTotalRow()),
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: enabled ? 1.0 : 0.4,
                  child: CustomButton(
                    onTap: enabled ? cubit.addInvoiceItem : null,
                    title: LocaleKeys.addItem,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
