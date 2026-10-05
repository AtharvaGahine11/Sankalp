class DiscussionReply {
  final String id;
  final String authorName;
  final String authorRole;
  final String content;
  final String timeAgo;
  final int likes;
  final bool isEducator;
  final bool isLikedByMe;

  const DiscussionReply({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.isEducator = false,
    this.isLikedByMe = false,
  });

  DiscussionReply copyWith({
    String? id,
    String? authorName,
    String? authorRole,
    String? content,
    String? timeAgo,
    int? likes,
    bool? isEducator,
    bool? isLikedByMe,
  }) {
    return DiscussionReply(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      likes: likes ?? this.likes,
      isEducator: isEducator ?? this.isEducator,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }
}

class DiscussionModel {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String authorRole;
  final String category;
  final String timeAgo;
  final int likes;
  final bool isLikedByMe;
  final List<DiscussionReply> replies;

  const DiscussionModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorRole,
    required this.category,
    required this.timeAgo,
    this.likes = 0,
    this.isLikedByMe = false,
    this.replies = const [],
  });

  int get repliesCount => replies.length;

  DiscussionModel copyWith({
    String? id,
    String? title,
    String? content,
    String? authorName,
    String? authorRole,
    String? category,
    String? timeAgo,
    int? likes,
    bool? isLikedByMe,
    List<DiscussionReply>? replies,
  }) {
    return DiscussionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      category: category ?? this.category,
      timeAgo: timeAgo ?? this.timeAgo,
      likes: likes ?? this.likes,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      replies: replies ?? this.replies,
    );
  }
}
