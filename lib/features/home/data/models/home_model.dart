import '../../../devices/data/models/device_model.dart';
import '../../../sessions/data/models/session_model.dart';
import '../../../transactions/data/models/transaction_model.dart';
import 'home_profit.dart';

class HomeModel {
  final HomeProfit profit;
  final List<DeviceModel> devices;
  final List<SessionModel> sessions;
  final List<TransactionModel> transactions;

  HomeModel({
    required this.profit,
    required this.devices,
    required this.sessions,
    required this.transactions,
  });
}
