import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/media_query_extenstions.dart';
import 'package:playstation_manager/core/utils/validations.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_pass_filed.dart';
import '../../cubits/cubit/profit_cubit.dart';

class PasswordBody extends StatelessWidget {
  const PasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfitCubit, ProfitState>(
      buildWhen:
          (previous, current) =>
              previous.passwordStatus != current.passwordStatus,
      builder: (context, state) {
        if (state.passwordStatus.isLoading || state.passwordStatus.isInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.passwordStatus.isFailure) {
          return const _SetPasswordForm();
        }

        return const _EnterPasswordForm();
      },
    );
  }
}

class _SetPasswordForm extends StatelessWidget {
  const _SetPasswordForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<ProfitCubit, ProfitState>(
          buildWhen: (p, c) => p.passwordStatus != c.passwordStatus,
          builder: (context, state) {
            final cubit = ProfitCubit.get(context);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),
              constraints: BoxConstraints(
                maxWidth: context.width / 2,
                minWidth: 335,
              ),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: PassFieldWithLabel(
                            label: LocaleKeys.password,
                            controller: cubit.passwordController,
                            validate: Validations.validatePassword,
                          ),
                        ),
                      ],
                    ),
                    gapH(20),
                    PassFieldWithLabel(
                      label: LocaleKeys.confirmPassword,
                      controller: cubit.confirmPasswordController,
                      validate:
                          (v) => Validations.validateConfirmPassword(
                            v,
                            cubit.passwordController.text,
                          ),
                    ),
                    gapH(32),
                    CustomButton(
                      title: LocaleKeys.save,
                      onTap: cubit.saveUserPassword,
                      isLoading: state.passwordStatus.isLoading,
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EnterPasswordForm extends StatelessWidget {
  const _EnterPasswordForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),
          constraints: BoxConstraints(
            maxWidth: context.width / 2,
            minWidth: 335,
          ),
          alignment: Alignment.center,
          child: BlocBuilder<ProfitCubit, ProfitState>(
            buildWhen: (p, c) => p.passwordStatus != c.passwordStatus,
            builder: (context, state) {
              final cubit = ProfitCubit.get(context);
              return Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    const Spacer(),
                    BlocBuilder<ProfitCubit, ProfitState>(
                      buildWhen: (p, c) => p.passwordStatus != c.passwordStatus,
                      builder: (context, state) {
                        return PassFieldWithLabel(
                          label: LocaleKeys.password,
                          controller: cubit.passwordController,
                          validate: (v) {
                            return Validations.validateEmpty(v);
                          },
                        );
                      },
                    ),
                    gapH(20),
                    CustomButton(
                      isEnabled: state.password?.isNotEmpty ?? false,
                      title: LocaleKeys.submitPassword,
                      isLoading: state.passwordStatus.isLoading,
                      onTap: () {
                        cubit.submitPassword(context);
                      },
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
