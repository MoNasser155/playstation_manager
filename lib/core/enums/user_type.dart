import '../languages/local_keys.g.dart';

enum UserType {
  customer;

  String get localizedName {
    switch (this) {
      case UserType.customer:
        return LocaleKeys.customer;
    }
  }

  bool get isCustomer => this == UserType.customer;
  bool get isSupplier => false;
}