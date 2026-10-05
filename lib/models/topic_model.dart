enum TopicStatus { notStarted, inProgress, completed }

class TopicItem {
  final String id;
  final String title;
  final String estimatedHours;
  final TopicStatus status;

  const TopicItem({
    required this.id,
    required this.title,
    required this.estimatedHours,
    this.status = TopicStatus.notStarted,
  });

  TopicItem copyWith({
    String? id,
    String? title,
    String? estimatedHours,
    TopicStatus? status,
  }) {
    return TopicItem(
      id: id ?? this.id,
      title: title ?? this.title,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'estimatedHours': estimatedHours,
    'status': status.name,
  };

  factory TopicItem.fromJson(Map<String, dynamic> json) => TopicItem(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    estimatedHours: json['estimatedHours'] ?? '2h',
    status: TopicStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => TopicStatus.notStarted,
    ),
  );
}

class SubjectSyllabus {
  final String id;
  final String subjectName;
  final String code;
  final String iconName;
  final List<TopicItem> topics;

  const SubjectSyllabus({
    required this.id,
    required this.subjectName,
    required this.code,
    required this.iconName,
    required this.topics,
  });

  int get totalTopics => topics.length;
  int get completedTopics =>
      topics.where((t) => t.status == TopicStatus.completed).length;
  double get progressPercentage =>
      totalTopics == 0 ? 0.0 : (completedTopics / totalTopics);

  SubjectSyllabus copyWith({
    String? id,
    String? subjectName,
    String? code,
    String? iconName,
    List<TopicItem>? topics,
  }) {
    return SubjectSyllabus(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      code: code ?? this.code,
      iconName: iconName ?? this.iconName,
      topics: topics ?? this.topics,
    );
  }
}
