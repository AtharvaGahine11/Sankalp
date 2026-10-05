import 'package:flutter/material.dart';
import '../../services/local_storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/primary_button.dart';
import '../../app/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = const [
    {
      'icon': Icons.school_rounded,
      'title': 'Learn from Expert Educators',
      'description':
          'Access structured live masterclasses, interactive polls, real-time doubt clearing, and recorded archives from India\'s top civil services mentors.',
    },
    {
      'icon': Icons.timer_outlined,
      'title': 'Practice with Smart Test Series',
      'description':
          'Simulate UPSC Prelims and Mains examination conditions with OMR-style evaluation, negative marking penalties, and question-wise diagnostic insights.',
    },
    {
      'icon': Icons.analytics_outlined,
      'title': 'Track Your UPSC Preparation',
      'description':
          'Monitor syllabus completion across GS & CSAT, create highlighted study notes, evaluate 6-year PYQ trends, and crack the Civil Services Exam.',
    },
  ];

  void _finishOnboarding() async {
    await LocalStorageService.setOnboardingCompleted(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _finishOnboarding,
              child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Educational Illustration Placeholder
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                (isDark ? AppColors.secondaryOrange : AppColors.primary).withOpacity(0.15),
                                AppColors.secondaryOrange.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: AppColors.secondaryOrange.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 64,
                            color: isDark ? AppColors.secondaryOrange : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page['title'] as String,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['description'] as String,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicators and Action Buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.secondaryOrange
                              : (isDark ? Colors.white24 : Colors.black12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_currentPage == _pages.length - 1)
                    PrimaryButton(
                      text: 'Get Started with Sankalp',
                      icon: Icons.arrow_forward,
                      backgroundColor: AppColors.secondaryOrange,
                      onPressed: _finishOnboarding,
                    )
                  else
                    PrimaryButton(
                      text: 'Next',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
