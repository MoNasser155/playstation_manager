import 'package:playstation_manager/core/objectbox/objectbox.g.dart';

import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../models/home_model.dart';
import '../models/home_profit.dart';

abstract class HomeLocalDataSource {
  HomeModel getHomeData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  @override
  HomeModel getHomeData() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStart = DateTime(
      yesterday.year,
      yesterday.month,
      yesterday.day,
      0,
      0,
      0,
    );
    final yesterdayEnd = DateTime(
      yesterday.year,
      yesterday.month,
      yesterday.day,
      23,
      59,
      59,
    );

    // 1. Fetch today's transactions
    final todayTxQuery =
        _store.transactions
            .query(
              TransactionModel_.createdAt
                  .greaterOrEqual(todayStart.millisecondsSinceEpoch)
                  .and(
                    TransactionModel_.createdAt.lessOrEqual(
                      todayEnd.millisecondsSinceEpoch,
                    ),
                  ),
            )
            .build();
    final todayTransactions = todayTxQuery.find();
    todayTxQuery.close();

    // 2. Fetch yesterday's transactions
    final yesterdayTxQuery =
        _store.transactions
            .query(
              TransactionModel_.createdAt
                  .greaterOrEqual(yesterdayStart.millisecondsSinceEpoch)
                  .and(
                    TransactionModel_.createdAt.lessOrEqual(
                      yesterdayEnd.millisecondsSinceEpoch,
                    ),
                  ),
            )
            .build();
    final yesterdayTransactions = yesterdayTxQuery.find();
    yesterdayTxQuery.close();

    // 3. Compute profits
    final todayProfit = todayTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.sessionProfit ?? 0.0),
    );
    final yesterdayProfit = yesterdayTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.sessionProfit ?? 0.0),
    );

    // 4. Fetch all devices
    final devices = _store.devices.getAll();

    // 5. Fetch active sessions (where isSession is true)
    final sessionsQuery =
        _store.sessions.query(SessionModel_.isSession.equals(true)).build();
    final sessions = sessionsQuery.find();
    sessionsQuery.close();

    // Sort today's transactions by date desc for display in UI
    todayTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return HomeModel(
      profit: HomeProfit(
        todayProfit: todayProfit,
        yesterdayProfit: yesterdayProfit,
      ),
      devices: devices,
      sessions: sessions,
      transactions: todayTransactions,
    );
  }
}
