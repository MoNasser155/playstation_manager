import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/vector_icon.dart';

class DeviceNotSelectedPlaceholder extends StatelessWidget {
  const DeviceNotSelectedPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.pf16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VectorIcon(
              assetPath: VectorIcons.gamepad,
              width: 64,
              height: 64,
              color: context.colorScheme.secondaryFixed,
            ),
            gapH(16),
            Text(
              LocaleKeys.selectDevice,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.secondaryFixed,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.s32,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
