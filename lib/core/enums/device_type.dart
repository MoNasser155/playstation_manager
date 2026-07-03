import '../languages/local_keys.g.dart';

enum DeviceType {
  ps4,
  ps5,
  ps3,
  vr,
  other;

  String get localizedName {
    switch (this) {
      case DeviceType.ps4:
        return LocaleKeys.ps4;
      case DeviceType.ps5:
        return LocaleKeys.ps5;
      case DeviceType.ps3:
        return LocaleKeys.ps3;
      case DeviceType.vr:
        return LocaleKeys.vr;
      case DeviceType.other:
        return LocaleKeys.other;
    }
  }
}
