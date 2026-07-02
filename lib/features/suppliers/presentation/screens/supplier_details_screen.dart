import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../../core/shared/di.dart';
import '../../../../core/widgets/custom_skeletonizer.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../cubits/supplier_details_cubit/supplier_details_cubit.dart';
import '../widgets/details_header/supplier_details_info_header.dart';
import '../widgets/supplier_details_transactions_section.dart';

part '../widgets/desktop/desktop_supplier_details_body.dart';
part '../widgets/mobile/mobile_supplier_details_body.dart';
part '../widgets/tablet/tablet_supplier_details_body.dart';

class SupplierDetailsScreen extends StatelessWidget {
  final String supplierUuid;
  const SupplierDetailsScreen({super.key, required this.supplierUuid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SupplierDetailsCubit>()..init(supplierUuid),
      child: Scaffold(
        key: ValueKey(context.locale.toString()),
        body: BlocBuilder<MainViewCubit, MainViewState>(
          buildWhen: (previous, current) {
            return previous.mode != current.mode;
          },
          builder: (context, state) {
            switch (state.mode) {
              case MainViewMode.mobile:
                return _MobileSupplierDetailsBody();
              case MainViewMode.tablet:
                return _TabletSupplierDetailsBody();
              case MainViewMode.desktop:
                return _DesktopSupplierDetailsBody();
            }
          },
        ),
      ),
    );
  }
}
