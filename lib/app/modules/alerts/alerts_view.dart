import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'alerts_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/offline_indicator.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../data/models/rate_alert_model.dart';
import '../../data/providers/currency_data.dart';

class AlertsView extends StatelessWidget {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AlertsController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Rate Alerts'),
        actions: [
          Obx(
            () => controller.alerts.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: () => _showClearAllDialog(context, controller),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          children: [
            // Offline Indicator
            const OfflineIndicator(),

            // Alerts List
            Expanded(
              child: controller.alerts.isEmpty
                  ? _buildEmptyState(context, controller)
                  : RefreshIndicator(
                      onRefresh: controller.loadAlerts,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (controller.activeAlerts.isNotEmpty) ...[
                            Text(
                              'Active Alerts (${controller.activeAlerts.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            ...controller.activeAlerts.map(
                              (alert) =>
                                  _buildAlertCard(context, controller, alert),
                            ),
                            const SizedBox(height: 24),
                          ],
                          if (controller.triggeredAlerts.isNotEmpty) ...[
                            Text(
                              'Triggered Alerts (${controller.triggeredAlerts.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            ...controller.triggeredAlerts.map(
                              (alert) => _buildAlertCard(
                                context,
                                controller,
                                alert,
                                isTriggered: true,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAlertDialog(context, controller),
        icon: const Icon(Icons.add_alert),
        label: const Text('New Alert'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AlertsController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Rate Alerts',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              'Create alerts to get notified when exchange rates reach your target',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Create Your First Alert',
              onPressed: () => _showCreateAlertDialog(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    AlertsController controller,
    RateAlert alert, {
    bool isTriggered = false,
  }) {
    final baseInfo = CurrencyData.currencyInfo[alert.baseCurrency]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isTriggered ? 1 : 2,
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: isTriggered
                  ? Colors.grey.shade200
                  : AppTheme.primaryColor.withOpacity(0.1),
              child: Text(
                '${baseInfo['flag']}',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            if (isTriggered)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
        title: Text(
          '${alert.baseCurrency}/${alert.targetCurrency}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isTriggered ? AppTheme.textSecondary : null,
            decoration: isTriggered ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alert.alertDescription,
              style: TextStyle(
                color: isTriggered ? AppTheme.textSecondary : null,
              ),
            ),
            if (isTriggered && alert.triggeredAt != null)
              Text(
                'Triggered ${_formatDate(alert.triggeredAt!)}',
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isTriggered)
              Switch(
                value: alert.isActive,
                onChanged: (value) => controller.toggleAlert(alert.id),
                activeColor: AppTheme.primaryColor,
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: AppTheme.errorColor,
              onPressed: () => _showDeleteDialog(context, controller, alert),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateAlertDialog(
    BuildContext context,
    AlertsController controller,
  ) {
    String baseCurrency = 'USD';
    String targetCurrency = 'EUR';
    String condition = 'above';
    final targetRateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Rate Alert'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Currency Pair',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: baseCurrency,
                      decoration: const InputDecoration(
                        labelText: 'Base',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      isExpanded: true,
                      items: CurrencyData.currencyInfo.keys
                          .map(
                            (code) => DropdownMenuItem(
                              value: code,
                              child: Text(
                                '$code ${CurrencyData.currencyInfo[code]!['flag']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => baseCurrency = value!,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('/'),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: targetCurrency,
                      decoration: const InputDecoration(
                        labelText: 'Target',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      isExpanded: true,
                      items: CurrencyData.currencyInfo.keys
                          .map(
                            (code) => DropdownMenuItem(
                              value: code,
                              child: Text(
                                '$code ${CurrencyData.currencyInfo[code]!['flag']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => targetCurrency = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Condition', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: condition,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'above', child: Text('Rises above')),
                  DropdownMenuItem(value: 'below', child: Text('Falls below')),
                ],
                onChanged: (value) => condition = value!,
              ),
              const SizedBox(height: 16),
              Text(
                'Target Rate',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: targetRateController,
                decoration: const InputDecoration(
                  hintText: 'Enter target rate',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.trending_up),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final targetRate = double.tryParse(targetRateController.text);
              if (targetRate == null || targetRate <= 0) {
                Get.snackbar(
                  'Invalid Rate',
                  'Please enter a valid target rate',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              final alert = RateAlert(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                baseCurrency: baseCurrency,
                targetCurrency: targetCurrency,
                targetRate: targetRate,
                condition: condition,
                createdAt: DateTime.now(),
              );

              controller.addAlert(alert);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AlertsController controller,
    RateAlert alert,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Alert'),
        content: Text(
          'Are you sure you want to delete this alert?\n\n${alert.alertDescription}',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.removeAlert(alert.id);
              Get.back();
              Get.snackbar(
                'Deleted',
                'Alert has been removed',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, AlertsController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Alerts'),
        content: const Text(
          'Are you sure you want to delete all alerts? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.clearAll();
              Get.back();
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
