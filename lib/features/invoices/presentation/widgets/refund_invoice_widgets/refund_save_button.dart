import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../../cubits/refund_cubit/refund_invoice_cubit.dart';

class RefundSaveButton extends StatelessWidget {
  const RefundSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundInvoiceCubit, RefundInvoiceState>(
      buildWhen: (prev, cur) =>
          prev.selectedInvoice != cur.selectedInvoice ||
          prev.canSaveRefund != cur.canSaveRefund ||
          prev.status != cur.status,
      builder: (context, state) {
        if (state.selectedInvoice == null) return const SliverToBoxAdapter();
        final cubit = RefundInvoiceCubit.get(context);
        final isLoading = state.status == StateStatus.loading;
        final isEnabled = state.canSaveRefund && !isLoading;

        return CustomSliverPadding(
          child: CustomButton(
            isEnabled: isEnabled,
            isLoading: isLoading,
            title: LocaleKeys.save,
            onTap: isEnabled ? () => cubit.saveRefund(context) : null,
          ),
        );
      },
    );
  }
}
