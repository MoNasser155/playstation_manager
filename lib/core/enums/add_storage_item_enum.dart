import '../languages/local_keys.g.dart';

enum AddStorageItemEnum {
  newItem,
  existingItem;

  String get localizedName => switch (this) {
    AddStorageItemEnum.newItem => LocaleKeys.addNewItem,
    AddStorageItemEnum.existingItem => LocaleKeys.useExistingItem,
  };
}
