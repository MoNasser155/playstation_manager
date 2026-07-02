import '../languages/local_keys.g.dart';

enum TransactionType { 
  invoiceProfit,
  customerPayment;

  String get localizedName {
    switch (this) {
      case TransactionType.invoiceProfit:
        return LocaleKeys.invoiceProfit;
      case TransactionType.customerPayment:
        return LocaleKeys.customerPayment;
    }
  }
}