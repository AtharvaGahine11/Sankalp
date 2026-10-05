import 'package:flutter/material.dart';
import '../../models/subscription_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/primary_button.dart';
import '../../app/routes.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final OrderModel order;

  const PaymentSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Badge Animation Placeholder
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.success, width: 2),
                  ),
                  child: const Icon(Icons.check_circle, size: 64, color: AppColors.success),
                ),
                const SizedBox(height: 20),
                Text(
                  'Payment Successful!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your UPSC learning plan is now active.',
                  style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 28),

                // Order Receipt Details Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      _buildReceiptRow('Order ID', order.orderId, isMono: true),
                      const Divider(height: 18),
                      _buildReceiptRow('Purchased Item', order.itemName),
                      const Divider(height: 18),
                      _buildReceiptRow('Amount Paid', AppHelpers.formatCurrency(order.totalAmount)),
                      const Divider(height: 18),
                      _buildReceiptRow('Payment Method', order.paymentMethod),
                      const Divider(height: 18),
                      _buildReceiptRow('Status', 'Active & Unlocked', isSuccess: true),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                PrimaryButton(
                  text: 'Explore Unlocked Courses',
                  icon: Icons.school,
                  backgroundColor: AppColors.secondaryOrange,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  child: const Text('Return to Home Dashboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isMono = false, bool isSuccess = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: isMono ? 'monospace' : null,
            color: isSuccess ? AppColors.success : null,
          ),
        ),
      ],
    );
  }
}
