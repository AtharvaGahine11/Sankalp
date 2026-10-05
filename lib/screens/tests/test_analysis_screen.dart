import 'package:flutter/material.dart';
import '../../models/test_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/difficulty_badge.dart';

class TestAnalysisScreen extends StatelessWidget {
  final dynamic testOrResult;

  const TestAnalysisScreen({super.key, required this.testOrResult});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Support both TestResultModel and TestModel for analysis view
    TestResultModel res;
    if (testOrResult is TestResultModel) {
      res = testOrResult as TestResultModel;
    } else {
      final t = testOrResult as TestModel;
      res = TestResultModel(
        testId: t.id,
        testTitle: t.title,
        totalQuestions: t.questions.length,
        totalMarks: t.totalMarks,
        score: t.previousScore ?? 76.0,
        accuracy: 82.0,
        correctCount: 7,
        wrongCount: 2,
        unattemptedCount: 1,
        timeTaken: '14m 12s',
        userAnswers: {0: 1, 1: 2, 2: 1, 3: 1, 4: 3, 5: 1, 6: 2, 7: 1, 8: 1, 9: 0},
        reviewStatus: {},
        subjectPerformance: const [
          SubjectPerformance(subject: 'Indian Polity', totalQuestions: 3, correct: 3, wrong: 0, percentage: 82.0),
          SubjectPerformance(subject: 'Modern History', totalQuestions: 2, correct: 2, wrong: 0, percentage: 74.0),
          SubjectPerformance(subject: 'Physical Geography', totalQuestions: 2, correct: 1, wrong: 1, percentage: 68.0),
          SubjectPerformance(subject: 'Indian Economy', totalQuestions: 2, correct: 2, wrong: 0, percentage: 79.0),
          SubjectPerformance(subject: 'Environment & Ecology', totalQuestions: 1, correct: 1, wrong: 0, percentage: 88.0),
        ],
        questions: t.questions,
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Diagnostic Test Analysis',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              res.testTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            // Performance Overview Card
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Final Score', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            '${res.score} / ${res.totalMarks}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Overall Accuracy', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            '${res.accuracy.toInt()}%',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.success),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: res.score / res.totalMarks,
                      minHeight: 8,
                      backgroundColor: Colors.black12,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryOrange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Subject-Wise Performance Breakdown
            const Text(
              'Subject-Wise Performance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...res.subjectPerformance.map((subj) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subj.subject,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '${subj.percentage.toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: subj.percentage >= 75 ? AppColors.success : AppColors.secondaryOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${subj.correct} correct of ${subj.totalQuestions} questions',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: subj.percentage / 100,
                        minHeight: 5,
                        backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          subj.percentage >= 75 ? AppColors.success : AppColors.secondaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Question-Wise Diagnostic Feedback
            const Text(
              'Question-Wise Diagnostic Feedback',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(res.questions.length, (idx) {
              final q = res.questions[idx];
              final userAns = res.userAnswers[idx];
              final isCorrect = userAns == q.correctOptionIndex;
              final isUnattempted = userAns == null;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Q${idx + 1}. ',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              DifficultyBadge(difficulty: q.difficulty),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? AppColors.success.withOpacity(0.12)
                                  : (isUnattempted ? Colors.grey.withOpacity(0.12) : AppColors.error.withOpacity(0.12)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isCorrect ? 'CORRECT (+2.0)' : (isUnattempted ? 'SKIPPED (0.0)' : 'WRONG (-0.66)'),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isCorrect ? AppColors.success : (isUnattempted ? Colors.grey : AppColors.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(q.questionText, style: const TextStyle(fontSize: 13, height: 1.4)),
                      const SizedBox(height: 10),
                      Text(
                        'Your Answer: ${userAns != null ? "(${String.fromCharCode(65 + userAns)}) ${q.options[userAns]}" : "None (Unattempted)"}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isCorrect ? AppColors.success : (isUnattempted ? Colors.grey : AppColors.error),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Correct Answer: (${String.fromCharCode(65 + q.correctOptionIndex)}) ${q.options[q.correctOptionIndex]}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Explanation: ${q.explanation}',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
