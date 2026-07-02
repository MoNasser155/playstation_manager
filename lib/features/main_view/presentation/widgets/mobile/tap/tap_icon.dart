import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../../core/widgets/vector_icon.dart';

class TabIcon extends StatelessWidget {
  const TabIcon({super.key, required this.icon, required this.isSelected});

  final String icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: isSelected ? 1.2 : 0.9,
      child: VectorIcon(
        assetPath: icon,
        color:
            isSelected
                ? context.colorScheme.primary
                : context.colorScheme.secondaryFixed,
      ),
    );
  }
}
