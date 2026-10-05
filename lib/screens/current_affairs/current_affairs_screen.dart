import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../models/current_affairs_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/current_affair_card.dart';
import '../../widgets/quiz_card.dart';
import '../../data/mock_data.dart';
import '../../app/routes.dart';

class CurrentAffairsScreen extends StatefulWidget {
  const CurrentAffairsScreen({super.key});

  @override
  State<CurrentAffairsScreen> createState() => _CurrentAffairsScreenState();
}

class _CurrentAffairsScreenState extends State<CurrentAffairsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Polity',
    'Economy',
    'Environment',
    'Science',
    'International',
    'National',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Daily Current Affairs Digest',
      ),
      body: Column(
        children: [
          // Date & Quiz Prompt Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '4 October 2026',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'UPSC Prelims & Mains Relevant News',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.quiz,
                      arguments: MockData.todayQuiz,
                    );
                  },
                  icon: const Icon(Icons.bolt, size: 16),
                  label: const Text('Daily Quiz'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Categories Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _categories.map((c) => Tab(text: c)).toList(),
          ),

          // List of Current Affairs Cards
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                final filtered = _filterArticles(appState.currentAffairs, category);
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    if (category == 'All') ...[
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
                    ],
                    ...filtered.map((article) => CurrentAffairCard(
                          article: article,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.currentAffairsDetail,
                              arguments: article,
                            );
                          },
                        )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<CurrentAffairsModel> _filterArticles(List<CurrentAffairsModel> list, String category) {
    if (category == 'All') return list;
    return list.where((item) => item.category.toLowerCase() == category.toLowerCase()).toList();
  }
}
