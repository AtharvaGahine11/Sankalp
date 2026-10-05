import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../models/class_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/live_class_card.dart';
import '../../app/routes.dart';

class LiveClassesScreen extends StatefulWidget {
  final bool isTab;

  const LiveClassesScreen({super.key, this.isTab = false});

  @override
  State<LiveClassesScreen> createState() => _LiveClassesScreenState();
}

class _LiveClassesScreenState extends State<LiveClassesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['All', 'GS', 'CSAT', 'Optional', 'Current Affairs'];

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
        title: 'Live & Scheduled Classes',
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
                final filtered = _filterClasses(appState.liveClasses, category);
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    // Switch to Recorded Archive Banner
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.recorded);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withOpacity(0.2)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.video_library, color: Colors.blue, size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Looking for past classes? Browse Recorded Archives',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...filtered.map((item) => LiveClassCard(
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
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<ClassModel> _filterClasses(List<ClassModel> list, String category) {
    if (category == 'All') return list;
    if (category == 'GS') {
      return list.where((c) => c.subject.contains('Polity') || c.subject.contains('History') || c.subject.contains('Economy')).toList();
    }
    if (category == 'CSAT') {
      return list.where((c) => c.subject.contains('CSAT')).toList();
    }
    if (category == 'Optional') {
      return list.where((c) => c.subject.contains('Optional') || c.subject.contains('Geography')).toList();
    }
    if (category == 'Current Affairs') {
      return list.where((c) => c.subject.contains('Current') || c.subject.contains('Environment')).toList();
    }
    return list;
  }
}
