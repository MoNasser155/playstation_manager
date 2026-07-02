import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_skeletonizer.dart';
import '../../cubits/transactions_cubit/transactions_cubit.dart';
import '../custom_transactions_appbar.dart';
import '../transactions_list.dart';

class TabletTransactionsBody extends StatelessWidget {
  const TabletTransactionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      buildWhen: (previous, current) {
        return previous.status != current.status;
      },
      builder: (context, state) {
        return CustomSkeletonizer(
          enabled: state.status.isLoading,
          child: CustomScrollView(
            slivers: [
              const CustomTransactionsAppbar(),
              sliverGapH(20),
              const TransactionsList(),
            ],
          ),
        );
      },
    );
  }
}
