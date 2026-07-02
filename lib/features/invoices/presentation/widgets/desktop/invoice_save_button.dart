import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/widgets/custom_sliver_padding.dart';

import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../cubits/cubit/invoice_cubit.dart';

class InvoiceSaveButton extends StatelessWidget {
  const InvoiceSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      buildWhen:
          (previous, current) =>
              previous.status != current.status ||
              previous.canSaveInvoice != current.canSaveInvoice,
      builder: (context, state) {
        final cubit = InvoiceCubit.get(context);

        return CustomSliverPadding(
          child: CustomButton(
            isEnabled: state.canSaveInvoice && !state.status.isLoading,
            isLoading: state.status.isLoading,
            title: LocaleKeys.saveInvoice,
            onTap:
                state.canSaveInvoice && !state.status.isLoading
                    ? () => cubit.saveInvoice(context)
                    : null,
          ),
        );
      },
    );
  }
}
