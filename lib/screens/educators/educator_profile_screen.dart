import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/educator_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/live_class_card.dart';
import '../../app/routes.dart';

class EducatorProfileScreen extends StatelessWidget {
  final EducatorModel educator;

  const EducatorProfileScreen({super.key, required this.educator});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);

    final educatorLiveClasses = appState.liveClasses
        .where((c) => c.educatorName.contains(educator.name.split(' ').last))
        .toList();

    final educatorCourses = appState.courses
        .where((c) => c.educatorName.contains(educator.name.split(' ').last))
        .toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: educator.name,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.primary,
                        backgroundImage: educator.imageUrl != null
                            ? AssetImage(educator.imageUrl!)
                            : null,
                        child: educator.imageUrl == null
                            ? Text(
                                educator.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified, size: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    educator.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    educator.subject,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat('Experience', educator.experience.split(' ').take(2).join(' '), theme),
                      Container(width: 1, height: 32, color: theme.dividerTheme.color),
                      _buildProfileStat('Learners', educator.studentCount, theme),
                      Container(width: 1, height: 32, color: theme.dividerTheme.color),
                      _buildProfileStat('Rating', '★ ${educator.rating}', theme, isStar: true),
                    ],
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        AppHelpers.showSnackBar(
                          context,
                          'You are now following ${educator.name}! You will receive live class notifications.',
                          isSuccess: true,
                        );
                      },
                      icon: const Icon(Icons.person_add_alt, size: 18),
                      label: const Text('Follow Educator'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bio & Academic Background
            const Text(
              'About Mentor & Pedagogy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              educator.bio,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Specialization Courses
            if (educatorCourses.isNotEmpty) ...[
              const Text(
                'Courses Taught by Educator',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...educatorCourses.map((c) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school, color: AppColors.secondaryOrange, size: 20),
                      ),
                      title: Text(
                        c.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text('${c.totalLessons} Lessons • ${c.duration}', style: const TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.courseDetail,
                          arguments: c,
                        );
                      },
                    ),
                  )),
              const SizedBox(height: 20),
            ],

            // Upcoming & Live Classes by this Educator
            if (educatorLiveClasses.isNotEmpty) ...[
              const Text(
                'Live Classes Schedule',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...educatorLiveClasses.map((item) => LiveClassCard(
                    classItem: item,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.liveClassDetail,
                        arguments: item,
                      );
                    },
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, ThemeData theme, {bool isStar = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isStar ? Colors.amber.shade800 : null,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
