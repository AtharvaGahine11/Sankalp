import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../app/routes.dart';

class ProfileScreen extends StatelessWidget {
  final bool isTab;

  const ProfileScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);
    final user = appState.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Aspirant Profile',
        showBackButton: !isTab,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            // User Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          user.name
                              .split(' ')
                              .map((n) => n.isNotEmpty ? n[0] : '')
                              .take(2)
                              .join(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              user.email,
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user.targetExam,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: 'Edit Profile',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.editProfile);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Plus Membership Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium, color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                user.isPlusMember ? 'Sankalp PLUS Member' : 'Free Aspirant Plan',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.subscription);
                        },
                        child: Text(user.isPlusMember ? 'Manage Plan' : 'Upgrade'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile Navigation Menu Items
            _buildSectionHeader('STUDY MANAGEMENT', theme),
            _buildMenuItem(
              icon: Icons.school_outlined,
              title: 'My Enrolled Courses',
              subtitle: '${appState.courses.where((c) => c.isUnlocked).length} active subjects',
              onTap: () => Navigator.pushNamed(context, AppRoutes.courses),
            ),
            _buildMenuItem(
              icon: Icons.quiz_outlined,
              title: 'My Mock Tests',
              subtitle: '${user.testsCompleted} tests completed',
              onTap: () {
                if (isTab) {
                  appState.setNavIndex(2);
                } else {
                  Navigator.pushNamed(context, AppRoutes.tests);
                }
              },
            ),
            _buildMenuItem(
              icon: Icons.edit_note_outlined,
              title: 'My Study Notes',
              subtitle: '${appState.notes.length} saved notes & summaries',
              onTap: () => Navigator.pushNamed(context, AppRoutes.notes),
            ),
            _buildMenuItem(
              icon: Icons.bookmark_border,
              title: 'Saved Items & Bookmarks',
              subtitle: '${appState.bookmarkedIds.length} bookmarked articles and classes',
              onTap: () => _showSavedItemsSheet(context, appState),
            ),
            _buildMenuItem(
              icon: Icons.track_changes_outlined,
              title: 'Syllabus Tracker',
              subtitle: '${(appState.overallSyllabusProgress * 100).toInt()}% completed',
              onTap: () => Navigator.pushNamed(context, AppRoutes.syllabus),
            ),

            const SizedBox(height: 12),
            _buildSectionHeader('SUBSCRIPTION & SETTINGS', theme),
            _buildMenuItem(
              icon: Icons.card_membership_outlined,
              title: 'Plans & Pricing',
              subtitle: 'Plus pass (₹24,999/yr) & Test Series pass',
              onTap: () => Navigator.pushNamed(context, AppRoutes.subscription),
            ),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'App Settings & Preferences',
              subtitle: 'Dark mode, Notifications, Language',
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Viva Information',
              subtitle: 'Case study context & B.Tech CSE details',
              onTap: () => _showVivaInfoDialog(context),
            ),

            const SizedBox(height: 12),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.2),
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Log Out from Sankalp'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.secondaryOrange, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showSavedItemsSheet(BuildContext context, AppStateProvider appState) {
    final bookmarkedArticles = appState.currentAffairs
        .where((a) => appState.isItemBookmarked(a.id))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.35,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Saved Items & Bookmarks',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: bookmarkedArticles.isEmpty
                    ? const Center(
                        child: Text('No bookmarked articles yet.'),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: bookmarkedArticles.length,
                        itemBuilder: (context, index) {
                          final article = bookmarkedArticles[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              subtitle: Text('${article.category} • ${article.date}', style: const TextStyle(fontSize: 11)),
                              trailing: IconButton(
                                icon: const Icon(Icons.bookmark, color: AppColors.secondaryOrange),
                                onPressed: () {
                                  appState.toggleBookmark(article.id);
                                  Navigator.pop(ctx);
                                },
                              ),
                              onTap: () {
                                Navigator.pop(ctx);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.currentAffairsDetail,
                                  arguments: article,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVivaInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.school, color: AppColors.secondaryOrange),
            SizedBox(width: 8),
            Text('Academic Case Study'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sankalp - UPSC Preparation Ecosystem',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text('Student: Atharva Suryawanshi'),
            Text('Degree: B.Tech CSE & AI - Semester V'),
            Text('Subject: Cross Platform App Development (Flutter)'),
            Text('Institution: ITM Skills University'),
            SizedBox(height: 10),
            Text(
              'Technical Stack: Flutter 3.47+, Dart 3.13, Provider state management, Material 3 design, Google Fonts, SharedPreferences persistence.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out?'),
        content: const Text('Are you sure you want to sign out from your Sankalp account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
