import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';
import 'package:local_erp_system/core/languages/local_keys.g.dart';
import 'package:local_erp_system/features/transactions/data/models/transaction_model.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/sliver_empty_body.dart';
import '../cubits/transactions_cubit/transactions_cubit.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          final length =
              state.status.isLoading ? 10 : state.transactions.length;
          if (state.status.isSuccess && state.transactions.isEmpty) {
            return SliverEmptyBody(title: LocaleKeys.noTransactionsFound);
          }
          return SliverList.separated(
            itemCount: length,
            itemBuilder: (context, index) {
              final transaction =
                  state.status.isLoading
                      ? TransactionModel.initial()
                      : state.transactions[index];
              return _TransactionItem(transaction: transaction);
            },
            separatorBuilder: (_, _) {
              return gapH(12);
            },
          );
        },
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pf20,
        vertical: AppPadding.pf12,
      ),
      decoration: BoxDecoration(
        color: context.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              '${transaction.id}',
              style: context.textTheme.titleLarge,
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
                transaction.notes ?? '',
                style: context.textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              transaction.invoiceProfit?.toStringAsFixed(2) ?? '0.00',
              style: context.textTheme.titleLarge!.copyWith(letterSpacing: 1.2),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              transaction.transactionTypeVal.localizedName,
              style: context.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
