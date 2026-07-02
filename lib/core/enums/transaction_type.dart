import '../languages/local_keys.g.dart';

enum TransactionType { 
  invoiceProfit,
  customerPayment,
  supplierPurchase,
  supplierPayment;

  String get localizedName {
    switch (this) {
      case TransactionType.invoiceProfit:
        return LocaleKeys.invoiceProfit;
      case TransactionType.customerPayment:
        return LocaleKeys.customerPayment;
      case TransactionType.supplierPurchase:
        return LocaleKeys.supplierPurchase;
      case TransactionType.supplierPayment:
        return LocaleKeys.supplierPayment;
    }
  }
}