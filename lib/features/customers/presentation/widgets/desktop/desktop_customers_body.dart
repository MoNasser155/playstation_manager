import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_skeletonizer.dart';
import '../../cubits/customers_cubit/customer_cubit.dart';
import '../custom_customers_body_appbar.dart';
import '../customers_list.dart';

class DesktopCustomersBody extends StatelessWidget {
  const DesktopCustomersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CustomersCubit, CustomersState, StateStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, state) {
        return CustomSkeletonizer(
          enabled: state.isLoading,
          child: CustomScrollView(
            slivers: [
              const CustomCustomersBodyAppbar(),
              sliverGapH(16),
              const CustomersList(),
            ],
          ),
        );
      },
    );
  }
}
