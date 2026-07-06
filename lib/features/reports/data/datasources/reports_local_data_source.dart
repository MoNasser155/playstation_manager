import 'package:playstation_manager/core/objectbox/objectbox.g.dart';

import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../../../sessions/data/models/session_model.dart';
import '../models/reports_model.dart';

abstract class ReportsLocalDataSource {
  ReportModel getReportData(ReportFilter filter);
}

class ReportsLocalDataSourceImpl implements ReportsLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  @override
  ReportModel getReportData(ReportFilter filter) {
    // 1. Query all completed sessions from database
    final completedSessionsQuery =
        _store.sessions.query(SessionModel_.isSession.equals(false)).build();
    final allCompletedSessions = completedSessionsQuery.find();
    completedSessionsQuery.close();

    // 2. Define date boundaries based on filters
    final now = DateTime.now();
    DateTime currentStart, currentEnd;
    DateTime previousStart, previousEnd;

    switch (filter) {
      case ReportFilter.today:
        currentStart = DateTime(now.year, now.month, now.day, 0, 0, 0);
        currentEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

        final yesterday = now.subtract(const Duration(days: 1));
        previousStart = DateTime(
          yesterday.year,
          yesterday.month,
          yesterday.day,
          0,
          0,
          0,
        );
        previousEnd = DateTime(
          yesterday.year,
          yesterday.month,
          yesterday.day,
          23,
          59,
          59,
        );
        break;

      case ReportFilter.thisWeek:
        currentStart = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));
        currentEnd = currentStart
            .add(const Duration(days: 7))
            .subtract(const Duration(seconds: 1));

        previousStart = currentStart.subtract(const Duration(days: 7));
        previousEnd = currentStart.subtract(const Duration(seconds: 1));
        break;

      case ReportFilter.thisMonth:
        currentStart = DateTime(now.year, now.month, 1, 0, 0, 0);
        final nextMonth = now.month == 12 ? 1 : now.month + 1;
        final nextMonthYear = now.month == 12 ? now.year + 1 : now.year;
        currentEnd = DateTime(
          nextMonthYear,
          nextMonth,
          1,
          0,
          0,
          0,
        ).subtract(const Duration(seconds: 1));

        int prevMonth = now.month - 1;
        int prevYear = now.year;
        if (prevMonth == 0) {
          prevMonth = 12;
          prevYear -= 1;
        }
        previousStart = DateTime(prevYear, prevMonth, 1, 0, 0, 0);
        final prevNextMonth = prevMonth == 12 ? 1 : prevMonth + 1;
        final prevNextMonthYear = prevMonth == 12 ? prevYear + 1 : prevYear;
        previousEnd = DateTime(
          prevNextMonthYear,
          prevNextMonth,
          1,
          0,
          0,
          0,
        ).subtract(const Duration(seconds: 1));
        break;

      case ReportFilter.thisYear:
        currentStart = DateTime(now.year, 1, 1, 0, 0, 0);
        currentEnd = DateTime(now.year, 12, 31, 23, 59, 59);

        previousStart = DateTime(now.year - 1, 1, 1, 0, 0, 0);
        previousEnd = DateTime(now.year - 1, 12, 31, 23, 59, 59);
        break;
    }

    // 3. Filter current and previous period sessions in memory
    final currentSessions =
        allCompletedSessions
            .where(
              (s) =>
                  s.sessionDate.isAfter(
                    currentStart.subtract(const Duration(seconds: 1)),
                  ) &&
                  s.sessionDate.isBefore(
                    currentEnd.add(const Duration(seconds: 1)),
                  ),
            )
            .toList();

    final previousSessions =
        allCompletedSessions
            .where(
              (s) =>
                  s.sessionDate.isAfter(
                    previousStart.subtract(const Duration(seconds: 1)),
                  ) &&
                  s.sessionDate.isBefore(
                    previousEnd.add(const Duration(seconds: 1)),
                  ),
            )
            .toList();

    // 4. Calculate core stats
    final totalRevenue = currentSessions.fold<double>(
      0.0,
      (sum, s) => sum + s.totalSession,
    );
    final previousRevenue = previousSessions.fold<double>(
      0.0,
      (sum, s) => sum + s.totalSession,
    );

    final double revenueChangePercentage =
        previousRevenue > 0
            ? ((totalRevenue - previousRevenue) / previousRevenue) * 100
            : (totalRevenue > 0 ? 100.0 : 0.0);

    final totalSessions = currentSessions.length;
    final avgSessionValue =
        totalSessions > 0 ? totalRevenue / totalSessions : 0.0;

    double totalProductsSold = 0.0;
    for (final session in currentSessions) {
      for (final item in session.items) {
        totalProductsSold += item.quantity;
      }
    }

    // 5. Daily revenue for the current week (Monday to Sunday)
    final dailyRevenue = _getDailyRevenueThisWeek(allCompletedSessions);

    // 6. Top 5 most used devices
    final deviceCounts = <int, int>{};
    for (final session in currentSessions) {
      final devId = session.device.targetId;
      if (devId != 0) {
        deviceCounts[devId] = (deviceCounts[devId] ?? 0) + 1;
      }
    }
    final sortedDevices =
        deviceCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final topDevices =
        sortedDevices.take(5).map((e) {
          final device = _store.devices.get(e.key);
          return DeviceUsage(
            deviceName: device?.name ?? 'Device #${e.key}',
            sessionCount: e.value,
          );
        }).toList();

    // 7. Top 5 best selling products
    final productQuantities = <String, double>{};
    final productRevenues = <String, double>{};
    for (final session in currentSessions) {
      for (final item in session.items) {
        final itemName = item.storageItem.target?.itemName ?? 'Product';
        productQuantities[itemName] =
            (productQuantities[itemName] ?? 0.0) + item.quantity;
        productRevenues[itemName] =
            (productRevenues[itemName] ?? 0.0) + item.totalItemPrice;
      }
    }
    final sortedProducts =
        productQuantities.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final topProducts =
        sortedProducts.take(5).map((e) {
          return ProductSale(
            productName: e.key,
            quantitySold: e.value,
            totalRevenue: productRevenues[e.key] ?? 0.0,
          );
        }).toList();

    // 8. Monthly income for last 6 months
    final monthlyIncome = _getMonthlyIncomeLast6Months(allCompletedSessions);

    return ReportModel(
      totalRevenue: totalRevenue,
      previousRevenue: previousRevenue,
      revenueChangePercentage: revenueChangePercentage,
      totalSessions: totalSessions,
      avgSessionValue: avgSessionValue,
      totalProductsSold: totalProductsSold,
      dailyRevenueThisWeek: dailyRevenue,
      topDevices: topDevices,
      topProducts: topProducts,
      monthlyIncome: monthlyIncome,
    );
  }

  List<DailyRevenue> _getDailyRevenueThisWeek(
    List<SessionModel> allCompletedSessions,
  ) {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final days = <DailyRevenue>[];
    List<String> weekdaysNames() {
      return [
        LocaleKeys.mon,
        LocaleKeys.tue,
        LocaleKeys.wed,
        LocaleKeys.thu,
        LocaleKeys.fri,
        LocaleKeys.sat,
        LocaleKeys.sun,
      ];
    }

    for (int i = 0; i < 7; i++) {
      final dayDate = startOfWeek.add(Duration(days: i));
      final dayStart = DateTime(
        dayDate.year,
        dayDate.month,
        dayDate.day,
        0,
        0,
        0,
      );
      final dayEnd = DateTime(
        dayDate.year,
        dayDate.month,
        dayDate.day,
        23,
        59,
        59,
      );

      final daySessions = allCompletedSessions.where(
        (s) =>
            s.sessionDate.isAfter(
              dayStart.subtract(const Duration(seconds: 1)),
            ) &&
            s.sessionDate.isBefore(dayEnd.add(const Duration(seconds: 1))),
      );

      final revenue = daySessions.fold<double>(
        0.0,
        (sum, s) => sum + s.totalSession,
      );

      days.add(
        DailyRevenue(
          date: dayDate,
          dayName: weekdaysNames()[i],
          revenue: revenue,
        ),
      );
    }
    return days;
  }

  List<MonthlyIncome> _getMonthlyIncomeLast6Months(
    List<SessionModel> allCompletedSessions,
  ) {
    final now = DateTime.now();
    final list = <MonthlyIncome>[];

    List<String> monthNames() {
      return [
        LocaleKeys.january,
        LocaleKeys.february,
        LocaleKeys.march,
        LocaleKeys.april,
        LocaleKeys.may,
        LocaleKeys.june,
        LocaleKeys.july,
        LocaleKeys.august,
        LocaleKeys.september,
        LocaleKeys.october,
        LocaleKeys.november,
        LocaleKeys.december,
      ];
    }

    for (int i = 5; i >= 0; i--) {
      int year = now.year;
      int month = now.month - i;
      while (month <= 0) {
        month += 12;
        year -= 1;
      }

      final monthStart = DateTime(year, month, 1, 0, 0, 0);
      final nextMonth = month == 12 ? 1 : month + 1;
      final nextMonthYear = month == 12 ? year + 1 : year;
      final monthEnd = DateTime(
        nextMonthYear,
        nextMonth,
        1,
        0,
        0,
        0,
      ).subtract(const Duration(seconds: 1));

      final monthSessions = allCompletedSessions.where(
        (s) =>
            s.sessionDate.isAfter(
              monthStart.subtract(const Duration(seconds: 1)),
            ) &&
            s.sessionDate.isBefore(monthEnd.add(const Duration(seconds: 1))),
      );

      final income = monthSessions.fold<double>(
        0.0,
        (sum, s) => sum + s.totalSession,
      );

      list.add(
        MonthlyIncome(
          monthName: monthNames()[month - 1],
          year: year,
          month: month,
          income: income,
          isCurrentMonth: i == 0,
        ),
      );
    }
    return list;
  }
}
