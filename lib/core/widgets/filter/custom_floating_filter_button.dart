import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../constants/app_values.dart';
import '../../utils/gaps.dart';
import 'show_model_bottom_sheet.dart';

class CustomFloatingFilterButton<C extends BlocBase<S>, S>
    extends StatelessWidget {
  const CustomFloatingFilterButton({
    super.key,
    required this.children,
    required this.onTap,
    required this.isLoading,
    this.cubit,
    this.floatingButton,
    required this.onTapClearButton,
    this.applyBottomGap = false,
  });

  final List<Widget> children;
  final void Function()? onTap;
  final bool isLoading;

  final C? cubit;
  final Widget? floatingButton;

  final void Function() onTapClearButton;
  final bool applyBottomGap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: AppPadding.pf12),

          child: FloatingActionButton(
            heroTag: null,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            backgroundColor:
                floatingButton != null
                    ? Colors.transparent
                    : context.colorScheme.primary,
            elevation: 0,
            onPressed: () {
              CustomModalBottomSheet.showFilter<C, S>(
                context: context,
                children: children,
                onTap: onTap,
                isLoading: isLoading,
                onTapClearButton: onTapClearButton,
                cubit: cubit,
              );
            },
            child:
                floatingButton ??
                const Icon(Icons.tune_rounded, color: Colors.white, size: 28),
          ),
        ),
        applyBottomGap
            ? gapH(kBottomNavigationBarHeight + 10)
            : const SizedBox.shrink(),
      ],
    );
  }
}
