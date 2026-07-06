import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import 'desktop/desktop_reports_body.dart';
import 'mobile/mobile_reports_body.dart';
import 'tablet/tablet_reports_body.dart';

class ReportsLayout extends StatelessWidget {
  const ReportsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainViewCubit, MainViewState>(
      buildWhen: (previous, current) => previous.mode != current.mode,
      builder: (context, state) {
        switch (state.mode) {
          case MainViewMode.mobile:
            return const MobileReportsBody();
          case MainViewMode.tablet:
            return const TabletReportsBody();
          case MainViewMode.desktop:
            return const DesktopReportsBody();
        }
      },
    );
  }
}
