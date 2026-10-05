import 'question_model.dart';

enum QuestionStatus { notVisited, visited, answered, markedForReview }

class SubjectPerformance {
  final String subject;
  final int totalQuestions;
  final int correct;
  final int wrong;
  final double percentage;

  const SubjectPerformance({
    required this.subject,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.percentage,
  });
}

class TestModel {
  final String id;
  final String title;
  final String category;
  final int totalQuestions;
  final int durationMinutes;
  final String difficulty;
  final int totalMarks;
  final double positiveMarks;
  final double negativeMarks;
  final String attemptsCount;
  final bool isCompleted;
  final double? previousScore;
  final List<QuestionModel> questions;

  const TestModel({
    required this.id,
    required this.title,
    required this.category,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.difficulty,
    this.totalMarks = 200,
    this.positiveMarks = 2.0,
    this.negativeMarks = 0.66,
    required this.attemptsCount,
    this.isCompleted = false,
    this.previousScore,
    required this.questions,
  });

  TestModel copyWith({
    String? id,
    String? title,
    String? category,
    int? totalQuestions,
    int? durationMinutes,
    String? difficulty,
    int? totalMarks,
    double? positiveMarks,
    double? negativeMarks,
    String? attemptsCount,
    bool? isCompleted,
    double? previousScore,
    List<QuestionModel>? questions,
  }) {
    return TestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      difficulty: difficulty ?? this.difficulty,
      totalMarks: totalMarks ?? this.totalMarks,
      positiveMarks: positiveMarks ?? this.positiveMarks,
      negativeMarks: negativeMarks ?? this.negativeMarks,
      attemptsCount: attemptsCount ?? this.attemptsCount,
      isCompleted: isCompleted ?? this.isCompleted,
      previousScore: previousScore ?? this.previousScore,
      questions: questions ?? this.questions,
    );
  }
}

class TestResultModel {
  final String testId;
  final String testTitle;
  final int totalQuestions;
  final int totalMarks;
  final double score;
  final double accuracy;
  final int correctCount;
  final int wrongCount;
  final int unattemptedCount;
  final String timeTaken;
  final Map<int, int?> userAnswers;
  final Map<int, bool> reviewStatus;
  final List<SubjectPerformance> subjectPerformance;
  final List<QuestionModel> questions;

  const TestResultModel({
    required this.testId,
    required this.testTitle,
    required this.totalQuestions,
    required this.totalMarks,
    required this.score,
    required this.accuracy,
    required this.correctCount,
    required this.wrongCount,
    required this.unattemptedCount,
    required this.timeTaken,
    required this.userAnswers,
    required this.reviewStatus,
    required this.subjectPerformance,
    required this.questions,
  });
}
