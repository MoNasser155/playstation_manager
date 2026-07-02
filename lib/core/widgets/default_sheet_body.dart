import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_values.dart';
import '../utils/gaps.dart';

class DefaultSheetBody extends StatelessWidget {
  final Widget child;
  const DefaultSheetBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Container(
            width: 1.sw,
            padding: EdgeInsets.only(
              bottom: ScreenUtil().bottomBarHeight == 0
                  ? AppSpacing.v20
                  : ScreenUtil().bottomBarHeight,
              left: AppSpacing.h20,
              right: AppSpacing.h20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSize.s24),
                topRight: Radius.circular(AppSize.s24),
              ),
            ),
            child: Wrap(children: [gapH(AppSpacing.v12), child]),
          ),
        ],
      ),
    );
  }
}
