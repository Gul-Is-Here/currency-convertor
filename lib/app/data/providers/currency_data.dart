import '../models/currency_model.dart';

class CurrencyData {
  static final Map<String, Map<String, String>> currencyInfo = {
    'USD': {'name': 'US Dollar', 'symbol': '\$', 'flag': '🇺🇸'},
    'EUR': {'name': 'Euro', 'symbol': '€', 'flag': '🇪🇺'},
    'GBP': {'name': 'British Pound', 'symbol': '£', 'flag': '🇬🇧'},
    'JPY': {'name': 'Japanese Yen', 'symbol': '¥', 'flag': '🇯🇵'},
    'AUD': {'name': 'Australian Dollar', 'symbol': 'A\$', 'flag': '🇦🇺'},
    'CAD': {'name': 'Canadian Dollar', 'symbol': 'C\$', 'flag': '🇨🇦'},
    'CHF': {'name': 'Swiss Franc', 'symbol': 'Fr', 'flag': '🇨🇭'},
    'CNY': {'name': 'Chinese Yuan', 'symbol': '¥', 'flag': '🇨🇳'},
    'INR': {'name': 'Indian Rupee', 'symbol': '₹', 'flag': '🇮🇳'},
    'PKR': {'name': 'Pakistani Rupee', 'symbol': 'Rs', 'flag': '🇵🇰'},
    'AED': {'name': 'UAE Dirham', 'symbol': 'د.إ', 'flag': '🇦🇪'},
    'SAR': {'name': 'Saudi Riyal', 'symbol': 'ر.س', 'flag': '🇸🇦'},
    'NZD': {'name': 'New Zealand Dollar', 'symbol': 'NZ\$', 'flag': '🇳🇿'},
    'SGD': {'name': 'Singapore Dollar', 'symbol': 'S\$', 'flag': '🇸🇬'},
    'HKD': {'name': 'Hong Kong Dollar', 'symbol': 'HK\$', 'flag': '🇭🇰'},
    'KRW': {'name': 'South Korean Won', 'symbol': '₩', 'flag': '🇰🇷'},
    'MXN': {'name': 'Mexican Peso', 'symbol': '\$', 'flag': '🇲🇽'},
    'BRL': {'name': 'Brazilian Real', 'symbol': 'R\$', 'flag': '🇧🇷'},
    'ZAR': {'name': 'South African Rand', 'symbol': 'R', 'flag': '🇿🇦'},
    'RUB': {'name': 'Russian Ruble', 'symbol': '₽', 'flag': '🇷🇺'},
    'TRY': {'name': 'Turkish Lira', 'symbol': '₺', 'flag': '🇹🇷'},
    'THB': {'name': 'Thai Baht', 'symbol': '฿', 'flag': '🇹🇭'},
    'IDR': {'name': 'Indonesian Rupiah', 'symbol': 'Rp', 'flag': '🇮🇩'},
    'MYR': {'name': 'Malaysian Ringgit', 'symbol': 'RM', 'flag': '🇲🇾'},
    'PHP': {'name': 'Philippine Peso', 'symbol': '₱', 'flag': '🇵🇭'},
    'SEK': {'name': 'Swedish Krona', 'symbol': 'kr', 'flag': '🇸🇪'},
    'NOK': {'name': 'Norwegian Krone', 'symbol': 'kr', 'flag': '🇳🇴'},
    'DKK': {'name': 'Danish Krone', 'symbol': 'kr', 'flag': '🇩🇰'},
    'PLN': {'name': 'Polish Zloty', 'symbol': 'zł', 'flag': '🇵🇱'},
    'CZK': {'name': 'Czech Koruna', 'symbol': 'Kč', 'flag': '🇨🇿'},

    // Cryptocurrencies
    'BTC': {'name': 'Bitcoin', 'symbol': '₿', 'flag': '🪙'},
    'ETH': {'name': 'Ethereum', 'symbol': 'Ξ', 'flag': '💎'},
    'BNB': {'name': 'Binance Coin', 'symbol': 'BNB', 'flag': '🟡'},
    'XRP': {'name': 'Ripple', 'symbol': 'XRP', 'flag': '💧'},
    'ADA': {'name': 'Cardano', 'symbol': 'ADA', 'flag': '🔷'},
    'SOL': {'name': 'Solana', 'symbol': 'SOL', 'flag': '🌞'},
    'DOT': {'name': 'Polkadot', 'symbol': 'DOT', 'flag': '🔴'},
    'DOGE': {'name': 'Dogecoin', 'symbol': 'Ð', 'flag': '🐕'},
    'SHIB': {'name': 'Shiba Inu', 'symbol': 'SHIB', 'flag': '🐶'},
    'LTC': {'name': 'Litecoin', 'symbol': 'Ł', 'flag': '🪙'},
    'MATIC': {'name': 'Polygon', 'symbol': 'MATIC', 'flag': '🟣'},
    'LINK': {'name': 'Chainlink', 'symbol': 'LINK', 'flag': '🔗'},
    'UNI': {'name': 'Uniswap', 'symbol': 'UNI', 'flag': '🦄'},
    'XLM': {'name': 'Stellar', 'symbol': 'XLM', 'flag': '⭐'},
    'TRX': {'name': 'Tron', 'symbol': 'TRX', 'flag': '🎮'},
  };

  static Currency getCurrency(String code) {
    final info = currencyInfo[code];
    if (info != null) {
      return Currency(
        code: code,
        name: info['name']!,
        symbol: info['symbol']!,
        flag: info['flag']!,
      );
    }
    return Currency(code: code, name: code, symbol: code, flag: '🌍');
  }

  static List<Currency> getAllCurrencies() {
    return currencyInfo.keys.map((code) => getCurrency(code)).toList();
  }

  static List<Currency> getPopularCurrencies() {
    const popular = [
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
    return popular.map((code) => getCurrency(code)).toList();
  }

  static List<Currency> getCryptoCurrencies() {
    const cryptos = [
      'BTC',
      'ETH',
      'BNB',
      'XRP',
      'ADA',
      'SOL',
      'DOT',
      'DOGE',
      'SHIB',
      'LTC',
      'MATIC',
      'LINK',
      'UNI',
      'XLM',
      'TRX',
    ];
    return cryptos.map((code) => getCurrency(code)).toList();
  }

  static List<Currency> getPopularCryptos() {
    const popular = ['BTC', 'ETH', 'BNB', 'XRP', 'ADA', 'SOL', 'DOGE'];
    return popular.map((code) => getCurrency(code)).toList();
  }

  static bool isCrypto(String code) {
    const cryptos = [
      'BTC',
      'ETH',
      'BNB',
      'XRP',
      'ADA',
      'SOL',
      'DOT',
      'DOGE',
      'SHIB',
      'LTC',
      'MATIC',
      'LINK',
      'UNI',
      'XLM',
      'TRX',
    ];
    return cryptos.contains(code);
  }
}
