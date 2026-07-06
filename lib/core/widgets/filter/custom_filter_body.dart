import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../constants/app_values.dart';
import '../../languages/local_keys.g.dart';
import '../../utils/gaps.dart';
import '../custom_button.dart';
import 'clear_filter_button.dart';
import 'expanded_filter_body.dart';

class CustomFilterBody extends StatelessWidget {
  const CustomFilterBody({
    super.key,
    required this.scrollController,
    required this.children,
    required this.onTap,
    required this.isLoading,

    required this.onTapClearButton,
  });

  final ScrollController scrollController;
  final List<Widget> children;
  final void Function()? onTap;
  final bool isLoading;

  final void Function() onTapClearButton;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          spacing: AppSpacing.v12,
          children: [
            gapH(0),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(AppSize.s24),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),
              child: Row(
                children: [
                  Visibility(
                    visible: false,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainSize: true,
                    maintainSemantics: true,
                    maintainInteractivity: true,
                    child: ClearFiltersButton(onTap: onTapClearButton),
                  ),
                  Spacer(),
                  Text(
                    LocaleKeys.filters,
                    style: context.textTheme.titleLarge!.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  Spacer(),
                  ClearFiltersButton(onTap: onTapClearButton),
                ],
              ),
            ),
          ],
        ),
        ExpandedFilterBody(
          scrollController: scrollController,
          children: children,
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: AppSpacing.v12,
            left: AppPadding.pf20,
            right: AppPadding.pf20,
            top: AppSpacing.v6,
          ),
          child: CustomButton(
            onTap: onTap,
            isLoading: isLoading,
            title: LocaleKeys.apply,
          ),
        ),
      ],
    );
  }
}
