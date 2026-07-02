import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../core/constants/app_values.dart';
import '../../../core/enums/home_cards.dart';
import '../../../core/widgets/custom_sliver_padding.dart';

class HomeTapsGridView extends StatelessWidget {
  const HomeTapsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HomeCards> cards = HomeCards.values;
    return CustomSliverPadding(
      sliver: SliverFillRemaining(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                key: ValueKey('${context.locale.toString()} ${context.theme}'),
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      cards[index].function(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppPadding.pf12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: Row(
                        spacing: AppSpacing.h16,
                        children: [
                          cards[index].getIcon(context),
                          Text(
                            cards[index].localizedName,
                            style: context.textTheme.displayLarge?.copyWith(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
