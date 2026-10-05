import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _classReminders = true;
  bool _dailyQuizAlert = true;
  String _selectedLanguage = 'English (India)';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings & Preferences',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildCategoryHeader('APPEARANCE & THEME'),
          SwitchListTile(
            title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text(
              'Switch between daylight and midnight dark theme for night study sessions.',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            value: appState.isDarkMode,
            activeColor: AppColors.secondaryOrange,
            onChanged: (val) => appState.toggleTheme(),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const Divider(),

          _buildCategoryHeader('NOTIFICATIONS & ALERTS'),
          SwitchListTile(
            title: const Text('Live Class Reminders', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: const Text('Notify 30 minutes before educator goes live', style: TextStyle(fontSize: 12)),
            value: _classReminders,
            activeColor: AppColors.secondaryOrange,
            onChanged: (val) => setState(() => _classReminders = val),
          ),
          SwitchListTile(
            title: const Text('Daily Current Affairs Digest', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: const Text('Morning notification with daily editorial digest', style: TextStyle(fontSize: 12)),
            value: _pushNotifications,
            activeColor: AppColors.secondaryOrange,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          SwitchListTile(
            title: const Text('Daily Quiz Milestone', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: const Text('Reminders to maintain your 12-day study streak', style: TextStyle(fontSize: 12)),
            value: _dailyQuizAlert,
            activeColor: AppColors.secondaryOrange,
            onChanged: (val) => setState(() => _dailyQuizAlert = val),
          ),
          const Divider(),

          _buildCategoryHeader('PREFERENCES & LANGUAGE'),
          ListTile(
            title: const Text('Language / Medium', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text(_selectedLanguage, style: const TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          const Divider(),

          _buildCategoryHeader('LEGAL & ABOUT'),
          ListTile(
            title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              _showTextDialog(
                context,
                'Privacy Policy',
                'Sankalp adheres to student data privacy principles. In this academic case study for ITM Skills University, mock local data is stored exclusively on the user device via SharedPreferences. No private data is transmitted to external servers without explicit consent.',
              );
            },
          ),
          ListTile(
            title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              _showTextDialog(
                context,
                'Terms of Service',
                'Sankalp is a specialized educational application built for UPSC aspirants as part of B.Tech CSE Semester V Cross Platform Application Development. All mock exams, test evaluations, notes, and course modules are designed for academic simulation purposes.',
              );
            },
          ),
          ListTile(
            title: const Text('About Sankalp & Case Study', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: const Text('Version 1.0.0 • Academic Build', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.info_outline, size: 20),
            onTap: () {
              _showTextDialog(
                context,
                'About Sankalp',
                'Sankalp ("Prepare Smarter. Serve Better.")\n\nDeveloped for: B.Tech Computer Science Engineering & AI (Semester V)\nSubject: Cross Platform Application Development - Flutter\nInstitution: ITM Skills University\nStudent: Atharva Suryawanshi\nCase Study 125: Specialized EdTech application for Civil Services Preparation.',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Examination Medium'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              value: 'English (India)',
              groupValue: _selectedLanguage,
              title: const Text('English (India)'),
              onChanged: (v) {
                setState(() => _selectedLanguage = v!);
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<String>(
              value: 'Hindi (हिन्दी)',
              groupValue: _selectedLanguage,
              title: const Text('Hindi (हिन्दी)'),
              onChanged: (v) {
                setState(() => _selectedLanguage = v!);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTextDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content, style: const TextStyle(fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
