class Expense {
  final String id;
  final String title;
  final double amount;
  final String currency;
  final ExpenseCategory category;
  final DateTime date;
  final String? notes;
  final String? receipt; // Image path

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.category,
    required this.date,
    this.notes,
    this.receipt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'currency': currency,
      'category': category.name,
      'date': date.toIso8601String(),
      'notes': notes,
      'receipt': receipt,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.other,
      ),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      receipt: json['receipt'] as String?,
    );
  }

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? currency,
    ExpenseCategory? category,
    DateTime? date,
    String? notes,
    String? receipt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      receipt: receipt ?? this.receipt,
    );
  }
}

enum ExpenseCategory {
  food,
  transport,
  shopping,
  entertainment,
  bills,
  health,
  education,
  travel,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food & Dining';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.bills:
        return 'Bills & Utilities';
      case ExpenseCategory.health:
        return 'Health & Fitness';
      case ExpenseCategory.education:
        return 'Education';
      case ExpenseCategory.travel:
        return 'Travel';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case ExpenseCategory.food:
        return '🍔';
      case ExpenseCategory.transport:
        return '🚗';
      case ExpenseCategory.shopping:
        return '🛍️';
      case ExpenseCategory.entertainment:
        return '🎬';
      case ExpenseCategory.bills:
        return '💡';
      case ExpenseCategory.health:
        return '💊';
      case ExpenseCategory.education:
        return '📚';
      case ExpenseCategory.travel:
        return '✈️';
      case ExpenseCategory.other:
        return '📌';
    }
  }

  int get colorValue {
    switch (this) {
      case ExpenseCategory.food:
        return 0xFFFF6B6B;
      case ExpenseCategory.transport:
        return 0xFF4ECDC4;
      case ExpenseCategory.shopping:
        return 0xFFFFBE0B;
      case ExpenseCategory.entertainment:
        return 0xFFFF006E;
      case ExpenseCategory.bills:
        return 0xFF8338EC;
      case ExpenseCategory.health:
        return 0xFF3A86FF;
      case ExpenseCategory.education:
        return 0xFFFB5607;
      case ExpenseCategory.travel:
        return 0xFF06FFA5;
      case ExpenseCategory.other:
        return 0xFF9E9E9E;
    }
  }
}

class Budget {
  final String id;
  final ExpenseCategory category;
  final double limit;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.currency,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'limit': limit,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.other,
      ),
      limit: (json['limit'] as num).toDouble(),
      currency: json['currency'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  bool isActive() {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
}
