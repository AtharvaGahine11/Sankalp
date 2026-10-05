import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../utils/constants.dart';
import 'difficulty_badge.dart';

class TestCard extends StatelessWidget {
  final TestModel test;
  final VoidCallback onStartTest;
  final VoidCallback? onViewAnalysis;

  const TestCard({
    super.key,
    required this.test,
    required this.onStartTest,
    this.onViewAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: test.isCompleted
              ? AppColors.success.withOpacity(0.4)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.12),
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
          const SizedBox(height: 10),
          Text(
            test.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMetaItem(Icons.help_outline, '${test.totalQuestions} Questions', theme),
              const SizedBox(width: 14),
              _buildMetaItem(Icons.timer_outlined, '${test.durationMinutes} Mins', theme),
              const SizedBox(width: 14),
              _buildMetaItem(Icons.people_outline, '${test.attemptsCount} attempts', theme),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    test.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 16,
                    color: test.isCompleted ? AppColors.success : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    test.isCompleted
                        ? 'Completed (Score: ${test.previousScore?.toInt() ?? 76}/100)'
                        : 'Not Attempted',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: test.isCompleted ? AppColors.success : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: test.isCompleted && onViewAnalysis != null ? onViewAnalysis : onStartTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: test.isCompleted ? AppColors.success : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  test.isCompleted ? 'View Analysis' : 'Start Test',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
