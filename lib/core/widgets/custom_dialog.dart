import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../constants/app_values.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key, required this.children, this.maxWidth});
  final List<Widget> children;
  final double? maxWidth;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),
      child: Container(
        padding: EdgeInsets.all(AppPadding.pf12),
        decoration: BoxDecoration(
          color: context.mapCard,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        constraints: BoxConstraints(maxWidth: maxWidth ?? context.width * .6),
        child: ListView(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: children,
        ),
      ),
    );
  }
}
