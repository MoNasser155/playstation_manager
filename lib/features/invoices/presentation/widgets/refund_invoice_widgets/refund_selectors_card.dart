import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/expanded_drop_down.dart';
import '../../../../customers/data/models/customer_model.dart';
import '../../../data/models/create_invoice_model.dart';
import '../../cubits/refund_cubit/refund_invoice_cubit.dart';

class RefundSelectorsCard extends StatelessWidget {
  const RefundSelectorsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundInvoiceCubit, RefundInvoiceState>(
      buildWhen:
          (prev, cur) =>
              prev.customers != cur.customers ||
              prev.selectedCustomer != cur.selectedCustomer ||
              prev.customerInvoices != cur.customerInvoices ||
              prev.selectedInvoice != cur.selectedInvoice,
      builder: (context, state) {
        final cubit = RefundInvoiceCubit.get(context);

        return Container(
          padding: EdgeInsets.all(AppPadding.pf8),
          decoration: BoxDecoration(
            color: context.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          child: Column(
            spacing: AppSpacing.v12,
            children: [
              // Customer dropdown
              ExpandedDropdown<CustomerModel>(
                withSearch: true,
                hint: LocaleKeys.selectCustomer,
                items: state.customers,
                isEnabled: state.customers.isNotEmpty,
                selectedValue: state.selectedCustomer?.name,
                backgroundColor: context.mapCard,
                searchFieldColor: context.mapCard,
                itemLabelBuilder: (c) => c.name,
                onChanged: (val) {
                  if (val != null) cubit.setCustomer(context, val);
                },
              ),
              // Invoice dropdown
              ExpandedDropdown<CreateInvoiceModel>(
                withSearch: true,
                hint:
                    state.selectedCustomer == null
                        ? LocaleKeys.pleaseSelectCustomer
                        : state.customerInvoices.isEmpty
                        ? LocaleKeys.noInvoicesForCustomer
                        : LocaleKeys.selectInvoice,
                items: state.customerInvoices,
                isEnabled: state.customerInvoices.isNotEmpty,
                selectedValue:
                    state.selectedInvoice != null
                        ? '${state.selectedInvoice!.uuid.substring(0, 8)}... '
                            '(${state.selectedInvoice!.totalInvoice.toStringAsFixed(2)}'
                            ' - ${state.selectedInvoice!.paymentType.localizedName})'
                        : null,
                backgroundColor: context.mapCard,
                searchFieldColor: context.mapCard,
                itemLabelBuilder:
                    (inv) =>
                        'ID: ${inv.uuid.substring(0, 8)}... '
                        '- ${inv.totalInvoice.toStringAsFixed(2)} '
                        '- ${inv.invoiceDate.toFullFormattedDate}',
                onChanged: (val) {
                  if (val != null) cubit.selectInvoice(val);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
