import '../languages/local_keys.g.dart';

enum StorageItemType{
  unit,
  meter,
  weight;

  String get localizedName {
    switch (this) {
      case StorageItemType.unit:
        return LocaleKeys.unit;
      case StorageItemType.meter:
        return LocaleKeys.meter;
      case StorageItemType.weight:
        return LocaleKeys.weight;
    }
  }
}