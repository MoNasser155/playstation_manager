part of 'custom_add_new_storage_item.dart';

class _StorageItemDropdown extends StatelessWidget {
  const _StorageItemDropdown({required this.cubit});
  final AddStorageItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddStorageItemCubit, AddStorageItemState>(
      buildWhen: (previous, current) {
        return previous.storageItems != current.storageItems ||
            previous.selectedStorageItem != current.selectedStorageItem ||
            previous.status != current.status;
      },
      builder: (context, state) {
        final isFetching = state.status.isLoading;

        return ExpandedDropdown<StorageModel>(
          prefix: Icon(Icons.inventory_2_outlined),
          withSearch: true,
          isEnabled: !isFetching && !state.itemLocked,
          isLoading: isFetching,
          selectedValue: state.selectedStorageItem?.itemName,
          hint: LocaleKeys.selectItem,
          items: state.storageItems,
          itemLabelBuilder: (StorageModel p1) {
            return p1.itemName;
          },
          onChanged: (value) {
            cubit.setSelectedStorageItem(value);
          },
        );
      },
    );
  }
}
