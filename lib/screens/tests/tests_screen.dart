import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../models/test_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/test_card.dart';
import '../../app/routes.dart';

class TestsScreen extends StatefulWidget {
  final bool isTab;

  const TestsScreen({super.key, this.isTab = false});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All Tests',
    'UPSC Prelims',
    'UPSC Mains',
    'CSAT',
    'Subject Tests',
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
        title: 'Mock Examinations & Test Series',
        showBackButton: !widget.isTab,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _categories.map((c) => Tab(text: c)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                final filtered = _filterTests(appState.tests, category);
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    ...filtered.map((test) => TestCard(
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
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<TestModel> _filterTests(List<TestModel> list, String category) {
    if (category == 'All Tests') return list;
    if (category == 'UPSC Prelims') {
      return list.where((t) => t.category.contains('Prelims')).toList();
    }
    if (category == 'UPSC Mains') {
      return list.where((t) => t.category.contains('Mains')).toList();
    }
    if (category == 'CSAT') {
      return list.where((t) => t.category.contains('CSAT')).toList();
    }
    if (category == 'Subject Tests') {
      return list.where((t) => t.category.contains('Subject')).toList();
    }
    return list;
  }
}
