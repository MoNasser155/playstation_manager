import 'package:flutter/material.dart';

import '../../../../../core/utils/gaps.dart';
import '../custom_customers_body_appbar.dart';
import '../customers_list.dart';

class TabletCustomersBody extends StatelessWidget {
  const TabletCustomersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        sliverGapH(12),
        const CustomCustomersBodyAppbar(),
        sliverGapH(16),
        const CustomersList(),
        sliverGapH(12),
      ],
    );
  }
}
