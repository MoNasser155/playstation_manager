import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/navigator_helper.dart';
import '../../../../core/utils/validations.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubits/cubit/add_transaction_cubit.dart';

class AddCustomerSupplierTransactionDialog extends StatelessWidget {
  const AddCustomerSupplierTransactionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      builder: (context, state) {
        final cubit = AddTransactionCubit.get(context);
        return Form(
          key: cubit.formKey,
          child: CustomDialog(
            children: [
              Text(
                LocaleKeys.addTransaction,
                style: context.textTheme.headlineLarge,
              ),
              gapH(24),
              CustomTextField(
                hint: LocaleKeys.enterNotesOptional,
                controller: cubit.notesController,
                prefix: const Icon(Icons.person),
              ),
              gapH(12),
              CustomTextField(
                hint: LocaleKeys.enterAmount,
                controller: cubit.amountController,
                prefix: const Icon(Icons.money),
                validate: Validations.validateEmpty,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                maxLength: 11,
              ),

              gapH(20),
              Row(
                spacing: AppSpacing.h12,
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: context.mapCard,
                      borderColor: context.colorScheme.error,
                      textColor: context.colorScheme.onPrimary,
                      title: LocaleKeys.cancel,
                      onTap: () {
                        AppNavigator.pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      isLoading: state.status.isLoading,
                      title: LocaleKeys.save,
                      onTap: () {
                        cubit.createTransaction(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
