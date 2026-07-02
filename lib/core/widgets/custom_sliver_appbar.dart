import 'package:flutter/material.dart';

import '../constants/app_values.dart';
import 'custom_appbar.dart';

class CustomSliverAppbar extends StatelessWidget {
  const CustomSliverAppbar({
    super.key,
    this.title,
    this.suffix,
    this.flexibleWidget,
    this.height,
    this.scrollUnderElevation,
    this.expandedHeight,
    this.collapsedHeight,
    this.shape,
    this.backgroundColor,
    this.applyPadding = false,
    this.pinned = true,
    this.floating = true,
    this.centerTitle = false,
    this.onBackTap,
  });
  final String? title;
  final Widget? suffix;
  final Widget? flexibleWidget;
  final double? height, scrollUnderElevation;
  final double? expandedHeight;
  final double? collapsedHeight;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final bool applyPadding;
  final bool pinned, floating;
  final bool centerTitle;
  final void Function()? onBackTap;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      shape: shape,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: scrollUnderElevation ?? 8,
      toolbarHeight: height ?? AppSize.appbarHeight,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      stretch: true,
      flexibleSpace: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: applyPadding ? AppPadding.pf20 : 0,
        ),
        child:
            flexibleWidget ??
            CustomAppbar(
              centerTitle: centerTitle,
              applyPadding: true,
              onBackTap: onBackTap,
              title: title,
              suffix: suffix,
            ),
      ),
    );
  }
}
