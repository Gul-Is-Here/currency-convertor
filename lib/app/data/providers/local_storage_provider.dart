import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageProvider {
  static const String _favoritesKey = 'favorite_currencies';
  static const String _recentKey = 'recent_conversions';
  static const String _cacheKey = 'cached_rates';
  static const String _lastUpdateKey = 'last_update';
  static const String _baseCurrencyKey = 'base_currency';
  static const String _themeKey = 'theme_preference';
  static const String _alertsKey = 'rate_alerts';
  static const String _expensesKey = 'expenses';
  static const String _budgetsKey = 'budgets';

  Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> saveRecentConversions(
    List<Map<String, String>> conversions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = conversions.map((e) => json.encode(e)).toList();
    await prefs.setStringList(_recentKey, jsonList);
  }

  Future<List<Map<String, String>>> getRecentConversions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_recentKey) ?? [];
    return jsonList
        .map((e) => Map<String, String>.from(json.decode(e)))
        .toList();
  }

  Future<void> cacheRates(
    String baseCurrency,
    Map<String, dynamic> rates,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_cacheKey}_$baseCurrency', json.encode(rates));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<Map<String, dynamic>?> getCachedRates(String baseCurrency) async {
    final prefs = await SharedPreferences.getInstance();
    final ratesJson = prefs.getString('${_cacheKey}_$baseCurrency');
    if (ratesJson != null) {
      return json.decode(ratesJson);
    }
    return null;
  }

  Future<DateTime?> getLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastUpdateKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  Future<void> setBaseCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseCurrencyKey, currency);
  }

  Future<String> getBaseCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseCurrencyKey) ?? 'USD';
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_cacheKey)) {
        await prefs.remove(key);
      }
    }
  }

  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  // Rate Alerts
  Future<void> saveAlerts(List<Map<String, dynamic>> alerts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = alerts.map((e) => json.encode(e)).toList();
    await prefs.setStringList(_alertsKey, jsonList);
  }

  Future<List<Map<String, dynamic>>> getAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_alertsKey) ?? [];
    return jsonList
        .map((e) => Map<String, dynamic>.from(json.decode(e)))
        .toList();
  }

  Future<void> clearAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_alertsKey);
  }

  // Expenses
  Future<void> saveExpenses(List<Map<String, dynamic>> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = expenses.map((e) => json.encode(e)).toList();
    await prefs.setStringList(_expensesKey, jsonList);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_expensesKey) ?? [];
    return jsonList
        .map((e) => Map<String, dynamic>.from(json.decode(e)))
        .toList();
  }

  Future<void> clearExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_expensesKey);
  }

  // Budgets
  Future<void> saveBudgets(List<Map<String, dynamic>> budgets) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = budgets.map((e) => json.encode(e)).toList();
    await prefs.setStringList(_budgetsKey, jsonList);
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_budgetsKey) ?? [];
    return jsonList
        .map((e) => Map<String, dynamic>.from(json.decode(e)))
        .toList();
  }

  Future<void> clearBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_budgetsKey);
  }

  // Generic data storage methods
  Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      await prefs.setString(key, json.encode(value));
    }
  }

  Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      final value = prefs.get(key);
      if (value is String && value.startsWith('{') ||
          value is String && value.startsWith('[')) {
        try {
          return json.decode(value);
        } catch (e) {
          return value;
        }
      }
      return value;
    }
    return null;
  }

  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
