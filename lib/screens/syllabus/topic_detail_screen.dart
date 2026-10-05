import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/topic_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';

class TopicDetailScreen extends StatelessWidget {
  final SubjectSyllabus subject;

  const TopicDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);

    // Watch updated subject from provider state
    final currentSubj = appState.syllabus.firstWhere(
      (s) => s.id == subject.id,
      orElse: () => subject,
    );

    final completedCount = currentSubj.completedTopics;
    final totalCount = currentSubj.totalTopics;
    final pct = (currentSubj.progressPercentage * 100).toInt();

    return Scaffold(
      appBar: CustomAppBar(
        title: currentSubj.subjectName,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentSubj.code,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryOrange,
                        ),
                      ),
                      Text(
                        '$completedCount of $totalCount Completed ($pct%)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: currentSubj.progressPercentage,
                      minHeight: 8,
                      backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        currentSubj.progressPercentage >= 0.7
                            ? AppColors.success
                            : AppColors.secondaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Chapters & Topics Breakdown',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap on the status badge to switch between Not Started, In Progress, and Completed.',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 14),

            // Topics List
            ...List.generate(currentSubj.topics.length, (index) {
              final topic = currentSubj.topics[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.title,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Estimated study time: ${topic.estimatedHours}',
                              style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status Switcher Chip
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _cycleTopicStatus(context, appState, currentSubj.id, topic),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusBg(topic.status),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _getStatusBorder(topic.status)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getStatusIcon(topic.status), size: 14, color: _getStatusColor(topic.status)),
                              const SizedBox(width: 4),
                              Text(
                                _getStatusLabel(topic.status),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(topic.status),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _cycleTopicStatus(
    BuildContext context,
    AppStateProvider appState,
    String subjectId,
    TopicItem topic,
  ) {
    TopicStatus nextStatus;
    switch (topic.status) {
      case TopicStatus.notStarted:
        nextStatus = TopicStatus.inProgress;
        break;
      case TopicStatus.inProgress:
        nextStatus = TopicStatus.completed;
        break;
      case TopicStatus.completed:
        nextStatus = TopicStatus.notStarted;
        break;
    }
    appState.updateTopicStatus(subjectId, topic.id, nextStatus);

    if (nextStatus == TopicStatus.completed) {
      AppHelpers.showSnackBar(context, 'Marked "${topic.title}" as Completed! Keep it up.', isSuccess: true);
    }
  }

  String _getStatusLabel(TopicStatus status) {
    switch (status) {
      case TopicStatus.completed:
        return 'Done';
      case TopicStatus.inProgress:
        return 'In Progress';
      case TopicStatus.notStarted:
        return 'Pending';
    }
  }

  Color _getStatusColor(TopicStatus status) {
    switch (status) {
      case TopicStatus.completed:
        return AppColors.success;
      case TopicStatus.inProgress:
        return AppColors.secondaryOrange;
      case TopicStatus.notStarted:
        return Colors.grey;
    }
  }

  Color _getStatusBg(TopicStatus status) {
    return _getStatusColor(status).withOpacity(0.12);
  }

  Color _getStatusBorder(TopicStatus status) {
    return _getStatusColor(status).withOpacity(0.4);
  }

  IconData _getStatusIcon(TopicStatus status) {
    switch (status) {
      case TopicStatus.completed:
        return Icons.check_circle;
      case TopicStatus.inProgress:
        return Icons.pending;
      case TopicStatus.notStarted:
        return Icons.radio_button_unchecked;
    }
  }
}
