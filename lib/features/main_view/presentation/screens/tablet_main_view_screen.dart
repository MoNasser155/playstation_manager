import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/gaps.dart';
import '../cubits/main_view_cubit/main_view_cubit.dart';
import '../widgets/custom_main_view_drawer.dart';

class TabletMainViewScreen extends StatelessWidget {
  const TabletMainViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, toolbarHeight: 48),
      drawer: Drawer(
        child: Column(
          children: [gapH(20), Expanded(child: CustomOpenedDrawer())],
        ),
      ),

      body: BlocBuilder<MainViewCubit, MainViewState>(
        buildWhen: (previous, current) {
          return previous.mode != current.mode ||
              previous.selectedTapIndex != current.selectedTapIndex ||
              previous.customizedView != current.customizedView;
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(child: state.customizedView ?? state.drawerView),
            ],
          );
        },
      ),
    );
  }
}
