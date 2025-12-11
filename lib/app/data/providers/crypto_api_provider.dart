import 'dart:convert';
import 'package:http/http.dart' as http;

/// Provider for cryptocurrency data from CoinGecko API
class CryptoApiProvider {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  /// Get list of supported cryptocurrencies with their current prices in USD
  Future<Map<String, double>> getCryptoPrices() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/simple/price?ids=bitcoin,ethereum,binancecoin,ripple,cardano,solana,polkadot,dogecoin,shiba-inu,litecoin,polygon,chainlink,uniswap,stellar,tron&vs_currencies=usd',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final prices = <String, double>{};

        data.forEach((key, value) {
          if (value is Map && value.containsKey('usd')) {
            prices[key] = (value['usd'] as num).toDouble();
          }
        });

        return prices;
      } else {
        throw Exception('Failed to load crypto prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch crypto prices: $e');
    }
  }

  /// Get historical crypto price data
  Future<List<Map<String, dynamic>>> getCryptoHistory({
    required String cryptoId,
    required int days,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/coins/$cryptoId/market_chart?vs_currency=usd&days=$days',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final prices = data['prices'] as List;

        return prices.map((price) {
          return {
            'timestamp': price[0] as int,
            'price': (price[1] as num).toDouble(),
          };
        }).toList();
      } else {
        throw Exception(
          'Failed to load crypto history: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch crypto history: $e');
    }
  }

  /// Convert crypto to fiat or vice versa
  Future<double> convertCryptoToFiat({
    required String cryptoId,
    required String fiatCode,
    required double amount,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/simple/price?ids=$cryptoId&vs_currencies=${fiatCode.toLowerCase()}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data.containsKey(cryptoId)) {
          final cryptoData = data[cryptoId] as Map<String, dynamic>;
          final rate = (cryptoData[fiatCode.toLowerCase()] as num).toDouble();
          return amount * rate;
        }
        throw Exception('Crypto not found');
      } else {
        throw Exception('Failed to convert crypto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to convert crypto: $e');
    }
  }
}
