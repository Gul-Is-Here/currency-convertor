class ExchangeRate {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime timestamp;
  final DateTime? nextUpdate;

  ExchangeRate({
    required this.baseCurrency,
    required this.rates,
    required this.timestamp,
    this.nextUpdate,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final ratesData = json['conversion_rates'] ?? json['rates'] ?? {};
    final Map<String, double> rates = {};

    ratesData.forEach((key, value) {
      rates[key] = (value is int)
          ? value.toDouble()
          : (value as num).toDouble();
    });

    return ExchangeRate(
      baseCurrency: json['base_code'] ?? json['base'] ?? '',
      rates: rates,
      timestamp: json['time_last_update_unix'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['time_last_update_unix'] * 1000,
            )
          : DateTime.now(),
      nextUpdate: json['time_next_update_unix'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['time_next_update_unix'] * 1000,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCurrency,
      'conversion_rates': rates,
      'time_last_update_unix': timestamp.millisecondsSinceEpoch ~/ 1000,
      'time_next_update_unix': nextUpdate != null
          ? nextUpdate!.millisecondsSinceEpoch ~/ 1000
          : null,
    };
  }

  double getRate(String toCurrency) {
    return rates[toCurrency] ?? 1.0;
  }

  double convert(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    // Convert to base currency first, then to target currency
    final fromRate = rates[fromCurrency] ?? 1.0;
    final toRate = rates[toCurrency] ?? 1.0;

    return amount * (toRate / fromRate);
  }
}
