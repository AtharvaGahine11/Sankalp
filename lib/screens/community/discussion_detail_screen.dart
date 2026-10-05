import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/discussion_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';

class DiscussionDetailScreen extends StatefulWidget {
  final DiscussionModel discussion;

  const DiscussionDetailScreen({super.key, required this.discussion});

  @override
  State<DiscussionDetailScreen> createState() => _DiscussionDetailScreenState();
}

class _DiscussionDetailScreenState extends State<DiscussionDetailScreen> {
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _addReply(AppStateProvider appState, String discussionId) {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    appState.addDiscussionReply(discussionId, text);
    _replyController.clear();
    FocusScope.of(context).unfocus();

    AppHelpers.showSnackBar(context, 'Your reply has been posted!', isSuccess: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);

    // Watch live model from provider state
    final currentDiscussion = appState.discussions.firstWhere(
      (d) => d.id == widget.discussion.id,
      orElse: () => widget.discussion,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: currentDiscussion.category,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original Post Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                currentDiscussion.authorName.isNotEmpty ? currentDiscussion.authorName[0] : 'U',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentDiscussion.authorName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  '${currentDiscussion.authorRole} • ${currentDiscussion.timeAgo}',
                                  style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentDiscussion.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentDiscussion.content,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => appState.toggleDiscussionLike(currentDiscussion.id),
                              icon: Icon(
                                currentDiscussion.isLikedByMe ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                                size: 16,
                                color: currentDiscussion.isLikedByMe ? AppColors.secondaryOrange : null,
                              ),
                              label: Text(
                                '${currentDiscussion.likes} Likes',
                                style: TextStyle(
                                  color: currentDiscussion.isLikedByMe ? AppColors.secondaryOrange : null,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${currentDiscussion.repliesCount} Replies',
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Replies Header
                  Row(
                    children: [
                      const Icon(Icons.mode_comment_outlined, size: 18, color: AppColors.secondaryOrange),
                      const SizedBox(width: 8),
                      Text(
                        'Discussion Responses (${currentDiscussion.repliesCount})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Replies List
                  if (currentDiscussion.replies.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'No responses yet. Share your thoughts below!',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    )
                  else
                    ...currentDiscussion.replies.map((reply) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: reply.isEducator
                              ? (isDark ? const Color(0xFF2B2011) : const Color(0xFFFFF7ED))
                              : (isDark ? AppColors.surfaceDark : Colors.white),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: reply.isEducator
                                ? AppColors.secondaryOrange.withOpacity(0.5)
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: reply.isEducator ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: reply.isEducator
                                          ? AppColors.secondaryOrange
                                          : AppColors.primary.withOpacity(0.2),
                                      child: Text(
                                        reply.authorName.isNotEmpty ? reply.authorName[0] : 'U',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: reply.isEducator ? Colors.white : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              reply.authorName,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            if (reply.isEducator) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondaryOrange,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  'FACULTY',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          '${reply.authorRole} • ${reply.timeAgo}',
                                          style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reply.content,
                              style: const TextStyle(fontSize: 13, height: 1.45),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),

          // Bottom Reply Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: const InputDecoration(
                      hintText: 'Write a helpful reply or follow-up question...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addReply(appState, currentDiscussion.id),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.secondaryOrange),
                  onPressed: () => _addReply(appState, currentDiscussion.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
