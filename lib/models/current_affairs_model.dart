class CurrentAffairsModel {
  final String id;
  final String title;
  final String category;
  final String date;
  final String summary;
  final List<String> keyPoints;
  final String upscRelevance;
  final List<String> relatedTopics;
  final bool isBookmarked;
  final bool isHighlighted;
  final String? imageUrl;

  const CurrentAffairsModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.summary,
    required this.keyPoints,
    required this.upscRelevance,
    required this.relatedTopics,
    this.isBookmarked = false,
    this.isHighlighted = false,
    this.imageUrl,
  });

  CurrentAffairsModel copyWith({
    String? id,
    String? title,
    String? category,
    String? date,
    String? summary,
    List<String>? keyPoints,
    String? upscRelevance,
    List<String>? relatedTopics,
    bool? isBookmarked,
    bool? isHighlighted,
    String? imageUrl,
  }) {
    return CurrentAffairsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      summary: summary ?? this.summary,
      keyPoints: keyPoints ?? this.keyPoints,
      upscRelevance: upscRelevance ?? this.upscRelevance,
      relatedTopics: relatedTopics ?? this.relatedTopics,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'date': date,
    'summary': summary,
    'keyPoints': keyPoints,
    'upscRelevance': upscRelevance,
    'relatedTopics': relatedTopics,
    'isBookmarked': isBookmarked,
    'isHighlighted': isHighlighted,
    'imageUrl': imageUrl,
  };

  factory CurrentAffairsModel.fromJson(Map<String, dynamic> json) => CurrentAffairsModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    date: json['date'] ?? '',
    summary: json['summary'] ?? '',
    keyPoints: List<String>.from(json['keyPoints'] ?? []),
    upscRelevance: json['upscRelevance'] ?? '',
    relatedTopics: List<String>.from(json['relatedTopics'] ?? []),
    isBookmarked: json['isBookmarked'] ?? false,
    isHighlighted: json['isHighlighted'] ?? false,
    imageUrl: json['imageUrl'],
  );
}
