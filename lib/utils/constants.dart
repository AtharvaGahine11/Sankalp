import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF0D1B2A); // Deep Navy
  static const Color primaryLight = Color(0xFF1B263B);
  static const Color primaryDark = Color(0xFF070D14);
  
  // Secondary / Accent Colors
  static const Color secondary = Color(0xFFE07A5F); // Warm Saffron / Terracotta
  static const Color secondaryLight = Color(0xFFF4A261);
  static const Color secondaryOrange = Color(0xFFFF7A00); // Vibrant Accent
  
  // Functional Colors
  static const Color success = Color(0xFF2A9D8F); // Forest Green
  static const Color warning = Color(0xFFE9C46A); // Warm Amber
  static const Color error = Color(0xFFE63946);   // Red
  static const Color info = Color(0xFF3A86FF);    // Blue
  
  // Neutral Colors (Light Mode)
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1B1B1E);
  static const Color textSecondaryLight = Color(0xFF6C757D);
  static const Color borderLight = Color(0xFFE9ECEF);
  static const Color dividerLight = Color(0xFFDEE2E6);

  // Neutral Colors (Dark Mode)
  static const Color backgroundDark = Color(0xFF0B131F);
  static const Color surfaceDark = Color(0xFF152238);
  static const Color cardDark = Color(0xFF1C2C48);
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textSecondaryDark = Color(0xFFADB5BD);
  static const Color borderDark = Color(0xFF263A5C);
  static const Color dividerDark = Color(0xFF1F304E);

  // Badges & Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF7A00), Color(0xFFE07A5F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient plusBadgeGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppConstants {
  static const String appName = 'Sankalp';
  static const String appTagline = 'Prepare Smarter. Serve Better.';
  static const String appVersion = '1.0.0';
  
  // Academic Context
  static const String universityName = 'ITM Skills University';
  static const String courseName = 'B.Tech CSE & AI - Semester V';
  static const String subjectName = 'Cross Platform Application Development - Flutter';
  static const String projectCaseStudy = 'Case Study 125: UPSC Preparation Platform';

  // Demo User Defaults
  static const String demoUserName = 'Atharva Suryawanshi';
  static const String demoUserEmail = 'atharva@example.com';
  static const String demoUserRole = 'UPSC Aspirant (Target: CSE 2027)';
  static const String demoStudyTime = '24h 35m';
  static const int demoQuestionsSolved = 1248;
  static const int demoTestsCompleted = 18;
  static const double demoSyllabusCompletion = 0.68;
  static const int demoStreakDays = 12;

  // Subscription Pricing (Per Case Study)
  static const int plusSubscriptionPrice = 24999;
  static const int testSeriesOnlyPrice = 4999;
  static const int individualCourseBasePrice = 2499;

  // Shared Preferences Keys
  static const String prefOnboardingCompleted = 'pref_onboarding_completed';
  static const String prefIsLoggedIn = 'pref_is_logged_in';
  static const String prefUserName = 'pref_user_name';
  static const String prefUserEmail = 'pref_user_email';
  static const String prefIsDarkMode = 'pref_is_dark_mode';
  static const String prefBookmarks = 'pref_bookmarks';
  static const String prefSyllabusProgress = 'pref_syllabus_progress';
  static const String prefNotes = 'pref_notes';
}
