import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../../core/enums/desktop_drawer_mode.dart';
import '../../../../../core/languages/languages.dart';
import '../../cubits/main_view_cubit/main_view_cubit.dart';
import '../custom_main_view_drawer.dart';

class DesktopDrawerSection extends StatelessWidget {
  const DesktopDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainViewCubit, MainViewState>(
      buildWhen: (previous, current) {
        return previous.drawerMode != current.drawerMode;
      },
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: state.drawerMode == DesktopDrawerMode.open ? 400.w : 80.w,
          ),
          decoration: BoxDecoration(
            border: Border(
              left:
                  Languages.currentLanguage.isArabic
                      ? BorderSide(color: context.colorScheme.secondaryFixed)
                      : BorderSide.none,
              right:
                  Languages.currentLanguage.isArabic
                      ? BorderSide.none
                      : BorderSide(color: context.colorScheme.secondaryFixed),
            ),
          ),
          child: Column(
            children: [
              AppBar(
                scrolledUnderElevation: 0,
                leading: BlocBuilder<MainViewCubit, MainViewState>(
                  buildWhen: (previous, current) {
                    return previous.drawerMode != current.drawerMode;
                  },
                  builder: (context, state) {
                    final cubit = MainViewCubit.get(context);
                    return IconButton(
                      icon: Icon(
                        state.drawerMode == DesktopDrawerMode.open
                            ? Icons.menu_open
                            : Icons.menu,
                      ),
                      onPressed: () {
                        cubit.toggleDesktopDrawer();
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child:
                    state.drawerMode == DesktopDrawerMode.open
                        ? CustomOpenedDrawer()
                        : CustomCollapsedDrawer(),
              ),
            ],
          ),
        );
      },
    );
  }
}
