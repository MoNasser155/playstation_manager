import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/gaps.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/sliver_empty_body.dart';
import '../../../../core/widgets/transactions/custom_transaction_card.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../cubits/supplier_details_cubit/supplier_details_cubit.dart';

class SupplierDetailsTransactionsList extends StatelessWidget {
  const SupplierDetailsTransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<SupplierDetailsCubit, SupplierDetailsState>(
        buildWhen:
            (previous, current) =>
                previous.transactionsState != current.transactionsState ||
                previous.transactions != current.transactions,
        builder: (context, state) {
          final length =
              state.transactionsState.isLoading
                  ? 10
                  : state.transactions.length;
          if (state.transactionsState.isSuccess && state.transactions.isEmpty) {
            return SliverEmptyBody(title: LocaleKeys.noTransactionsFound);
          }
          return SliverList.separated(
            itemBuilder: (context, index) {
              final transaction =
                  state.transactionsState.isLoading
                      ? TransactionModel.initial()
                      : state.transactions[index];
              return CustomTransactionCardWidget(transaction: transaction);
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
