import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';

class CustomDetailsTransactionsHeader extends StatelessWidget {
  const CustomDetailsTransactionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: CustomSliverAppbar(
        applyPadding: true,
        height: 30,
        flexibleWidget: Row(
          children: [
            const SizedBox(width: 64),
            Expanded(
              flex: 7,
              child: Text(
                LocaleKeys.note,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                LocaleKeys.before,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                LocaleKeys.total,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                LocaleKeys.paid,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                LocaleKeys.after,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                LocaleKeys.type,
                style: context.textTheme.headlineLarge,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                LocaleKeys.date,
                style: context.textTheme.headlineLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
