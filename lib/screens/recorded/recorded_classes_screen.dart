import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/live_class_card.dart';
import '../../app/routes.dart';

class RecordedClassesScreen extends StatelessWidget {
  const RecordedClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Recorded Classes & Archive',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Past masterclasses and high-yield topic revisions available for anytime on-demand streaming.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...appState.recordedClasses.map((item) => LiveClassCard(
                classItem: item,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.videoDetail,
                    arguments: item,
                  );
                },
              )),
        ],
      ),
    );
  }
}
