import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extentions/theme_extensions.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../cubits/storage_item_details_cubit/storage_item_details_cubit.dart';
import 'storage_details_info_header.dart';
import 'storage_details_item_info_holder.dart';
import 'storage_details_transactions_list.dart';

class StorageItemDetailsBody extends StatelessWidget {
  const StorageItemDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageItemDetailsCubit, StorageItemDetailsState>(
      buildWhen: (prev, curr) => curr.status != prev.status,
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            CustomSliverAppbar(
              height: 64,
              flexibleWidget: const StorageDetailsInfoHeader(),
            ),
            const StorageDetailsItemInfoHolder(),
            sliverGapHFix(12),
            const CustomDetailsTransactionsHeader(),
            const StorageDetailsTransactionsList(),
          ],
        );
      },
    );
  }
}

class CustomDetailsTransactionsHeader extends StatelessWidget {
  const CustomDetailsTransactionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: CustomSliverAppbar(
        applyPadding: true,
        height: 30,
        flexibleWidget: Row(
          children: [
            const SizedBox(width: 64),
            Expanded(
              flex: 7,
              child: Text(
                LocaleKeys.note,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                LocaleKeys.profit,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                LocaleKeys.type,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                LocaleKeys.date,
                style: context.textTheme.headlineLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
