import 'package:flutter/material.dart';
import '../../models/class_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';

class LiveClassDetailScreen extends StatefulWidget {
  final ClassModel classItem;

  const LiveClassDetailScreen({super.key, required this.classItem});

  @override
  State<LiveClassDetailScreen> createState() => _LiveClassDetailScreenState();
}

class _LiveClassDetailScreenState extends State<LiveClassDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _doubtController = TextEditingController();

  late List<ChatMessage> _chatMessages;
  late LivePoll _poll;
  late List<DoubtItem> _doubts;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _chatMessages = List.from(widget.classItem.initialChat);
    _poll = widget.classItem.samplePoll ??
        const LivePoll(
          id: 'poll_def',
          question: 'Which article of the Indian Constitution guarantees Right to Equality before Law?',
          options: ['Article 14', 'Article 19', 'Article 21', 'Article 32'],
          votes: [1240, 85, 110, 45],
          correctOptionIndex: 0,
        );
    _doubts = List.from(widget.classItem.initialDoubts);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _doubtController.dispose();
    super.dispose();
  }

  void _sendChatMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add(
        ChatMessage(
          id: 'cm_${DateTime.now().millisecondsSinceEpoch}',
          userName: AppConstants.demoUserName,
          message: text,
          timestamp: 'Just now',
          isEducator: false,
        ),
      );
      _chatController.clear();
    });
  }

  void _postDoubt() {
    final text = _doubtController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _doubts.insert(
        0,
        DoubtItem(
          id: 'd_${DateTime.now().millisecondsSinceEpoch}',
          userName: AppConstants.demoUserName,
          question: text,
          timestamp: 'Just now',
          educatorReply: 'Dr. Rohan Mehta will address this live in 2 minutes.',
        ),
      );
      _doubtController.clear();
    });

    AppHelpers.showSnackBar(
      context,
      'Your doubt has been submitted to the faculty queue!',
      isSuccess: true,
    );
  }

  void _votePoll(int optionIndex) {
    if (_poll.selectedOptionIndex != null) return;

    final updatedVotes = List<int>.from(_poll.votes);
    updatedVotes[optionIndex] = updatedVotes[optionIndex] + 1;

    setState(() {
      _poll = _poll.copyWith(
        votes: updatedVotes,
        selectedOptionIndex: optionIndex,
      );
    });

    AppHelpers.showSnackBar(
      context,
      optionIndex == _poll.correctOptionIndex
          ? 'Correct Answer! Well done.'
          : 'Incorrect. Correct option was ${_poll.options[_poll.correctOptionIndex]}.',
      isSuccess: optionIndex == _poll.correctOptionIndex,
      isError: optionIndex != _poll.correctOptionIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.classItem.subject,
        showThemeToggle: false,
      ),
      body: Column(
        children: [
          // -------------------------------------------------------------
          // MOCK VIDEO PLAYER CONTAINER
          // -------------------------------------------------------------
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  // Video Background / Simulated Stream
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            widget.classItem.educatorName
                                .split(' ')
                                .map((n) => n.isNotEmpty ? n[0] : '')
                                .take(2)
                                .join(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.classItem.educatorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Live Stream Active (1080p 60fps)',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Overlay Badge (Live & Learners count)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.classItem.studentCount} watching',
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Player Controls Bar
                  Positioned(
                    bottom: 8,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => setState(() => _isPlaying = !_isPlaying),
                        ),
                        Text(
                          '${widget.classItem.duration} Scheduled',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.hd_outlined, color: Colors.white, size: 20),
                              onPressed: () => AppHelpers.showSnackBar(context, 'Quality set to Auto (1080p)'),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.fullscreen, color: Colors.white, size: 24),
                              onPressed: () => AppHelpers.showSnackBar(context, 'Fullscreen simulation enabled'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------
          // CLASS TITLE & EDUCATOR STRIP
          // -------------------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.classItem.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: AppColors.secondaryOrange),
                    const SizedBox(width: 4),
                    Text(
                      widget.classItem.educatorName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.classItem.scheduledTime,
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------
          // TABS: CHAT, POLLS, DOUBTS
          // -------------------------------------------------------------
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.chat_bubble_outline, size: 18), text: 'Live Chat'),
              Tab(icon: Icon(Icons.how_to_vote_outlined, size: 18), text: 'Polls'),
              Tab(icon: Icon(Icons.question_answer_outlined, size: 18), text: 'Doubts'),
            ],
          ),

          // Tab Contents
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. LIVE CHAT
                _buildChatTab(theme, isDark),

                // 2. LIVE POLLS
                _buildPollTab(theme, isDark),

                // 3. DOUBT CLEARING
                _buildDoubtsTab(theme, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              final msg = _chatMessages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: msg.isEducator
                          ? AppColors.secondaryOrange
                          : AppColors.primary.withOpacity(0.15),
                      child: Text(
                        msg.userName.isNotEmpty ? msg.userName[0] : 'U',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: msg.isEducator ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: '${msg.userName} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: msg.isEducator
                                ? AppColors.secondaryOrange
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                          children: [
                            if (msg.isEducator)
                              const TextSpan(
                                text: '[Educator] ',
                                style: TextStyle(
                                  color: AppColors.secondaryOrange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            TextSpan(
                              text: msg.message,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      msg.timestamp,
                      style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message in live chat...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _sendChatMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.secondaryOrange),
                onPressed: _sendChatMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPollTab(ThemeData theme, bool isDark) {
    final totalVotes = _poll.votes.fold<int>(0, (sum, v) => sum + v);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondaryOrange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt, color: AppColors.secondaryOrange, size: 18),
                SizedBox(width: 8),
                Text(
                  'Active Live Poll by Educator',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.secondaryOrange),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _poll.question,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(_poll.options.length, (index) {
            final isSelected = _poll.selectedOptionIndex == index;
            final isAnswered = _poll.selectedOptionIndex != null;
            final optionVotes = _poll.votes[index];
            final percent = totalVotes > 0 ? (optionVotes / totalVotes * 100).toInt() : 0;
            final isCorrect = index == _poll.correctOptionIndex;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: isAnswered ? null : () => _votePoll(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isCorrect ? AppColors.success.withOpacity(0.15) : AppColors.error.withOpacity(0.15))
                        : (isDark ? AppColors.surfaceDark : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? (isCorrect ? AppColors.success : AppColors.error)
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _poll.options[index],
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                            ],
                          ),
                          if (isAnswered)
                            Text(
                              '$percent%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCorrect ? AppColors.success : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                      if (isAnswered) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: percent / 100,
                            minHeight: 4,
                            backgroundColor: Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCorrect ? AppColors.success : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          Text(
            'Total votes recorded: $totalVotes',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildDoubtsTab(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _doubtController,
                  decoration: const InputDecoration(
                    hintText: 'Ask your doubt to Dr. Rohan Mehta...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _postDoubt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Post Doubt', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _doubts.isEmpty
              ? Center(
                  child: Text(
                    'No doubts posted yet. Be the first to ask!',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _doubts.length,
                  itemBuilder: (context, index) {
                    final doubt = _doubts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  doubt.userName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  doubt.timestamp,
                                  style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(doubt.question, style: const TextStyle(fontSize: 13)),
                            if (doubt.educatorReply != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (isDark ? AppColors.surfaceDark : Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.3)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.verified, size: 14, color: AppColors.secondaryOrange),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Educator Reply: ${doubt.educatorReply!}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? Colors.white70 : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
