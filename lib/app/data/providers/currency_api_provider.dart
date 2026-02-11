import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/exchange_rate_model.dart';

class CurrencyApiProvider {
  // Using open.er-api.com for unlimited requests (no key needed)
  static const String freeBaseUrl = 'https://open.er-api.com/v6';

  // Retry configuration
  static const int _maxRetries = 3;
  static const Duration _initialRetryDelay = Duration(seconds: 1);

  /// Make an HTTP GET request with exponential backoff retry
  Future<http.Response> _getWithRetry(String url) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 15));
        if (response.statusCode == 200) {
          return response;
        } else if (response.statusCode == 429 || response.statusCode >= 500) {
          attempt++;
          if (attempt >= _maxRetries) {
            throw Exception(
              'Failed after $_maxRetries attempts: ${response.statusCode}',
            );
          }
          final delay = _initialRetryDelay * pow(2, attempt - 1);
          await Future.delayed(delay);
        } else {
          throw Exception('HTTP Error: ${response.statusCode}');
        }
      } catch (e) {
        attempt++;
        if (attempt >= _maxRetries) {
          rethrow;
        }
        final delay = _initialRetryDelay * pow(2, attempt - 1);
        await Future.delayed(delay);
      }
    }
  }

  Future<ExchangeRate> getLatestRates(String baseCurrency) async {
    try {
      final url = '$freeBaseUrl/latest/$baseCurrency';
      final response = await _getWithRetry(url);

      final data = json.decode(response.body);
      return ExchangeRate.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching rates: $e');
    }
  }

  Future<Map<String, double>> getPairRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    try {
      final url = '$freeBaseUrl/latest/$fromCurrency';
      final response = await _getWithRetry(url);

      final data = json.decode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;
      return {toCurrency: (rates[toCurrency] as num).toDouble()};
    } catch (e) {
      throw Exception('Error fetching pair rate: $e');
    }
  }

  Future<List<String>> getSupportedCurrencies() async {
    try {
      final url = '$freeBaseUrl/latest/USD';
      final response = await _getWithRetry(url);

      final data = json.decode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;
      return rates.keys.toList()..sort();
    } catch (e) {
      throw Exception('Error fetching currencies: $e');
    }
  }

  /// Generate simulated historical rates with deterministic variance.
  /// The free API doesn't provide historical data, so we simulate it
  /// with reproducible variations based on the date.
  Future<Map<String, double>> getHistoricalRates(
    String baseCurrency,
    String targetCurrency,
    DateTime date,
  ) async {
    final currentRate = await getLatestRates(baseCurrency);
    final rate = currentRate.rates[targetCurrency] ?? 1.0;

    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);
    final variance = (random.nextDouble() - 0.5) * 0.06; // +/-3%
    return {targetCurrency: rate * (1 + variance)};
  }
}
