
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/extentions/theme_extensions.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/utils/validations.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_dialog.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../cubits/supplier_details_cubit/supplier_details_cubit.dart';

class CustomEditSupplierDialog extends StatelessWidget {
  const CustomEditSupplierDialog({super.key, required this.cubit});

  final SupplierDetailsCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierDetailsCubit, SupplierDetailsState>(
      bloc: cubit,
      buildWhen: (p, c) {
        return p.supplierDetails.supplier != c.supplierDetails.supplier;
      },
      builder: (context, state) {
        return Form(
          key: cubit.formKey,
          child: CustomDialog(
            children: [
              Text(
                LocaleKeys.addNewCustomer,
                style: context.textTheme.headlineLarge,
              ),
              gapH(24),
              CustomTextField(
                hint: LocaleKeys.enterNameRequired,
                controller: cubit.nameController,
                prefix: const Icon(Icons.person),
                validate: Validations.validateEmpty,
              ),
              gapH(12),
              CustomTextField(
                hint: LocaleKeys.enterPhoneRequired,
                controller: cubit.phone1Controller,
                prefix: const Icon(Icons.phone),
                validate: Validations.validateEgyPhone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 11,
              ),
              gapH(12),
              CustomTextField(
                hint: LocaleKeys.enterPhoneOptional,
                prefix: const Icon(Icons.phone),
                controller: cubit.phone2Controller,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 11,
              ),
              gapH(12),
              CustomTextField(
                hint: LocaleKeys.enterAddressRequired,
                prefix: const Icon(Icons.location_on),
                controller: cubit.addressController,
                validate: Validations.validateEmpty,
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
                        cubit.updateCustomer(context);
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
