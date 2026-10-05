import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/quiz_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../app/routes.dart';

class CurrentAffairsQuizScreen extends StatefulWidget {
  final QuizModel quiz;

  const CurrentAffairsQuizScreen({super.key, required this.quiz});

  @override
  State<CurrentAffairsQuizScreen> createState() => _CurrentAffairsQuizScreenState();
}

class _CurrentAffairsQuizScreenState extends State<CurrentAffairsQuizScreen> {
  int _currentIndex = 0;
  final Map<int, int?> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex
  late int _secondsRemaining;
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.quiz.durationMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          _elapsedSeconds++;
        });
      } else {
        _timer?.cancel();
        _submitQuiz();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _submitQuiz() {
    _timer?.cancel();

    int correct = 0;
    int wrong = 0;
    int unattempted = 0;

    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final selected = _selectedAnswers[i];
      if (selected == null) {
        unattempted++;
      } else if (selected == widget.quiz.questions[i].correctOptionIndex) {
        correct++;
      } else {
        wrong++;
      }
    }

    final total = widget.quiz.questions.length;
    final accuracy = (correct + wrong) == 0 ? 0.0 : (correct / (correct + wrong) * 100);
    final score = correct.toDouble();
    final timeStr = '${_elapsedSeconds ~/ 60}m ${_elapsedSeconds % 60}s';

    final result = QuizResultModel(
      quizId: widget.quiz.id,
      quizTitle: widget.quiz.title,
      totalQuestions: total,
      correctCount: correct,
      wrongCount: wrong,
      unattemptedCount: unattempted,
      score: score,
      accuracy: accuracy,
      timeTaken: timeStr,
      selectedAnswers: _selectedAnswers,
      questions: widget.quiz.questions,
    );

    Provider.of<AppStateProvider>(context, listen: false).saveQuizResult(result);

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.quizResult,
      arguments: result,
    );
  }

  void _confirmSubmit() {
    final unattempted = widget.quiz.questions.length - _selectedAnswers.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: Text(
          unattempted > 0
              ? 'You have $unattempted unattempted question(s). Are you sure you want to finish and submit?'
              : 'You have answered all questions. Ready to view your performance?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Review Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _submitQuiz();
            },
            child: const Text('Submit Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentQ = widget.quiz.questions[_currentIndex];
    final selectedOption = _selectedAnswers[_currentIndex];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Daily Quiz',
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _secondsRemaining < 120
                  ? AppColors.error.withOpacity(0.15)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: _secondsRemaining < 120 ? AppColors.error : AppColors.secondaryOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimer(_secondsRemaining),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _secondsRemaining < 120 ? AppColors.error : (isDark ? Colors.white : AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _confirmSubmit,
            child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar & Question Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${widget.quiz.totalQuestions}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'Attempted: ${_selectedAnswers.length}/${widget.quiz.totalQuestions}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / widget.quiz.totalQuestions,
                  minHeight: 6,
                  backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryOrange),
                ),
              ),
              const SizedBox(height: 20),

              // Question Text Card
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${currentQ.subject} • ${currentQ.difficulty}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentQ.questionText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Options
                      ...List.generate(currentQ.options.length, (optIdx) {
                        final isSelected = selectedOption == optIdx;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                _selectedAnswers[_currentIndex] = optIdx;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark ? AppColors.secondaryOrange.withOpacity(0.15) : AppColors.primary.withOpacity(0.08))
                                    : (isDark ? AppColors.surfaceDark : Colors.white),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? (isDark ? AppColors.secondaryOrange : AppColors.primary)
                                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                  width: isSelected ? 1.8 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (isDark ? AppColors.secondaryOrange : AppColors.primary)
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      String.fromCharCode(65 + optIdx),
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      currentQ.options[optIdx],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: _currentIndex > 0
                        ? () => setState(() => _currentIndex--)
                        : null,
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Previous'),
                  ),
                  if (_currentIndex < widget.quiz.totalQuestions - 1)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _currentIndex++),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Next Question'),
                    )
                  else
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryOrange,
                      ),
                      onPressed: _confirmSubmit,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Submit Quiz'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
