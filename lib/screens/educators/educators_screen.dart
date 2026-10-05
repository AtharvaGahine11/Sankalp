import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/educator_card.dart';
import '../../app/routes.dart';

class EducatorsScreen extends StatelessWidget {
  const EducatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mentors & Faculty Directory',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Connect with India\'s distinguished UPSC mentors, constitutional scholars, and civil services examiners.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...MockData.educators.map((ed) => EducatorCard(
                educator: ed,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.educatorProfile,
                    arguments: ed,
                  );
                },
              )),
        ],
      ),
    );
  }
}
