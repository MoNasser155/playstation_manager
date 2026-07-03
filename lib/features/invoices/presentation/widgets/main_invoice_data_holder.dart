import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/device_status.dart';
import '../../../../core/enums/play_type.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/expanded_drop_down.dart';
import '../../../devices/data/models/device_model.dart';
import '../cubits/cubit/invoice_cubit.dart';
import 'end_session_dialog.dart';

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
              child: BlocBuilder<InvoiceCubit, InvoiceState>(
                buildWhen: (previous, current) {
                  return previous.playType != current.playType ||
                      previous.isSessionActive != current.isSessionActive;
                },
                builder: (context, state) {
                  final cubit = InvoiceCubit.get(context);
                  return ExpandedDropdown<PlayType>(
                    hint: LocaleKeys.playType,
                    items: PlayType.values,
                    isEnabled: !state.isSessionActive,
                    selectedValue: state.playType.localizedName,
                    backgroundColor: context.mapCard,
                    searchFieldColor: context.mapCard,
                    itemLabelBuilder: (PlayType p) {
                      return p.localizedName;
                    },
                    onChanged: (value) {
                      if (value != null) {
                        cubit.changePlayType(value);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
