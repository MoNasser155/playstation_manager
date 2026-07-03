import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/device_status.dart';
import '../../../../core/enums/payment_type.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/expanded_drop_down.dart';
import '../../../../core/widgets/row_taps/custom_taps_row.dart';
import '../../../devices/data/models/device_model.dart';
import '../cubits/cubit/invoice_cubit.dart';

part 'invoice_customer_payment_holder.dart';

class MainInvoiceDataHolder extends StatelessWidget {
  const MainInvoiceDataHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.h12,
        children: [
          _IvoiceCustomerPaymentHolder(),

          Expanded(
            child: Container(
              padding: EdgeInsets.all(AppPadding.pf8),
              decoration: BoxDecoration(
                color: context.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
              child: Column(
                children: [
                  Row(
                    spacing: AppSpacing.h12,
                    children: [
                      Expanded(
                        child: Text(
                          LocaleKeys.date,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(AppPadding.pf8),
                          decoration: BoxDecoration(
                            color: context.primaryContainer,
                            border: Border.all(
                              color: context.colorScheme.secondaryFixed,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.r4),
                          ),
                          child: Text(
                            DateTime.now().toFullFormattedDate,
                            style: context.textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                  gapH(12),
                  Row(
                    spacing: AppSpacing.h12,
                    children: [
                      Expanded(
                        child: Text(
                          LocaleKeys.invoiceId,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(AppPadding.pf8),
                          decoration: BoxDecoration(
                            color: context.primaryContainer,
                            border: Border.all(
                              color: context.colorScheme.secondaryFixed,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.r4),
                          ),
                          child: BlocBuilder<InvoiceCubit, InvoiceState>(
                            buildWhen: (previous, current) {
                              return previous.invoiceUuid !=
                                  current.invoiceUuid;
                            },
                            builder: (context, state) {
                              return Text(
                                state.invoiceUuid,
                                style: context.textTheme.titleLarge,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  gapH(12),
                  BlocBuilder<InvoiceCubit, InvoiceState>(
                    buildWhen:
                        (previous, current) =>
                            previous.paymentType != current.paymentType ||
                            previous.totalInvoice != current.totalInvoice ||
                            previous.cashPaid != current.cashPaid,
                    builder: (context, state) {
                      final cubit = InvoiceCubit.get(context);
                      return Visibility(
                        visible: state.paymentType == PaymentType.later,
                        child: Column(
                          spacing: AppSpacing.v8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: cubit.paidCashController,
                              inputType: TextInputType.number,
                              hint: LocaleKeys.paidNow,
                              onChange: (_) => cubit.updateCashPaid(),
                              fillColor: context.mapCard,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.pf8,
                                vertical: AppPadding.pf8,
                              ),
                              decoration: BoxDecoration(
                                color: context.mapCard,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r8,
                                ),
                                border: Border.all(
                                  color: context.colorScheme.secondaryFixed,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.laterAmount,
                                    style: context.textTheme.titleMedium,
                                  ),
                                  Text(
                                    state.laterPaid.toStringAsFixed(2),
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(
                                          color: context.colorScheme.error,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
