import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_values.dart';
import '../../../../data/models/taps_model.dart';
import 'tap_icon.dart';
import 'tap_label.dart';

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.index,
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  final int index;
  final TapsModel config;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.pf8),
        child: Column(
          spacing: AppPadding.p4,
          mainAxisSize: MainAxisSize.min,
          children: [
            TabIcon(icon: config.icon, isSelected: isSelected),
            TabLabel(label: config.title, isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
