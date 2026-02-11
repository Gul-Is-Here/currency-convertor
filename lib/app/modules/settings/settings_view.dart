import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart';
import '../../core/controllers/theme_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/offline_indicator.dart';
import '../../data/services/connectivity_service.dart';
import '../../data/services/rate_monitor_service.dart';
import '../../data/widgets/admob_banner_widget.dart';
import '../../routes/app_routes.dart';
import '../converter/currency_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final currencyController = Get.find<CurrencyController>();
    final connectivityService = Get.find<ConnectivityService>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(
        () => ListView(
          children: [
            // Banner Ad at top
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: AdMobBannerWidget(),
            ),

            // Connection Status
            _buildSectionHeader(context, 'Connection Status'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(
                  connectivityService.isOnline.value
                      ? Icons.wifi
                      : Icons.wifi_off,
                  color: connectivityService.isOnline.value
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text(
                  connectivityService.isOnline.value ? 'Online' : 'Offline',
                ),
                subtitle: Text(
                  'Connection: ${connectivityService.connectionType}',
                ),
                trailing: const ConnectionStatusBadge(),
              ),
            ),

            // Theme Section - ENABLED
            _buildSectionHeader(context, 'Appearance'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: Text(
                  themeController.isDarkMode.value
                      ? 'Dark theme enabled'
                      : 'Light theme enabled',
                ),
                value: themeController.isDarkMode.value,
                onChanged: (value) => themeController.toggleTheme(),
                secondary: Icon(
                  themeController.isDarkMode.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),

            // Notifications Section
            _buildSectionHeader(context, 'Notifications'),
            _buildNotificationSettings(context),

            // Learn & Tips Section
            _buildSectionHeader(context, 'Learn & Tips'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                    ),
                    title: const Text('Currency Tips & Travel Guide'),
                    subtitle: const Text('Save money on currency exchange'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.tips),
                  ),
                ],
              ),
            ),

            // Data Section
            _buildSectionHeader(context, 'Data Management'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Expense Tracker'),
                    subtitle: const Text('Track and analyze your expenses'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.expenses),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.notifications_active,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Rate Alerts'),
                    subtitle: const Text('Manage currency rate notifications'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.alerts),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.refresh,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Clear Cache'),
                    subtitle: Text(
                      currencyController.lastUpdate.value != null
                          ? 'Last updated: ${_formatDate(currencyController.lastUpdate.value!)}'
                          : 'No cache data',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showClearCacheDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: AppTheme.errorColor,
                    ),
                    title: const Text('Clear History'),
                    subtitle: Text(
                      '${currencyController.recentConversions.length} recent conversions',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showClearHistoryDialog(context),
                  ),
                ],
              ),
            ),

            // Share & Feedback
            _buildSectionHeader(context, 'Share & Feedback'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.share,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Share App'),
                    subtitle: const Text('Tell friends about CurrencyHub Live'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Share.share(
                        'Check out CurrencyHub Live - Your Complete Currency & Crypto Companion! '
                        'Real-time exchange rates, crypto tracking, and more.\n\n'
                        'https://play.google.com/store/apps/details?id=com.gulishereapps.currency_convertor',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.star_rate, color: Colors.amber),
                    title: const Text('Rate Us'),
                    subtitle: const Text('Leave a review on Play Store'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final uri = Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.gulishereapps.currency_convertor',
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip_outlined,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Privacy Policy'),
                    subtitle: const Text('Read our privacy policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final uri = Uri.parse(
                        'https://gul-is-here.github.io/currency-convertor/',
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // About Section - Dynamic Version
            _buildSectionHeader(context, 'About'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final version = snapshot.hasData
                          ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                          : 'Loading...';
                      return ListTile(
                        leading: const Icon(
                          Icons.info_outline,
                          color: AppTheme.primaryColor,
                        ),
                        title: const Text('App Version'),
                        subtitle: Text(version),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.api,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Data Source'),
                    subtitle: const Text('open.er-api.com & CoinGecko'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.code,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Developer'),
                    subtitle: const Text('Gul-Is-Here'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final uri = Uri.parse('https://github.com/Gul-Is-Here');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    final rateMonitor = RateMonitorService();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          FutureBuilder<bool>(
            future: rateMonitor.isEnabled(),
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? true;
              return SwitchListTile(
                title: const Text('Auto Rate Alerts'),
                subtitle: Text(
                  enabled
                      ? 'Get notified when rates move significantly'
                      : 'Automatic alerts disabled',
                ),
                value: enabled,
                onChanged: (value) async {
                  await rateMonitor.setEnabled(value);
                  // Force rebuild
                  (context as Element).markNeedsBuild();
                  Get.snackbar(
                    value ? 'Alerts Enabled' : 'Alerts Disabled',
                    value
                        ? 'You\'ll be notified when rates change significantly'
                        : 'Automatic rate notifications turned off',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
                secondary: const Icon(
                  Icons.notifications_active_outlined,
                  color: AppTheme.primaryColor,
                ),
              );
            },
          ),
          const Divider(height: 1),
          FutureBuilder<double>(
            future: rateMonitor.getThreshold(),
            builder: (context, snapshot) {
              final threshold = snapshot.data ?? 1.0;
              return ListTile(
                leading: const Icon(Icons.tune, color: AppTheme.primaryColor),
                title: const Text('Alert Sensitivity'),
                subtitle: Text(
                  'Notify when rate changes ≥ ${threshold.toStringAsFixed(1)}%',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    _showThresholdPicker(context, rateMonitor, threshold),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showThresholdPicker(
    BuildContext context,
    RateMonitorService rateMonitor,
    double currentThreshold,
  ) {
    double selected = currentThreshold;
    final options = [0.5, 1.0, 2.0, 3.0, 5.0];

    Get.dialog(
      AlertDialog(
        title: const Text('Alert Sensitivity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notify me when any monitored rate changes by at least:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: options.map((value) {
                    String label;
                    String desc;
                    if (value <= 0.5) {
                      label = '${value.toStringAsFixed(1)}%';
                      desc = 'Very sensitive';
                    } else if (value <= 1.0) {
                      label = '${value.toStringAsFixed(1)}%';
                      desc = 'Recommended';
                    } else if (value <= 2.0) {
                      label = '${value.toStringAsFixed(1)}%';
                      desc = 'Moderate';
                    } else if (value <= 3.0) {
                      label = '${value.toStringAsFixed(1)}%';
                      desc = 'Less frequent';
                    } else {
                      label = '${value.toStringAsFixed(1)}%';
                      desc = 'Major moves only';
                    }
                    return RadioListTile<double>(
                      title: Text(label),
                      subtitle: Text(
                        desc,
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: value,
                      groupValue: selected,
                      activeColor: AppTheme.primaryColor,
                      dense: true,
                      onChanged: (val) {
                        setState(() => selected = val!);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await rateMonitor.setThreshold(selected);
              Get.back();
              Get.snackbar(
                'Threshold Updated',
                'You\'ll be notified when rates change by ≥ ${selected.toStringAsFixed(1)}%',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showClearCacheDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will remove all cached exchange rate data. '
          'The app will fetch fresh data on next use.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.snackbar(
                'Success',
                'Cache cleared successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'This will remove all recent conversion history. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.snackbar(
                'Success',
                'History cleared successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
