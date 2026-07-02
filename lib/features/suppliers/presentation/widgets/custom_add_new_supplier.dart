part of 'custom_suppliers_body_appbar.dart';

class _CustomAddNewSupplier extends StatelessWidget {
  const _CustomAddNewSupplier();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSupplierCubit, AddSupplierState>(
      buildWhen: (previous, current) {
        return previous.status != current.status;
      },
      builder: (context, state) {
        final cubit = AddSupplierCubit.get(context);
        return Form(
          key: cubit.formKey,
          child: CustomDialog(
            children: [
              Text(
                LocaleKeys.addNewSupplier,
                style: context.textTheme.headlineLarge,
              ),
              gapH(24),
              CustomTextField(
                hint: LocaleKeys.enterNameRequired,
                controller: cubit.nameController,
                prefix: Icon(Icons.person),
                validate: Validations.validateEmpty,
              ),
              gapH(12),
              CustomTextField(
                hint: LocaleKeys.enterPhoneRequired,
                controller: cubit.phone1Controller,
                prefix: Icon(Icons.phone),
                validate: Validations.validateEgyPhone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 11,
              ),
              gapH(12),
              CustomTextField(
                hint: LocaleKeys.enterPhoneOptional,
                prefix: Icon(Icons.phone),
                controller: cubit.phone2Controller,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 11,
              ),
              gapH(12),
              CustomTextField(
                hint: LocaleKeys.enterAddressRequired,
                prefix: Icon(Icons.location_on),
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
                        cubit.addSupplier();
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
