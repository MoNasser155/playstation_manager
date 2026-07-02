import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_skeletonizer.dart';
import '../../cubits/suppliers_cubit/suppliers_cubit.dart';
import '../custom_suppliers_body_appbar.dart';
import '../suppliers_list.dart';

class DesktopSuppliersBody extends StatelessWidget {
  const DesktopSuppliersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SuppliersCubit, SuppliersState, StateStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, state) {
        return CustomSkeletonizer(
          enabled: state.isLoading,
          child: CustomScrollView(
            slivers: [
              CustomSuppliersBodyAppbar(),
              sliverGapH(16),
              SuppliersList(),
            ],
          ),
        );
      },
    );
  }
}
