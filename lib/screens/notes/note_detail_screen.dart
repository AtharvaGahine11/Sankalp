import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';
import '../../app/routes.dart';

class NoteDetailScreen extends StatelessWidget {
  final NoteModel note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);

    // Watch the updated note from state
    final currentNote = appState.notes.firstWhere(
      (n) => n.id == note.id,
      orElse: () => note,
    );
    final isBookmarked = appState.isItemBookmarked(currentNote.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: currentNote.subject,
        actions: [
          IconButton(
            icon: Icon(
              currentNote.isHighlighted ? Icons.highlight : Icons.highlight_outlined,
              color: currentNote.isHighlighted ? AppColors.warning : null,
            ),
            tooltip: 'Highlight Note',
            onPressed: () => appState.toggleNoteHighlight(currentNote.id),
          ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.secondaryOrange : null,
            ),
            tooltip: 'Bookmark Note',
            onPressed: () => appState.toggleBookmark(currentNote.id),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Note',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.noteEditor,
                arguments: currentNote,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Note',
            onPressed: () {
              _confirmDelete(context, appState, currentNote);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${currentNote.subject} • ${currentNote.topic}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              currentNote.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Created on ${AppHelpers.formatDate(currentNote.createdAt)}',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: currentNote.isHighlighted
                    ? (isDark ? const Color(0xFF2E2412) : const Color(0xFFFFF9E6))
                    : (isDark ? AppColors.surfaceDark : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: currentNote.isHighlighted
                      ? AppColors.warning
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ),
              child: Text(
                currentNote.content,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppStateProvider appState, NoteModel note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Study Note?'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              appState.deleteNote(note.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
