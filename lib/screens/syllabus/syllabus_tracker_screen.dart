import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/topic_progress_card.dart';
import '../../utils/constants.dart';
import '../../app/routes.dart';

class SyllabusTrackerScreen extends StatelessWidget {
  const SyllabusTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final overallPct = (appState.overallSyllabusProgress * 100).toInt();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'UPSC Syllabus Completion Tracker',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Overall Completion Metric Header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
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
                          color: AppColors.secondaryOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CSE 2027 TARGET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Overall Syllabus Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '8 UPSC Prelims & Mains subjects tracked',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 68,
                      height: 68,
                      child: CircularProgressIndicator(
                        value: appState.overallSyllabusProgress,
                        strokeWidth: 7,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryOrange),
                      ),
                    ),
                    Text(
                      '$overallPct%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Tap any subject to view detailed chapter modules and mark topic milestones:',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Subjects List
          ...appState.syllabus.map((subj) => TopicProgressCard(
                subject: subj,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.topicDetail,
                    arguments: subj,
                  );
                },
              )),
        ],
      ),
    );
  }
}
