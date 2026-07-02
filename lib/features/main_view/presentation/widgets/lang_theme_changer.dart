import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/shared/cubits/global_theming_cubit.dart';
import '../../../../core/shared/models/option_row_model.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_option_row.dart';
import '../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../core/widgets/switch_lang_button.dart';

class LangWithThemeChanger extends StatelessWidget {
  const LangWithThemeChanger({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          Spacer(),

          SwitchLangButton(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pf16),
            child: CustomOptionRow(
              style: context.textTheme.headlineLarge!.copyWith(
                color: context.colorScheme.onPrimary,
              ),
              optionRowModel: OptionRowModel(
                title: LocaleKeys.darkMode,
                suffix: CustomToggle(
                  initialValue:
                      context.read<GlobalThemingCubit>().state.themeMode ==
                      ThemeMode.dark,
                  onChanged: (value) {
                    context.read<GlobalThemingCubit>().toggleTheme();
                  },
                ),
              ),
            ),
          ),
          gapH(20),
        ],
      ),
    );
  }
}
