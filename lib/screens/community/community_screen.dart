import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../models/discussion_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/discussion_card.dart';
import '../../widgets/empty_state.dart';
import '../../app/routes.dart';

class CommunityScreen extends StatefulWidget {
  final bool isTab;

  const CommunityScreen({super.key, this.isTab = false});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'General Discussion',
    'Prelims',
    'Mains',
    'Optional',
    'Current Affairs',
    'Strategy',
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
      appBar: CustomAppBar(
        title: 'UPSC Community Forum',
        showBackButton: !widget.isTab,
      ),
      body: Column(
        children: [
          // Subheader Info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aspirants & Faculty Discussions',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ask questions, share strategies, and get educator feedback',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.createDiscussion);
                  },
                  icon: const Icon(Icons.add_comment, size: 16),
                  label: const Text('Post', style: TextStyle(fontSize: 12)),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _categories.map((c) => Tab(text: c)).toList(),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((cat) {
                final filtered = _filterDiscussions(appState.discussions, cat);

                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.forum_outlined,
                    title: 'No discussions yet in $cat',
                    message: 'Start the conversation and connect with fellow civil service aspirants.',
                    buttonText: 'Ask a Question',
                    onButtonPressed: () {
                      Navigator.pushNamed(context, AppRoutes.createDiscussion);
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return DiscussionCard(
                      discussion: item,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.discussionDetail,
                          arguments: item,
                        );
                      },
                      onLikeToggle: () => appState.toggleDiscussionLike(item.id),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createDiscussion);
        },
        backgroundColor: AppColors.secondaryOrange,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  List<DiscussionModel> _filterDiscussions(List<DiscussionModel> list, String category) {
    if (category == 'All') return list;
    return list.where((d) => d.category.toLowerCase() == category.toLowerCase()).toList();
  }
}
