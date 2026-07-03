import '../languages/local_keys.g.dart';

enum DeviceStatus {
  available,
  reserved,
  maintenance;

  String get localizedName {
    switch (this) {
      case DeviceStatus.available:
        return LocaleKeys.available;
      case DeviceStatus.reserved:
        return LocaleKeys.reserved;
      case DeviceStatus.maintenance:
        return LocaleKeys.maintenance;
    }
  }
}
