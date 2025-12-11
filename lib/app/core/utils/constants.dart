class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://open.er-api.com/v6';
  static const int apiTimeout = 10; // seconds
  static const int cacheExpiryHours = 1;

  // App Configuration
  static const String appName = 'Currency Converter';
  static const String appVersion = '1.0.0';

  // Chart periods
  static const List<String> chartPeriods = ['7D', '1M', '3M', '1Y'];

  // Default currencies
  static const String defaultBaseCurrency = 'USD';
  static const String defaultTargetCurrency = 'EUR';

  // Pagination
  static const int recentConversionsLimit = 10;
  static const int favoritesLimit = 20;

  // Auto-refresh interval
  static const int autoRefreshMinutes = 5;

  // Animation durations (milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Popular currencies
  static const List<String> popularCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'INR',
    'PKR',
  ];
}
