import 'package:flutter/material.dart';

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

  IconData get icon {
    switch (this) {
      case DeviceType.ps4:
      case DeviceType.ps5:
      case DeviceType.ps3:
        return Icons.gamepad_rounded;
      case DeviceType.vr:
        return Icons.vrpano_rounded;
      case DeviceType.other:
        return Icons.videogame_asset_rounded;
    }
  }
}
