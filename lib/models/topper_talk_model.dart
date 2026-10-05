class TopperTalkModel {
  final String id;
  final String title;
  final String topperName;
  final String rankAndYear;
  final String duration;
  final String views;
  final String description;
  final List<String> keyAdvice;
  final bool isFree;
  final String? imageUrl;

  const TopperTalkModel({
    required this.id,
    required this.title,
    required this.topperName,
    required this.rankAndYear,
    required this.duration,
    required this.views,
    required this.description,
    required this.keyAdvice,
    this.isFree = true,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'topperName': topperName,
    'rankAndYear': rankAndYear,
    'duration': duration,
    'views': views,
    'description': description,
    'keyAdvice': keyAdvice,
    'isFree': isFree,
    'imageUrl': imageUrl,
  };

  factory TopperTalkModel.fromJson(Map<String, dynamic> json) => TopperTalkModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    topperName: json['topperName'] ?? '',
    rankAndYear: json['rankAndYear'] ?? '',
    duration: json['duration'] ?? '',
    views: json['views'] ?? '',
    description: json['description'] ?? '',
    keyAdvice: List<String>.from(json['keyAdvice'] ?? []),
    isFree: json['isFree'] ?? true,
    imageUrl: json['imageUrl'],
  );
}
