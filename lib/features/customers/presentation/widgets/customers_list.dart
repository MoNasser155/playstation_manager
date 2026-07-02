import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/sliver_empty_body.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../data/models/customer_model.dart';
import '../cubits/customers_cubit/customer_cubit.dart';
import '../screens/customer_details_screen.dart';
import 'custom_delete_customer_dialog.dart';

part 'customer_item.dart';

class CustomersList extends StatelessWidget {
  const CustomersList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<CustomersCubit, CustomersState>(
        buildWhen: (previous, current) {
          return previous.customers != current.customers ||
              previous.filteredCustomers != current.filteredCustomers;
        },
        builder: (context, state) {
          final isApplyFilter =
              CustomersCubit.get(context).searchController.text.isNotEmpty;
          final length =
              state.status.isLoading
                  ? 10
                  : (isApplyFilter
                      ? state.filteredCustomers.length
                      : state.customers.length);
          if (length == 0 && !state.status.isLoading) {
            return SliverEmptyBody(title: LocaleKeys.noCustomers);
          }
          return SliverList.separated(
            itemCount: length,
            separatorBuilder: (context, index) {
              return gapH(16);
            },
            itemBuilder: (context, index) {
              final customer =
                  state.status.isLoading
                      ? CustomerModel.initial()
                      : (isApplyFilter
                          ? state.filteredCustomers[index]
                          : state.customers[index]);
              return _CustomerItem(customer: customer);
            },
          );
        },
      ),
    );
  }
}
