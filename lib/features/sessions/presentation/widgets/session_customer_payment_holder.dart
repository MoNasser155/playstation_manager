part of 'main_session_data_holder.dart';

class _SessionCustomerPaymentHolder extends StatelessWidget {
  const _SessionCustomerPaymentHolder({required this.showTimerAndActions});
  final bool showTimerAndActions;

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
          children: [
            BlocBuilder<SessionCubit, SessionState>(
              buildWhen: (previous, current) {
                return previous.devices != current.devices ||
                    previous.selectedDevice != current.selectedDevice;
              },
              builder: (context, state) {
                final cubit = SessionCubit.get(context);
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

            if (showTimerAndActions)
              const SessionTimerAndActions(isDesktop: false),
          ],
        ),
      ),
    );
  }
}
