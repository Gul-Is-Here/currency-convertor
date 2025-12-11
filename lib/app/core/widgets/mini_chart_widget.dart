import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';
import '../utils/format_utils.dart';
import '../../modules/converter/currency_controller.dart';

class MiniChartWidget extends StatelessWidget {
  const MiniChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CurrencyController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoadingChart.value) {
        return Center(child: CircularProgressIndicator());
      }

      final chartData = controller.miniChartData.value;

      if (chartData == null || chartData.rates.isEmpty) {
        return const SizedBox.shrink();
      }

      return Card(
        elevation: 2,
        child: InkWell(
          onTap: () => Get.toNamed('/chart'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.fromCurrency.value.code}/${controller.toCurrency.value.code}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Last 7 Days',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: chartData.changePercentage >= 0
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            chartData.changePercentage >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            size: 16,
                            color: chartData.changePercentage >= 0
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            FormatUtils.formatPercentage(
                              chartData.changePercentage.abs(),
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: chartData.changePercentage >= 0
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: chartData.rates.length.toDouble() - 1,
                      minY: chartData.minRate * 0.999,
                      maxY: chartData.maxRate * 1.001,
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartData.rates.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              entry.value.rate,
                            );
                          }).toList(),
                          isCurved: true,
                          color: chartData.changePercentage >= 0
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                (chartData.changePercentage >= 0
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor)
                                    .withOpacity(0.2),
                                (chartData.changePercentage >= 0
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor)
                                    .withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(enabled: false),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat(
                      context,
                      'High',
                      FormatUtils.formatCurrency(
                        chartData.maxRate,
                        controller.toCurrency.value.code,
                        decimals: 4,
                      ),
                      AppTheme.successColor,
                    ),
                    _buildStat(
                      context,
                      'Low',
                      FormatUtils.formatCurrency(
                        chartData.minRate,
                        controller.toCurrency.value.code,
                        decimals: 4,
                      ),
                      AppTheme.errorColor,
                    ),
                    _buildStat(
                      context,
                      'Avg',
                      FormatUtils.formatCurrency(
                        chartData.avgRate,
                        controller.toCurrency.value.code,
                        decimals: 4,
                      ),
                      AppTheme.secondaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tap to view detailed chart',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
