import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/current_affairs_model.dart';
import '../services/app_state_provider.dart';
import '../utils/constants.dart';

class CurrentAffairCard extends StatelessWidget {
  final CurrentAffairsModel article;
  final VoidCallback onTap;

  const CurrentAffairCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);
    final isBookmarked = appState.isItemBookmarked(article.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: article.isHighlighted
            ? (isDark ? const Color(0xFF2E2412) : const Color(0xFFFFF9E6))
            : (isDark ? AppColors.cardDark : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: article.isHighlighted
              ? AppColors.warning.withOpacity(0.6)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: article.isHighlighted ? 1.5 : 1,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(article.category).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            article.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(article.category),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          article.date,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            article.isHighlighted ? Icons.highlight : Icons.highlight_outlined,
                            size: 19,
                            color: article.isHighlighted ? AppColors.warning : Colors.grey,
                          ),
                          tooltip: 'Highlight',
                          onPressed: () => appState.toggleHighlightCurrentAffair(article.id),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            size: 20,
                            color: isBookmarked ? AppColors.secondaryOrange : Colors.grey,
                          ),
                          tooltip: 'Bookmark',
                          onPressed: () => appState.toggleBookmark(article.id),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.summary,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school_outlined, size: 14, color: AppColors.secondaryOrange),
                        const SizedBox(width: 4),
                        Text(
                          'GS II / GS III Mains Relevance',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Read More',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'polity':
        return Colors.blue;
      case 'economy':
        return Colors.green;
      case 'environment':
        return Colors.teal;
      case 'science':
        return Colors.purple;
      case 'international':
        return Colors.indigo;
      default:
        return AppColors.secondaryOrange;
    }
  }
}
