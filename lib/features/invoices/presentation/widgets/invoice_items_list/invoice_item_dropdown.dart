import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/expanded_drop_down.dart';
import '../../../../storage/data/models/storage_model.dart';
import '../../cubits/cubit/invoice_cubit.dart';

class InvoiceItemDropdown extends StatelessWidget {
  const InvoiceItemDropdown({super.key, this.selectedItem, this.onChanged});

  final StorageModel? selectedItem;
  final ValueChanged<StorageModel?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      buildWhen:
          (previous, current) =>
              previous.invoiceModels.storageItems !=
                  current.invoiceModels.storageItems ||
              previous.selectedStorageItem != current.selectedStorageItem,
      builder: (context, state) {
        return ExpandedDropdown<StorageModel>(
          withSearch: true,
          searchFieldColor: context.mapCard,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                bottomRight:
                    context.isRtl
                        ? Radius.circular(AppRadius.r16)
                        : Radius.zero,
                bottomLeft:
                    context.isRtl
                        ? Radius.zero
                        : Radius.circular(AppRadius.r16),
              ),
            ),
          ),
          hint:
              state.invoiceModels.storageItems.isEmpty
                  ? LocaleKeys.noItems
                  : LocaleKeys.selectItem,
          selectedValue: selectedItem?.itemName,
          items: state.invoiceModels.storageItems,
          itemLabelBuilder: (p) {
            return p.itemName;
          },
          itemSublabelBuilder: (p) {
            final qtyStr = p.quantity.toStringAsFixed(2);
            return '${LocaleKeys.quantity}: $qtyStr ${p.type.localizedName}';
          },
          onChanged: onChanged,
        );
      },
    );
  }
}
