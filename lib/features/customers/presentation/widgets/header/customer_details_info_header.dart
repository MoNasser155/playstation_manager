import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/row_taps/custom_taps_row.dart';
import '../../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../../../transactions/presentation/cubits/cubit/add_transaction_cubit.dart';
import '../../../../transactions/presentation/widgets/add_customer_supplier_transaction_dialog.dart';
import '../../../data/models/customer_model.dart';
import '../../cubits/customer_details_cubit/customer_details_cubit.dart';
import '../custom_delete_customer_dialog.dart';
import 'edit_customer_dialog.dart';

part '_first_header.dart';
part '_second_header.dart';
part '_third_header.dart';

class CustomerDetailsInfoHeader extends StatelessWidget {
  const CustomerDetailsInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pf20,
        vertical: AppPadding.pf12,
      ),
      child: Column(
        children: [
          const _FirstCustomerDetailsHeader(),
          const _SecondCustomerDetailsHeader(),
          const _ThirdCustomerDetailsHeader(),
        ],
      ),
    );
  }
}
