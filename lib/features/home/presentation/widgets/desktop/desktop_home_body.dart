import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';
import 'package:playstation_manager/core/widgets/custom_skeletonizer.dart';
import 'package:playstation_manager/core/widgets/custom_sliver_padding.dart';

import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../devices/data/models/device_model.dart';
import '../../../../sessions/data/models/session_model.dart';
import '../../../../transactions/data/models/transaction_model.dart';
import '../../../data/models/home_profit.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/home_cubit/home_state.dart';
import '../../home_taps_grid_view.dart';
import '../dashboard/device_status_summary_widget.dart';
import '../dashboard/latest_transactions_list.dart';
import '../dashboard/profit_widget.dart';
import '../dashboard/reserved_devices_list.dart';

class DesktopHomeBody extends StatelessWidget {
  const DesktopHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getHomeData(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final profit =
              state.status.isLoading
                  ? HomeProfit.initial()
                  : state.homeModel!.profit;
          final devices =
              state.status.isLoading
                  ? List.generate(5, (index) => DeviceModel.initial())
                  : state.homeModel!.devices;
          final transactions =
              state.status.isLoading
                  ? List.generate(5, (index) => TransactionModel.initial())
                  : state.homeModel!.transactions;
          final sessions =
              state.status.isLoading
                  ? List.generate(5, (index) => SessionModel.initial())
                  : state.homeModel!.sessions;
          return CustomSkeletonizer(
            enabled: state.status.isLoading,
            child: CustomScrollView(
              slivers: [
                sliverGapHFix(24),
                CustomSliverPadding(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DeviceStatusSummaryWidget(devices: devices),
                      ),
                      gapWFix(12),
                      Expanded(child: ProfitWidget(profit: profit)),
                    ],
                  ),
                ),
                sliverGapHFix(12),
                CustomSliverPadding(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ReservedDevicesList(sessions: sessions)),
                      gapWFix(12),
                      Expanded(
                        child: LatestTransactionsList(
                          transactions: transactions,
                        ),
                      ),
                    ],
                  ),
                ),
                sliverGapHFix(20),
                CustomSliverPadding(
                  child: Text(
                    LocaleKeys.quickAccess,
                    style: context.textTheme.displayMedium?.copyWith(
                      color: context.colorScheme.secondaryFixed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                sliverGapHFix(16),
                const HomeTapsGridView(),
                sliverGapHFix(40),
              ],
            ),
          );
        },
      ),
    );
  }
}
