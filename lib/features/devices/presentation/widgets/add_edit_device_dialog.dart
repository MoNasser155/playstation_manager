import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/enums/device_status.dart';
import '../../../../core/enums/device_type.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/utils/validations.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/expanded_drop_down.dart';
import '../../data/models/device_model.dart';
import '../cubits/add_device_cubit/add_device_cubit.dart';
import '../cubits/add_device_cubit/add_device_state.dart';

class AddEditDeviceDialog extends StatelessWidget {
  const AddEditDeviceDialog({super.key, this.device});

  final DeviceModel? device;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddDeviceCubit()..setInitialValues(device),
      child: BlocBuilder<AddDeviceCubit, AddDeviceState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          final cubit = AddDeviceCubit.get(context);
          final isEdit = device != null;

          return Form(
            key: cubit.formKey,
            child: CustomDialog(
              children: [
                Text(
                  isEdit ? LocaleKeys.editDevice : LocaleKeys.addDevice,
                  style: context.textTheme.headlineLarge,
                ),
                gapH(24),
                CustomTextField(
                  hint: LocaleKeys.deviceName,
                  controller: cubit.nameController,
                  prefix: const Icon(Icons.gamepad_outlined),
                  validate: Validations.validateEmpty,
                ),
                gapH(20),
                CustomTextField(
                  hint: LocaleKeys.hourlyRate,
                  controller: cubit.hourlyRateController,
                  prefix: const Icon(Icons.monetization_on_outlined),
                  validate: Validations.validateEmpty,
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                ),
                gapH(20),
                BlocBuilder<AddDeviceCubit, AddDeviceState>(
                  buildWhen: (prev, curr) => prev.deviceType != curr.deviceType,
                  builder: (context, state) {
                    return ExpandedDropdown<DeviceType>(
                      prefix: const Icon(Icons.merge_type_rounded),
                      hint: LocaleKeys.deviceType,
                      items: DeviceType.values,
                      selectedValue: state.deviceType.localizedName,
                      itemLabelBuilder: (DeviceType t) => t.localizedName,
                      onChanged: (value) {
                        if (value != null) {
                          cubit.changeDeviceType(value);
                        }
                      },
                    );
                  },
                ),
                if (isEdit) ...[
                  gapH(20),
                  BlocBuilder<AddDeviceCubit, AddDeviceState>(
                    buildWhen:
                        (prev, curr) => prev.deviceStatus != curr.deviceStatus,
                    builder: (context, state) {
                      return ExpandedDropdown<DeviceStatus>(
                        prefix: const Icon(Icons.info_outline_rounded),
                        hint: LocaleKeys.deviceStatus,
                        items: DeviceStatus.values,
                        selectedValue: state.deviceStatus.localizedName,
                        itemLabelBuilder: (DeviceStatus s) => s.localizedName,
                        onChanged: (value) {
                          if (value != null) {
                            cubit.changeDeviceStatus(value);
                          }
                        },
                      );
                    },
                  ),
                ],
                gapH(24),
                CustomButton(
                  isLoading: state.status.isLoading,
                  title: LocaleKeys.save,
                  onTap: () {
                    cubit.submit(existingDevice: device);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
