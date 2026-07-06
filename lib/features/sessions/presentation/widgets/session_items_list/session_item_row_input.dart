import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../cubits/cubit/session_cubit.dart';
import 'session_item_dropdown.dart';
import 'session_item_text_field.dart';

class SessionItemRowInput extends StatelessWidget {
  const SessionItemRowInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = SessionCubit.get(context);

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
            child: BlocBuilder<SessionCubit, SessionState>(
              buildWhen:
                  (p, c) =>
                      p.selectedStorageItem != c.selectedStorageItem ||
                      p.sessionModels.storageItems !=
                          c.sessionModels.storageItems,
              builder: (context, state) {
                return SessionItemDropdown(
                  selectedItem: state.selectedStorageItem,
                  onChanged: cubit.selectItem,
                );
              },
            ),
          ),
          BlocBuilder<SessionCubit, SessionState>(
            buildWhen: (p, c) => p.selectedStorageItem != c.selectedStorageItem,
            builder: (context, state) {
              return Expanded(
                flex: 2,
                child: SessionItemTextField(
                  hint: LocaleKeys.price,
                  controller: cubit.sellPriceController,
                  onChanged: (_) => cubit.updateInputTotal(context),
                ),
              );
            },
          ),
          Expanded(
            flex: 2,
            child: BlocBuilder<SessionCubit, SessionState>(
              buildWhen:
                  (p, c) => p.selectedStorageItem != c.selectedStorageItem,
              builder: (context, state) {
                return SessionItemTextField(
                  hint: LocaleKeys.quantity,
                  controller: cubit.quantityController,
                  onChanged: (_) => cubit.updateInputTotal(context),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: BlocBuilder<SessionCubit, SessionState>(
              buildWhen: (p, c) => p.currentInputTotal != c.currentInputTotal,
              builder: (context, state) {
                return SessionItemTextField(
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
