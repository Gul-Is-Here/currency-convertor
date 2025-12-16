import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'currency_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/mini_chart_widget.dart';
import '../../core/widgets/offline_indicator.dart';
import '../../data/services/notification_service.dart';
// import '../../core/widgets/shimmer_loading.dart';
import 'currency_selector_sheet.dart';

class ConverterView extends StatefulWidget {
  const ConverterView({super.key});

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // Request notification permission when view loads
    _checkAndRequestNotificationPermission();
  }

  Future<void> _checkAndRequestNotificationPermission() async {
    // Small delay to let the view render first
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check current permission status
    final isAllowed = await _notificationService.requestPermission();

    if (!isAllowed && mounted) {
      // Only show message if permission was just denied (not already denied)
      Get.snackbar(
        'Enable Notifications',
        'Get instant alerts when your target exchange rates are reached',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: AppTheme.primaryColor.withOpacity(0.95),
        colorText: Colors.white,
        icon: const Icon(
          Icons.notifications_active_outlined,
          color: Colors.white,
        ),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        isDismissible: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CurrencyController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.exchangeRates.value == null) {
          return Center(child: const CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Offline Indicator
                const OfflineIndicator(),
                if (controller.lastUpdate.value != null)
                  const SizedBox(height: 12),

                // Header with Last Update and Mini Chart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (controller.lastUpdate.value != null)
                      Expanded(
                        child: Text(
                          'Updated ${FormatUtils.formatTimeAgo(controller.lastUpdate.value!)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Mini Chart
                const MiniChartWidget(),
                const SizedBox(height: 20),

                // Currency Conversion Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // From Currency
                        _buildCompactCurrencyInput(
                          context,
                          controller,
                          isFrom: true,
                        ),

                        const SizedBox(height: 12),

                        // Swap Button
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.swap_vert,
                              color: Colors.white,
                            ),
                            onPressed: controller.swapCurrencies,
                            iconSize: 28,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // To Currency
                        _buildCompactCurrencyInput(
                          context,
                          controller,
                          isFrom: false,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Exchange Rate Info
                if (controller.currentRate.value > 0)
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Exchange Rate',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '1 ${controller.fromCurrency.value.code} = ${FormatUtils.formatCurrency(controller.currentRate.value, controller.toCurrency.value.code, decimals: 4)} ${controller.toCurrency.value.code}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: 'View Chart',
                        icon: Icons.show_chart,
                        onPressed: () => Get.toNamed('/chart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientButton(
                        text: 'Rate Alerts',
                        icon: Icons.notifications_active,
                        onPressed: () => Get.toNamed('/alerts'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Recent Conversions
                if (controller.recentConversions.isNotEmpty) ...[
                  Text(
                    'Recent Conversions',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  ...controller.recentConversions.take(5).map((conversion) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(
                            0.1,
                          ),
                          child: const Icon(
                            Icons.history,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        title: Text(
                          '${conversion['amount']} ${conversion['from']} → ${conversion['to']}',
                        ),
                        subtitle: Text(
                          FormatUtils.formatTimeAgo(
                            DateTime.parse(conversion['timestamp']!),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  // Compact Currency Input Widget
  Widget _buildCompactCurrencyInput(
    BuildContext context,
    CurrencyController controller, {
    required bool isFrom,
  }) {
    final currency = isFrom
        ? controller.fromCurrency.value
        : controller.toCurrency.value;

    return Container(
      decoration: BoxDecoration(
        color: isFrom ? Colors.white : AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFrom
              ? Colors.grey.shade300
              : AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency Selector
          InkWell(
            onTap: () => _showCurrencySelector(context, controller, isFrom),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Flag
                  Text(currency.flag, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  // Currency Code and Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currency.code,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currency.name,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Amount Input/Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currency.symbol,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isFrom ? Colors.grey[800] : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: isFrom
                      ? TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: controller.setAmount,
                        )
                      : Text(
                          FormatUtils.formatCurrency(
                            controller.convertedAmount.value,
                            currency.code,
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelector(
    BuildContext context,
    CurrencyController controller,
    bool isFrom,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySelectorSheet(
        onSelect: (currency) {
          if (isFrom) {
            controller.setFromCurrency(currency);
          } else {
            controller.setToCurrency(currency);
          }
          Get.back();
        },
        controller: controller,
      ),
    );
  }
}
