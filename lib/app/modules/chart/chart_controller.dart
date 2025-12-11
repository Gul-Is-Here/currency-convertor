import 'package:get/get.dart';
import '../../data/models/historical_rate_model.dart';
import '../../data/services/currency_service.dart';
import '../converter/currency_controller.dart';

class ChartController extends GetxController {
  final CurrencyService _service = CurrencyService();
  final CurrencyController currencyController = Get.find();

  final Rx<ChartData?> chartData = Rx<ChartData?>(null);
  final RxString selectedPeriod = '7D'.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadChartData();
  }

  Future<void> loadChartData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _service.getHistoricalData(
        currencyController.fromCurrency.value.code,
        currencyController.toCurrency.value.code,
        selectedPeriod.value,
      );

      chartData.value = data;
    } catch (e) {
      errorMessage.value = 'Failed to load chart data: $e';
      Get.snackbar(
        'Error',
        'Failed to load historical data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    loadChartData();
  }

  void refreshChart() {
    loadChartData();
  }
}
