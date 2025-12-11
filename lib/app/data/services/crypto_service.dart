import '../providers/crypto_api_provider.dart';
import '../providers/local_storage_provider.dart';

/// Service for managing cryptocurrency data
class CryptoService {
  final CryptoApiProvider _apiProvider = CryptoApiProvider();
  final LocalStorageProvider _storageProvider = LocalStorageProvider();

  static const String _cryptoPricesKey = 'crypto_prices';
  static const String _lastCryptoUpdateKey = 'last_crypto_update';

  /// Get current cryptocurrency prices
  Future<Map<String, double>> getCryptoPrices({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _getCachedPrices();
      if (cached != null) {
        return cached;
      }
    }

    try {
      final prices = await _apiProvider.getCryptoPrices();
      await _cachePrices(prices);
      return prices;
    } catch (e) {
      // Return cached data if API fails
      final cached = await _getCachedPrices();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  /// Get historical crypto price data
  Future<List<Map<String, dynamic>>> getCryptoHistory({
    required String cryptoId,
    required int days,
  }) async {
    return await _apiProvider.getCryptoHistory(cryptoId: cryptoId, days: days);
  }

  /// Convert cryptocurrency to fiat
  Future<double> convertCryptoToFiat({
    required String cryptoId,
    required String fiatCode,
    required double amount,
  }) async {
    return await _apiProvider.convertCryptoToFiat(
      cryptoId: cryptoId,
      fiatCode: fiatCode,
      amount: amount,
    );
  }

  /// Get crypto ID for API calls (e.g., BTC -> bitcoin)
  String getCryptoId(String code) {
    const mapping = {
      'BTC': 'bitcoin',
      'ETH': 'ethereum',
      'BNB': 'binancecoin',
      'XRP': 'ripple',
      'ADA': 'cardano',
      'SOL': 'solana',
      'DOT': 'polkadot',
      'DOGE': 'dogecoin',
      'SHIB': 'shiba-inu',
      'LTC': 'litecoin',
      'MATIC': 'polygon',
      'LINK': 'chainlink',
      'UNI': 'uniswap',
      'XLM': 'stellar',
      'TRX': 'tron',
    };
    return mapping[code] ?? code.toLowerCase();
  }

  /// Get crypto code from ID (e.g., bitcoin -> BTC)
  String getCryptoCode(String id) {
    const mapping = {
      'bitcoin': 'BTC',
      'ethereum': 'ETH',
      'binancecoin': 'BNB',
      'ripple': 'XRP',
      'cardano': 'ADA',
      'solana': 'SOL',
      'polkadot': 'DOT',
      'dogecoin': 'DOGE',
      'shiba-inu': 'SHIB',
      'litecoin': 'LTC',
      'polygon': 'MATIC',
      'chainlink': 'LINK',
      'uniswap': 'UNI',
      'stellar': 'XLM',
      'tron': 'TRX',
    };
    return mapping[id] ?? id.toUpperCase();
  }

  /// Cache crypto prices
  Future<void> _cachePrices(Map<String, double> prices) async {
    await _storageProvider.saveData(_cryptoPricesKey, prices);
    await _storageProvider.saveData(
      _lastCryptoUpdateKey,
      DateTime.now().toIso8601String(),
    );
  }

  /// Get cached crypto prices
  Future<Map<String, double>?> _getCachedPrices() async {
    final lastUpdate = await _storageProvider.getData(_lastCryptoUpdateKey);
    if (lastUpdate != null) {
      final updateTime = DateTime.parse(lastUpdate);
      // Cache valid for 5 minutes
      if (DateTime.now().difference(updateTime).inMinutes < 5) {
        final cached = await _storageProvider.getData(_cryptoPricesKey);
        if (cached != null && cached is Map) {
          return Map<String, double>.from(cached);
        }
      }
    }
    return null;
  }

  /// Get last update time
  Future<DateTime?> getLastUpdateTime() async {
    final lastUpdate = await _storageProvider.getData(_lastCryptoUpdateKey);
    if (lastUpdate != null) {
      return DateTime.parse(lastUpdate);
    }
    return null;
  }

  /// Clear cached crypto data
  Future<void> clearCache() async {
    await _storageProvider.removeData(_cryptoPricesKey);
    await _storageProvider.removeData(_lastCryptoUpdateKey);
  }
}
