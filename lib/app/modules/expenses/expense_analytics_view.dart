import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'expense_controller.dart';
import '../../data/models/expense_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../data/providers/currency_data.dart';

class ExpenseAnalyticsView extends StatelessWidget {
  final ExpenseController controller;

  const ExpenseAnalyticsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.expenses.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 80,
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No data to analyze',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Add some expenses to see analytics',
                style: TextStyle(
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadExpenses,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Currency Selector
              _buildCurrencySelector(context),
              const SizedBox(height: 20),

              // Summary Cards
              _buildSummaryCards(),
              const SizedBox(height: 24),

              // Category Breakdown Chart
              Text(
                'Spending by Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildCategoryPieChart(),
              const SizedBox(height: 24),

              // Category List
              _buildCategoryList(context),
              const SizedBox(height: 24),

              // Budget Progress (if any budgets exist)
              if (controller.budgets.isNotEmpty) ...[
                Text(
                  'Budget Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildBudgetProgress(),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCurrencySelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.currency_exchange),
            const SizedBox(width: 12),
            const Text('Display in:'),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => DropdownButton<String>(
                  value: controller.selectedCurrency.value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: CurrencyData.currencyInfo.keys.map((currency) {
                    final info = CurrencyData.currencyInfo[currency]!;
                    return DropdownMenuItem(
                      value: currency,
                      child: Text('$currency - ${info['name']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedCurrency.value = value;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(() {
      final total = controller.getTotalExpenses();
      final average = controller.getAverageExpense();

      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Spent',
              FormatUtils.formatAmount(total),
              controller.selectedCurrency.value,
              Icons.account_balance_wallet,
              AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Average',
              FormatUtils.formatAmount(average),
              controller.selectedCurrency.value,
              Icons.trending_up,
              Colors.orange,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String currency,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              currency,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart() {
    return Obx(() {
      final breakdown = controller.getCategoryBreakdown();
      final total = controller.getTotalExpenses();

      // Filter out categories with 0 spending
      final nonZeroCategories =
          breakdown.entries.where((e) => e.value > 0).toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      if (nonZeroCategories.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(child: Text('No spending data')),
        );
      }

      return SizedBox(
        height: 250,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(
                  sections: nonZeroCategories.map((entry) {
                    final percentage = (entry.value / total) * 100;
                    return PieChartSectionData(
                      value: entry.value,
                      title: '${percentage.toStringAsFixed(0)}%',
                      color: Color(entry.key.colorValue),
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: nonZeroCategories.take(5).map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(entry.key.colorValue),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key.icon,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryList(BuildContext context) {
    return Obx(() {
      final breakdown = controller.getCategoryBreakdown();
      final total = controller.getTotalExpenses();

      final nonZeroCategories =
          breakdown.entries.where((e) => e.value > 0).toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      return Column(
        children: nonZeroCategories.map((entry) {
          final percentage = total > 0 ? (entry.value / total) * 100 : 0;
          final color = Color(entry.key.colorValue);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            entry.key.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${controller.getExpensesByCategory(entry.key).length} expenses',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            FormatUtils.formatAmount(entry.value),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildBudgetProgress() {
    return Obx(
      () => Column(
        children: controller.budgets.where((b) => b.isActive()).map((budget) {
          final spent = controller.getTotalByCategory(
            budget.category,
            budget.currency,
          );
          final progress = controller.getBudgetProgress(budget.category);
          final remaining = budget.limit - spent;
          final color = Color(budget.category.colorValue);
          final isOverBudget = spent > budget.limit;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        budget.category.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              budget.category.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Budget: ${FormatUtils.formatAmount(budget.limit)} ${budget.currency}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            FormatUtils.formatAmount(spent),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isOverBudget ? Colors.red : color,
                            ),
                          ),
                          Text(
                            isOverBudget
                                ? 'Over by ${FormatUtils.formatAmount(spent - budget.limit)}'
                                : 'Remaining ${FormatUtils.formatAmount(remaining)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isOverBudget
                                  ? Colors.red
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverBudget ? Colors.red : color,
                    ),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}% of budget used',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverBudget ? Colors.red : AppTheme.textSecondary,
                      fontWeight: isOverBudget
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
