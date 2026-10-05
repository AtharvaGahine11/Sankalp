import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/class_model.dart';
import '../models/current_affairs_model.dart';
import '../models/test_model.dart';
import '../models/quiz_model.dart';
import '../models/note_model.dart';
import '../models/discussion_model.dart';
import '../models/topic_model.dart';
import '../models/subscription_model.dart';
import '../data/mock_data.dart';
import 'local_storage_service.dart';

class AppStateProvider extends ChangeNotifier {
  // Navigation
  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  // Theme
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // User
  UserModel _user = MockData.demoUser;
  UserModel get user => _user;

  // Data Collections
  List<CourseModel> _courses = List.from(MockData.courses);
  final List<ClassModel> _liveClasses = List.from(MockData.liveClasses);
  final List<ClassModel> _recordedClasses = List.from(MockData.recordedClasses);
  final List<CurrentAffairsModel> _currentAffairs = List.from(MockData.currentAffairs);
  final List<TestModel> _tests = List.from(MockData.tests);
  List<NoteModel> _notes = List.from(MockData.initialNotes);
  final List<DiscussionModel> _discussions = List.from(MockData.initialDiscussions);
  final List<SubjectSyllabus> _syllabus = List.from(MockData.initialSyllabus);
  final List<Map<String, dynamic>> _notifications = List.from(MockData.notifications);
  final List<OrderModel> _orders = [];

  // Bookmarks (Set of item IDs)
  Set<String> _bookmarkedIds = {};
  Set<String> get bookmarkedIds => _bookmarkedIds;

  // Active Results
  QuizResultModel? _lastQuizResult;
  QuizResultModel? get lastQuizResult => _lastQuizResult;

  TestResultModel? _lastTestResult;
  TestResultModel? get lastTestResult => _lastTestResult;

  // Getters
  List<CourseModel> get courses => _courses;
  List<ClassModel> get liveClasses => _liveClasses;
  List<ClassModel> get recordedClasses => _recordedClasses;
  List<CurrentAffairsModel> get currentAffairs => _currentAffairs;
  List<TestModel> get tests => _tests;
  List<NoteModel> get notes => _notes;
  List<DiscussionModel> get discussions => _discussions;
  List<SubjectSyllabus> get syllabus => _syllabus;
  List<Map<String, dynamic>> get notifications => _notifications;
  List<OrderModel> get orders => _orders;

  int get unreadNotificationCount =>
      _notifications.where((n) => n['isRead'] == false).length;

  double get overallSyllabusProgress {
    int total = 0;
    int completed = 0;
    for (var subj in _syllabus) {
      total += subj.totalTopics;
      completed += subj.completedTopics;
    }
    return total == 0 ? 0.0 : (completed / total);
  }

  AppStateProvider() {
    _initFromStorage();
  }

  void _initFromStorage() {
    _isDarkMode = LocalStorageService.isDarkMode();
    _bookmarkedIds = Set.from(LocalStorageService.getBookmarks());
    final loadedNotes = LocalStorageService.getNotes();
    if (loadedNotes.isNotEmpty) {
      _notes = loadedNotes;
    }
  }

  // Navigation setter
  void setNavIndex(int index) {
    if (_selectedNavIndex != index) {
      _selectedNavIndex = index;
      notifyListeners();
    }
  }

  // Theme Toggle
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    LocalStorageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  // User Profile
  void updateUserProfile({
    String? name,
    String? email,
    String? role,
    String? targetExam,
  }) {
    _user = _user.copyWith(
      name: name,
      email: email,
      role: role,
      targetExam: targetExam,
    );
    notifyListeners();
  }

  // Bookmarking
  bool isItemBookmarked(String id) => _bookmarkedIds.contains(id);

  void toggleBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    LocalStorageService.setBookmarks(_bookmarkedIds.toList());
    notifyListeners();
  }

  // Current Affairs Highlighting
  void toggleHighlightCurrentAffair(String id) {
    final idx = _currentAffairs.indexWhere((item) => item.id == id);
    if (idx != -1) {
      final item = _currentAffairs[idx];
      _currentAffairs[idx] = item.copyWith(isHighlighted: !item.isHighlighted);
      notifyListeners();
    }
  }

  // Notes Management
  void addNote({
    required String title,
    required String subject,
    required String topic,
    required String content,
  }) {
    final newNote = NoteModel(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subject: subject,
      topic: topic,
      content: content,
      createdAt: DateTime.now(),
    );
    _notes.insert(0, newNote);
    LocalStorageService.saveNotes(_notes);
    notifyListeners();
  }

  void updateNote(NoteModel updatedNote) {
    final idx = _notes.indexWhere((n) => n.id == updatedNote.id);
    if (idx != -1) {
      _notes[idx] = updatedNote;
      LocalStorageService.saveNotes(_notes);
      notifyListeners();
    }
  }

  void deleteNote(String noteId) {
    _notes.removeWhere((n) => n.id == noteId);
    _bookmarkedIds.remove(noteId);
    LocalStorageService.saveNotes(_notes);
    LocalStorageService.setBookmarks(_bookmarkedIds.toList());
    notifyListeners();
  }

  void toggleNoteHighlight(String noteId) {
    final idx = _notes.indexWhere((n) => n.id == noteId);
    if (idx != -1) {
      _notes[idx] = _notes[idx].copyWith(isHighlighted: !_notes[idx].isHighlighted);
      LocalStorageService.saveNotes(_notes);
      notifyListeners();
    }
  }

  // Syllabus Topic State Tracking
  void updateTopicStatus(String subjectId, String topicId, TopicStatus newStatus) {
    final sIdx = _syllabus.indexWhere((s) => s.id == subjectId);
    if (sIdx != -1) {
      final subj = _syllabus[sIdx];
      final tIdx = subj.topics.indexWhere((t) => t.id == topicId);
      if (tIdx != -1) {
        final updatedTopics = List<TopicItem>.from(subj.topics);
        updatedTopics[tIdx] = updatedTopics[tIdx].copyWith(status: newStatus);
        _syllabus[sIdx] = subj.copyWith(topics: updatedTopics);
        
        // update user's overall progress stat
        _user = _user.copyWith(syllabusProgress: overallSyllabusProgress);
        notifyListeners();
      }
    }
  }

  // Community Management
  void addDiscussion({
    required String title,
    required String category,
    required String content,
  }) {
    final newDiscussion = DiscussionModel(
      id: 'disc_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      content: content,
      authorName: _user.name,
      authorRole: _user.role,
      timeAgo: 'Just now',
      likes: 1,
      isLikedByMe: true,
      replies: [],
    );
    _discussions.insert(0, newDiscussion);
    notifyListeners();
  }

  void toggleDiscussionLike(String discussionId) {
    final idx = _discussions.indexWhere((d) => d.id == discussionId);
    if (idx != -1) {
      final disc = _discussions[idx];
      final isLiked = disc.isLikedByMe;
      _discussions[idx] = disc.copyWith(
        isLikedByMe: !isLiked,
        likes: isLiked ? disc.likes - 1 : disc.likes + 1,
      );
      notifyListeners();
    }
  }

  void addDiscussionReply(String discussionId, String content) {
    final idx = _discussions.indexWhere((d) => d.id == discussionId);
    if (idx != -1) {
      final disc = _discussions[idx];
      final newReply = DiscussionReply(
        id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
        authorName: _user.name,
        authorRole: _user.role,
        content: content,
        timeAgo: 'Just now',
        likes: 0,
      );
      _discussions[idx] = disc.copyWith(
        replies: [...disc.replies, newReply],
      );
      notifyListeners();
    }
  }

  // Quiz Execution Result
  void saveQuizResult(QuizResultModel result) {
    _lastQuizResult = result;
    _user = _user.copyWith(
      questionsSolved: _user.questionsSolved + result.totalQuestions,
    );
    notifyListeners();
  }

  // Test Execution Result
  void saveTestResult(TestResultModel result) {
    _lastTestResult = result;
    
    // Mark test as completed in test list
    final idx = _tests.indexWhere((t) => t.id == result.testId);
    if (idx != -1) {
      _tests[idx] = _tests[idx].copyWith(
        isCompleted: true,
        previousScore: result.score,
      );
    }

    _user = _user.copyWith(
      questionsSolved: _user.questionsSolved + result.totalQuestions,
      testsCompleted: _user.testsCompleted + 1,
    );
    notifyListeners();
  }

  // Course / Subscription Unlocking
  void unlockCourse(String courseId) {
    final idx = _courses.indexWhere((c) => c.id == courseId);
    if (idx != -1) {
      _courses[idx] = _courses[idx].copyWith(isUnlocked: true);
      notifyListeners();
    }
  }

  void recordOrder(OrderModel order) {
    _orders.insert(0, order);
    if (order.itemType == 'plus_subscription') {
      _user = _user.copyWith(isPlusMember: true);
      // unlock all courses
      _courses = _courses.map((c) => c.copyWith(isUnlocked: true)).toList();
    } else if (order.itemType == 'course') {
      final courseMatch = _courses.firstWhere(
        (c) => c.title == order.itemName,
        orElse: () => _courses.first,
      );
      unlockCourse(courseMatch.id);
    }
    notifyListeners();
  }

  // Notifications
  void markNotificationAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n['id'] == id);
    if (idx != -1) {
      _notifications[idx]['isRead'] = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n['isRead'] = true;
    }
    notifyListeners();
  }
}
