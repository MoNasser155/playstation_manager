import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/shared/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../cubits/main_view_cubit/main_view_cubit.dart';

class ResponsiveMainViewScreen extends StatelessWidget {
  const ResponsiveMainViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainViewCubit>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cubit = MainViewCubit.get(context);
          cubit.updateMode(constraints);
          return BlocConsumer<MainViewCubit, MainViewState>(
            listenWhen: (p, c) {
              return p.backupStatus != c.backupStatus ||
                  p.backupError != c.backupError ||
                  p.restoreStatus != c.restoreStatus;
            },
            listener: (context, state) {
              if (state.backupStatus.isSuccess) {
                CustomSnackBar.top(
                  context: context,
                  msg: LocaleKeys.backupCreatedSuccessfully,
                  color: AppColors.successColor,
                );
              } else if (state.backupStatus.isFailure) {
                CustomSnackBar.top(
                  context: context,
                  msg: LocaleKeys.backupCreationFailed,
                );
              } else if (state.restoreStatus.isSuccess) {
                CustomSnackBar.top(
                  context: context,
                  msg: LocaleKeys.backupRestoredSuccessfully,
                  color: AppColors.successColor,
                );
              } else if (state.restoreStatus.isFailure) {
                CustomSnackBar.top(
                  context: context,
                  msg: LocaleKeys.backupRestoreFailed,
                );
              }
            },
            buildWhen: (previous, current) {
              return previous.mode != current.mode ||
                  previous.isLoading != current.isLoading;
            },
            builder: (context, state) {
              return Stack(
                children: [
                  state.view,
                  if (state.isLoading) ...[
                    const ModalBarrier(
                      dismissible: false,
                      color: Colors.black38,
                    ),

                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
