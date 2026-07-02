import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';

import '../../../../../core/utils/gaps.dart';
import '../../home_taps_grid_view.dart';

class DesktopHomeBody extends StatelessWidget {
  const DesktopHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [sliverGapHFix(context.height / 3), HomeTapsGridView()],
    );
  }
}
