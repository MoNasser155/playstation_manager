import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/main_view_cubit/main_view_cubit.dart';
import '../widgets/desktop/desktop_drawer_section.dart';

class DesktopMainViewScreen extends StatelessWidget {
  const DesktopMainViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.toString()),
      body: Row(
        children: [
          DesktopDrawerSection(),
          Expanded(
            child: BlocBuilder<MainViewCubit, MainViewState>(
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
          ),
        ],
      ),
    );
  }
}
