import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:civiledge/app/app.dart';
import 'package:civiledge/services/app_state_provider.dart';
import 'package:civiledge/services/local_storage_service.dart';
import 'package:civiledge/models/topic_model.dart';
import 'package:civiledge/screens/onboarding/splash_screen.dart';
import 'package:civiledge/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefOnboardingCompleted: true,
      AppConstants.prefIsLoggedIn: true,
    });
    await LocalStorageService.init();
  });

  group('Sankalp App Smoke & Widget Tests', () {
    testWidgets('App renders splash screen without crashing', (WidgetTester tester) async {
      final provider = AppStateProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateProvider>.value(
          value: provider,
          child: const SankalpApp(),
        ),
      );

      // Verify that SplashScreen and its elements are present
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text(AppConstants.appTagline), findsOneWidget);

      // Advance timer so splash transition completes cleanly without pending timers
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });

  group('AppStateProvider Unit Tests', () {
    test('Initial collections load correctly', () {
      final provider = AppStateProvider();
      expect(provider.courses.isNotEmpty, true);
      expect(provider.liveClasses.isNotEmpty, true);
      expect(provider.recordedClasses.isNotEmpty, true);
      expect(provider.currentAffairs.isNotEmpty, true);
      expect(provider.tests.isNotEmpty, true);
      expect(provider.notes.isNotEmpty, true);
      expect(provider.syllabus.isNotEmpty, true);
      expect(provider.discussions.isNotEmpty, true);
    });

    test('Add, update, and delete note in Provider', () {
      final provider = AppStateProvider();
      final initialCount = provider.notes.length;

      provider.addNote(
        title: 'Fundamental Rights Summary',
        subject: 'Indian Polity',
        topic: 'Part III Articles 12-35',
        content: 'Right to Equality (Articles 14-18), Right to Freedom (Articles 19-22).',
      );

      expect(provider.notes.length, initialCount + 1);
      final createdNote = provider.notes.first;
      expect(createdNote.title, 'Fundamental Rights Summary');

      final updatedNote = createdNote.copyWith(title: 'Fundamental Rights - Revised');
      provider.updateNote(updatedNote);
      expect(provider.notes.first.title, 'Fundamental Rights - Revised');

      provider.deleteNote(createdNote.id);
      expect(provider.notes.length, initialCount);
    });

    test('Toggle bookmark updates state correctly', () {
      final provider = AppStateProvider();
      const testId = 'ca_test_bookmark_101';

      expect(provider.isItemBookmarked(testId), false);
      provider.toggleBookmark(testId);
      expect(provider.isItemBookmarked(testId), true);
      provider.toggleBookmark(testId);
      expect(provider.isItemBookmarked(testId), false);
    });

    test('Topic status update modifies syllabus completion status', () {
      final provider = AppStateProvider();
      final subject = provider.syllabus.first;
      final topic = subject.topics.first;

      // Update topic status to inProgress
      provider.updateTopicStatus(subject.id, topic.id, TopicStatus.inProgress);
      var updatedSubject = provider.syllabus.firstWhere((s) => s.id == subject.id);
      var updatedTopic = updatedSubject.topics.firstWhere((t) => t.id == topic.id);
      expect(updatedTopic.status, TopicStatus.inProgress);

      // Update topic status to completed
      provider.updateTopicStatus(subject.id, topic.id, TopicStatus.completed);
      updatedSubject = provider.syllabus.firstWhere((s) => s.id == subject.id);
      updatedTopic = updatedSubject.topics.firstWhere((t) => t.id == topic.id);
      expect(updatedTopic.status, TopicStatus.completed);
    });

    test('Case study pricing constants are correctly configured', () {
      expect(AppConstants.plusSubscriptionPrice, 24999);
      expect(AppConstants.testSeriesOnlyPrice, 4999);
      expect(AppConstants.individualCourseBasePrice, 2499);
    });
  });
}
