class HistoricalRate {
  final DateTime date;
  final double rate;
  final String fromCurrency;
  final String toCurrency;

  HistoricalRate({
    required this.date,
    required this.rate,
    required this.fromCurrency,
    required this.toCurrency,
  });

  factory HistoricalRate.fromJson(Map<String, dynamic> json) {
    return HistoricalRate(
      date: DateTime.parse(json['date']),
      rate: (json['rate'] as num).toDouble(),
      fromCurrency: json['fromCurrency'] ?? '',
      toCurrency: json['toCurrency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'rate': rate,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
    };
  }
}

class ChartData {
  final List<HistoricalRate> rates;
  final String period; // '7D', '1M', '3M', '1Y'

  ChartData({required this.rates, required this.period});

  double get minRate => rates.isEmpty
      ? 0
      : rates.map((e) => e.rate).reduce((a, b) => a < b ? a : b);

  double get maxRate => rates.isEmpty
      ? 0
      : rates.map((e) => e.rate).reduce((a, b) => a > b ? a : b);

  double get avgRate => rates.isEmpty
      ? 0
      : rates.map((e) => e.rate).reduce((a, b) => a + b) / rates.length;

  double get change =>
      rates.length < 2 ? 0 : rates.last.rate - rates.first.rate;

  double get changePercentage => rates.isEmpty || rates.first.rate == 0
      ? 0
      : (change / rates.first.rate) * 100;
}
