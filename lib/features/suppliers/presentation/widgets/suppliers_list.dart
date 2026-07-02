import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/sliver_empty_body.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../data/models/supplier_model.dart';
import '../cubits/suppliers_cubit/suppliers_cubit.dart';
import '../screens/supplier_details_screen.dart';
import 'custom_delete_supplier_dialog.dart';

part 'supplier_item.dart';

class SuppliersList extends StatelessWidget {
  const SuppliersList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<SuppliersCubit, SuppliersState>(
        buildWhen: (previous, current) {
          return previous.suppliers != current.suppliers ||
              previous.filteredSuppliers != current.filteredSuppliers;
        },
        builder: (context, state) {
          final isApplyFilter =
              SuppliersCubit.get(context).searchController.text.isNotEmpty;
          final length =
              state.status.isLoading
                  ? 10
                  : (isApplyFilter
                      ? state.filteredSuppliers.length
                      : state.suppliers.length);
          if (length == 0 && !state.status.isLoading) {
            return SliverEmptyBody(title: LocaleKeys.noSuppliers);
          }
          return SliverList.separated(
            itemCount: length,
            separatorBuilder: (context, index) {
              return gapH(16);
            },
            itemBuilder: (context, index) {
              final supplier =
                  state.status.isLoading
                      ? SupplierModel.initial()
                      : (isApplyFilter
                          ? state.filteredSuppliers[index]
                          : state.suppliers[index]);
              return _SupplierItem(supplier: supplier);
            },
          );
        },
      ),
    );
  }
}
