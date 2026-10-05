import 'package:flutter/material.dart';
import '../../models/test_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../app/routes.dart';

class TestResultScreen extends StatelessWidget {
  final TestResultModel result;

  const TestResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Test Scorecard',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryOrange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'OFFICIAL OMR EVALUATION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${result.score.toStringAsFixed(1)} / ${result.totalMarks}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    result.score >= (result.totalMarks * 0.45)
                        ? 'Estimated Rank: Top 8% of all India candidates'
                        : 'Score below cutoff: Needs focused subject revision',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildResultTile(
                    'Accuracy',
                    '${result.accuracy.toInt()}%',
                    Icons.speed,
                    AppColors.info,
                    theme,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildResultTile(
                    'Time Taken',
                    result.timeTaken,
                    Icons.timer_outlined,
                    Colors.amber,
                    theme,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildResultTile(
                    'Correct Answers',
                    '${result.correctCount}',
                    Icons.check_circle_outline,
                    AppColors.success,
                    theme,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildResultTile(
                    'Wrong (Negative)',
                    '${result.wrongCount}',
                    Icons.cancel_outlined,
                    AppColors.error,
                    theme,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildResultTile(
                    'Unattempted',
                    '${result.unattemptedCount}',
                    Icons.radio_button_unchecked,
                    Colors.grey,
                    theme,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Detailed Analysis CTA
            PrimaryButton(
              text: 'View Detailed Test Analysis',
              icon: Icons.analytics_outlined,
              backgroundColor: AppColors.secondaryOrange,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.testAnalysis,
                  arguments: result,
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Return to Tests Screen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTile(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
