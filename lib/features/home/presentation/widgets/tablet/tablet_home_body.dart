import 'package:flutter/material.dart';

import '../../../../../core/extentions/media_query_extenstions.dart';
import '../../../../../core/utils/gaps.dart';
import '../../home_taps_grid_view.dart';

class TabletHomeBody extends StatelessWidget {
  const TabletHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [sliverGapHFix(context.height / 3), HomeTapsGridView()],
    );
  }
}
