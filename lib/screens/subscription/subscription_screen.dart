import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../app/routes.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Subscription Plans & Pricing',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SANKALP ACADEMY PASS',
                    style: TextStyle(
                      color: AppColors.secondaryOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Invest in Your Civil Services Dream',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Clear, transparent pricing designed strictly according to university case study specifications.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Select Your Preparation Plan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Plan Cards
            ...MockData.subscriptionPlans.map((plan) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: plan.isBestValue
                        ? AppColors.secondaryOrange
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: plan.isBestValue ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: plan.isBestValue
                          ? AppColors.secondaryOrange.withOpacity(0.12)
                          : Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge if Best Value
                    if (plan.isBestValue)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: const BoxDecoration(
                          gradient: AppColors.plusBadgeGradient,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '★ BEST VALUE FOR UPSC CSE 2027 ★',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                plan.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  plan.tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                AppHelpers.formatCurrency(plan.price),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppHelpers.formatCurrency(plan.originalPrice),
                                style: const TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '/ ${plan.billingPeriod}',
                                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),

                          ...plan.features.map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check, color: AppColors.success, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        f,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 18),

                          PrimaryButton(
                            text: 'Select & Proceed to Checkout',
                            icon: Icons.arrow_forward,
                            backgroundColor: plan.isBestValue
                                ? AppColors.secondaryOrange
                                : (isDark ? AppColors.primaryLight : AppColors.primary),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.checkout,
                                arguments: {
                                  'itemName': plan.name,
                                  'itemType': plan.id == 'plan_plus' ? 'plus_subscription' : 'test_series',
                                  'price': plan.price,
                                  'originalPrice': plan.originalPrice,
                                },
                              );
                            },
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
      ),
    );
  }
}
