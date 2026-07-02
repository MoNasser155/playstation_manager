import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/theme/app_colors.dart';
import 'custom_tap_bar.dart';

class MobileBottomSheet extends StatelessWidget {
  const MobileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.0, 0.4],
          colors: [
            AppColors.darkContainer.withValues(alpha: 0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: AppPadding.pf20,
          right: AppPadding.pf20,
          bottom: AppPadding.pf12,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.grey800.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const CustomTabBar(),
            ),
          ),
        ),
      ),
    );
  }
}
