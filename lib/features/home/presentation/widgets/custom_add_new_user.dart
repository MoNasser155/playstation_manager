import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/shared/di.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/utils/navigator_helper.dart';
import '../../../../core/utils/validations.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/row_taps/custom_taps_row.dart';
import '../cubits/add_user_cubit/add_user_cubit.dart';

class AddNewUserProvider extends StatelessWidget {
  const AddNewUserProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddUserCubit>(),
      child: const _CustomAddNewUser(),
    );
  }
}

class _CustomAddNewUser extends StatelessWidget {
  const _CustomAddNewUser();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddUserCubit, AddUserState>(
      buildWhen: (previous, current) {
        return previous.status != current.status ||
            previous.userType != current.userType;
      },
      builder: (context, state) {
        final cubit = AddUserCubit.get(context);
        return Form(
          key: cubit.formKey,
          child: CustomDialog(
            children: [
              BlocBuilder<AddUserCubit, AddUserState>(
                buildWhen: (previous, current) {
                  return previous.userType != current.userType;
                },
                builder: (context, state) {
                  return CustomTapsRow(
                    itemsName:
                        UserType.values.map((e) => e.localizedName).toList(),
                    selectedIndex: state.userType.index,
                    itemsCount: UserType.values.length,

                    onTap: (index) {
                      cubit.changeUserType(index);
                    },
                  );
                },
              ),
              gapH(20),

              Text(
                state.userType.isCustomer
                    ? LocaleKeys.addNewCustomer
                    : LocaleKeys.addNewSupplier,
                style: context.textTheme.headlineLarge,
              ),
              gapH(20),
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
                        cubit.addUser();
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
