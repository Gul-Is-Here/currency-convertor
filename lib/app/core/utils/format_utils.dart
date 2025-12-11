import 'package:intl/intl.dart';

class FormatUtils {
  // Format currency amount
  static String formatCurrency(
    double amount,
    String currencyCode, {
    int decimals = 2,
  }) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimals,
    );
    return formatter.format(amount).trim();
  }

  // Format amount without currency symbol
  static String formatAmount(double amount, {int decimals = 2}) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimals,
    );
    return formatter.format(amount).trim();
  }

  // Format large numbers with K, M, B suffixes
  static String formatCompact(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }

  // Format percentage
  static String formatPercentage(double percentage, {int decimals = 2}) {
    return '${percentage.toStringAsFixed(decimals)}%';
  }

  // Format date
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  // Format time ago
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Parse double from string
  static double parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  // Format rate change with sign
  static String formatRateChange(double change, {int decimals = 2}) {
    final formatted = change.toStringAsFixed(decimals);
    return change >= 0 ? '+$formatted' : formatted;
  }
}
