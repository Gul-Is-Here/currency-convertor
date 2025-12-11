import 'dart:async';
import 'package:get/get.dart';
import '../../data/models/rate_alert_model.dart';
import '../../data/providers/local_storage_provider.dart';
import '../../data/services/currency_service.dart';
import '../../data/services/notification_service.dart';

class AlertsController extends GetxController {
  final CurrencyService _currencyService = CurrencyService();
  final LocalStorageProvider _storage = LocalStorageProvider();
  final NotificationService _notificationService = NotificationService();

  final RxList<RateAlert> alerts = <RateAlert>[].obs;
  final RxBool isLoading = false.obs;
  Timer? _checkTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    loadAlerts();
    startMonitoring();
  }

  @override
  void onClose() {
    _checkTimer?.cancel();
    super.onClose();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  Future<void> loadAlerts() async {
    try {
      isLoading.value = true;
      final alertsJson = await _storage.getAlerts();
      alerts.value = alertsJson
          .map((json) => RateAlert.fromJson(json))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load alerts',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAlerts() async {
    try {
      final alertsJson = alerts.map((alert) => alert.toJson()).toList();
      await _storage.saveAlerts(alertsJson);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save alerts',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> addAlert(RateAlert alert) async {
    alerts.add(alert);
    await saveAlerts();
    Get.snackbar(
      'Alert Created',
      'You will be notified when ${alert.alertDescription}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> removeAlert(String id) async {
    alerts.removeWhere((alert) => alert.id == id);
    await saveAlerts();
  }

  Future<void> toggleAlert(String id) async {
    final index = alerts.indexWhere((alert) => alert.id == id);
    if (index != -1) {
      alerts[index] = alerts[index].copyWith(isActive: !alerts[index].isActive);
      await saveAlerts();
    }
  }

  void startMonitoring() {
    // Check rates every 5 minutes
    _checkTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      checkAlerts();
    });
  }

  Future<void> checkAlerts() async {
    if (alerts.isEmpty) return;

    for (final alert in alerts) {
      if (!alert.isActive) continue;

      try {
        final rates = await _currencyService.getExchangeRates(
          alert.baseCurrency,
        );
        final currentRate = rates.rates[alert.targetCurrency];

        if (currentRate == null) continue;

        bool shouldTrigger = false;
        if (alert.condition == 'above' && currentRate >= alert.targetRate) {
          shouldTrigger = true;
        } else if (alert.condition == 'below' &&
            currentRate <= alert.targetRate) {
          shouldTrigger = true;
        }

        if (shouldTrigger) {
          await _triggerAlert(alert, currentRate);
        }
      } catch (e) {
        // Silently fail - will try again next cycle
      }
    }
  }

  Future<void> _triggerAlert(RateAlert alert, double currentRate) async {
    // Send notification
    await _notificationService.showRateAlert(
      id: alert.id,
      title: '🔔 Rate Alert Triggered!',
      body:
          '${alert.baseCurrency}/${alert.targetCurrency} has ${alert.conditionText} ${alert.targetRate}. Current rate: $currentRate',
      baseCurrency: alert.baseCurrency,
      targetCurrency: alert.targetCurrency,
      currentRate: currentRate,
    );

    // Mark alert as triggered and deactivate
    final index = alerts.indexWhere((a) => a.id == alert.id);
    if (index != -1) {
      alerts[index] = alerts[index].copyWith(
        isActive: false,
        triggeredAt: DateTime.now(),
      );
      await saveAlerts();
    }
  }

  Future<void> clearAll() async {
    alerts.clear();
    await _storage.clearAlerts();
    Get.snackbar(
      'Cleared',
      'All alerts have been removed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  List<RateAlert> get activeAlerts =>
      alerts.where((alert) => alert.isActive).toList();

  List<RateAlert> get triggeredAlerts =>
      alerts.where((alert) => alert.triggeredAt != null).toList();
}
