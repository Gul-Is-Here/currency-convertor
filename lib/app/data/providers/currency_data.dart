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
    'HUF': {'name': 'Hungarian Forint', 'symbol': 'Ft', 'flag': '🇭🇺'},
    'RON': {'name': 'Romanian Leu', 'symbol': 'lei', 'flag': '🇷🇴'},
    'BGN': {'name': 'Bulgarian Lev', 'symbol': 'лв', 'flag': '🇧🇬'},
    'HRK': {'name': 'Croatian Kuna', 'symbol': 'kn', 'flag': '🇭🇷'},
    'ISK': {'name': 'Icelandic Krona', 'symbol': 'kr', 'flag': '🇮🇸'},

    // Middle East & Africa
    'EGP': {'name': 'Egyptian Pound', 'symbol': '£', 'flag': '🇪🇬'},
    'ILS': {'name': 'Israeli Shekel', 'symbol': '₪', 'flag': '🇮🇱'},
    'JOD': {'name': 'Jordanian Dinar', 'symbol': 'د.ا', 'flag': '🇯🇴'},
    'KWD': {'name': 'Kuwaiti Dinar', 'symbol': 'د.ك', 'flag': '🇰🇼'},
    'BHD': {'name': 'Bahraini Dinar', 'symbol': 'د.ب', 'flag': '🇧🇭'},
    'OMR': {'name': 'Omani Rial', 'symbol': 'ر.ع.', 'flag': '🇴🇲'},
    'QAR': {'name': 'Qatari Riyal', 'symbol': 'ر.ق', 'flag': '🇶🇦'},
    'MAD': {'name': 'Moroccan Dirham', 'symbol': 'د.م.', 'flag': '🇲🇦'},
    'TND': {'name': 'Tunisian Dinar', 'symbol': 'د.ت', 'flag': '🇹🇳'},
    'DZD': {'name': 'Algerian Dinar', 'symbol': 'د.ج', 'flag': '🇩🇿'},
    'LBP': {'name': 'Lebanese Pound', 'symbol': 'ل.ل', 'flag': '🇱🇧'},
    'NGN': {'name': 'Nigerian Naira', 'symbol': '₦', 'flag': '🇳🇬'},
    'KES': {'name': 'Kenyan Shilling', 'symbol': 'KSh', 'flag': '🇰🇪'},
    'GHS': {'name': 'Ghanaian Cedi', 'symbol': '₵', 'flag': '🇬🇭'},
    'UGX': {'name': 'Ugandan Shilling', 'symbol': 'USh', 'flag': '🇺🇬'},
    'TZS': {'name': 'Tanzanian Shilling', 'symbol': 'TSh', 'flag': '🇹🇿'},
    'ETB': {'name': 'Ethiopian Birr', 'symbol': 'Br', 'flag': '🇪🇹'},

    // Asia Pacific
    'VND': {'name': 'Vietnamese Dong', 'symbol': '₫', 'flag': '🇻🇳'},
    'BDT': {'name': 'Bangladeshi Taka', 'symbol': '৳', 'flag': '🇧🇩'},
    'LKR': {'name': 'Sri Lankan Rupee', 'symbol': 'Rs', 'flag': '🇱🇰'},
    'NPR': {'name': 'Nepalese Rupee', 'symbol': 'Rs', 'flag': '🇳🇵'},
    'MMK': {'name': 'Myanmar Kyat', 'symbol': 'K', 'flag': '🇲🇲'},
    'KHR': {'name': 'Cambodian Riel', 'symbol': '៛', 'flag': '🇰🇭'},
    'LAK': {'name': 'Lao Kip', 'symbol': '₭', 'flag': '🇱🇦'},
    'TWD': {'name': 'New Taiwan Dollar', 'symbol': 'NT\$', 'flag': '🇹🇼'},
    'MOP': {'name': 'Macanese Pataca', 'symbol': 'MOP\$', 'flag': '🇲🇴'},
    'AFN': {'name': 'Afghan Afghani', 'symbol': '؋', 'flag': '🇦🇫'},

    // Americas
    'ARS': {'name': 'Argentine Peso', 'symbol': '\$', 'flag': '🇦🇷'},
    'CLP': {'name': 'Chilean Peso', 'symbol': '\$', 'flag': '🇨🇱'},
    'COP': {'name': 'Colombian Peso', 'symbol': '\$', 'flag': '🇨🇴'},
    'PEN': {'name': 'Peruvian Sol', 'symbol': 'S/', 'flag': '🇵🇪'},
    'UYU': {'name': 'Uruguayan Peso', 'symbol': '\$U', 'flag': '🇺🇾'},
    'VES': {'name': 'Venezuelan Bolivar', 'symbol': 'Bs', 'flag': '🇻🇪'},
    'BOB': {'name': 'Bolivian Boliviano', 'symbol': 'Bs', 'flag': '🇧🇴'},
    'PYG': {'name': 'Paraguayan Guarani', 'symbol': '₲', 'flag': '🇵🇾'},
    'DOP': {'name': 'Dominican Peso', 'symbol': 'RD\$', 'flag': '🇩🇴'},
    'CRC': {'name': 'Costa Rican Colon', 'symbol': '₡', 'flag': '🇨🇷'},
    'GTQ': {'name': 'Guatemalan Quetzal', 'symbol': 'Q', 'flag': '🇬🇹'},
    'HNL': {'name': 'Honduran Lempira', 'symbol': 'L', 'flag': '🇭🇳'},
    'NIO': {'name': 'Nicaraguan Cordoba', 'symbol': 'C\$', 'flag': '🇳🇮'},
    'PAB': {'name': 'Panamanian Balboa', 'symbol': 'B/.', 'flag': '🇵🇦'},
    'JMD': {'name': 'Jamaican Dollar', 'symbol': 'J\$', 'flag': '🇯🇲'},
    'TTD': {'name': 'Trinidad Dollar', 'symbol': 'TT\$', 'flag': '🇹🇹'},
    'BBD': {'name': 'Barbadian Dollar', 'symbol': 'Bds\$', 'flag': '🇧🇧'},
    'BZD': {'name': 'Belize Dollar', 'symbol': 'BZ\$', 'flag': '🇧🇿'},

    // Europe (Additional)
    'UAH': {'name': 'Ukrainian Hryvnia', 'symbol': '₴', 'flag': '🇺🇦'},
    'RSD': {'name': 'Serbian Dinar', 'symbol': 'din', 'flag': '🇷🇸'},
    'MKD': {'name': 'Macedonian Denar', 'symbol': 'ден', 'flag': '🇲🇰'},
    'ALL': {'name': 'Albanian Lek', 'symbol': 'L', 'flag': '🇦🇱'},
    'BAM': {'name': 'Bosnia Mark', 'symbol': 'KM', 'flag': '🇧🇦'},
    'MDL': {'name': 'Moldovan Leu', 'symbol': 'L', 'flag': '🇲🇩'},
    'GEL': {'name': 'Georgian Lari', 'symbol': '₾', 'flag': '🇬🇪'},
    'AMD': {'name': 'Armenian Dram', 'symbol': '֏', 'flag': '🇦🇲'},
    'AZN': {'name': 'Azerbaijani Manat', 'symbol': '₼', 'flag': '🇦🇿'},
    'BYN': {'name': 'Belarusian Ruble', 'symbol': 'Br', 'flag': '🇧🇾'},
    'KZT': {'name': 'Kazakhstani Tenge', 'symbol': '₸', 'flag': '🇰🇿'},
    'UZS': {'name': 'Uzbekistani Som', 'symbol': 'so\'m', 'flag': '🇺🇿'},
    'KGS': {'name': 'Kyrgyzstani Som', 'symbol': 'с', 'flag': '🇰🇬'},
    'TJS': {'name': 'Tajikistani Somoni', 'symbol': 'ЅМ', 'flag': '🇹🇯'},
    'TMT': {'name': 'Turkmenistani Manat', 'symbol': 'm', 'flag': '🇹🇲'},

    // Pacific & Caribbean
    'FJD': {'name': 'Fijian Dollar', 'symbol': 'FJ\$', 'flag': '🇫🇯'},
    'PGK': {'name': 'Papua New Guinean Kina', 'symbol': 'K', 'flag': '🇵🇬'},
    'TOP': {'name': 'Tongan Pa\'anga', 'symbol': 'T\$', 'flag': '🇹🇴'},
    'WST': {'name': 'Samoan Tala', 'symbol': 'WS\$', 'flag': '🇼🇸'},
    'VUV': {'name': 'Vanuatu Vatu', 'symbol': 'VT', 'flag': '🇻🇺'},
    'SBD': {'name': 'Solomon Islands Dollar', 'symbol': 'SI\$', 'flag': '🇸🇧'},
    'XCD': {'name': 'East Caribbean Dollar', 'symbol': 'EC\$', 'flag': '🇦🇬'},
    'BSD': {'name': 'Bahamian Dollar', 'symbol': 'B\$', 'flag': '🇧🇸'},
    'KYD': {'name': 'Cayman Islands Dollar', 'symbol': 'CI\$', 'flag': '🇰🇾'},
    'BMD': {'name': 'Bermudian Dollar', 'symbol': 'BD\$', 'flag': '🇧🇲'},

    // Additional Asian Currencies
    'MNT': {'name': 'Mongolian Tugrik', 'symbol': '₮', 'flag': '🇲🇳'},
    'BND': {'name': 'Brunei Dollar', 'symbol': 'B\$', 'flag': '🇧🇳'},
    'MVR': {'name': 'Maldivian Rufiyaa', 'symbol': 'Rf', 'flag': '🇲🇻'},
    'BTN': {'name': 'Bhutanese Ngultrum', 'symbol': 'Nu.', 'flag': '🇧🇹'},

    // Additional Middle Eastern
    'IQD': {'name': 'Iraqi Dinar', 'symbol': 'ع.د', 'flag': '🇮🇶'},
    'SYP': {'name': 'Syrian Pound', 'symbol': '£S', 'flag': '🇸🇾'},
    'YER': {'name': 'Yemeni Rial', 'symbol': '﷼', 'flag': '🇾🇪'},

    // Additional African Currencies
    'BWP': {'name': 'Botswana Pula', 'symbol': 'P', 'flag': '🇧🇼'},
    'MUR': {'name': 'Mauritian Rupee', 'symbol': '₨', 'flag': '🇲🇺'},
    'NAD': {'name': 'Namibian Dollar', 'symbol': 'N\$', 'flag': '🇳🇦'},
    'SCR': {'name': 'Seychellois Rupee', 'symbol': '₨', 'flag': '🇸🇨'},
    'ZMW': {'name': 'Zambian Kwacha', 'symbol': 'ZK', 'flag': '🇿🇲'},
    'MWK': {'name': 'Malawian Kwacha', 'symbol': 'MK', 'flag': '🇲🇼'},
    'AOA': {'name': 'Angolan Kwanza', 'symbol': 'Kz', 'flag': '🇦🇴'},
    'MZN': {'name': 'Mozambican Metical', 'symbol': 'MT', 'flag': '🇲🇿'},
    'RWF': {'name': 'Rwandan Franc', 'symbol': 'FRw', 'flag': '🇷🇼'},
    'SOS': {'name': 'Somali Shilling', 'symbol': 'Sh', 'flag': '🇸🇴'},
    'SDG': {'name': 'Sudanese Pound', 'symbol': '£', 'flag': '🇸🇩'},
    'SZL': {'name': 'Swazi Lilangeni', 'symbol': 'L', 'flag': '🇸🇿'},
    'LSL': {'name': 'Lesotho Loti', 'symbol': 'L', 'flag': '🇱🇸'},
    'GMD': {'name': 'Gambian Dalasi', 'symbol': 'D', 'flag': '🇬🇲'},
    'GNF': {'name': 'Guinean Franc', 'symbol': 'FG', 'flag': '🇬🇳'},
    'LRD': {'name': 'Liberian Dollar', 'symbol': 'L\$', 'flag': '🇱🇷'},
    'SLL': {'name': 'Sierra Leonean Leone', 'symbol': 'Le', 'flag': '🇸🇱'},
    'CDF': {'name': 'Congolese Franc', 'symbol': 'FC', 'flag': '🇨🇩'},
    'XOF': {'name': 'West African CFA Franc', 'symbol': 'CFA', 'flag': '🌍'},
    'XAF': {
      'name': 'Central African CFA Franc',
      'symbol': 'FCFA',
      'flag': '🌍',
    },

    // Additional Latin American
    'HTG': {'name': 'Haitian Gourde', 'symbol': 'G', 'flag': '🇭🇹'},
    'SRD': {'name': 'Surinamese Dollar', 'symbol': '\$', 'flag': '🇸🇷'},
    'GYD': {'name': 'Guyanese Dollar', 'symbol': 'GY\$', 'flag': '🇬🇾'},
    'AWG': {'name': 'Aruban Florin', 'symbol': 'ƒ', 'flag': '🇦🇼'},
    'ANG': {
      'name': 'Netherlands Antillean Guilder',
      'symbol': 'ƒ',
      'flag': '🇨🇼',
    },

    // Exotic & Special Currencies
    'CUP': {'name': 'Cuban Peso', 'symbol': '\$', 'flag': '🇨🇺'},
    'KPW': {'name': 'North Korean Won', 'symbol': '₩', 'flag': '🇰🇵'},
    'IRR': {'name': 'Iranian Rial', 'symbol': '﷼', 'flag': '🇮🇷'},
    'STN': {'name': 'São Tomé Príncipe Dobra', 'symbol': 'Db', 'flag': '🇸🇹'},
    'CVE': {'name': 'Cape Verdean Escudo', 'symbol': '\$', 'flag': '🇨🇻'},
    'DJF': {'name': 'Djiboutian Franc', 'symbol': 'Fdj', 'flag': '🇩🇯'},
    'ERN': {'name': 'Eritrean Nakfa', 'symbol': 'Nfk', 'flag': '🇪🇷'},
    'MGA': {'name': 'Malagasy Ariary', 'symbol': 'Ar', 'flag': '🇲🇬'},
    'KMF': {'name': 'Comorian Franc', 'symbol': 'CF', 'flag': '🇰🇲'},
    'MRU': {'name': 'Mauritanian Ouguiya', 'symbol': 'UM', 'flag': '🇲🇷'},
    'BIF': {'name': 'Burundian Franc', 'symbol': 'FBu', 'flag': '🇧🇮'},

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
