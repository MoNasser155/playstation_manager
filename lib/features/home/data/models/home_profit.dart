class HomeProfit {
  final double todayProfit;
  final double yesterdayProfit;

  HomeProfit({required this.todayProfit, required this.yesterdayProfit});

  factory HomeProfit.initial() {
    return HomeProfit(todayProfit: 0.0, yesterdayProfit: 0.0);
  }
}
