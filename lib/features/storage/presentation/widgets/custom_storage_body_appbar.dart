import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubits/storage_cubit/storage_cubit.dart';
import 'add_storage_item/custom_add_new_storage_item.dart';

class CustomStorageBodyAppbar extends StatelessWidget {
  const CustomStorageBodyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverAppbar(
      applyPadding: true,
      collapsedHeight: 64,
      flexibleWidget: Column(
        children: [
          gapHFix(8),
          Row(
            spacing: AppSpacing.h12,
            children: [
              Expanded(
                flex: 8,
                child: BlocSelector<StorageCubit, StorageState, StateStatus>(
                  selector: (state) {
                    return state.status;
                  },
                  builder: (context, status) {
                    final cubit = StorageCubit.get(context);
                    return CustomTextField(
                      controller: cubit.searchController,
                      prefix: Icon(Icons.search),
                      hint: LocaleKeys.search,
                      maxlines: 1,
                      minlines: 1,
                      onChange: (value) {
                        cubit.searchOnStorageItems();
                      },
                    );
                  },
                ),
              ),
              BlocSelector<StorageCubit, StorageState, StateStatus>(
                selector: (state) {
                  return state.status;
                },
                builder: (context, status) {
                  final cubit = StorageCubit.get(context);
                  return Expanded(
                    flex: 2,
                    child: CustomButton(
                      isLoading: status.isLoading,
                      title: LocaleKeys.add,
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) {
                            return const AddStorageItemProvider();
                          },
                        );
                        if (result == true) {
                          cubit.refresh();
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
