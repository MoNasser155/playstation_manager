import 'package:flutter/material.dart';

import '../../constants/app_values.dart';
import '../../utils/gaps.dart';


class ExpandedFilterBody extends StatelessWidget {
  const ExpandedFilterBody({
    super.key,
    required this.scrollController,
    required this.children,
  });

  final ScrollController scrollController;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          sliverGapH(12),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),

            sliver: SliverList(
              delegate: SliverChildListDelegate(
                List.generate(children.length, (index) {
                  if (index != children.length - 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [children[index], gapH(AppSpacing.v20)],
                    );
                  }
                  return children[index];
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
