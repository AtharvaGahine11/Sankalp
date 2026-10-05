import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';

class QuizResultScreen extends StatefulWidget {
  final QuizResultModel result;

  const QuizResultScreen({super.key, required this.result});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool _showReview = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final res = widget.result;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Quiz Performance Summary',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score Banner
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
                  const Text(
                    'QUIZ SCORE',
                    style: TextStyle(
                      color: AppColors.secondaryOrange,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${res.correctCount} / ${res.totalQuestions}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    res.accuracy >= 70
                        ? 'Excellent conceptual grasp!'
                        : 'Good effort, revise key takeaways.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Performance Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Accuracy',
                    '${res.accuracy.toInt()}%',
                    Icons.track_changes,
                    AppColors.info,
                    theme,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    'Time Taken',
                    res.timeTaken,
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
                  child: _buildMetricTile(
                    'Correct',
                    '${res.correctCount}',
                    Icons.check_circle_outline,
                    AppColors.success,
                    theme,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    'Wrong',
                    '${res.wrongCount}',
                    Icons.cancel_outlined,
                    AppColors.error,
                    theme,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Review Answers Toggle Button
            PrimaryButton(
              text: _showReview ? 'Hide Detailed Explanations' : 'Review Answers with Explanations',
              icon: _showReview ? Icons.visibility_off : Icons.visibility,
              backgroundColor: _showReview ? AppColors.primaryLight : AppColors.secondaryOrange,
              onPressed: () {
                setState(() {
                  _showReview = !_showReview;
                });
              },
            ),
            const SizedBox(height: 12),

            // Finish Button
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Back to Dashboard'),
            ),

            // REVIEW SECTION
            if (_showReview) ...[
              const SizedBox(height: 28),
              Row(
                children: [
                  const Icon(Icons.menu_book, size: 20, color: AppColors.secondaryOrange),
                  const SizedBox(width: 8),
                  Text(
                    'Question-Wise Review & Solutions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...List.generate(res.questions.length, (index) {
                final q = res.questions[index];
                final userSelected = res.selectedAnswers[index];
                final isCorrect = userSelected == q.correctOptionIndex;
                final isUnattempted = userSelected == null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isCorrect
                          ? AppColors.success.withOpacity(0.5)
                          : (isUnattempted ? Colors.grey.withOpacity(0.3) : AppColors.error.withOpacity(0.5)),
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? AppColors.success.withOpacity(0.15)
                                    : (isUnattempted ? Colors.grey.withOpacity(0.15) : AppColors.error.withOpacity(0.15)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isCorrect
                                    ? 'CORRECT'
                                    : (isUnattempted ? 'UNATTEMPTED' : 'INCORRECT'),
                                style: TextStyle(
                                  color: isCorrect
                                      ? AppColors.success
                                      : (isUnattempted ? Colors.grey : AppColors.error),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          q.questionText,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 12),

                        // Options list
                        ...List.generate(q.options.length, (optIdx) {
                          final isRightAnswer = optIdx == q.correctOptionIndex;
                          final isChosen = optIdx == userSelected;

                          Color optColor = Colors.transparent;
                          Color textCol = theme.textTheme.bodyMedium?.color ?? Colors.black;

                          if (isRightAnswer) {
                            optColor = AppColors.success.withOpacity(0.12);
                            textCol = AppColors.success;
                          } else if (isChosen && !isRightAnswer) {
                            optColor = AppColors.error.withOpacity(0.12);
                            textCol = AppColors.error;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: optColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '(${String.fromCharCode(65 + optIdx)}) ',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: textCol, fontSize: 12),
                                ),
                                Expanded(
                                  child: Text(
                                    q.options[optIdx],
                                    style: TextStyle(color: textCol, fontSize: 13),
                                  ),
                                ),
                                if (isRightAnswer)
                                  const Icon(Icons.check, color: AppColors.success, size: 16),
                                if (isChosen && !isRightAnswer)
                                  const Icon(Icons.close, color: AppColors.error, size: 16),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Explanation:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                q.explanation,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
