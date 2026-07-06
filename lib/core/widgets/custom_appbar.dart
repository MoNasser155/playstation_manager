import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../constants/app_values.dart';
import '../utils/gaps.dart';
import '../utils/navigator_helper.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    this.title,
    this.suffix,
    this.applyPadding = false,
    this.centerTitle = false,
    this.onBackTap,
    this.titleWidget,
  });
  final String? title;
  final Widget? titleWidget;
  final Widget? suffix;
  final bool? applyPadding, centerTitle;
  final void Function()? onBackTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          height: AppSize.appbarHeight,
          padding: EdgeInsets.only(
            left: applyPadding == true ? AppPadding.pf20 : 0,
            right: applyPadding == true ? AppPadding.pf20 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                centerTitle == true
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              InkWell(
                radius: AppRadius.r8,
                borderRadius: BorderRadius.circular(AppRadius.r16),
                onTap: () {
                  if (onBackTap != null) {
                    onBackTap!();
                  } else {
                    AppNavigator.pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.pf8),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
              centerTitle == true ? const Spacer() : gapW(12),
              titleWidget ??
                  Text(
                    title == null ? '' : title!,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium!.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
              const Spacer(),
              suffix ?? gapW(AppSize.s24),
            ],
          ),
        ),
      ),
    );
  }
}
