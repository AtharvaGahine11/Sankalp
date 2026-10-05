import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';

class PYQAnalysisScreen extends StatelessWidget {
  const PYQAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: '6-Year PYQ Weightage Trends',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UPSC CSE PRELIMS (2020 - 2025)',
                    style: TextStyle(
                      color: AppColors.secondaryOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Historical Topic & Subject Weightage',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Analyze question frequency across six years to prioritize your preparation hours smartly.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Frequently Asked High-Yield Topics
            const Text(
              'Top High-Yield Sub-Topics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...MockData.pyqTopicWeightage.map((tw) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            tw.topicName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        Text(
                          '${tw.percentage}% (${tw.questionsCount} Qs)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Core Subject: ${tw.subject}',
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: tw.percentage / 25,
                        minHeight: 6,
                        backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryOrange),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Difficulty Distribution
            const Text(
              'Historical Difficulty Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDifficultyStatCard(
                    'Easy',
                    '28%',
                    'Direct NCERT & standard book facts',
                    AppColors.success,
                    theme,
                    isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDifficultyStatCard(
                    'Medium',
                    '48%',
                    'Analytical application & elimination',
                    AppColors.warning,
                    theme,
                    isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDifficultyStatCard(
                    'Hard',
                    '24%',
                    'Specialized current affairs & treaties',
                    AppColors.error,
                    theme,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Year-Wise Subject Question Count Table
            const Text(
              'Year-Wise Question Trend (2020 - 2025)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 18,
                  headingRowColor: MaterialStateProperty.all(
                    (isDark ? AppColors.primaryDark : AppColors.primary).withOpacity(0.08),
                  ),
                  columns: const [
                    DataColumn(label: Text('Year', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Polity', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('History', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Geog', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Economy', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Env', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Sci & Tech', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: MockData.pyqYearTrends.map((yt) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${yt.year}', style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text('${yt.polity}')),
                        DataCell(Text('${yt.history}')),
                        DataCell(Text('${yt.geography}')),
                        DataCell(Text('${yt.economy}')),
                        DataCell(Text('${yt.environment}')),
                        DataCell(Text('${yt.science}')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyStatCard(
    String label,
    String pct,
    String desc,
    Color color,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(pct, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
