part of 'main_invoice_data_holder.dart';

class _IvoiceCustomerPaymentHolder extends StatelessWidget {
  const _IvoiceCustomerPaymentHolder();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppPadding.pf8),
        decoration: BoxDecoration(
          color: context.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Column(
          spacing: AppSpacing.v12,
          children: [
            BlocBuilder<InvoiceCubit, InvoiceState>(
              buildWhen: (previous, current) {
                return previous.devices != current.devices ||
                    previous.selectedDevice != current.selectedDevice;
              },
              builder: (context, state) {
                final cubit = InvoiceCubit.get(context);
                return ExpandedDropdown<DeviceModel>(
                  withSearch: true,
                  hint:
                      state.devices.isEmpty
                          ? LocaleKeys.noDevicesRegistered
                          : LocaleKeys.selectDevice,
                  items: state.devices,
                  isEnabled: state.devices.isNotEmpty,
                  selectedValue: state.selectedDevice?.name,
                  backgroundColor: context.mapCard,
                  searchFieldColor: context.mapCard,
                  itemLabelBuilder: (DeviceModel d) {
                    return d.name;
                  },
                  onChanged: (value) {
                    cubit.selectDevice(value);
                  },
                );
              },
            ),

            BlocBuilder<InvoiceCubit, InvoiceState>(
              buildWhen: (previous, current) {
                return previous.selectedDevice != current.selectedDevice ||
                    previous.isSessionActive != current.isSessionActive ||
                    previous.sessionDuration != current.sessionDuration ||
                    previous.sessionCost != current.sessionCost;
              },
              builder: (context, state) {
                if (state.selectedDevice == null) {
                  return const SizedBox.shrink();
                }

                final cubit = InvoiceCubit.get(context);
                final device = state.selectedDevice!;

                if (state.isSessionActive) {
                  String formatDuration(Duration duration) {
                    String twoDigits(int n) => n.toString().padLeft(2, '0');
                    final hours = twoDigits(duration.inHours);
                    final minutes = twoDigits(duration.inMinutes.remainder(60));
                    final seconds = twoDigits(duration.inSeconds.remainder(60));
                    return "$hours:$minutes:$seconds";
                  }

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.mapCard,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      border: Border.all(color: Colors.orange, width: 1.2),
                    ),
                    child: Column(
                      spacing: AppSpacing.v8,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.sessionDuration,
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              formatDuration(state.sessionDuration),
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.sessionCost,
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              "${state.sessionCost.toStringAsFixed(2)} ${LocaleKeys.egp}",
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        gapH(4),
                        CustomButton(
                          title: LocaleKeys.endSession,
                          backgroundColor: context.colorScheme.error,
                          onTap: () {
                            cubit.endSession(context);
                          },
                        ),
                      ],
                    ),
                  );
                } else if (device.status == DeviceStatus.available) {
                  return CustomButton(
                    title: LocaleKeys.startSession,
                    backgroundColor: Colors.green,
                    onTap: () {
                      cubit.startSession(context);
                    },
                  );
                } else if (device.status == DeviceStatus.maintenance) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      border: Border.all(color: context.colorScheme.error),
                    ),
                    child: Text(
                      LocaleKeys.maintenance,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
