import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/theme_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/offline_indicator.dart';
import '../../data/services/connectivity_service.dart';
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(
        () => ListView(
          children: [
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

            // Theme Section
            // _buildSectionHeader(context, 'Appearance'),
            // Card(
            //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: SwitchListTile(
            //     title: const Text('Dark Mode'),
            //     subtitle: Text(
            //       themeController.isDarkMode.value
            //           ? 'Dark theme enabled'
            //           : 'Light theme enabled',
            //     ),
            //     value: themeController.isDarkMode.value,
            //     onChanged: (value) => themeController.toggleTheme(),
            //     secondary: Icon(
            //       themeController.isDarkMode.value
            //           ? Icons.dark_mode
            //           : Icons.light_mode,
            //       color: AppTheme.primaryColor,
            //     ),
            //   ),
            // ),

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

            // About Section
            _buildSectionHeader(context, 'About'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('App Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.api,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Data Source'),
                    subtitle: const Text('open.er-api.com'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.code,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Developer'),
                    subtitle: const Text('Gul-Is-Here'),
                    onTap: () {
                      // Open GitHub profile
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
              // Clear cache logic here
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
              // Clear history logic here
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
