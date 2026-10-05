# 05. System Architecture & State Management — Sankalp

> **Academic Course**: Cross-Platform Application Development (Flutter)  
> **Institution**: ITM Skills University  
> **Topic**: Architecture, State Management, and Data Flow  

---

## 1. Architectural Overview

Sankalp is engineered following the principles of **Layered Clean Architecture**. This ensures separation of concerns, high maintainability, unit-testability, and clarity for academic review:

```
+-------------------------------------------------------------------------+
|                          PRESENTATION LAYER                             |
|  • Screens (35+ screens in lib/screens/)                               |
|  • Atomic Widgets (20 reusable components in lib/widgets/)             |
|  • Navigation & Route Generator (lib/app/routes.dart & app.dart)        |
|  • Material 3 Design System (lib/app/theme.dart)                        |
+------------------------------------+------------------------------------+
                                     |
                                     v
+-------------------------------------------------------------------------+
|                        STATE MANAGEMENT LAYER                           |
|  • AppStateProvider (ChangeNotifier) in lib/services/                   |
|  • Consumers & Selectors bound to Widget Tree                           |
|  • Unidirectional Data Flow (Action -> State Mutation -> notifyListeners)|
+------------------------------------+------------------------------------+
                                     |
                                     v
+-------------------------------------------------------------------------+
|                           SERVICES LAYER                                |
|  • LocalStorageService (SharedPreferences asynchronous persistence)     |
|  • MockAuthService (Validation, Session Simulation)                     |
+------------------------------------+------------------------------------+
                                     |
                                     v
+-------------------------------------------------------------------------+
|                        DATA & DOMAIN LAYER                              |
|  • Strongly-typed Immutable Domain Models (lib/models/)                 |
|  • Mock Data Repositories (lib/data/mock_data.dart)                     |
+-------------------------------------------------------------------------+
```

---

## 2. State Management Architecture: Provider

The application employs **Provider** (`ChangeNotifierProvider` and `Consumer`), the state management solution recommended by the Flutter team and ideal for academic demonstration:

### Unidirectional State Flow
1. **User Action**: The user interacts with the UI (e.g., taps "Toggle Topic Completed" on a syllabus item).
2. **Method Invocation**: The widget dispatches an action to `AppStateProvider.updateTopicStatus(...)`.
3. **State Mutation**: The provider updates its internal collection and synchronizes state to `LocalStorageService`.
4. **Reactivity**: The provider calls `notifyListeners()`.
5. **Re-rendering**: All subscribed `Consumer<AppStateProvider>` widgets re-render selectively without rebuilding unaffected parts of the widget tree.

```
+------------+       User Action        +--------------------+
|   Widget   | -----------------------> |  AppStateProvider  |
+------------+                          +---------+----------+
      ^                                           |
      |             notifyListeners()             | State Mutation
      +-------------------------------------------+
```

---

## 3. Local Persistence Layer

To achieve complete self-containment without external servers or databases, Sankalp uses a dedicated `LocalStorageService` wrapping Flutter's official `shared_preferences` package:

| Storage Key | Data Format | Stored Entities |
|---|---|---|
| `pref_onboarding_completed` | `bool` | Flag tracking if user has viewed onboarding walkthrough. |
| `pref_is_logged_in` | `bool` | Mock authentication session flag. |
| `pref_is_dark_mode` | `bool` | User theme preference (Light vs. Dark). |
| `pref_bookmarks` | `List<String>` | IDs of bookmarked current affairs, courses, and notes. |
| `pref_notes` | `List<String>` (JSON) | Serialized `NoteModel` objects created by the user. |

---

## 4. Entity-Relationship (ER) Domain Model

The data layer consists of 14 strongly typed, immutable Dart models with `copyWith`, `toJson`, and `fromJson` capabilities:

```
+------------------+         +------------------+
|    UserModel     | 1     * |    OrderModel    |
|------------------|---------|------------------|
| id, name, email  |         | orderId, amount  |
| role, targetExam |         | itemType, date   |
+------------------+         +------------------+
        | 1
        |
        | *
+------------------+         +------------------+
|    NoteModel     |         |   CourseModel    |
|------------------|         |------------------|
| id, title        |         | id, title, price |
| subject, content |         | educatorId       |
+------------------+         +------------------+
                                      | 1
                                      |
                                      | *
+------------------+         +------------------+
|  EducatorModel   | 1     * |    ClassModel    |
|------------------|---------|------------------|
| id, name, bio    |         | id, courseId     |
| rating, initials |         | isLive, duration |
+------------------+         +------------------+

+------------------+         +------------------+
| SubjectSyllabus  | 1     * |    TopicItem     |
|------------------|---------|------------------|
| id, subjectName  |         | id, topicName    |
| iconName         |         | status (Enum)    |
+------------------+         +------------------+

+------------------+ 1     * +------------------+
|    TestModel     |---------|  QuestionModel   |
|------------------|         |------------------|
| id, title, marks |         | id, prompt       |
| totalQuestions   |         | options, answer  |
+------------------+         +------------------+
```

---

## 5. Navigation & Routing Architecture

Sankalp utilizes **Named Routing** with a centralized route generator in `lib/app/app.dart`. Over 38 distinct routes are declared in `lib/app/routes.dart`.

To guarantee zero crashes during deep linking or browser URL navigation, every screen route includes fallback argument handling:
```dart
case AppRoutes.courseDetail:
  final course = settings.arguments as CourseModel? ?? MockData.courses.first;
  return MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course));
```
This defensive programming practice ensures that even if a route is triggered without explicit arguments, sensible mock data is gracefully supplied.
