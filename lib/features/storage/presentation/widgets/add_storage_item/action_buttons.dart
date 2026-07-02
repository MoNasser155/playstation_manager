part of 'custom_add_new_storage_item.dart';

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.cubit, required this.status});
  final AddStorageItemCubit cubit;
  final StateStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.h12,
      children: [
        Expanded(
          child: CustomButton(
            backgroundColor: context.mapCard,
            borderColor: context.colorScheme.error,
            textColor: context.colorScheme.onPrimary,
            title: LocaleKeys.cancel,
            onTap: () {
              AppNavigator.pop();
            },
          ),
        ),
        Expanded(
          child: CustomButton(
            isLoading: status.isLoading,
            title: LocaleKeys.save,
            onTap: () {
              cubit.addStorageItem(context);
            },
          ),
        ),
      ],
    );
  }
}
