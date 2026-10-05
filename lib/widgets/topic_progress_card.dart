import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import '../utils/constants.dart';

class TopicProgressCard extends StatelessWidget {
  final SubjectSyllabus subject;
  final VoidCallback onTap;

  const TopicProgressCard({
    super.key,
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final percentage = (subject.progressPercentage * 100).toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Subject Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getSubjectIcon(subject.iconName),
                    color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                // Title and progress stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              subject.subjectName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${subject.completedTopics} of ${subject.totalTopics} topics completed • ${subject.code}',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: subject.progressPercentage,
                          minHeight: 6,
                          backgroundColor: (isDark ? Colors.white12 : Colors.grey.shade200),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            subject.progressPercentage >= 0.7
                                ? AppColors.success
                                : AppColors.secondaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String iconName) {
    switch (iconName) {
      case 'account_balance':
        return Icons.account_balance;
      case 'history_edu':
        return Icons.history_edu;
      case 'public':
        return Icons.public;
      case 'trending_up':
        return Icons.trending_up;
      case 'eco':
        return Icons.eco;
      case 'biotech':
        return Icons.biotech;
      case 'newspaper':
        return Icons.newspaper;
      case 'calculate':
        return Icons.calculate;
      default:
        return Icons.menu_book;
    }
  }
}
