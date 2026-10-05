import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class AppHelpers {
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String formatCurrency(num amount) {
    return _currencyFormatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMMM y').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  static Color getDifficultyColor(String difficulty, {bool isDark = false}) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return isDark ? Colors.amberAccent : AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    Color bg = colorScheme.surfaceVariant;
    Color textCol = colorScheme.onSurfaceVariant;
    IconData icon = Icons.info_outline;

    if (isError) {
      bg = AppColors.error;
      textCol = Colors.white;
      icon = Icons.error_outline;
    } else if (isSuccess) {
      bg = AppColors.success;
      textCol = Colors.white;
      icon = Icons.check_circle_outline;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textCol, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textCol, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: duration,
      ),
    );
  }

  static void showComingSoonDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.stars, color: AppColors.secondaryOrange),
            const SizedBox(width: 8),
            Text(featureName),
          ],
        ),
        content: const Text(
          'This feature is fully simulated with mock data for your B.Tech CSE Semester V evaluation. Additional live cloud APIs will be available in future releases.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }
}
