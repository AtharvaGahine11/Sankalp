import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/pyq_card.dart';
import '../../app/routes.dart';

class PYQScreen extends StatefulWidget {
  const PYQScreen({super.key});

  @override
  State<PYQScreen> createState() => _PYQScreenState();
}

class _PYQScreenState extends State<PYQScreen> {
  int? _selectedYear;
  String _selectedSubject = 'All';
  String _selectedDifficulty = 'All';

  final List<int> _years = [2025, 2024, 2023, 2022, 2021, 2020];
  final List<String> _subjects = ['All', 'Indian Polity', 'Modern History', 'Physical Geography', 'Indian Economy', 'Environment'];
  final List<String> _difficulties = ['All', 'Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    var filtered = MockData.pyqList;

    if (_selectedYear != null) {
      filtered = filtered.where((p) => p.year == _selectedYear).toList();
    }
    if (_selectedSubject != 'All') {
      filtered = filtered.where((p) => p.subject == _selectedSubject).toList();
    }
    if (_selectedDifficulty != 'All') {
      filtered = filtered.where((p) => p.difficulty == _selectedDifficulty).toList();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Previous Year Questions (PYQs)',
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'PYQ Trends & Analysis',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.pyqAnalysis);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Trends Shortcut Button
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.pyqAnalysis),
                  icon: const Icon(Icons.insights, size: 16),
                  label: const Text('View 6-Year Trends'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 12),

                // Year Filter
                DropdownButton<int?>(
                  value: _selectedYear,
                  hint: const Text('Year', style: TextStyle(fontSize: 12)),
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Years')),
                    ..._years.map((y) => DropdownMenuItem(value: y, child: Text('$y'))),
                  ],
                  onChanged: (v) => setState(() => _selectedYear = v),
                ),
                const SizedBox(width: 12),

                // Subject Filter
                DropdownButton<String>(
                  value: _selectedSubject,
                  underline: const SizedBox(),
                  items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _selectedSubject = v ?? 'All'),
                ),
                const SizedBox(width: 12),

                // Difficulty Filter
                DropdownButton<String>(
                  value: _selectedDifficulty,
                  underline: const SizedBox(),
                  items: _difficulties.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) => setState(() => _selectedDifficulty = v ?? 'All'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    'Showing ${filtered.length} curated UPSC Prelims questions with detailed explanations:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ...filtered.map((pyq) => PYQCard(pyq: pyq)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
