import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../utils/constants.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: appState.selectedNavIndex,
        onDestinationSelected: (index) {
          appState.setNavIndex(index);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: (isDark ? AppColors.secondaryOrange : AppColors.primary)
            .withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.secondaryOrange),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_lesson_outlined),
            selectedIcon: Icon(Icons.play_lesson, color: AppColors.secondaryOrange),
            label: 'Classes',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz, color: AppColors.secondaryOrange),
            label: 'Tests',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum, color: AppColors.secondaryOrange),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.secondaryOrange),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
