import '../models/currency_model.dart';
import '../models/exchange_rate_model.dart';
import '../models/historical_rate_model.dart';
import '../providers/currency_api_provider.dart';
import '../providers/local_storage_provider.dart';
import '../providers/currency_data.dart';

class CurrencyService {
  final CurrencyApiProvider _apiProvider = CurrencyApiProvider();
  final LocalStorageProvider _storageProvider = LocalStorageProvider();

  // Get latest exchange rates
  Future<ExchangeRate> getExchangeRates(String baseCurrency) async {
    try {
      // Try to get from API
      final rates = await _apiProvider.getLatestRates(baseCurrency);

      // Cache the rates
      await _storageProvider.cacheRates(baseCurrency, rates.toJson());

      return rates;
    } catch (e) {
      // If API fails, try to get from cache
      final cached = await _storageProvider.getCachedRates(baseCurrency);
      if (cached != null) {
        return ExchangeRate.fromJson(cached);
      }
      rethrow;
    }
  }

  // Convert amount between currencies
  Future<double> convertCurrency(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) async {
    final rates = await getExchangeRates(fromCurrency);
    return rates.convert(amount, fromCurrency, toCurrency);
  }

  // Get historical rates for chart
  Future<ChartData> getHistoricalData(
    String fromCurrency,
    String toCurrency,
    String period,
  ) async {
    final List<HistoricalRate> rates = [];
    final now = DateTime.now();
    int days;

    switch (period) {
      case '7D':
        days = 7;
        break;
      case '1M':
        days = 30;
        break;
      case '3M':
        days = 90;
        break;
      case '1Y':
        days = 365;
        break;
      default:
        days = 7;
    }

    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      try {
        final historicalRates = await _apiProvider.getHistoricalRates(
          fromCurrency,
          toCurrency,
          date,
        );

        rates.add(
          HistoricalRate(
            date: date,
            rate: historicalRates[toCurrency] ?? 1.0,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
          ),
        );
      } catch (e) {
        // Skip failed dates
        continue;
      }
    }

    return ChartData(rates: rates, period: period);
  }

  // Favorite management
  Future<void> addFavorite(String currencyCode) async {
    final favorites = await _storageProvider.getFavorites();
    if (!favorites.contains(currencyCode)) {
      favorites.add(currencyCode);
      await _storageProvider.saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String currencyCode) async {
    final favorites = await _storageProvider.getFavorites();
    favorites.remove(currencyCode);
    await _storageProvider.saveFavorites(favorites);
  }

  Future<List<Currency>> getFavoriteCurrencies() async {
    final codes = await _storageProvider.getFavorites();
    return codes.map((code) => CurrencyData.getCurrency(code)).toList();
  }

  Future<bool> isFavorite(String currencyCode) async {
    final favorites = await _storageProvider.getFavorites();
    return favorites.contains(currencyCode);
  }

  // Recent conversions
  Future<void> saveRecentConversion(
    String fromCurrency,
    String toCurrency,
    String amount,
  ) async {
    final recent = await _storageProvider.getRecentConversions();

    final conversion = {
      'from': fromCurrency,
      'to': toCurrency,
      'amount': amount,
      'timestamp': DateTime.now().toIso8601String(),
    };

    recent.insert(0, conversion);

    // Keep only last 10
    if (recent.length > 10) {
      recent.removeRange(10, recent.length);
    }

    await _storageProvider.saveRecentConversions(recent);
  }

  Future<List<Map<String, String>>> getRecentConversions() async {
    return await _storageProvider.getRecentConversions();
  }

  // Get all available currencies
  List<Currency> getAllCurrencies() {
    return CurrencyData.getAllCurrencies();
  }

  List<Currency> getPopularCurrencies() {
    return CurrencyData.getPopularCurrencies();
  }

  // Base currency management
  Future<void> setBaseCurrency(String currency) async {
    await _storageProvider.setBaseCurrency(currency);
  }

  Future<String> getBaseCurrency() async {
    return await _storageProvider.getBaseCurrency();
  }

  // Cache management
  Future<DateTime?> getLastUpdate() async {
    return await _storageProvider.getLastUpdate();
  }

  Future<void> clearCache() async {
    await _storageProvider.clearCache();
  }
}
