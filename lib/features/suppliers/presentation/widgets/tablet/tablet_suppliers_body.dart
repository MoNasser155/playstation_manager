import 'package:flutter/material.dart';

import '../../../../../core/utils/gaps.dart';
import '../custom_suppliers_body_appbar.dart';
import '../suppliers_list.dart';

class TabletSuppliersBody extends StatelessWidget {
  const TabletSuppliersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        sliverGapH(12),
        CustomSuppliersBodyAppbar(),
        sliverGapH(16),
        SuppliersList(),
        sliverGapH(12),
      ],
    );
  }
}
