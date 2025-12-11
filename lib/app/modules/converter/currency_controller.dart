import 'dart:async';
import 'package:get/get.dart';
import '../../data/models/currency_model.dart';
import '../../data/models/exchange_rate_model.dart';
import '../../data/models/historical_rate_model.dart';
import '../../data/services/currency_service.dart';
import '../../core/utils/constants.dart';

class CurrencyController extends GetxController {
  final CurrencyService _service = CurrencyService();

  // Observable variables
  final Rx<Currency> fromCurrency = Rx<Currency>(
    Currency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸'),
  );
  final Rx<Currency> toCurrency = Rx<Currency>(
    Currency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
  );

  final RxString amount = '1.0'.obs;
  final RxDouble convertedAmount = 0.0.obs;
  final RxDouble currentRate = 0.0.obs;

  final RxBool isLoading = false.obs;
  final RxBool isConverting = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<ExchangeRate?> exchangeRates = Rx<ExchangeRate?>(null);
  final RxList<Currency> allCurrencies = <Currency>[].obs;
  final RxList<Currency> favoriteCurrencies = <Currency>[].obs;
  final RxList<Map<String, String>> recentConversions =
      <Map<String, String>>[].obs;

  final Rx<DateTime?> lastUpdate = Rx<DateTime?>(null);

  // Mini chart data
  final Rx<ChartData?> miniChartData = Rx<ChartData?>(null);
  final RxBool isLoadingChart = false.obs;

  Timer? _autoRefreshTimer;

  @override
  void onInit() {
    super.onInit();
    initializeData();
    startAutoRefresh();
  }

  @override
  void onClose() {
    _autoRefreshTimer?.cancel();
    super.onClose();
  }

  Future<void> initializeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load all currencies
      allCurrencies.value = _service.getAllCurrencies();

      // Load favorites
      await loadFavorites();

      // Load recent conversions
      await loadRecentConversions();

      // Load exchange rates
      await fetchExchangeRates();

      // Get last update time
      lastUpdate.value = await _service.getLastUpdate();

      // Load mini chart data
      await loadMiniChartData();
    } catch (e) {
      errorMessage.value = 'Failed to initialize: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMiniChartData() async {
    try {
      isLoadingChart.value = true;
      final chartData = await _service.getHistoricalData(
        fromCurrency.value.code,
        toCurrency.value.code,
        '7D',
      );
      miniChartData.value = chartData;
    } catch (e) {
      // Silently fail for chart data
      miniChartData.value = null;
    } finally {
      isLoadingChart.value = false;
    }
  }

  Future<void> fetchExchangeRates() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final rates = await _service.getExchangeRates(fromCurrency.value.code);
      exchangeRates.value = rates;
      lastUpdate.value = rates.timestamp;

      // Update converted amount
      await convertCurrency();
    } catch (e) {
      errorMessage.value = 'Failed to fetch rates: $e';
      Get.snackbar(
        'Error',
        'Failed to fetch exchange rates',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> convertCurrency() async {
    try {
      if (amount.value.isEmpty || amount.value == '0') {
        convertedAmount.value = 0.0;
        return;
      }

      isConverting.value = true;
      final amountValue = double.tryParse(amount.value) ?? 0.0;

      if (exchangeRates.value != null) {
        final result = exchangeRates.value!.convert(
          amountValue,
          fromCurrency.value.code,
          toCurrency.value.code,
        );
        convertedAmount.value = result;
        currentRate.value =
            exchangeRates.value!.getRate(toCurrency.value.code) /
            exchangeRates.value!.getRate(fromCurrency.value.code);

        // Save to recent conversions
        await _service.saveRecentConversion(
          fromCurrency.value.code,
          toCurrency.value.code,
          amount.value,
        );
        await loadRecentConversions();
      }
    } catch (e) {
      errorMessage.value = 'Conversion error: $e';
    } finally {
      isConverting.value = false;
    }
  }

  void swapCurrencies() {
    final temp = fromCurrency.value;
    fromCurrency.value = toCurrency.value;
    toCurrency.value = temp;

    fetchExchangeRates();
    loadMiniChartData();
  }

  void setFromCurrency(Currency currency) {
    fromCurrency.value = currency;
    fetchExchangeRates();
    loadMiniChartData();
  }

  void setToCurrency(Currency currency) {
    toCurrency.value = currency;
    convertCurrency();
    loadMiniChartData();
  }

  void setAmount(String value) {
    amount.value = value;
    convertCurrency();
  }

  Future<void> loadFavorites() async {
    try {
      favoriteCurrencies.value = await _service.getFavoriteCurrencies();
    } catch (e) {
      errorMessage.value = 'Failed to load favorites: $e';
    }
  }

  Future<void> toggleFavorite(Currency currency) async {
    try {
      final isFav = await _service.isFavorite(currency.code);
      if (isFav) {
        await _service.removeFavorite(currency.code);
      } else {
        await _service.addFavorite(currency.code);
      }
      await loadFavorites();
    } catch (e) {
      errorMessage.value = 'Failed to update favorites: $e';
    }
  }

  Future<bool> isFavorite(String currencyCode) async {
    return await _service.isFavorite(currencyCode);
  }

  Future<void> loadRecentConversions() async {
    try {
      recentConversions.value = await _service.getRecentConversions();
    } catch (e) {
      errorMessage.value = 'Failed to load recent conversions: $e';
    }
  }

  void startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: AppConstants.autoRefreshMinutes),
      (_) => fetchExchangeRates(),
    );
  }

  @override
  Future<void> refresh() async {
    await fetchExchangeRates();
    Get.snackbar(
      'Success',
      'Exchange rates updated',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  List<Currency> searchCurrencies(String query) {
    if (query.isEmpty) {
      return allCurrencies;
    }

    return allCurrencies.where((currency) {
      return currency.code.toLowerCase().contains(query.toLowerCase()) ||
          currency.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
