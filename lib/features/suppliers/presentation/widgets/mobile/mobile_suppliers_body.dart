import 'package:flutter/material.dart';

import '../../../../../core/utils/gaps.dart';
import '../custom_suppliers_body_appbar.dart';
import '../suppliers_list.dart';

class MobileSuppliersBody extends StatelessWidget {
  const MobileSuppliersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        CustomSuppliersBodyAppbar(),
        sliverGapH(16),
        SuppliersList(),
        sliverGapH(kBottomNavigationBarHeight + 20),
      ],
    );
  }
}
