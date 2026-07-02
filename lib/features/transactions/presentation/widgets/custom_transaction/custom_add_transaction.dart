import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';
import 'package:local_erp_system/core/widgets/expanded_drop_down.dart';
import 'package:local_erp_system/features/transactions/presentation/cubits/cubit/add_transaction_cubit.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/utils/validations.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_dialog.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../customers/data/models/customer_model.dart';

part '_customer_dropdown.dart';

class CustomAddTransactionProvider extends StatelessWidget {
  const CustomAddTransactionProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddTransactionCubit>()..customInit(),
      child: _CustomAddTransaction(),
    );
  }
}

class _CustomAddTransaction extends StatelessWidget {
  const _CustomAddTransaction();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      children: [
        _CustomersDropdown(),
        gapH(20),
        BlocBuilder<AddTransactionCubit, AddTransactionState>(
          buildWhen: (previous, current) {
            return previous.customerStatus != current.customerStatus;
          },
          builder: (context, state) {
            final cubit = AddTransactionCubit.get(context);
            return Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  CustomTextField(
                    hint: LocaleKeys.enterNotesOptional,
                    controller: cubit.notesController,
                    prefix: const Icon(Icons.person),
                  ),
                  gapH(20),
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
                ],
              ),
            );
          },
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
            BlocBuilder<AddTransactionCubit, AddTransactionState>(
              buildWhen: (previous, current) {
                return previous.customer != current.customer;
              },
              builder: (context, state) {
                final cubit = AddTransactionCubit.get(context);
                return Expanded(
                  child: CustomButton(
                    isLoading: state.customerStatus.isLoading,
                    title: LocaleKeys.save,
                    onTap: () {
                      cubit.createTransaction(context);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
