import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/play_type.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/widgets/expanded_drop_down.dart';
import '../../../devices/data/models/device_model.dart';
import '../cubits/cubit/session_cubit.dart';
import 'session_timer_and_actions.dart';

part 'session_customer_payment_holder.dart';

class MainSessionDataHolder extends StatelessWidget {
  const MainSessionDataHolder({super.key, this.showTimerAndActions = true});
  final bool showTimerAndActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.h12,
        children: [
          _SessionCustomerPaymentHolder(
            showTimerAndActions: showTimerAndActions,
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.all(AppPadding.pf8),
              decoration: BoxDecoration(
                color: context.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
              child: BlocBuilder<SessionCubit, SessionState>(
                buildWhen: (previous, current) {
                  return previous.playType != current.playType ||
                      previous.isSessionActive != current.isSessionActive;
                },
                builder: (context, state) {
                  final cubit = SessionCubit.get(context);
                  return ExpandedDropdown<PlayType>(
                    hint: LocaleKeys.playType,
                    items: PlayType.values,
                    isEnabled: !state.isSessionActive,
                    selectedValue: state.playType.localizedName,
                    backgroundColor: context.mapCard,
                    searchFieldColor: context.mapCard,
                    itemLabelBuilder: (PlayType p) {
                      return p.localizedName;
                    },
                    onChanged: (value) {
                      if (value != null) {
                        cubit.changePlayType(value);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
