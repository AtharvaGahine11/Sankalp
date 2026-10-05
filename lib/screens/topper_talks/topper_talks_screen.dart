import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/topper_talk_card.dart';
import '../../app/routes.dart';

class TopperTalksScreen extends StatelessWidget {
  const TopperTalksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Topper Talks & Preparation Strategy',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.workspace_premium, color: AppColors.success, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '100% Free Strategy Archive',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.success),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'In-depth interviews and study timelines from UPSC CSE All India Rankers.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...MockData.topperTalks.map((talk) => TopperTalkCard(
                talk: talk,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.topperVideo,
                    arguments: talk,
                  );
                },
              )),
        ],
      ),
    );
  }
}
