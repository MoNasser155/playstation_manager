import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/main_view_cubit/main_view_cubit.dart';
import '../widgets/mobile/mobile_buttom_sheet.dart';

class MobileMainViewScreen extends StatelessWidget {
  const MobileMainViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.toString()),
      bottomSheet: MobileBottomSheet(),
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
