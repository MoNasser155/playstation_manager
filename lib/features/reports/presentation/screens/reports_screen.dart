import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/di.dart';
import '../cubits/cubit/reports_cubit.dart';
import '../widgets/reports_layout.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportsCubit>()..getReportData(),
      child: Scaffold(
        key: ValueKey(context.locale.toString()),
        body: const SafeArea(child: ReportsLayout()),
      ),
    );
  }
}
