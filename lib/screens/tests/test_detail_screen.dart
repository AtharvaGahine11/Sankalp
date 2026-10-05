import 'package:flutter/material.dart';
import '../../models/test_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/difficulty_badge.dart';
import '../../app/routes.dart';

class TestDetailScreen extends StatelessWidget {
  final TestModel test;

  const TestDetailScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Test Overview & Rules',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    test.category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                    ),
                  ),
                ),
                DifficultyBadge(difficulty: test.difficulty),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              test.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            // Examination Parameters
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildParam(Icons.help_outline, '${test.totalQuestions}', 'Questions', theme),
                      Container(width: 1, height: 40, color: theme.dividerTheme.color),
                      _buildParam(Icons.timer_outlined, '${test.durationMinutes}m', 'Duration', theme),
                      Container(width: 1, height: 40, color: theme.dividerTheme.color),
                      _buildParam(Icons.grade_outlined, '${test.totalMarks}', 'Total Marks', theme),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.add_circle_outline, color: AppColors.success, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '+${test.positiveMarks} Marks for Correct',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '-${test.negativeMarks} Negative Marking',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Examination Guidelines
            const Text(
              'Important Exam Instructions',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInstructionItem('1. The test consists of multiple-choice questions matching standard UPSC CSE pattern.'),
            _buildInstructionItem('2. Use the question palette to jump between questions or mark tricky items for later review.'),
            _buildInstructionItem('3. There is negative marking of 0.66 marks for every wrong answer, identical to UPSC Prelims.'),
            _buildInstructionItem('4. The test timer will start immediately once you click "Start Test Now". Do not switch apps.'),
            _buildInstructionItem('5. You can submit at any time, or the test will auto-submit when the countdown concludes.'),
            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Start Test Now',
              icon: Icons.play_arrow,
              backgroundColor: AppColors.secondaryOrange,
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.testAttempt,
                  arguments: test,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParam(IconData icon, String val, String label, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.secondaryOrange),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, height: 1.45),
      ),
    );
  }
}
