import 'question_model.dart';

class QuizModel {
  final String id;
  final String title;
  final String date;
  final int totalQuestions;
  final int durationMinutes;
  final List<QuestionModel> questions;

  const QuizModel({
    required this.id,
    required this.title,
    required this.date,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.questions,
  });
}

class QuizResultModel {
  final String quizId;
  final String quizTitle;
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final int unattemptedCount;
  final double score;
  final double accuracy;
  final String timeTaken;
  final Map<int, int?> selectedAnswers; // questionIndex -> selectedOptionIndex
  final List<QuestionModel> questions;

  const QuizResultModel({
    required this.quizId,
    required this.quizTitle,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.unattemptedCount,
    required this.score,
    required this.accuracy,
    required this.timeTaken,
    required this.selectedAnswers,
    required this.questions,
  });
}
