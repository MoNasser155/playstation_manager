import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/features/sessions/presentation/widgets/session_items_list/session_items_total_row.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../cubits/cubit/session_cubit.dart';

class SessionItemAddButton extends StatelessWidget {
  const SessionItemAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen:
          (previous, current) => previous.canAddItem != current.canAddItem,
      builder: (context, state) {
        final cubit = SessionCubit.get(context);
        final enabled = state.canAddItem;

        return CustomSliverPadding(
          verticalPadding: AppSpacing.h8,
          child: Row(
            spacing: AppSpacing.h12,
            children: [
              Expanded(flex: 3, child: SessionItemsTotalRow()),
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: enabled ? 1.0 : 0.4,
                  child: CustomButton(
                    onTap: enabled ? cubit.addSessionItem : null,
                    title: LocaleKeys.addItem,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
