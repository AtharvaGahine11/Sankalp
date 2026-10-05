class CourseModule {
  final String title;
  final int lessonsCount;
  final String duration;
  final List<String> topics;

  const CourseModule({
    required this.title,
    required this.lessonsCount,
    required this.duration,
    required this.topics,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'lessonsCount': lessonsCount,
    'duration': duration,
    'topics': topics,
  };

  factory CourseModule.fromJson(Map<String, dynamic> json) => CourseModule(
    title: json['title'] ?? '',
    lessonsCount: json['lessonsCount'] ?? 0,
    duration: json['duration'] ?? '',
    topics: List<String>.from(json['topics'] ?? []),
  );
}

class CourseModel {
  final String id;
  final String title;
  final String category;
  final String educatorName;
  final String educatorId;
  final String duration;
  final int totalLessons;
  final String studentsCount;
  final double rating;
  final int price;
  final int originalPrice;
  final String description;
  final List<String> highlights;
  final List<CourseModule> modules;
  final bool isUnlocked;
  final String level;
  final String? imageUrl;

  const CourseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.educatorName,
    required this.educatorId,
    required this.duration,
    required this.totalLessons,
    required this.studentsCount,
    required this.rating,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.highlights,
    required this.modules,
    this.isUnlocked = false,
    this.level = 'Prelims + Mains',
    this.imageUrl,
  });

  CourseModel copyWith({
    String? id,
    String? title,
    String? category,
    String? educatorName,
    String? educatorId,
    String? duration,
    int? totalLessons,
    String? studentsCount,
    double? rating,
    int? price,
    int? originalPrice,
    String? description,
    List<String>? highlights,
    List<CourseModule>? modules,
    bool? isUnlocked,
    String? level,
    String? imageUrl,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      educatorName: educatorName ?? this.educatorName,
      educatorId: educatorId ?? this.educatorId,
      duration: duration ?? this.duration,
      totalLessons: totalLessons ?? this.totalLessons,
      studentsCount: studentsCount ?? this.studentsCount,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      description: description ?? this.description,
      highlights: highlights ?? this.highlights,
      modules: modules ?? this.modules,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      level: level ?? this.level,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'educatorName': educatorName,
    'educatorId': educatorId,
    'duration': duration,
    'totalLessons': totalLessons,
    'studentsCount': studentsCount,
    'rating': rating,
    'price': price,
    'originalPrice': originalPrice,
    'description': description,
    'highlights': highlights,
    'modules': modules.map((m) => m.toJson()).toList(),
    'isUnlocked': isUnlocked,
    'level': level,
    'imageUrl': imageUrl,
  };

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    educatorName: json['educatorName'] ?? '',
    educatorId: json['educatorId'] ?? '',
    duration: json['duration'] ?? '',
    totalLessons: json['totalLessons'] ?? 0,
    studentsCount: json['studentsCount'] ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
    price: json['price'] ?? 0,
    originalPrice: json['originalPrice'] ?? 0,
    description: json['description'] ?? '',
    highlights: List<String>.from(json['highlights'] ?? []),
    modules: (json['modules'] as List? ?? [])
        .map((m) => CourseModule.fromJson(m))
        .toList(),
    isUnlocked: json['isUnlocked'] ?? false,
    level: json['level'] ?? 'Prelims + Mains',
    imageUrl: json['imageUrl'],
  );
}
