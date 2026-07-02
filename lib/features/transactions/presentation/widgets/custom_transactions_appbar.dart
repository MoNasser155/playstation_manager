import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/services/pdf-transactions/save_pdf.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../../core/widgets/row_taps/custom_taps_row.dart';
import '../cubits/transactions_cubit/transactions_cubit.dart';
import 'custom_transaction/custom_add_transaction.dart';
import 'transactions_date_range_picker.dart';

part '_transactions_monthly_filter.dart';

class CustomTransactionsAppbar extends StatelessWidget {
  const CustomTransactionsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      buildWhen: (previous, current) {
        return previous.selectedTapIndex != current.selectedTapIndex;
      },
      builder: (context, state) {
        final cubit = TransactionsCubit.get(context);
        return CustomSliverAppbar(
          applyPadding: true,
          height: 160,
          flexibleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gapHFix(12),
              Column(
                children: [
                  Row(
                    spacing: AppSpacing.h16,
                    children: [
                      Expanded(child: TransactionsDateRangePicker()),
                      Expanded(flex: 4, child: _TransactionsMonthlyFilter()),
                    ],
                  ),
                  Column(
                    children: [
                      gapHFix(8),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTapsRow(
                              selectedIndex: state.selectedTapIndex,
                              itemsCount: UserType.values.length + 1,
                              itemsName: [
                                LocaleKeys.all,
                                ...UserType.values.map(
                                  (type) => type.localizedName,
                                ),
                              ],
                              onTap: (index) {
                                cubit.changeTapIndex(index);
                              },
                            ),
                          ),
                          gapWFix(12),
                          Expanded(
                            flex: 2,
                            child: CustomButton(
                              buttonHeight: 40,
                              title: LocaleKeys.addTransaction,
                              onTap: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return const CustomAddTransactionProvider();
                                  },
                                );
                                if (result == true) {
                                  cubit.refresh();
                                }
                              },
                            ),
                          ),
                          gapWFix(12),
                          BlocBuilder<TransactionsCubit, TransactionsState>(
                            buildWhen: (previous, current) {
                              return previous.transactions !=
                                  current.transactions;
                            },
                            builder: (context, state) {
                              return Expanded(
                                child: CustomButton(
                                  buttonHeight: 40,
                                  title: LocaleKeys.exportPdf,
                                  onTap: () {
                                    showDialog<String>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder:
                                          (_) => SavePdfDialog(
                                            transactions: state.transactions,
                                            initialName:
                                                DateTime.now()
                                                    .shortenFormattedPdfDate,
                                            totalAmount: state.totalAmount
                                                .toStringAsFixed(2),
                                          ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),
                  child: Row(
                    children: [
                      const SizedBox(width: 64),
                      Expanded(
                        flex: 5,
                        child: Text(
                          LocaleKeys.notes,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          LocaleKeys.name,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          LocaleKeys.before,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          LocaleKeys.payment,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          LocaleKeys.after,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          LocaleKeys.type,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          LocaleKeys.date,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
