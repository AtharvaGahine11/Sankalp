import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onBookmarkToggle;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onDelete,
    this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: note.isHighlighted
            ? (isDark ? const Color(0xFF2E2412) : const Color(0xFFFFF9E6))
            : (isDark ? AppColors.cardDark : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: note.isHighlighted
              ? AppColors.warning.withOpacity(0.6)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: note.isHighlighted ? 1.5 : 1,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        note.subject,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (note.isHighlighted)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.highlight, color: AppColors.warning, size: 18),
                          ),
                        if (onBookmarkToggle != null)
                          IconButton(
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              note.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: note.isBookmarked ? AppColors.secondaryOrange : Colors.grey,
                              size: 20,
                            ),
                            onPressed: onBookmarkToggle,
                          ),
                        if (onDelete != null)
                          IconButton(
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 19),
                            onPressed: onDelete,
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Topic: ${note.topic}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppHelpers.formatDate(note.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Edit Note',
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
}
