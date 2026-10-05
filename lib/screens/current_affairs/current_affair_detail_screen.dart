import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/current_affairs_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../app/routes.dart';

class CurrentAffairDetailScreen extends StatelessWidget {
  final CurrentAffairsModel article;

  const CurrentAffairDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);

    // Get reactive instance from provider state
    final currentArticle = appState.currentAffairs.firstWhere(
      (a) => a.id == article.id,
      orElse: () => article,
    );
    final isBookmarked = appState.isItemBookmarked(currentArticle.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: currentArticle.category,
        actions: [
          IconButton(
            icon: Icon(
              currentArticle.isHighlighted ? Icons.highlight : Icons.highlight_outlined,
              color: currentArticle.isHighlighted ? AppColors.warning : null,
            ),
            tooltip: 'Highlight',
            onPressed: () => appState.toggleHighlightCurrentAffair(currentArticle.id),
          ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.secondaryOrange : null,
            ),
            tooltip: 'Bookmark',
            onPressed: () => appState.toggleBookmark(currentArticle.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata Tags
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    currentArticle.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  currentArticle.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              currentArticle.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            if (currentArticle.imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  currentArticle.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Summary Callout Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: currentArticle.isHighlighted
                    ? (isDark ? const Color(0xFF2E2412) : const Color(0xFFFFF9E6))
                    : (isDark ? AppColors.surfaceDark : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: currentArticle.isHighlighted
                      ? AppColors.warning
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.summarize_outlined, size: 16, color: AppColors.secondaryOrange),
                      const SizedBox(width: 6),
                      Text(
                        'EXECUTIVE SUMMARY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentArticle.summary,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Key Points
            const Text(
              'Key Points & Dimensions',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...currentArticle.keyPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),

            // UPSC Relevance Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'UPSC CSE Syllabus Relevance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentArticle.upscRelevance,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Related Topics Chips
            const Text(
              'Interlinked Syllabus Topics',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentArticle.relatedTopics
                  .map(
                    (topic) => Chip(
                      label: Text(topic, style: const TextStyle(fontSize: 12)),
                      backgroundColor: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                      side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 28),

            // Make Note from Article Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Pre-fill note editor
                  Navigator.pushNamed(
                    context,
                    AppRoutes.noteEditor,
                    arguments: {
                      'title': 'Notes on: ${currentArticle.title}',
                      'subject': currentArticle.category,
                      'topic': currentArticle.relatedTopics.isNotEmpty ? currentArticle.relatedTopics.first : 'General',
                      'content': 'Summary:\n${currentArticle.summary}\n\nKey Points:\n${currentArticle.keyPoints.join('\n')}',
                    },
                  );
                },
                icon: const Icon(Icons.edit_note, size: 20),
                label: const Text('Create Study Note from this Article'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
