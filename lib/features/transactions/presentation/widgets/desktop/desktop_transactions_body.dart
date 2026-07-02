import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/widgets/custom_skeletonizer.dart';

import '../../../../../core/utils/gaps.dart';
import '../../cubits/transactions_cubit/transactions_cubit.dart';
import '../custom_transactions_appbar.dart';
import '../transactions_list.dart';

class DesktopTransactionsBody extends StatelessWidget {
  const DesktopTransactionsBody({super.key});

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
              sliverGapH(20),
            ],
          ),
        );
      },
    );
  }
}
