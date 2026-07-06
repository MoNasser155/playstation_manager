import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/media_query_extenstions.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/play_type.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/shared/di.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/expanded_drop_down.dart';
import '../../../sessions/presentation/cubits/cubit/session_cubit.dart';
import '../../data/models/device_model.dart';

class StartSessionDialog extends StatelessWidget {
  const StartSessionDialog({super.key, required this.device});
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SessionCubit>()..init(context, device: device),
      child: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          final cubit = SessionCubit.get(context);
          return CustomDialog(
            maxWidth: context.width * .35,
            children: [
              Text(
                "${LocaleKeys.startSession} - ${device.name}",
                style: context.textTheme.displayLarge,
              ),
              gapH(16),
              Text(LocaleKeys.playType, style: context.textTheme.titleMedium),
              gapH(8),
              ExpandedDropdown<PlayType>(
                hint: LocaleKeys.playType,
                items: PlayType.values,
                selectedValue: state.playType.localizedName,
                backgroundColor: context.primaryContainer,
                searchFieldColor: context.mapCard,
                itemLabelBuilder: (PlayType p) => p.localizedName,
                onChanged: (value) {
                  if (value != null) {
                    cubit.changePlayType(value);
                  }
                },
              ),
              gapH(20),
              Row(
                spacing: AppSpacing.h12,
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonHeight: 40,
                      title: LocaleKeys.cancel,
                      textColor: context.colorScheme.onPrimary,
                      backgroundColor: context.mapCard,
                      borderColor: context.colorScheme.primary,
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      title: LocaleKeys.startSession,
                      buttonHeight: 40,
                      onTap: () async {
                        await cubit.startSession(context);
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
