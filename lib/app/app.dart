import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../utils/constants.dart';
import 'theme.dart';
import 'routes.dart';

// Models
import '../models/class_model.dart';
import '../models/current_affairs_model.dart';
import '../models/quiz_model.dart';
import '../models/test_model.dart';
import '../models/note_model.dart';
import '../models/discussion_model.dart';
import '../models/educator_model.dart';
import '../models/topic_model.dart';
import '../models/course_model.dart';
import '../models/subscription_model.dart';
import '../models/topper_talk_model.dart';

// Screens
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/live_classes/live_classes_screen.dart';
import '../screens/live_classes/live_class_detail_screen.dart';
import '../screens/recorded/recorded_classes_screen.dart';
import '../screens/recorded/video_detail_screen.dart';
import '../screens/current_affairs/current_affairs_screen.dart';
import '../screens/current_affairs/current_affair_detail_screen.dart';
import '../screens/current_affairs/current_affairs_quiz_screen.dart';
import '../screens/current_affairs/quiz_result_screen.dart';
import '../screens/tests/tests_screen.dart';
import '../screens/tests/test_detail_screen.dart';
import '../screens/tests/test_attempt_screen.dart';
import '../screens/tests/test_result_screen.dart';
import '../screens/tests/test_analysis_screen.dart';
import '../screens/notes/notes_screen.dart';
import '../screens/notes/note_editor_screen.dart';
import '../screens/notes/note_detail_screen.dart';
import '../screens/community/community_screen.dart';
import '../screens/community/discussion_detail_screen.dart';
import '../screens/community/create_discussion_screen.dart';
import '../screens/educators/educators_screen.dart';
import '../screens/educators/educator_profile_screen.dart';
import '../screens/syllabus/syllabus_tracker_screen.dart';
import '../screens/syllabus/topic_detail_screen.dart';
import '../screens/pyq/pyq_screen.dart';
import '../screens/pyq/pyq_analysis_screen.dart';
import '../screens/courses/courses_screen.dart';
import '../screens/courses/course_detail_screen.dart';
import '../screens/subscription/subscription_screen.dart';
import '../screens/subscription/checkout_screen.dart';
import '../screens/subscription/payment_success_screen.dart';
import '../screens/topper_talks/topper_talks_screen.dart';
import '../screens/topper_talks/topper_video_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/settings_screen.dart';

// Mock data fallback
import '../data/mock_data.dart';

class SankalpApp extends StatelessWidget {
  const SankalpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.splash:
                return MaterialPageRoute(builder: (_) => const SplashScreen());

              case AppRoutes.onboarding:
                return MaterialPageRoute(builder: (_) => const OnboardingScreen());

              case AppRoutes.login:
                return MaterialPageRoute(builder: (_) => const LoginScreen());

              case AppRoutes.signup:
                return MaterialPageRoute(builder: (_) => const SignupScreen());

              case AppRoutes.home:
                return MaterialPageRoute(builder: (_) => const HomeScreen());

              case AppRoutes.liveClasses:
                return MaterialPageRoute(builder: (_) => const LiveClassesScreen());

              case AppRoutes.liveClassDetail:
                final item = settings.arguments is ClassModel
                    ? settings.arguments as ClassModel
                    : MockData.liveClasses.first;
                return MaterialPageRoute(builder: (_) => LiveClassDetailScreen(classItem: item));

              case AppRoutes.recorded:
                return MaterialPageRoute(builder: (_) => const RecordedClassesScreen());

              case AppRoutes.videoDetail:
                final item = settings.arguments is ClassModel
                    ? settings.arguments as ClassModel
                    : MockData.recordedClasses.first;
                return MaterialPageRoute(builder: (_) => VideoDetailScreen(classItem: item));

              case AppRoutes.currentAffairs:
                return MaterialPageRoute(builder: (_) => const CurrentAffairsScreen());

              case AppRoutes.currentAffairsDetail:
                final article = settings.arguments is CurrentAffairsModel
                    ? settings.arguments as CurrentAffairsModel
                    : MockData.currentAffairs.first;
                return MaterialPageRoute(builder: (_) => CurrentAffairDetailScreen(article: article));

              case AppRoutes.quiz:
                final quiz = settings.arguments is QuizModel
                    ? settings.arguments as QuizModel
                    : MockData.todayQuiz;
                return MaterialPageRoute(builder: (_) => CurrentAffairsQuizScreen(quiz: quiz));

              case AppRoutes.quizResult:
                final res = settings.arguments as QuizResultModel;
                return MaterialPageRoute(builder: (_) => QuizResultScreen(result: res));

              case AppRoutes.tests:
                return MaterialPageRoute(builder: (_) => const TestsScreen());

              case AppRoutes.testDetail:
                final test = settings.arguments is TestModel
                    ? settings.arguments as TestModel
                    : MockData.tests.first;
                return MaterialPageRoute(builder: (_) => TestDetailScreen(test: test));

              case AppRoutes.testAttempt:
                final test = settings.arguments is TestModel
                    ? settings.arguments as TestModel
                    : MockData.tests.first;
                return MaterialPageRoute(builder: (_) => TestAttemptScreen(test: test));

              case AppRoutes.testResult:
                final res = settings.arguments as TestResultModel;
                return MaterialPageRoute(builder: (_) => TestResultScreen(result: res));

              case AppRoutes.testAnalysis:
                final arg = settings.arguments ?? MockData.tests.first;
                return MaterialPageRoute(builder: (_) => TestAnalysisScreen(testOrResult: arg));

              case AppRoutes.notes:
                return MaterialPageRoute(builder: (_) => const NotesScreen());

              case AppRoutes.noteEditor:
                return MaterialPageRoute(
                  builder: (_) => NoteEditorScreen(initialNoteOrData: settings.arguments),
                );

              case AppRoutes.noteDetail:
                final note = settings.arguments is NoteModel
                    ? settings.arguments as NoteModel
                    : MockData.initialNotes.first;
                return MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note));

              case AppRoutes.community:
                return MaterialPageRoute(builder: (_) => const CommunityScreen());

              case AppRoutes.discussionDetail:
                final disc = settings.arguments is DiscussionModel
                    ? settings.arguments as DiscussionModel
                    : MockData.initialDiscussions.first;
                return MaterialPageRoute(builder: (_) => DiscussionDetailScreen(discussion: disc));

              case AppRoutes.createDiscussion:
                return MaterialPageRoute(builder: (_) => const CreateDiscussionScreen());

              case AppRoutes.educators:
                return MaterialPageRoute(builder: (_) => const EducatorsScreen());

              case AppRoutes.educatorProfile:
                final ed = settings.arguments is EducatorModel
                    ? settings.arguments as EducatorModel
                    : MockData.educators.first;
                return MaterialPageRoute(builder: (_) => EducatorProfileScreen(educator: ed));

              case AppRoutes.syllabus:
                return MaterialPageRoute(builder: (_) => const SyllabusTrackerScreen());

              case AppRoutes.topicDetail:
                final subj = settings.arguments is SubjectSyllabus
                    ? settings.arguments as SubjectSyllabus
                    : MockData.initialSyllabus.first;
                return MaterialPageRoute(builder: (_) => TopicDetailScreen(subject: subj));

              case AppRoutes.pyq:
                return MaterialPageRoute(builder: (_) => const PYQScreen());

              case AppRoutes.pyqAnalysis:
                return MaterialPageRoute(builder: (_) => const PYQAnalysisScreen());

              case AppRoutes.courses:
                return MaterialPageRoute(builder: (_) => const CoursesScreen());

              case AppRoutes.courseDetail:
                final course = settings.arguments is CourseModel
                    ? settings.arguments as CourseModel
                    : MockData.courses.first;
                return MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course));

              case AppRoutes.subscription:
                return MaterialPageRoute(builder: (_) => const SubscriptionScreen());

              case AppRoutes.checkout:
                final data = settings.arguments is Map<String, dynamic>
                    ? settings.arguments as Map<String, dynamic>
                    : <String, dynamic>{
                        'itemName': 'Sankalp PLUS Subscription',
                        'itemType': 'plus_subscription',
                        'price': 24999,
                        'originalPrice': 49999,
                      };
                return MaterialPageRoute(builder: (_) => CheckoutScreen(checkoutData: data));

              case AppRoutes.paymentSuccess:
                final order = settings.arguments as OrderModel;
                return MaterialPageRoute(builder: (_) => PaymentSuccessScreen(order: order));

              case AppRoutes.topperTalks:
                return MaterialPageRoute(builder: (_) => const TopperTalksScreen());

              case AppRoutes.topperVideo:
                final talk = settings.arguments is TopperTalkModel
                    ? settings.arguments as TopperTalkModel
                    : MockData.topperTalks.first;
                return MaterialPageRoute(builder: (_) => TopperVideoScreen(talk: talk));

              case AppRoutes.profile:
                return MaterialPageRoute(builder: (_) => const ProfileScreen());

              case AppRoutes.editProfile:
                return MaterialPageRoute(builder: (_) => const EditProfileScreen());

              case AppRoutes.settings:
                return MaterialPageRoute(builder: (_) => const SettingsScreen());

              default:
                return MaterialPageRoute(builder: (_) => const HomeScreen());
            }
          },
        );
      },
    );
  }
}

/// Backwards-compatibility alias for the root application widget.
typedef CivilEdgeApp = SankalpApp;
