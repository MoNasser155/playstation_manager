import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../cubits/cubit/invoice_cubit.dart';
import 'invoice_item_dropdown.dart';
import 'invoice_item_text_field.dart';

class InvoiceItemRowInput extends StatelessWidget {
  const InvoiceItemRowInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = InvoiceCubit.get(context);

    return Container(
      decoration: BoxDecoration(
        color: context.primaryContainer,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r16),
          bottomRight: Radius.circular(AppRadius.r16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: BlocBuilder<InvoiceCubit, InvoiceState>(
              buildWhen:
                  (p, c) =>
                      p.selectedStorageItem != c.selectedStorageItem ||
                      p.invoiceModels.storageItems !=
                          c.invoiceModels.storageItems,
              builder: (context, state) {
                return InvoiceItemDropdown(
                  selectedItem: state.selectedStorageItem,
                  onChanged: cubit.selectItem,
                );
              },
            ),
          ),
          BlocBuilder<InvoiceCubit, InvoiceState>(
            buildWhen: (p, c) => p.selectedStorageItem != c.selectedStorageItem,
            builder: (context, state) {
              return Expanded(
                flex: 2,
                child: InvoiceItemTextField(
                  hint: LocaleKeys.price,
                  controller: cubit.sellPriceController,
                  onChanged: (_) => cubit.updateInputTotal(context),
                ),
              );
            },
          ),
          Expanded(
            flex: 2,
            child: BlocBuilder<InvoiceCubit, InvoiceState>(
              buildWhen:
                  (p, c) => p.selectedStorageItem != c.selectedStorageItem,
              builder: (context, state) {
                return InvoiceItemTextField(
                  hint: LocaleKeys.quantity,
                  controller: cubit.quantityController,
                  onChanged: (_) => cubit.updateInputTotal(context),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: BlocBuilder<InvoiceCubit, InvoiceState>(
              buildWhen: (p, c) => p.currentInputTotal != c.currentInputTotal,
              builder: (context, state) {
                return InvoiceItemTextField(
                  isLastColumn: true,
                  readonly: true,
                  initial:
                      state.currentInputTotal > 0
                          ? state.currentInputTotal.toStringAsFixed(2)
                          : '',
                  hint: '0.00',
                );
              },
            ),
          ),
          gapWFix(48),
        ],
      ),
    );
  }
}
