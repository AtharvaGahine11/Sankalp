import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../app/routes.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);

    // Watch live model from provider
    final currentCourse = appState.courses.firstWhere(
      (c) => c.id == course.id,
      orElse: () => course,
    );
    final isBookmarked = appState.isItemBookmarked(currentCourse.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: currentCourse.category,
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.secondaryOrange : null,
            ),
            tooltip: 'Bookmark Course',
            onPressed: () => appState.toggleBookmark(currentCourse.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Container
            Container(
              height: 190,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  if (currentCourse.imageUrl != null)
                    Positioned.fill(
                      child: Image.asset(
                        currentCourse.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.45),
                            Colors.black.withOpacity(0.85),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            currentCourse.level.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentCourse.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              currentCourse.educatorName,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (currentCourse.isUnlocked)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'ENROLLED',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content Area
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ratings and Students Row
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${currentCourse.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        ' (${currentCourse.studentsCount} Enrolled Aspirants)',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const Spacer(),
                      Text(
                        '${currentCourse.totalLessons} Lessons • ${currentCourse.duration}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Course Description
                  const Text(
                    'Course Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentCourse.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // What You'll Learn
                  const Text(
                    'What You\'ll Learn',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...currentCourse.highlights.map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                h,
                                style: const TextStyle(fontSize: 13, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 24),

                  // Course Curriculum / Modules
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Curriculum & Modules',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${currentCourse.modules.length} Modules',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...currentCourse.modules.map((m) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: ExpansionTile(
                        shape: const Border(),
                        leading: const Icon(Icons.folder_outlined, color: AppColors.secondaryOrange),
                        title: Text(
                          m.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        subtitle: Text(
                          '${m.lessonsCount} Lessons • ${m.duration}',
                          style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        children: m.topics
                            .map((t) => ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.play_circle_outline, size: 18),
                                  title: Text(t, style: const TextStyle(fontSize: 12)),
                                  trailing: const Text('Free Preview', style: TextStyle(fontSize: 10, color: Colors.blue)),
                                  onTap: () {
                                    AppHelpers.showSnackBar(context, 'Playing lesson: $t');
                                  },
                                ))
                            .toList(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppHelpers.formatCurrency(currentCourse.price),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                    ),
                  ),
                  Text(
                    AppHelpers.formatCurrency(currentCourse.originalPrice),
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: PrimaryButton(
                  text: currentCourse.isUnlocked ? 'Start Learning' : 'Enroll Now',
                  icon: currentCourse.isUnlocked ? Icons.play_arrow : Icons.shopping_bag_outlined,
                  backgroundColor: currentCourse.isUnlocked ? AppColors.success : AppColors.secondaryOrange,
                  onPressed: () {
                    if (currentCourse.isUnlocked) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.videoDetail,
                        arguments: appState.recordedClasses.first,
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.checkout,
                        arguments: {
                          'itemName': currentCourse.title,
                          'itemType': 'course',
                          'price': currentCourse.price,
                          'originalPrice': currentCourse.originalPrice,
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
