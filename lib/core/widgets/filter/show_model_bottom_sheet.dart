import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../constants/app_values.dart';
import '../../utils/gaps.dart';
import '../custom_button.dart';
import 'custom_filter_body.dart';
import 'expanded_filter_body.dart';

part 'custom_add_sheet_body.dart';

class CustomModalBottomSheet {
  const CustomModalBottomSheet();

  static Future<T?> show<T, C extends BlocBase<S>, S>({
    required BuildContext context,
    required Widget child,
    C? cubit,
  }) {
    return showModalBottomSheet<T>(
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.s24),
          topRight: Radius.circular(AppSize.s24),
        ),
      ),
      backgroundColor: context.mapCard,
      context: context,
      builder: (bottomSheetContext) {
        if (cubit != null) {
          return BlocProvider<C>.value(
            value: cubit,
            child: BlocBuilder<C, S>(builder: (context, state) => child),
          );
        }
        return child;
      },
    );
  }

  /// Specialized method for filter bottom sheets using DraggableScrollableSheet and CustomFilterBody.
  static Future<void> showFilter<C extends BlocBase<S>, S>({
    required BuildContext context,
    required List<Widget> children,
    required void Function()? onTap,
    required bool isLoading,
    required void Function() onTapClearButton,
    C? cubit,
  }) {
    return show<void, C, S>(
      context: context,
      cubit: cubit,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: CustomFilterBody(
              scrollController: scrollController,
              onTap: onTap,
              isLoading: isLoading,
              onTapClearButton: onTapClearButton,
              children: children,
            ),
          );
        },
      ),
    );
  }

  static Future<void> showAddSheet<C extends BlocBase<S>, S>({
    required BuildContext context,
    required String title,
    required String buttonTitle,
    required List<Widget> children,
    required void Function()? onTap,
    required bool isLoading,
    C? cubit,
  }) {
    return show<void, C, S>(
      context: context,
      cubit: cubit,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: _CustomAddSheetBody(
              scrollController: scrollController,
              onTap: onTap,
              isLoading: isLoading,
              title: title,
              buttonTitle: buttonTitle,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
