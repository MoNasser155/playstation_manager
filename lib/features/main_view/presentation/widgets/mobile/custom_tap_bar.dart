import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_values.dart';
import '../../cubits/main_view_cubit/main_view_cubit.dart';
import 'tap/tap_item.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainViewCubit, MainViewState>(
      builder: (context, state) {
        final cubit = MainViewCubit.get(context);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pf12),
          child: Container(
            height: 56.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                cubit.taps.length,
                (index) => Expanded(
                  child: TabItem(
                    index: index,
                    config: cubit.taps[index],
                    isSelected: state.selectedTapIndex == index,
                    onTap: () => cubit.setSelectedTap(index),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
