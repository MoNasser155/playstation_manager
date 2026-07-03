import 'package:flutter/material.dart';

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

  Color get color {
    switch (this) {
      case DeviceStatus.available:
        return Colors.green;
      case DeviceStatus.reserved:
        return Colors.orange;
      case DeviceStatus.maintenance:
        return Colors.red;
    }
  }
}
