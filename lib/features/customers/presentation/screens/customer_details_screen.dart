import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../../core/shared/di.dart';
import '../../../../core/widgets/custom_skeletonizer.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../cubits/customer_details_cubit/customer_details_cubit.dart';
import '../widgets/customer_invoices_section/customer_details_invoices_section.dart';
import '../widgets/customer_transactions_section/customer_details_transactions_section.dart';
import '../widgets/header/customer_details_info_header.dart';

part '../widgets/mobile/mobile_customer_details_body.dart';
part '../widgets/tablet/tablet_customer_details_body.dart';
part '../widgets/desktop/desktop_customer_details_body.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final String customerUuid;
  const CustomerDetailsScreen({super.key, required this.customerUuid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CustomerDetailsCubit>()..init(customerUuid),
      child: Scaffold(
        key: ValueKey(context.locale.toString()),
        body: BlocBuilder<MainViewCubit, MainViewState>(
          buildWhen: (previous, current) {
            return previous.mode != current.mode;
          },
          builder: (context, state) {
            switch (state.mode) {
              case MainViewMode.mobile:
                return _MobileCustomerDetailsBody();
              case MainViewMode.tablet:
                return _TabletCustomerDetailsBody();
              case MainViewMode.desktop:
                return _DesktopCustomerDetailsBody();
            }
          },
        ),
      ),
    );
  }
}
