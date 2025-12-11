import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exchange_rate_model.dart';

class CurrencyApiProvider {
  // Using exchangerate-api.com - Free tier: 1,500 requests/month
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String apiKey =
      'YOUR_API_KEY_HERE'; // Get free key from exchangerate-api.com

  // Alternative: Use open.er-api.com for unlimited requests (no key needed)
  static const String freeBaseUrl = 'https://open.er-api.com/v6';

  Future<ExchangeRate> getLatestRates(String baseCurrency) async {
    try {
      // Using free API (no key required)
      final url = '$freeBaseUrl/latest/$baseCurrency';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ExchangeRate.fromJson(data);
      } else {
        throw Exception(
          'Failed to load exchange rates: ${response.statusCode}',
        );
      }
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
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return {toCurrency: (rates[toCurrency] as num).toDouble()};
      } else {
        throw Exception('Failed to load pair rate');
      }
    } catch (e) {
      throw Exception('Error fetching pair rate: $e');
    }
  }

  Future<List<String>> getSupportedCurrencies() async {
    try {
      final url = '$freeBaseUrl/latest/USD';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return rates.keys.toList()..sort();
      } else {
        throw Exception('Failed to load supported currencies');
      }
    } catch (e) {
      throw Exception('Error fetching currencies: $e');
    }
  }

  // Simulate historical data (as free API doesn't provide it)
  // In production, use a paid API like exchangerate-api.com with historical endpoint
  Future<Map<String, double>> getHistoricalRates(
    String baseCurrency,
    String targetCurrency,
    DateTime date,
  ) async {
    // For demo, return current rate with slight variation
    final currentRate = await getLatestRates(baseCurrency);
    final rate = currentRate.rates[targetCurrency] ?? 1.0;

    // Add some randomness to simulate historical data
    final random = (date.day % 10) / 100;
    return {targetCurrency: rate * (1 + random - 0.05)};
  }
}
