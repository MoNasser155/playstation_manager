import '../../../../core/languages/local_keys.g.dart';

class DailyRevenue {
  final DateTime date;
  final String dayName; // Mon, Tue, etc.
  final double revenue;

  DailyRevenue({
    required this.date,
    required this.dayName,
    required this.revenue,
  });

  factory DailyRevenue.initial() {
    return DailyRevenue(date: DateTime.now(), dayName: '', revenue: 0);
  }
}

class DeviceUsage {
  final String deviceName;
  final int sessionCount;

  DeviceUsage({required this.deviceName, required this.sessionCount});

  factory DeviceUsage.initial() {
    return DeviceUsage(deviceName: '', sessionCount: 0);
  }
}

class ProductSale {
  final String productName;
  final double quantitySold;
  final double totalRevenue;

  ProductSale({
    required this.productName,
    required this.quantitySold,
    required this.totalRevenue,
  });

  factory ProductSale.initial() {
    return ProductSale(productName: '', quantitySold: 0, totalRevenue: 0);
  }
}

class MonthlyIncome {
  final String monthName; // Jan, Feb, etc.
  final int year;
  final int month;
  final double income;
  final bool isCurrentMonth;

  MonthlyIncome({
    required this.monthName,
    required this.year,
    required this.month,
    required this.income,
    required this.isCurrentMonth,
  });

  factory MonthlyIncome.initial() {
    return MonthlyIncome(
      monthName: '',
      year: 0,
      month: 0,
      income: 0,
      isCurrentMonth: false,
    );
  }
}

enum ReportFilter {
  today,
  thisWeek,
  thisMonth,
  thisYear;

  String get localizedName {
    switch (this) {
      case ReportFilter.today:
        return LocaleKeys.todayFilter;
      case ReportFilter.thisWeek:
        return LocaleKeys.thisWeek;
      case ReportFilter.thisMonth:
        return LocaleKeys.thisMonth;
      case ReportFilter.thisYear:
        return LocaleKeys.thisYear;
    }
  }
}

class ReportModel {
  final double totalRevenue;
  final double previousRevenue;
  final double revenueChangePercentage;
  final int totalSessions;
  final double avgSessionValue;
  final double totalProductsSold;
  final List<DailyRevenue> dailyRevenueThisWeek;
  final List<DeviceUsage> topDevices;
  final List<ProductSale> topProducts;
  final List<MonthlyIncome> monthlyIncome;

  ReportModel({
    required this.totalRevenue,
    required this.previousRevenue,
    required this.revenueChangePercentage,
    required this.totalSessions,
    required this.avgSessionValue,
    required this.totalProductsSold,
    required this.dailyRevenueThisWeek,
    required this.topDevices,
    required this.topProducts,
    required this.monthlyIncome,
  });

  factory ReportModel.initial() {
    return ReportModel(
      totalRevenue: 0.0,
      previousRevenue: 0.0,
      revenueChangePercentage: 0.0,
      totalSessions: 0,
      avgSessionValue: 0.0,
      totalProductsSold: 0.0,
      dailyRevenueThisWeek: [],
      topDevices: [],
      topProducts: [],
      monthlyIncome: [],
    );
  }
}
