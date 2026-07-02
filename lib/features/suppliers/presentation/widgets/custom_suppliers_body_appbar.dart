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
import '../cubits/add_supplier_cubit/add_supplier_cubit.dart';
import '../cubits/suppliers_cubit/suppliers_cubit.dart';

part 'custom_add_new_supplier.dart';

class CustomSuppliersBodyAppbar extends StatelessWidget {
  const CustomSuppliersBodyAppbar({super.key});

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
                    BlocSelector<SuppliersCubit, SuppliersState, StateStatus>(
                      selector: (state) {
                        return state.status;
                      },
                      builder: (context, status) {
                        final cubit = SuppliersCubit.get(context);
                        return CustomTextField(
                          controller: cubit.searchController,
                          prefix: Icon(Icons.search),
                          hint: LocaleKeys.search,
                          maxlines: 1,
                          minlines: 1,
                          onChange: (value) {
                            cubit.searchOnSuppliers();
                          },
                        );
                      },
                    ),
              ),
              BlocSelector<SuppliersCubit, SuppliersState, StateStatus>(
                selector: (state) {
                  return state.status;
                },
                builder: (context, status) {
                  final cubit = SuppliersCubit.get(context);
                  return Expanded(
                    flex: 2,
                    child: CustomButton(
                      isLoading: status.isLoading,
                      title: LocaleKeys.add,
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) {
                            return const _AddSupplierProvider();
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
          const _SuppliersInfoHeader(),
          gapH(4),
        ],
      ),
    );
  }
}

class _AddSupplierProvider extends StatelessWidget {
  const _AddSupplierProvider();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddSupplierCubit>(),
      child: _CustomAddNewSupplier(),
    );
  }
}

class _SuppliersInfoHeader extends StatelessWidget {
  const _SuppliersInfoHeader();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        spacing: AppSpacing.h12,
        children: [
          Expanded(child: SizedBox.shrink()),
          Expanded(
            flex: 6,
            child: Text(
              LocaleKeys.supplierName,
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
          SizedBox(width: 40),
        ],
      ),
    );
  }
}
