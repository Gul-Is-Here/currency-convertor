import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'currency_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/widgets/mini_chart_widget.dart';
import '../../core/widgets/offline_indicator.dart';
import '../../data/services/notification_service.dart';
import '../../data/widgets/admob_banner_widget.dart';
import 'currency_selector_sheet.dart';

class ConverterView extends StatefulWidget {
  const ConverterView({super.key});

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView>
    with SingleTickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  late AnimationController _swapAnimController;
  late Animation<double> _swapRotation;

  @override
  void initState() {
    super.initState();
    _swapAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _swapRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _swapAnimController, curve: Curves.easeInOut),
    );
    _checkAndRequestNotificationPermission();
  }

  @override
  void dispose() {
    _swapAnimController.dispose();
    super.dispose();
  }

  Future<void> _checkAndRequestNotificationPermission() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await _notificationService.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CurrencyController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() {
        // Error state
        if (controller.errorMessage.value.isNotEmpty &&
            controller.exchangeRates.value == null) {
          return _buildErrorState(controller, isDark);
        }

        // Loading state
        if (controller.isLoading.value &&
            controller.exchangeRates.value == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppTheme.primaryColor),
                const SizedBox(height: 16),
                Text(
                  'Loading exchange rates...',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Ad at top
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: AdMobBannerWidget(margin: EdgeInsets.only(bottom: 8)),
                ),

                // Offline Indicator
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: OfflineIndicator(),
                ),

                const SizedBox(height: 4),

                // ─── MAIN CONVERSION CARD ───
                _buildConversionSection(context, controller, isDark),

                const SizedBox(height: 12),

                // ─── EXCHANGE RATE PILL ───
                if (controller.currentRate.value > 0)
                  _buildExchangeRateChip(context, controller, isDark),

                const SizedBox(height: 16),

                // ─── QUICK ACTIONS ───
                _buildQuickActions(context, isDark),

                const SizedBox(height: 16),

                // ─── MINI CHART ───
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: MiniChartWidget(),
                ),

                const SizedBox(height: 16),

                // ─── RECENT CONVERSIONS ───
                if (controller.recentConversions.isNotEmpty)
                  _buildRecentConversions(context, controller, isDark),

                // Last updated timestamp
                if (controller.lastUpdate.value != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Center(
                      child: Text(
                        'Updated ${FormatUtils.formatTimeAgo(controller.lastUpdate.value!)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ══════════════════════════════════════════
  //  MAIN CONVERSION SECTION
  // ══════════════════════════════════════════
  Widget _buildConversionSection(
    BuildContext context,
    CurrencyController controller,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              // FROM card
              _buildCurrencyTile(
                context,
                controller,
                isDark,
                isFrom: true,
                label: 'You send',
              ),

              const SizedBox(height: 6),

              // TO card
              _buildCurrencyTile(
                context,
                controller,
                isDark,
                isFrom: false,
                label: 'They receive',
              ),
            ],
          ),

          // Floating swap button
          Positioned(
            top: 0,
            bottom: 0,
            right: 24,
            child: Center(
              child: RotationTransition(
                turns: _swapRotation,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _swapAnimController.forward(from: 0);
                    controller.swapCurrencies();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  CURRENCY TILE (From / To)
  // ══════════════════════════════════════════
  Widget _buildCurrencyTile(
    BuildContext context,
    CurrencyController controller,
    bool isDark, {
    required bool isFrom,
    required String label,
  }) {
    final currency = isFrom
        ? controller.fromCurrency.value
        : controller.toCurrency.value;

    final cardColor = isDark
        ? (isFrom ? Colors.grey[850] : Colors.grey[900])
        : (isFrom ? Colors.white : const Color(0xFFF5F3FF));

    final borderColor = isDark
        ? (isFrom
              ? Colors.grey[700]!
              : AppTheme.primaryColor.withValues(alpha: 0.25))
        : (isFrom
              ? Colors.grey.shade200
              : AppTheme.primaryColor.withValues(alpha: 0.15));

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 48, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),

          // Flag + Code + Name  |  Amount
          Row(
            children: [
              // Currency selector (tappable)
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () =>
                      _showCurrencySelector(context, controller, isFrom),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      // Flag circle
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[800]
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          currency.flag,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  currency.code,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: Colors.grey[500],
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currency.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider line
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: isDark ? Colors.grey[700] : Colors.grey.shade200,
              ),

              // Amount area
              Expanded(
                flex: 2,
                child: isFrom
                    ? TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppTheme.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[600] : Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: controller.setAmount,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              FormatUtils.formatCurrency(
                                controller.convertedAmount.value,
                                currency.code,
                              ),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currency.symbol,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  EXCHANGE RATE CHIP
  // ══════════════════════════════════════════
  Widget _buildExchangeRateChip(
    BuildContext context,
    CurrencyController controller,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.primaryColor.withValues(alpha: 0.12)
              : AppTheme.primaryColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.sync_alt_rounded,
              size: 18,
              color: AppTheme.primaryColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '1 ${controller.fromCurrency.value.code} = ${FormatUtils.formatCurrency(controller.currentRate.value, controller.toCurrency.value.code, decimals: 4)} ${controller.toCurrency.value.code}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppTheme.textPrimary,
                ),
              ),
            ),
            // Share button
            InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                final from = controller.fromCurrency.value;
                final to = controller.toCurrency.value;
                final amount = controller.amount.value;
                final result = FormatUtils.formatCurrency(
                  controller.convertedAmount.value,
                  to.code,
                );
                Share.share(
                  '$amount ${from.code} = $result ${to.code}\n'
                  'Rate: 1 ${from.code} = ${FormatUtils.formatCurrency(controller.currentRate.value, to.code, decimals: 4)} ${to.code}\n\n'
                  'Converted with CurrencyHub Live',
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.share_rounded,
                  size: 18,
                  color: AppTheme.primaryColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  QUICK ACTIONS
  // ══════════════════════════════════════════
  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildActionChip(
            context,
            isDark,
            icon: Icons.show_chart_rounded,
            label: 'Charts',
            color: AppTheme.primaryColor,
            onTap: () => Get.toNamed('/chart'),
          ),
          const SizedBox(width: 10),
          _buildActionChip(
            context,
            isDark,
            icon: Icons.notifications_active_rounded,
            label: 'Alerts',
            color: AppTheme.secondaryColor,
            onTap: () => Get.toNamed('/alerts'),
          ),
          const SizedBox(width: 10),
          _buildActionChip(
            context,
            isDark,
            icon: Icons.receipt_long_rounded,
            label: 'Expenses',
            color: AppTheme.accentColor,
            onTap: () => Get.toNamed('/expenses'),
          ),
          const SizedBox(width: 10),
          _buildActionChip(
            context,
            isDark,
            icon: Icons.lightbulb_outline_rounded,
            label: 'Tips',
            color: Colors.amber.shade700,
            onTap: () => Get.toNamed('/tips'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isDark
                ? color.withValues(alpha: 0.12)
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  RECENT CONVERSIONS
  // ══════════════════════════════════════════
  Widget _buildRecentConversions(
    BuildContext context,
    CurrencyController controller,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppTheme.textPrimary,
                ),
              ),
              Text(
                '${controller.recentConversions.length} conversions',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...controller.recentConversions.take(4).map((conversion) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey.shade100,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${conversion['amount']} ${conversion['from']} → ${conversion['to']}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          FormatUtils.formatTimeAgo(
                            DateTime.parse(conversion['timestamp']!),
                          ),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[600] : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  ERROR STATE
  // ══════════════════════════════════════════
  Widget _buildErrorState(CurrencyController controller, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to Load Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 160,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.errorMessage.value = '';
                  controller.initializeData();
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  'Retry',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  CURRENCY SELECTOR SHEET
  // ══════════════════════════════════════════
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
