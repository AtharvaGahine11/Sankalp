class EducatorModel {
  final String id;
  final String name;
  final String subject;
  final String experience;
  final String studentCount;
  final double rating;
  final String bio;
  final List<String> courses;
  final int reviewsCount;
  final String initials;
  final String? imageUrl;

  const EducatorModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.experience,
    required this.studentCount,
    required this.rating,
    required this.bio,
    this.courses = const [],
    this.reviewsCount = 4200,
    required this.initials,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subject': subject,
    'experience': experience,
    'studentCount': studentCount,
    'rating': rating,
    'bio': bio,
    'courses': courses,
    'reviewsCount': reviewsCount,
    'initials': initials,
    'imageUrl': imageUrl,
  };

  factory EducatorModel.fromJson(Map<String, dynamic> json) => EducatorModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    subject: json['subject'] ?? '',
    experience: json['experience'] ?? '',
    studentCount: json['studentCount'] ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
    bio: json['bio'] ?? '',
    courses: List<String>.from(json['courses'] ?? []),
    reviewsCount: json['reviewsCount'] ?? 0,
    initials: json['initials'] ?? 'ED',
    imageUrl: json['imageUrl'],
  );
}
