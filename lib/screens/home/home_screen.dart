import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/app_bottom_navigation.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/section_header.dart';
import '../../widgets/progress_indicator_card.dart';
import '../../widgets/course_card.dart';
import '../../widgets/live_class_card.dart';
import '../../widgets/current_affair_card.dart';
import '../../widgets/quiz_card.dart';
import '../../widgets/test_card.dart';
import '../../widgets/topper_talk_card.dart';
import '../../widgets/educator_card.dart';
import '../../data/mock_data.dart';
import '../../app/routes.dart';

// Child screens for tabs
import '../live_classes/live_classes_screen.dart';
import '../tests/tests_screen.dart';
import '../community/community_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    // Render tab based on bottom navigation index
    switch (appState.selectedNavIndex) {
      case 1:
        return const Scaffold(
          body: LiveClassesScreen(isTab: true),
          bottomNavigationBar: AppBottomNavigation(),
        );
      case 2:
        return const Scaffold(
          body: TestsScreen(isTab: true),
          bottomNavigationBar: AppBottomNavigation(),
        );
      case 3:
        return const Scaffold(
          body: CommunityScreen(isTab: true),
          bottomNavigationBar: AppBottomNavigation(),
        );
      case 4:
        return const Scaffold(
          body: ProfileScreen(isTab: true),
          bottomNavigationBar: AppBottomNavigation(),
        );
      case 0:
      default:
        return _buildHomeDashboard(context, appState);
    }
  }

  Widget _buildHomeDashboard(BuildContext context, AppStateProvider appState) {
    final theme = Theme.of(context);
    final user = appState.user;

    // Filtered search items if search query is not empty
    final isSearching = _searchQuery.trim().isNotEmpty;
    final filteredCourses = appState.courses
        .where((c) =>
            c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.educatorName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Good Morning, ${user.name.split(' ')[0]} 👋',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isPlusMember) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppColors.plusBadgeGradient,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.stars, color: Colors.black87, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'PLUS MEMBER',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Let\'s continue your UPSC preparation.',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              CustomSearchBar(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),

              // SEARCH RESULTS VIEW IF TYPING
              if (isSearching) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Search Results for "$_searchQuery" (${filteredCourses.length} courses)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (filteredCourses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text('No results found.')),
                  )
                else
                  ...filteredCourses.map((c) => CourseCard(
                        course: c,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.courseDetail,
                            arguments: c,
                          );
                        },
                      )),
              ] else ...[
                // NORMAL DASHBOARD CONTENT

                // Continue Learning & Today's Progress Card
                ProgressIndicatorCard(
                  user: user,
                  onContinueLearning: () {
                    // Open sample recorded video detail
                    Navigator.pushNamed(
                      context,
                      AppRoutes.videoDetail,
                      arguments: appState.recordedClasses.first,
                    );
                  },
                ),

                // Quick Navigation Hub
                const SizedBox(height: 10),
                _buildQuickActions(context),

                // Upcoming Live Classes
                const SizedBox(height: 12),
                SectionHeader(
                  title: 'Upcoming Live Classes',
                  subtitle: 'Interactive lectures with polls & live doubts',
                  actionText: 'See All',
                  icon: Icons.live_tv,
                  onActionTap: () => appState.setNavIndex(1),
                ),
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: appState.liveClasses.length,
                    itemBuilder: (context, index) {
                      final item = appState.liveClasses[index];
                      return LiveClassCard(
                        classItem: item,
                        isHorizontal: true,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.liveClassDetail,
                            arguments: item,
                          );
                        },
                      );
                    },
                  ),
                ),

                // Plus Subscription Value Banner
                _buildPlusPromoBanner(context),

                // Daily Current Affairs (2-3 cards)
                const SizedBox(height: 12),
                SectionHeader(
                  title: 'Daily Current Affairs Digest',
                  subtitle: '4 October 2026 • Curated for Prelims & Mains',
                  actionText: 'View All',
                  icon: Icons.newspaper,
                  onActionTap: () => Navigator.pushNamed(context, AppRoutes.currentAffairs),
                ),
                ...appState.currentAffairs.take(3).map((article) => CurrentAffairCard(
                      article: article,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.currentAffairsDetail,
                          arguments: article,
                        );
                      },
                    )),

                // Today's Quiz Card
                const SizedBox(height: 10),
                QuizCard(
                  quiz: MockData.todayQuiz,
                  onStartQuiz: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.quiz,
                      arguments: MockData.todayQuiz,
                    );
                  },
                ),

                // Recommended Test Series
                const SizedBox(height: 12),
                SectionHeader(
                  title: 'Recommended Test Series',
                  subtitle: 'Real exam hall simulation with OMR-style timer',
                  actionText: 'All Tests',
                  icon: Icons.quiz,
                  onActionTap: () => appState.setNavIndex(2),
                ),
                ...appState.tests.take(2).map((test) => TestCard(
                      test: test,
                      onStartTest: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.testDetail,
                          arguments: test,
                        );
                      },
                      onViewAnalysis: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.testAnalysis,
                          arguments: test,
                        );
                      },
                    )),

                // Featured UPSC Courses
                const SizedBox(height: 12),
                SectionHeader(
                  title: 'Featured UPSC Courses',
                  subtitle: 'Prelims, Mains, and Optional Masterclasses',
                  actionText: 'Explore',
                  icon: Icons.school,
                  onActionTap: () => Navigator.pushNamed(context, AppRoutes.courses),
                ),
                SizedBox(
                  height: 310,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: appState.courses.length,
                    itemBuilder: (context, index) {
                      final course = appState.courses[index];
                      return CourseCard(
                        course: course,
                        isHorizontal: true,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.courseDetail,
                            arguments: course,
                          );
                        },
                      );
                    },
                  ),
                ),

                // Top Educators
                const SizedBox(height: 12),
                SectionHeader(
                  title: 'Mentors & Faculty',
                  subtitle: 'Learn directly from subject matter authorities',
                  actionText: 'View All',
                  icon: Icons.people,
                  onActionTap: () => Navigator.pushNamed(context, AppRoutes.educators),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: MockData.educators.length,
                    itemBuilder: (context, index) {
                      final ed = MockData.educators[index];
                      return EducatorCard(
                        educator: ed,
                        isHorizontal: true,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.educatorProfile,
                            arguments: ed,
                          );
                        },
                      );
                    },
                  ),
                ),

                // Free Topper Talks
                const SizedBox(height: 12),
                SectionHeader(
                  title: 'Topper Talks & Strategy',
                  subtitle: 'Free insightful sessions from UPSC CSE All India Rankers',
                  actionText: 'View Archive',
                  icon: Icons.star_rate,
                  onActionTap: () => Navigator.pushNamed(context, AppRoutes.topperTalks),
                ),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: MockData.topperTalks.length,
                    itemBuilder: (context, index) {
                      final talk = MockData.topperTalks[index];
                      return TopperTalkCard(
                        talk: talk,
                        isHorizontal: true,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.topperVideo,
                            arguments: talk,
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.live_tv, 'label': 'Live Classes', 'route': AppRoutes.liveClasses, 'color': Colors.red},
      {'icon': Icons.newspaper, 'label': 'Current Affairs', 'route': AppRoutes.currentAffairs, 'color': Colors.blue},
      {'icon': Icons.quiz, 'label': 'Test Series', 'route': AppRoutes.tests, 'color': Colors.green},
      {'icon': Icons.edit_note, 'label': 'Study Notes', 'route': AppRoutes.notes, 'color': Colors.amber},
      {'icon': Icons.track_changes, 'label': 'Syllabus', 'route': AppRoutes.syllabus, 'color': Colors.purple},
      {'icon': Icons.history, 'label': 'PYQ Analysis', 'route': AppRoutes.pyq, 'color': Colors.teal},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actions.take(3).map((a) => Expanded(child: _buildQuickActionButton(context, a))).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actions.skip(3).map((a) => Expanded(child: _buildQuickActionButton(context, a))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = item['color'] as Color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final route = item['route'] as String;
          if (route == AppRoutes.liveClasses) {
            Provider.of<AppStateProvider>(context, listen: false).setNavIndex(1);
          } else if (route == AppRoutes.tests) {
            Provider.of<AppStateProvider>(context, listen: false).setNavIndex(2);
          } else {
            Navigator.pushNamed(context, route);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                item['label'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlusPromoBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B263B), Color(0xFF0D1B2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: AppColors.plusBadgeGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BEST VALUE SUBSCRIPTION',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sankalp Plus Pass',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Access ALL GS & Optional courses + 50 Tests for ₹24,999/yr',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.subscription);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Upgrade', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
