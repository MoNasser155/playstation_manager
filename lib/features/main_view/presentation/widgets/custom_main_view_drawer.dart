import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/languages.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/vector_icon.dart';
import '../cubits/main_view_cubit/main_view_cubit.dart';
import 'lang_theme_changer.dart';

class CustomOpenedDrawer extends StatelessWidget {
  const CustomOpenedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: CustomScrollView(
        slivers: [
          BlocBuilder<MainViewCubit, MainViewState>(
            buildWhen: (previous, current) {
              return previous.selectedTapIndex != current.selectedTapIndex;
            },
            builder: (context, state) {
              final cubit = MainViewCubit.get(context);
              return SliverList.separated(
                separatorBuilder: (context, index) {
                  return gapH(12);
                },
                itemBuilder: (context, index) {
                  final tap = cubit.taps[index];
                  final isSelected = state.selectedTapIndex == index;
                  return InkWell(
                    onTap: () {
                      cubit.setSelectedTap(index);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.p16,
                        vertical: AppPadding.p8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? context.colorScheme.secondaryFixed.withValues(
                                  alpha: 0.15,
                                )
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                        border:
                            isSelected
                                ? Languages.currentLanguage.isEnglish
                                    ? Border(
                                      left: BorderSide(
                                        color: context.colorScheme.primary,
                                        width: 4,
                                      ),
                                    )
                                    : Border(
                                      right: BorderSide(
                                        color: context.colorScheme.primary,
                                        width: 4,
                                      ),
                                    )
                                : null,
                      ),
                      child: Row(
                        spacing: AppSpacing.h8,
                        children: [
                          VectorIcon(
                            assetPath: tap.icon,
                            color:
                                isSelected
                                    ? context.colorScheme.primary
                                    : Colors.grey,
                          ),
                          Text(
                            tap.title,
                            style: context.textTheme.headlineLarge!.copyWith(
                              color:
                                  isSelected
                                      ? context.colorScheme.primary
                                      : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: cubit.taps.length,
              );
            },
          ),
          LangWithThemeChanger(),
        ],
      ),
    );
  }
}

class CustomCollapsedDrawer extends StatelessWidget {
  const CustomCollapsedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p8),
      child: CustomScrollView(
        slivers: [
          BlocBuilder<MainViewCubit, MainViewState>(
            buildWhen: (previous, current) {
              return previous.selectedTapIndex != current.selectedTapIndex;
            },
            builder: (context, state) {
              final cubit = MainViewCubit.get(context);

              return SliverList.separated(
                separatorBuilder: (context, index) {
                  return gapH(12);
                },
                itemBuilder: (context, index) {
                  final tap = cubit.taps[index];
                  final isSelected = state.selectedTapIndex == index;
                  return InkWell(
                    onTap: () {
                      cubit.setSelectedTap(index);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.p8,
                        vertical: AppPadding.p8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? context.colorScheme.secondaryFixed.withValues(
                                  alpha: 0.1,
                                )
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                        border:
                            isSelected
                                ? Languages.currentLanguage.isEnglish
                                    ? Border(
                                      left: BorderSide(
                                        color: context.colorScheme.primary,
                                        width: 4,
                                      ),
                                    )
                                    : Border(
                                      right: BorderSide(
                                        color: context.colorScheme.primary,
                                        width: 4,
                                      ),
                                    )
                                : null,
                      ),
                      child: VectorIcon(
                        assetPath: tap.icon,
                        color:
                            isSelected
                                ? context.colorScheme.primary
                                : Colors.grey,
                      ),
                    ),
                  );
                },
                itemCount: cubit.taps.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
