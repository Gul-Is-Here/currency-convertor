import 'package:get/get.dart';
import '../../data/models/exchange_rate_model.dart';
import '../../data/providers/currency_data.dart';
import '../../data/services/currency_service.dart';

class CalculatorController extends GetxController {
  final CurrencyService _currencyService = CurrencyService();

  final RxString amount = '100'.obs;
  final RxString baseCurrency = 'USD'.obs;
  final RxList<String> selectedCurrencies = <String>[
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
  ].obs;

  final Rx<ExchangeRate?> exchangeRates = Rx<ExchangeRate?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRates();
  }

  Future<void> loadRates() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final rates = await _currencyService.getExchangeRates(baseCurrency.value);
      exchangeRates.value = rates;
    } catch (e) {
      errorMessage.value = 'Failed to load exchange rates';
    } finally {
      isLoading.value = false;
    }
  }

  void updateAmount(String value) {
    amount.value = value;
  }

  void updateBaseCurrency(String currency) {
    baseCurrency.value = currency;
    loadRates();
  }

  void toggleCurrency(String currency) {
    if (selectedCurrencies.contains(currency)) {
      selectedCurrencies.remove(currency);
    } else {
      selectedCurrencies.add(currency);
    }
  }

  void addCurrency(String currency) {
    if (!selectedCurrencies.contains(currency)) {
      selectedCurrencies.add(currency);
    }
  }

  void removeCurrency(String currency) {
    selectedCurrencies.remove(currency);
  }

  void clearAllCurrencies() {
    selectedCurrencies.clear();
  }

  double calculateAmount(String targetCurrency) {
    if (exchangeRates.value == null) return 0.0;

    final rate = exchangeRates.value!.rates[targetCurrency];
    if (rate == null) return 0.0;

    final amountValue = double.tryParse(amount.value) ?? 0.0;
    return amountValue * rate;
  }

  List<String> get availableCurrencies {
    return CurrencyData.currencyInfo.keys.toList()
      ..sort((a, b) => a.compareTo(b));
  }

  Future<void> refresh() async {
    await loadRates();
  }
}
