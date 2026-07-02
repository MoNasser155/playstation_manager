import '../languages/local_keys.g.dart';

enum UserType {
  customer,
  supplier;

  String get localizedName {
    switch (this) {
      case UserType.customer:
        return LocaleKeys.customer;
      case UserType.supplier:
        return LocaleKeys.supplier;
    }
  }

  bool get isCustomer => this == UserType.customer;
  bool get isSupplier => this == UserType.supplier;
}