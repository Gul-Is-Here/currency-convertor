import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';
import 'currency_service.dart';

// ──────────────────────────────────────────────────────
//  BACKGROUND TASK NAMES
// ──────────────────────────────────────────────────────
const String _bgTaskRateCheck = 'com.gulishereapps.ratecheck';
const String _bgTaskRateCheckUnique = 'com.gulishereapps.ratecheck.periodic';

// ──────────────────────────────────────────────────────
//  TOP-LEVEL CALLBACK (required by workmanager)
//  This runs in an ISOLATE when app is killed/background.
// ──────────────────────────────────────────────────────
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      debugPrint('BackgroundTask: $taskName started');

      if (taskName == _bgTaskRateCheck ||
          taskName == Workmanager.iOSBackgroundTask) {
        await _performBackgroundRateCheck();
      }

      debugPrint('BackgroundTask: $taskName completed');
      return Future.value(true);
    } catch (e) {
      debugPrint('BackgroundTask: $taskName failed - $e');
      return Future.value(false);
    }
  });
}

/// Standalone function that runs in background isolate.
/// Cannot use Flutter UI or GetX - uses raw HTTP + SharedPreferences only.
Future<void> _performBackgroundRateCheck() async {
  final prefs = await SharedPreferences.getInstance();

  // Check if monitoring is enabled
  final enabled = prefs.getBool('rate_monitor_enabled') ?? true;
  if (!enabled) return;

  final threshold = prefs.getDouble('rate_monitor_threshold') ?? 1.0;

  // Build list of currencies to monitor
  final favorites = prefs.getStringList('favorite_currencies') ?? [];
  final codes = <String>{
    ...favorites,
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'PKR',
    'INR',
    'CNY',
  };
  codes.remove('USD');
  if (codes.isEmpty) return;

  // Fetch latest rates directly (raw HTTP - no Flutter UI context available)
  final url = Uri.parse('https://open.er-api.com/v6/latest/USD');
  final response = await http.get(url).timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) return;

  final data = json.decode(response.body);
  final Map<String, dynamic> rawRates = data['rates'] ?? {};
  final Map<String, double> latestRates = rawRates.map(
    (k, v) => MapEntry(k, (v as num).toDouble()),
  );

  // Load previous snapshot
  final prevJson = prefs.getString('previous_rates_snapshot');
  if (prevJson == null) {
    // First run: save snapshot, don't notify
    await prefs.setString('previous_rates_snapshot', json.encode(latestRates));
    return;
  }

  final Map<String, dynamic> prevDecoded = json.decode(prevJson);
  final Map<String, double> previousRates = prevDecoded.map(
    (k, v) => MapEntry(k, (v as num).toDouble()),
  );

  // Compare
  final List<Map<String, dynamic>> changes = [];

  for (final code in codes) {
    final current = latestRates[code];
    final previous = previousRates[code];
    if (current == null || previous == null || previous == 0) continue;

    final pct = ((current - previous) / previous) * 100;
    if (pct.abs() >= threshold) {
      changes.add({
        'code': code,
        'prev': previous,
        'curr': current,
        'pct': pct,
      });
    }
  }

  // Send notification if there are significant changes
  if (changes.isNotEmpty) {
    // Sort by abs change
    changes.sort(
      (a, b) =>
          (b['pct'] as double).abs().compareTo((a['pct'] as double).abs()),
    );

    final risers = changes.where((c) => (c['pct'] as double) > 0).toList();
    final fallers = changes.where((c) => (c['pct'] as double) < 0).toList();

    final buffer = StringBuffer();
    if (risers.isNotEmpty) {
      buffer.write('📈 Up: ');
      buffer.write(
        risers
            .take(4)
            .map(
              (c) =>
                  '${c['code']} +${(c['pct'] as double).toStringAsFixed(2)}%',
            )
            .join(', '),
      );
      if (risers.length > 4) buffer.write(' +${risers.length - 4} more');
    }
    if (risers.isNotEmpty && fallers.isNotEmpty) buffer.write('\n');
    if (fallers.isNotEmpty) {
      buffer.write('📉 Down: ');
      buffer.write(
        fallers
            .take(4)
            .map(
              (c) => '${c['code']} ${(c['pct'] as double).toStringAsFixed(2)}%',
            )
            .join(', '),
      );
      if (fallers.length > 4) buffer.write(' +${fallers.length - 4} more');
    }

    final title =
        '💱 ${changes.length} Rate${changes.length > 1 ? 's' : ''} Moved (vs USD)';

    // Use awesome_notifications directly in background
    await NotificationService().initialize();
    await NotificationService().showRateChangeNotification(
      title: title,
      body: buffer.toString(),
      groupKey: 'rate_changes',
    );
  }

  // Update snapshot
  await prefs.setString('previous_rates_snapshot', json.encode(latestRates));
  await prefs.setInt(
    'rate_monitor_last_check',
    DateTime.now().millisecondsSinceEpoch,
  );
}

// ──────────────────────────────────────────────────────
//  SERVICE CLASS (for foreground use + managing settings)
// ──────────────────────────────────────────────────────
class RateMonitorService {
  static final RateMonitorService _instance = RateMonitorService._internal();
  factory RateMonitorService() => _instance;
  RateMonitorService._internal();

  final NotificationService _notificationService = NotificationService();
  final CurrencyService _currencyService = CurrencyService();

  static const String _previousRatesKey = 'previous_rates_snapshot';
  static const String _monitorEnabledKey = 'rate_monitor_enabled';
  static const String _thresholdKey = 'rate_monitor_threshold';
  static const String _lastCheckKey = 'rate_monitor_last_check';

  static const double defaultThreshold = 1.0;

  /// Initialize workmanager and register periodic background task.
  /// Call this once from main().
  Future<void> initializeBackgroundTasks() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    final enabled = await isEnabled();
    if (enabled) {
      await _registerPeriodicTask();
    }
  }

  /// Register the periodic background task
  Future<void> _registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      _bgTaskRateCheckUnique,
      _bgTaskRateCheck,
      frequency: const Duration(hours: 1),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 15),
      tag: 'rate_monitor',
    );
    debugPrint('RateMonitor: Periodic background task registered (every ~1hr)');
  }

  /// Cancel the periodic background task
  Future<void> _cancelPeriodicTask() async {
    await Workmanager().cancelByTag('rate_monitor');
    debugPrint('RateMonitor: Background task cancelled');
  }

  /// Whether auto-notifications are enabled
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_monitorEnabledKey) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_monitorEnabledKey, enabled);
    if (enabled) {
      await _registerPeriodicTask();
    } else {
      await _cancelPeriodicTask();
    }
  }

  /// Get / set threshold percentage
  Future<double> getThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_thresholdKey) ?? defaultThreshold;
  }

  Future<void> setThreshold(double threshold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_thresholdKey, threshold);
  }

  /// Run a foreground check (when app is open)
  Future<void> checkForRateChanges() async {
    try {
      final enabled = await isEnabled();
      if (!enabled) return;

      final prefs = await SharedPreferences.getInstance();
      final lastCheckMs = prefs.getInt(_lastCheckKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastCheckMs < 10 * 60 * 1000) return; // 10 min throttle
      await prefs.setInt(_lastCheckKey, now);

      final threshold = await getThreshold();

      final favorites = prefs.getStringList('favorite_currencies') ?? [];
      final codes = <String>{
        ...favorites,
        'EUR',
        'GBP',
        'JPY',
        'CAD',
        'AUD',
        'PKR',
        'INR',
        'CNY',
      };
      codes.remove('USD');
      if (codes.isEmpty) return;

      final latestRates = await _currencyService.getExchangeRates('USD');
      final previousSnapshot = await _loadPreviousRates();

      if (previousSnapshot.isEmpty) {
        await _saveCurrentRates(latestRates.rates);
        return;
      }

      final List<_RateChange> significantChanges = [];
      for (final code in codes) {
        final currentRate = latestRates.rates[code];
        final previousRate = previousSnapshot[code];
        if (currentRate == null || previousRate == null || previousRate == 0)
          continue;

        final changePercent =
            ((currentRate - previousRate) / previousRate) * 100;
        if (changePercent.abs() >= threshold) {
          significantChanges.add(
            _RateChange(
              currencyCode: code,
              previousRate: previousRate,
              currentRate: currentRate,
              changePercent: changePercent,
            ),
          );
        }
      }

      if (significantChanges.isNotEmpty) {
        await _sendChangeNotifications(significantChanges);
      }

      await _saveCurrentRates(latestRates.rates);
    } catch (e) {
      debugPrint('RateMonitorService: Error checking rates - $e');
    }
  }

  Future<Map<String, double>> _loadPreviousRates() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_previousRatesKey);
    if (jsonStr == null) return {};
    try {
      final Map<String, dynamic> decoded = json.decode(jsonStr);
      return decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } catch (e) {
      return {};
    }
  }

  Future<void> _saveCurrentRates(Map<String, double> rates) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_previousRatesKey, json.encode(rates));
  }

  Future<void> _sendChangeNotifications(List<_RateChange> changes) async {
    changes.sort(
      (a, b) => b.changePercent.abs().compareTo(a.changePercent.abs()),
    );

    final risers = changes.where((c) => c.changePercent > 0).toList();
    final fallers = changes.where((c) => c.changePercent < 0).toList();

    final buffer = StringBuffer();
    if (risers.isNotEmpty) {
      buffer.write('📈 Up: ');
      buffer.write(
        risers
            .take(4)
            .map(
              (c) =>
                  '${c.currencyCode} +${c.changePercent.toStringAsFixed(2)}%',
            )
            .join(', '),
      );
      if (risers.length > 4) buffer.write(' +${risers.length - 4} more');
    }
    if (risers.isNotEmpty && fallers.isNotEmpty) buffer.write('\n');
    if (fallers.isNotEmpty) {
      buffer.write('📉 Down: ');
      buffer.write(
        fallers
            .take(4)
            .map(
              (c) => '${c.currencyCode} ${c.changePercent.toStringAsFixed(2)}%',
            )
            .join(', '),
      );
      if (fallers.length > 4) buffer.write(' +${fallers.length - 4} more');
    }

    final title =
        '💱 ${changes.length} Rate${changes.length > 1 ? 's' : ''} Moved (vs USD)';

    await _notificationService.showRateChangeNotification(
      title: title,
      body: buffer.toString(),
      groupKey: 'rate_changes',
    );
  }

  /// Reset the stored snapshot (e.g. after clearing cache)
  Future<void> resetSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_previousRatesKey);
    await prefs.remove(_lastCheckKey);
  }
}

class _RateChange {
  final String currencyCode;
  final double previousRate;
  final double currentRate;
  final double changePercent;

  _RateChange({
    required this.currencyCode,
    required this.previousRate,
    required this.currentRate,
    required this.changePercent,
  });
}
