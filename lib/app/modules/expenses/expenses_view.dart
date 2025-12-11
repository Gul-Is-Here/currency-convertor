import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/expense_model.dart';
import 'expense_controller.dart';
import '../../core/theme/app_theme.dart';
import 'expense_list_view.dart';
import 'expense_analytics_view.dart';
import 'add_expense_view.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExpenseController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Expense Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Expenses'),
              Tab(icon: Icon(Icons.pie_chart), text: 'Analytics'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterSheet(context, controller),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ExpenseListView(controller: controller),
            ExpenseAnalyticsView(controller: controller),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.to(() => const AddExpenseView()),
          icon: const Icon(Icons.add),
          label: const Text('Add Expense'),
          backgroundColor: AppTheme.primaryColor,
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, ExpenseController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: controller.selectedCategory.value == null,
                    onSelected: (_) {
                      controller.filterByCategory(null);
                      Get.back();
                    },
                  ),
                  ...ExpenseCategory.values.map((category) {
                    return FilterChip(
                      label: Text('${category.icon} ${category.displayName}'),
                      selected: controller.selectedCategory.value == category,
                      onSelected: (_) {
                        controller.filterByCategory(category);
                        Get.back();
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
