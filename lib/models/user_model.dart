class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String targetExam;
  final String avatarUrl;
  final String studyTime;
  final int questionsSolved;
  final int testsCompleted;
  final double syllabusProgress;
  final int currentStreak;
  final bool isPlusMember;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.targetExam,
    this.avatarUrl = '',
    this.studyTime = '24h 35m',
    this.questionsSolved = 1248,
    this.testsCompleted = 18,
    this.syllabusProgress = 0.68,
    this.currentStreak = 12,
    this.isPlusMember = true,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? targetExam,
    String? avatarUrl,
    String? studyTime,
    int? questionsSolved,
    int? testsCompleted,
    double? syllabusProgress,
    int? currentStreak,
    bool? isPlusMember,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      targetExam: targetExam ?? this.targetExam,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      studyTime: studyTime ?? this.studyTime,
      questionsSolved: questionsSolved ?? this.questionsSolved,
      testsCompleted: testsCompleted ?? this.testsCompleted,
      syllabusProgress: syllabusProgress ?? this.syllabusProgress,
      currentStreak: currentStreak ?? this.currentStreak,
      isPlusMember: isPlusMember ?? this.isPlusMember,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'targetExam': targetExam,
    'studyTime': studyTime,
    'questionsSolved': questionsSolved,
    'testsCompleted': testsCompleted,
    'syllabusProgress': syllabusProgress,
    'currentStreak': currentStreak,
    'isPlusMember': isPlusMember,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? '',
    targetExam: json['targetExam'] ?? '',
    studyTime: json['studyTime'] ?? '24h 35m',
    questionsSolved: json['questionsSolved'] ?? 0,
    testsCompleted: json['testsCompleted'] ?? 0,
    syllabusProgress: (json['syllabusProgress'] as num?)?.toDouble() ?? 0.0,
    currentStreak: json['currentStreak'] ?? 0,
    isPlusMember: json['isPlusMember'] ?? false,
  );
}
