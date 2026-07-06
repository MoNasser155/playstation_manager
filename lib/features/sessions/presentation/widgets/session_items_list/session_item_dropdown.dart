import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/expanded_drop_down.dart';
import '../../../../storage/data/models/storage_model.dart';
import '../../cubits/cubit/session_cubit.dart';

class SessionItemDropdown extends StatelessWidget {
  const SessionItemDropdown({super.key, this.selectedItem, this.onChanged});

  final StorageModel? selectedItem;
  final ValueChanged<StorageModel?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen:
          (previous, current) =>
              previous.sessionModels.storageItems !=
                  current.sessionModels.storageItems ||
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
              state.sessionModels.storageItems.isEmpty
                  ? LocaleKeys.noItems
                  : LocaleKeys.selectItem,
          selectedValue: selectedItem?.itemName,
          items: state.sessionModels.storageItems,
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
