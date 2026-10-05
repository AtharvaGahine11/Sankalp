import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/test_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../app/routes.dart';

class TestAttemptScreen extends StatefulWidget {
  final TestModel test;

  const TestAttemptScreen({super.key, required this.test});

  @override
  State<TestAttemptScreen> createState() => _TestAttemptScreenState();
}

class _TestAttemptScreenState extends State<TestAttemptScreen> {
  int _currentIndex = 0;
  final Map<int, int?> _userAnswers = {}; // questionIndex -> selectedOptionIndex
  final Map<int, bool> _reviewStatus = {}; // questionIndex -> isMarkedForReview
  final Set<int> _visited = {};

  late int _secondsRemaining;
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.test.durationMinutes * 60;
    _visited.add(0);
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
        _submitTest();
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

  QuestionStatus _getQuestionStatus(int index) {
    final isMarked = _reviewStatus[index] == true;
    final isAnswered = _userAnswers[index] != null;
    final isVisited = _visited.contains(index);

    if (isMarked) return QuestionStatus.markedForReview;
    if (isAnswered) return QuestionStatus.answered;
    if (isVisited) return QuestionStatus.visited;
    return QuestionStatus.notVisited;
  }

  Color _getStatusColor(QuestionStatus status) {
    switch (status) {
      case QuestionStatus.answered:
        return AppColors.success;
      case QuestionStatus.markedForReview:
        return AppColors.warning;
      case QuestionStatus.visited:
        return AppColors.error;
      case QuestionStatus.notVisited:
        return Colors.grey.shade400;
    }
  }

  void _submitTest() {
    _timer?.cancel();

    int correct = 0;
    int wrong = 0;
    int unattempted = 0;

    for (int i = 0; i < widget.test.questions.length; i++) {
      final selected = _userAnswers[i];
      if (selected == null) {
        unattempted++;
      } else if (selected == widget.test.questions[i].correctOptionIndex) {
        correct++;
      } else {
        wrong++;
      }
    }

    // Score calculation with UPSC negative marking
    final rawScore = (correct * widget.test.positiveMarks) - (wrong * widget.test.negativeMarks);
    final score = rawScore < 0 ? 0.0 : rawScore;
    final accuracy = (correct + wrong) == 0 ? 0.0 : (correct / (correct + wrong) * 100);
    final timeStr = '${_elapsedSeconds ~/ 60}m ${_elapsedSeconds % 60}s';

    // Subject breakdown
    final subjectMap = <String, List<bool>>{};
    for (int i = 0; i < widget.test.questions.length; i++) {
      final q = widget.test.questions[i];
      final isRight = _userAnswers[i] == q.correctOptionIndex;
      subjectMap.putIfAbsent(q.subject, () => []).add(isRight);
    }

    final subjectPerformance = subjectMap.entries.map((e) {
      final correctInSubj = e.value.where((v) => v).length;
      final totalInSubj = e.value.length;
      final pct = totalInSubj == 0 ? 0.0 : (correctInSubj / totalInSubj * 100);
      return SubjectPerformance(
        subject: e.key,
        totalQuestions: totalInSubj,
        correct: correctInSubj,
        wrong: totalInSubj - correctInSubj,
        percentage: pct,
      );
    }).toList();

    final result = TestResultModel(
      testId: widget.test.id,
      testTitle: widget.test.title,
      totalQuestions: widget.test.questions.length,
      totalMarks: widget.test.totalMarks,
      score: double.parse(score.toStringAsFixed(1)),
      accuracy: double.parse(accuracy.toStringAsFixed(1)),
      correctCount: correct,
      wrongCount: wrong,
      unattemptedCount: unattempted,
      timeTaken: timeStr,
      userAnswers: _userAnswers,
      reviewStatus: _reviewStatus,
      subjectPerformance: subjectPerformance,
      questions: widget.test.questions,
    );

    Provider.of<AppStateProvider>(context, listen: false).saveTestResult(result);

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.testResult,
      arguments: result,
    );
  }

  void _showConfirmSubmitDialog() {
    int answeredCount = _userAnswers.values.where((v) => v != null).length;
    int markedCount = _reviewStatus.values.where((v) => v == true).length;
    int unattemptedCount = widget.test.questions.length - answeredCount;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Test Submission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Answered: $answeredCount'),
            Text('• Marked for Review: $markedCount'),
            Text('• Unattempted: $unattemptedCount'),
            const SizedBox(height: 12),
            const Text(
              'Are you sure you want to end this examination? Once submitted, answers cannot be edited.',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Back to Test'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              _submitTest();
            },
            child: const Text('Submit & Evaluate'),
          ),
        ],
      ),
    );
  }

  void _showQuestionPaletteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Question Palette & OMR Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              // Legend
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildLegendItem('Answered', AppColors.success),
                  _buildLegendItem('Marked for Review', AppColors.warning),
                  _buildLegendItem('Visited', AppColors.error),
                  _buildLegendItem('Not Visited', Colors.grey.shade400),
                ],
              ),
              const Divider(height: 24),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: widget.test.questions.length,
                  itemBuilder: (context, index) {
                    final status = _getQuestionStatus(index);
                    final color = _getStatusColor(status);
                    final isCurrent = index == _currentIndex;

                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                          _visited.add(index);
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrent ? AppColors.primary : color,
                            width: isCurrent ? 2 : 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentQ = widget.test.questions[_currentIndex];
    final selectedOption = _userAnswers[_currentIndex];
    final isMarked = _reviewStatus[_currentIndex] == true;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mock Examination',
        actions: [
          // Timer
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _secondsRemaining < 300
                  ? AppColors.error.withOpacity(0.15)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 15,
                  color: _secondsRemaining < 300 ? AppColors.error : AppColors.secondaryOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimer(_secondsRemaining),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _secondsRemaining < 300 ? AppColors.error : (isDark ? Colors.white : AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          // Question Palette icon
          IconButton(
            icon: const Icon(Icons.grid_view),
            tooltip: 'Question Palette',
            onPressed: _showQuestionPaletteSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top status bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Question ${_currentIndex + 1} of ${widget.test.questions.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '+${widget.test.positiveMarks} / -${widget.test.negativeMarks}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Question Subject / Difficulty
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${currentQ.subject} • ${currentQ.topic} • ${currentQ.difficulty}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Question Text & Options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentQ.questionText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),

                      ...List.generate(currentQ.options.length, (optIdx) {
                        final isSelected = selectedOption == optIdx;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                _userAnswers[_currentIndex] = optIdx;
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

              // Action Toolbar: Mark for review & Clear response
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _reviewStatus[_currentIndex] = !isMarked;
                      });
                    },
                    icon: Icon(
                      isMarked ? Icons.bookmark : Icons.bookmark_border,
                      size: 16,
                      color: isMarked ? AppColors.warning : null,
                    ),
                    label: Text(
                      isMarked ? 'Marked for Review' : 'Mark for Review',
                      style: TextStyle(color: isMarked ? AppColors.warning : null),
                    ),
                  ),
                  if (selectedOption != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _userAnswers.remove(_currentIndex);
                        });
                      },
                      child: const Text('Clear Response'),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Bottom Navigation Controls
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _currentIndex > 0
                        ? () {
                            setState(() {
                              _currentIndex--;
                              _visited.add(_currentIndex);
                            });
                          }
                        : null,
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < widget.test.questions.length - 1) {
                          setState(() {
                            _currentIndex++;
                            _visited.add(_currentIndex);
                          });
                        } else {
                          _showConfirmSubmitDialog();
                        }
                      },
                      child: Text(
                        _currentIndex < widget.test.questions.length - 1
                            ? 'Save & Next'
                            : 'Submit Test',
                      ),
                    ),
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
