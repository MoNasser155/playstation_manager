import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../../core/shared/di.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../cubits/suppliers_cubit/suppliers_cubit.dart';
import '../widgets/desktop/desktop_suppliers_body.dart';
import '../widgets/mobile/mobile_suppliers_body.dart';
import '../widgets/tablet/tablet_suppliers_body.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SuppliersCubit>()..getAllSuppliers(),
      child: Scaffold(
        key: ValueKey(context.locale.toString()),
        body: BlocBuilder<MainViewCubit, MainViewState>(
          buildWhen: (previous, current) {
            return previous.mode != current.mode;
          },
          builder: (context, state) {
            switch (state.mode) {
              case MainViewMode.mobile:
                return MobileSuppliersBody();
              case MainViewMode.tablet:
                return TabletSuppliersBody();
              case MainViewMode.desktop:
                return DesktopSuppliersBody();
            }
          },
        ),
      ),
    );
  }
}
