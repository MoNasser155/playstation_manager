import '../languages/local_keys.g.dart';

enum PaymentType {
  cash, later;

  String get localizedName {
    switch (this) {
      case PaymentType.cash:
        return LocaleKeys.cash;
      case PaymentType.later:
        return LocaleKeys.later;
    }
  }
}