import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../models/course_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/course_card.dart';
import '../../app/routes.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'GS Foundation',
    'Prelims',
    'Mains',
    'CSAT',
    'Current Affairs',
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
        title: 'UPSC CSE Courses & Masterclasses',
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
              children: _categories.map((cat) {
                final filtered = _filterCourses(appState.courses, cat);

                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    ...filtered.map((c) => CourseCard(
                          course: c,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.courseDetail,
                              arguments: c,
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

  List<CourseModel> _filterCourses(List<CourseModel> list, String category) {
    if (category == 'All') return list;
    return list.where((c) => c.category.toLowerCase() == category.toLowerCase()).toList();
  }
}
