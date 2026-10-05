class QuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String subject;
  final String topic;
  final String difficulty; // Easy, Medium, Hard
  final int? year; // For PYQ questions

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.subject,
    required this.topic,
    this.difficulty = 'Medium',
    this.year,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'questionText': questionText,
    'options': options,
    'correctOptionIndex': correctOptionIndex,
    'explanation': explanation,
    'subject': subject,
    'topic': topic,
    'difficulty': difficulty,
    'year': year,
  };

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    id: json['id'] ?? '',
    questionText: json['questionText'] ?? '',
    options: List<String>.from(json['options'] ?? []),
    correctOptionIndex: json['correctOptionIndex'] ?? 0,
    explanation: json['explanation'] ?? '',
    subject: json['subject'] ?? '',
    topic: json['topic'] ?? '',
    difficulty: json['difficulty'] ?? 'Medium',
    year: json['year'],
  );
}
