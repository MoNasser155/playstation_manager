import '../languages/local_keys.g.dart';

enum TransactionType { 
  sessionProfit;


  String get localizedName {
    switch (this) {
      case TransactionType.sessionProfit:
        return LocaleKeys.sessionProfit;
     
    }
  }
}