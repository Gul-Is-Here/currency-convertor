import 'package:get/get.dart';
import '../../data/models/expense_model.dart';
import '../../data/providers/local_storage_provider.dart';
import '../converter/currency_controller.dart';

class ExpenseController extends GetxController {
  final LocalStorageProvider _storage = LocalStorageProvider();

  final expenses = <Expense>[].obs;
  final budgets = <Budget>[].obs;
  final isLoading = false.obs;
  final selectedCategory = Rx<ExpenseCategory?>(null);
  final selectedCurrency = 'USD'.obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
    loadBudgets();
  }

  Future<void> loadExpenses() async {
    try {
      isLoading.value = true;
      final expensesList = await _storage.getExpenses();
      expenses.value = expensesList
          .map((json) => Expense.fromJson(json))
          .toList();
      // Sort by date (newest first)
      expenses.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load expenses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBudgets() async {
    try {
      final budgetsList = await _storage.getBudgets();
      budgets.value = budgetsList.map((json) => Budget.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load budgets: $e');
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      expenses.insert(0, expense);
      await _saveExpenses();

      // Check budget alerts
      _checkBudgetAlert(expense);

      Get.back();
      Get.snackbar(
        'Success',
        'Expense added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add expense: $e');
    }
  }

  Future<void> updateExpense(String id, Expense updatedExpense) async {
    try {
      final index = expenses.indexWhere((e) => e.id == id);
      if (index != -1) {
        expenses[index] = updatedExpense;
        await _saveExpenses();
        Get.snackbar(
          'Success',
          'Expense updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update expense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      expenses.removeWhere((e) => e.id == id);
      await _saveExpenses();
      Get.snackbar(
        'Success',
        'Expense deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete expense: $e');
    }
  }

  Future<void> addBudget(Budget budget) async {
    try {
      // Remove existing budget for same category if exists
      budgets.removeWhere((b) => b.category == budget.category);
      budgets.add(budget);
      await _saveBudgets();
      Get.back();
      Get.snackbar(
        'Success',
        'Budget set successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to set budget: $e');
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      budgets.removeWhere((b) => b.id == id);
      await _saveBudgets();
      Get.snackbar(
        'Success',
        'Budget deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete budget: $e');
    }
  }

  Future<void> _saveExpenses() async {
    final expensesList = expenses.map((e) => e.toJson()).toList();
    await _storage.saveExpenses(expensesList);
  }

  Future<void> _saveBudgets() async {
    final budgetsList = budgets.map((b) => b.toJson()).toList();
    await _storage.saveBudgets(budgetsList);
  }

  void _checkBudgetAlert(Expense expense) {
    final activeBudget = budgets.firstWhereOrNull(
      (b) => b.category == expense.category && b.isActive(),
    );

    if (activeBudget != null) {
      final spent = getTotalByCategory(expense.category, activeBudget.currency);
      final percentage = (spent / activeBudget.limit) * 100;

      if (percentage >= 90) {
        Get.snackbar(
          '⚠️ Budget Alert',
          'You have spent ${percentage.toStringAsFixed(0)}% of your ${expense.category.displayName} budget!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        );
      }
    }
  }

  // Analytics Methods
  double getTotalExpenses({String? currency}) {
    final targetCurrency = currency ?? selectedCurrency.value;
    double total = 0;

    for (final expense in expenses) {
      final convertedAmount = _convertAmount(
        expense.amount,
        expense.currency,
        targetCurrency,
      );
      total += convertedAmount;
    }

    return total;
  }

  double getTotalByCategory(ExpenseCategory category, String? currency) {
    final targetCurrency = currency ?? selectedCurrency.value;
    double total = 0;

    for (final expense in expenses.where((e) => e.category == category)) {
      final convertedAmount = _convertAmount(
        expense.amount,
        expense.currency,
        targetCurrency,
      );
      total += convertedAmount;
    }

    return total;
  }

  Map<ExpenseCategory, double> getCategoryBreakdown({String? currency}) {
    final targetCurrency = currency ?? selectedCurrency.value;
    final breakdown = <ExpenseCategory, double>{};

    for (final category in ExpenseCategory.values) {
      breakdown[category] = getTotalByCategory(category, targetCurrency);
    }

    return breakdown;
  }

  List<Expense> getExpensesByCategory(ExpenseCategory category) {
    return expenses.where((e) => e.category == category).toList();
  }

  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return expenses
        .where(
          (e) =>
              e.date.isAfter(start.subtract(const Duration(days: 1))) &&
              e.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  double getAverageExpense({String? currency}) {
    if (expenses.isEmpty) return 0;
    return getTotalExpenses(currency: currency) / expenses.length;
  }

  ExpenseCategory? getTopCategory() {
    final breakdown = getCategoryBreakdown();
    if (breakdown.isEmpty) return null;

    return breakdown.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double _convertAmount(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    try {
      // Use the currency controller's rates if available
      final currencyController = Get.find<CurrencyController>();
      final rates = currencyController.exchangeRates.value?.rates;
      if (rates == null) return amount;

      // Convert to base currency (USD) first
      final toBase = amount / (rates[fromCurrency] ?? 1);
      // Then convert to target currency
      final converted = toBase * (rates[toCurrency] ?? 1);

      return converted;
    } catch (e) {
      return amount;
    }
  }

  Budget? getBudgetForCategory(ExpenseCategory category) {
    return budgets.firstWhereOrNull(
      (b) => b.category == category && b.isActive(),
    );
  }

  double getBudgetProgress(ExpenseCategory category) {
    final budget = getBudgetForCategory(category);
    if (budget == null) return 0;

    final spent = getTotalByCategory(category, budget.currency);
    return (spent / budget.limit).clamp(0.0, 1.0);
  }

  Future<void> clearAllExpenses() async {
    try {
      expenses.clear();
      await _storage.clearExpenses();
      Get.snackbar(
        'Success',
        'All expenses cleared',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear expenses: $e');
    }
  }

  void filterByCategory(ExpenseCategory? category) {
    selectedCategory.value = category;
  }

  List<Expense> get filteredExpenses {
    if (selectedCategory.value == null) {
      return expenses;
    }
    return expenses.where((e) => e.category == selectedCategory.value).toList();
  }
}
