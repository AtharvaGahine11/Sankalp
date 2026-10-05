enum ClassType { live, upcoming, recorded }

class ChatMessage {
  final String id;
  final String userName;
  final String message;
  final String timestamp;
  final bool isEducator;

  const ChatMessage({
    required this.id,
    required this.userName,
    required this.message,
    required this.timestamp,
    this.isEducator = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'message': message,
    'timestamp': timestamp,
    'isEducator': isEducator,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] ?? '',
    userName: json['userName'] ?? '',
    message: json['message'] ?? '',
    timestamp: json['timestamp'] ?? '',
    isEducator: json['isEducator'] ?? false,
  );
}

class LivePoll {
  final String id;
  final String question;
  final List<String> options;
  final List<int> votes;
  final int correctOptionIndex;
  final int? selectedOptionIndex;

  const LivePoll({
    required this.id,
    required this.question,
    required this.options,
    required this.votes,
    required this.correctOptionIndex,
    this.selectedOptionIndex,
  });

  LivePoll copyWith({
    String? id,
    String? question,
    List<String>? options,
    List<int>? votes,
    int? correctOptionIndex,
    int? selectedOptionIndex,
  }) {
    return LivePoll(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      votes: votes ?? this.votes,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
    );
  }
}

class DoubtItem {
  final String id;
  final String userName;
  final String question;
  final String timestamp;
  final String? educatorReply;

  const DoubtItem({
    required this.id,
    required this.userName,
    required this.question,
    required this.timestamp,
    this.educatorReply,
  });
}

class ClassModel {
  final String id;
  final String title;
  final String subject;
  final String educatorName;
  final String educatorId;
  final String scheduledDate;
  final String scheduledTime;
  final String duration;
  final String studentCount;
  final ClassType type;
  final String views;
  final String description;
  final List<ChatMessage> initialChat;
  final LivePoll? samplePoll;
  final List<DoubtItem> initialDoubts;
  final String? imageUrl;

  const ClassModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.educatorName,
    required this.educatorId,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.duration,
    required this.studentCount,
    required this.type,
    this.views = '12.4K',
    this.description = '',
    this.initialChat = const [],
    this.samplePoll,
    this.initialDoubts = const [],
    this.imageUrl,
  });

  bool get isLive => type == ClassType.live;
  bool get isUpcoming => type == ClassType.upcoming;
  bool get isRecorded => type == ClassType.recorded;
}
