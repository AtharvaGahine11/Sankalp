import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/subscription_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../app/routes.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> checkoutData;

  const CheckoutScreen({super.key, required this.checkoutData});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final itemName = widget.checkoutData['itemName'] ?? 'Sankalp Preparation Plan';
    final itemType = widget.checkoutData['itemType'] ?? 'course';
    final int price = widget.checkoutData['price'] ?? 2499;
    final int originalPrice = widget.checkoutData['originalPrice'] ?? (price * 1.5).toInt();
    final int discount = originalPrice - price;
    final int gst = (price * 0.18).toInt();
    final int totalPayable = price + gst;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Order Checkout',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.receipt_long, color: AppColors.secondaryOrange, size: 20),
                      SizedBox(width: 8),
                      Text('Selected Item Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    itemName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Full syllabus access, mock tests, and live doubt clearance included.',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Price Breakdown Table
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _buildPriceRow('List Price', AppHelpers.formatCurrency(originalPrice), theme),
                  const SizedBox(height: 8),
                  _buildPriceRow('Aspirant Discount', '- ${AppHelpers.formatCurrency(discount)}', theme, isDiscount: true),
                  const SizedBox(height: 8),
                  _buildPriceRow('Standard Price', AppHelpers.formatCurrency(price), theme),
                  const SizedBox(height: 8),
                  _buildPriceRow('GST (18% Govt Mandate)', AppHelpers.formatCurrency(gst), theme),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Payable Amount',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        AppHelpers.formatCurrency(totalPayable),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods
            const Text(
              'Select Payment Method (Mock Flow)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPaymentOption('UPI', 'Google Pay, PhonePe, Paytm, BHIM UPI', Icons.account_balance_wallet_outlined),
            _buildPaymentOption('Card', 'Credit & Debit Cards (Visa, Mastercard, RuPay)', Icons.credit_card),
            _buildPaymentOption('Net Banking', 'All Major Indian Public & Private Banks', Icons.account_balance),
            const SizedBox(height: 28),

            // Pay Button
            PrimaryButton(
              text: 'Pay ${AppHelpers.formatCurrency(totalPayable)}',
              icon: Icons.lock,
              isLoading: _isProcessing,
              backgroundColor: AppColors.secondaryOrange,
              onPressed: () async {
                final navigator = Navigator.of(context);
                setState(() => _isProcessing = true);
                await Future.delayed(const Duration(milliseconds: 1000));

                final orderId = 'ORD-2026-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}';
                final order = OrderModel(
                  orderId: orderId,
                  itemName: itemName,
                  itemType: itemType,
                  amount: price,
                  discount: discount,
                  gst: gst,
                  totalAmount: totalPayable,
                  paymentMethod: _selectedPaymentMethod,
                  orderDate: DateTime.now(),
                );

                appState.recordOrder(order);

                if (!mounted) return;
                setState(() => _isProcessing = false);

                navigator.pushReplacementNamed(
                  AppRoutes.paymentSuccess,
                  arguments: order,
                );
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Academic Simulation • No Real Transactions Occur',
                style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, ThemeData theme, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.success : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String id, String subtitle, IconData icon) {
    final isSelected = _selectedPaymentMethod == id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.secondaryOrange
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isSelected ? 1.8 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: id,
        groupValue: _selectedPaymentMethod,
        onChanged: (val) {
          if (val != null) setState(() => _selectedPaymentMethod = val);
        },
        title: Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        secondary: Icon(icon, color: isSelected ? AppColors.secondaryOrange : Colors.grey),
      ),
    );
  }
}
