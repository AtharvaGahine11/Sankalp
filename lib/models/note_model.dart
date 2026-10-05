class NoteModel {
  final String id;
  final String title;
  final String subject;
  final String topic;
  final String content;
  final DateTime createdAt;
  final bool isBookmarked;
  final bool isHighlighted;

  const NoteModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.topic,
    required this.content,
    required this.createdAt,
    this.isBookmarked = false,
    this.isHighlighted = false,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? topic,
    String? content,
    DateTime? createdAt,
    bool? isBookmarked,
    bool? isHighlighted,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'topic': topic,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'isBookmarked': isBookmarked,
    'isHighlighted': isHighlighted,
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    subject: json['subject'] ?? '',
    topic: json['topic'] ?? '',
    content: json['content'] ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
        : DateTime.now(),
    isBookmarked: json['isBookmarked'] ?? false,
    isHighlighted: json['isHighlighted'] ?? false,
  );
}
