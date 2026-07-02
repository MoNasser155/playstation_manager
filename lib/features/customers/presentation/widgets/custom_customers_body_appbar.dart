import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';
import 'package:local_erp_system/core/widgets/custom_dialog.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/shared/di.dart';
import '../../../../core/utils/navigator_helper.dart';
import '../../../../core/utils/validations.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubits/add_customer_cubit/add_customer_cubit.dart';
import '../cubits/customers_cubit/customer_cubit.dart';

part 'custom_add_new_customer.dart';

class CustomCustomersBodyAppbar extends StatelessWidget {
  const CustomCustomersBodyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverAppbar(
      applyPadding: true,
      height: 110,
      flexibleWidget: Column(
        children: [
          gapHFix(8),
          Row(
            spacing: AppSpacing.h12,
            children: [
              Expanded(
                flex: 8,
                child:
                    BlocSelector<CustomersCubit, CustomersState, StateStatus>(
                      selector: (state) {
                        return state.status;
                      },
                      builder: (context, status) {
                        final cubit = CustomersCubit.get(context);
                        return CustomTextField(
                          controller: cubit.searchController,
                          prefix: const Icon(Icons.search),
                          hint: LocaleKeys.search,
                          maxlines: 1,
                          minlines: 1,
                          onChange: (value) {
                            cubit.searchOnCustomers();
                          },
                        );
                      },
                    ),
              ),
              BlocSelector<CustomersCubit, CustomersState, StateStatus>(
                selector: (state) {
                  return state.status;
                },
                builder: (context, status) {
                  final cubit = CustomersCubit.get(context);
                  return Expanded(
                    flex: 2,
                    child: CustomButton(
                      isLoading: status.isLoading,
                      title: LocaleKeys.add,
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) {
                            return const AddCustomerProvider();
                          },
                        );
                        if (result == true) {
                          cubit.refresh();
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          gapH(12),
          const _CustomersInfoHeader(),
          gapH(4),
        ],
      ),
    );
  }
}

class _CustomersInfoHeader extends StatelessWidget {
  const _CustomersInfoHeader();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        spacing: AppSpacing.h12,
        children: [
          const Expanded(child: SizedBox.shrink()),
          Expanded(
            flex: 6,
            child: Text(
              LocaleKeys.customerName,
              style: context.textTheme.titleLarge,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              LocaleKeys.balance,
              style: context.textTheme.titleLarge,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              LocaleKeys.contact,
              style: context.textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class AddCustomerProvider extends StatelessWidget {
  const AddCustomerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddCustomerCubit>(),
      child: const _CustomAddNewCustomer(),
    );
  }
}
