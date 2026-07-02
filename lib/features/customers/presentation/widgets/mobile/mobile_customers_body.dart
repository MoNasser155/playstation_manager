import 'package:flutter/material.dart';

import '../../../../../core/utils/gaps.dart';
import '../custom_customers_body_appbar.dart';
import '../customers_list.dart';

class MobileCustomersBody extends StatelessWidget {
  const MobileCustomersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        const CustomCustomersBodyAppbar(),
        sliverGapH(16),
        const CustomersList(),
        sliverGapH(kBottomNavigationBarHeight + 20),
      ],
    );
  }
}
