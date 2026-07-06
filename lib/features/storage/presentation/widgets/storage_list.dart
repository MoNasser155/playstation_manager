import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/media_query_extenstions.dart';

import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/sliver_empty_body.dart';
import '../../data/models/storage_model.dart';
import '../cubits/storage_cubit/storage_cubit.dart';
import 'storage_item.dart';

class StorageList extends StatelessWidget {
  const StorageList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<StorageCubit, StorageState>(
        buildWhen:
            (previous, current) =>
                current.storageItems != previous.storageItems ||
                previous.filteredStorageItems != current.filteredStorageItems,
        builder: (context, state) {
          final isApplyFilter =
              StorageCubit.get(context).searchController.text.isNotEmpty;
          final length =
              state.status.isLoading
                  ? 10
                  : (isApplyFilter
                      ? state.filteredStorageItems.length
                      : state.storageItems.length);
          if (length == 0 && !state.status.isLoading) {
            return SliverEmptyBody(title: LocaleKeys.noItems);
          }
          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  context.width > 1000
                      ? 5
                      : context.width > 800
                      ? 4
                      : context.width > 600
                      ? 3
                      : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final item =
                  state.status.isLoading
                      ? StorageModel.initial()
                      : (isApplyFilter
                          ? state.filteredStorageItems[index]
                          : state.storageItems[index]);
              return StorageItemWidget(item: item);
            },
            itemCount: length,
          );
        },
      ),
    );
  }
}
