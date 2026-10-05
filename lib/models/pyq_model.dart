class PYQModel {
  final String id;
  final int year;
  final String paper; // 'Prelims Paper I (GS)', 'Prelims Paper II (CSAT)', etc.
  final String subject;
  final String topic;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String difficulty; // Easy, Medium, Hard
  final bool isSample;

  const PYQModel({
    required this.id,
    required this.year,
    required this.paper,
    required this.subject,
    required this.topic,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.difficulty,
    this.isSample = true,
  });
}

class TopicWeightage {
  final String topicName;
  final String subject;
  final int questionsCount;
  final double percentage;

  const TopicWeightage({
    required this.topicName,
    required this.subject,
    required this.questionsCount,
    required this.percentage,
  });
}

class YearTrend {
  final int year;
  final int polity;
  final int history;
  final int geography;
  final int economy;
  final int environment;
  final int science;

  const YearTrend({
    required this.year,
    required this.polity,
    required this.history,
    required this.geography,
    required this.economy,
    required this.environment,
    required this.science,
  });
}
