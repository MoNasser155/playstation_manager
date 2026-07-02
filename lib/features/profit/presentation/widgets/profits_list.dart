import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/sliver_empty_body.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../cubits/cubit/profit_cubit.dart';

class ProfitsList extends StatelessWidget {
  const ProfitsList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<ProfitCubit, ProfitState>(
        buildWhen:
            (previous, current) =>
                previous.profits.transactions != current.profits.transactions,
        builder: (context, state) {
          final length =
              state.status.isLoading ? 10 : state.profits.transactions.length;
          if (state.status.isSuccess && state.profits.transactions.isEmpty) {
            return SliverEmptyBody(title: LocaleKeys.noProfitData);
          }
          return SliverList.separated(
            itemBuilder: (context, index) {
              final transaction =
                  state.status.isLoading
                      ? TransactionModel.initial()
                      : state.profits.transactions[index];
              return _CustomProfitCardWidget(transaction: transaction);
            },
            separatorBuilder: (context, index) {
              return gapH(12);
            },
            itemCount: length,
          );
        },
      ),
    );
  }
}

class _CustomProfitCardWidget extends StatelessWidget {
  final TransactionModel transaction;
  const _CustomProfitCardWidget({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pf20,
        vertical: AppPadding.pf12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        color: context.primaryContainer,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              transaction.id.toString(),
              style: context.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 7,
            child: Tooltip(
              message: transaction.notes ?? "",
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.pf12,
                vertical: AppPadding.pf6,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryFixed,
                borderRadius: BorderRadius.circular(AppRadius.r4),
              ),
              textStyle: context.textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    context.theme.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
              ),
              child: Text(
                transaction.notes ?? "",
                style: context.textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction.invoiceProfit.toString(),
              style: context.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction.transactionTypeVal.localizedName,
              style: context.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Tooltip(
              message: transaction.createdAt.toFullFormattedDate,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.pf12,
                vertical: AppPadding.pf6,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryFixed,
                borderRadius: BorderRadius.circular(AppRadius.r4),
              ),
              textStyle: context.textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    context.theme.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
              ),
              child: Text(
                transaction.createdAt.toFullFormattedDate,
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
