# Sankalp — UPSC CSE Preparation Platform

> **"Prepare Smarter. Serve Better."**  
> Complete Cross-Platform Mobile Application built with Flutter & Dart.  
> Developed for **ITM Skills University — B.Tech Computer Science & AI (Semester V)**.  
> **Case Study 125**: Full-Scale EdTech UPSC Preparation Platform.

---

## 🌟 Executive Summary

**Sankalp** is a comprehensive, production-grade UPSC Civil Services Examination (CSE) preparation platform inspired by leading Indian EdTech architectures. It empowers aspirants across India with live interactive classes, on-demand video libraries, daily editorial digests & current affairs quizzes, a full-length All-India Mock Test Series with an interactive OMR sheet and diagnostic analytics, a digital notebook with local persistence, a peer community forum, and an interactive UPSC syllabus completion tracker.

The entire codebase is implemented cleanly in **pure Flutter + Dart** following clean architecture and **Provider** state management. It runs entirely self-contained with offline/mock persistence (via `shared_preferences`), requiring zero external cloud dependencies to run or demonstrate during an academic viva.

---

## 🏛️ Academic Metadata

| Attribute | Details |
|---|---|
| **Institution** | ITM Skills University |
| **Program** | B.Tech Computer Science Engineering & Artificial Intelligence |
| **Semester** | Semester V (Academic Year 2026-2027) |
| **Subject** | Cross-Platform Application Development (Flutter) |
| **Case Study** | Case Study 125 — EdTech Civil Services Examination Platform |
| **Candidate** | Atharva Suryawanshi |
| **Framework** | Flutter 3.47+ (Dart 3.13+) |
| **Architecture** | Layered Architecture (Presentation, State Management, Data/Models, Services) |
| **State Management**| Provider (`ChangeNotifier`, `ChangeNotifierProvider`, `Consumer`) |
| **Local Storage** | `shared_preferences` (JSON Serialization for Notes, Bookmarks & State) |

---

## 📱 Core Features & Modules

### 1. Onboarding & Authentication
- **Animated Splash Screen**: Brand emblem, tagline, and animated entrance.
- **Onboarding Carousel**: 3 value-proposition slides highlighting Live Classes, Mock Tests, and Syllabus Tracking.
- **Mock Authentication**: Form validation (Email + Password) with pre-filled demo account (`atharva@example.com` / `password123`).

### 2. Home Dashboard & Bottom Navigation
- **5 Core Tabs**: Home, Live, Tests, Current Affairs, and Profile.
- **Dynamic Search Bar**: Instant real-time filtering of courses, lectures, and mock tests.
- **Daily Study Streak & Target Tracker**: Gamified 12-day streak counter and target year indicator (Target: CSE 2027).
- **Quick Action Grid**: 1-tap shortcuts to Syllabus Tracker, PYQs (2020-2025), Topper Talks, Community, and Digital Notes.
- **Interactive Carousels**: Featured UPSC courses, upcoming live lectures, top educator profiles, and value banners.

### 3. Live & Recorded Classes
- **Live Classroom Simulation**: Mock video streaming player with Live/Upcoming/Ended status tags.
- **Real-Time Live Chat**: Interactive student chat stream with instant question submission.
- **Live Polls**: Real-time multiple-choice poll with instant percentage breakdown and explanation.
- **Doubts Tab**: Dedicated question submission queue for educator review.
- **Recorded Class Detail**: Video playback scrubber (play/pause, seek, 1.25x/1.5x speed toggle, PDF lecture notes download).

### 4. Daily Current Affairs & Editorial Analysis
- **Categorized Digest**: Articles mapped directly to GS-I, GS-II, GS-III, GS-IV, and Prelims.
- **Deep Article View**: Key takeaways, prelims pointers, mains practice question, and "Add to My Notes" integration.
- **Daily Current Affairs Quiz**: Timed 5-question MCQs with negative marking simulation (-0.66 marks).
- **Quiz Performance Card**: Scorecard, accuracy percentage, time taken, and detailed rationales.

### 5. All-India Prelims Test Series & OMR Engine
- **Test Catalog**: Filter by Full-Length Mocks, CSAT Paper-II, Subject-Wise GS tests, and PYQ simulations.
- **Test Instructions**: Syllabus breakdown, marking rules (+2.0 correct, -0.66 incorrect, 120 minutes).
- **Interactive Test Attempt Engine**:
  - Live countdown timer with auto-submit safeguard.
  - Question navigation palette with standard color coding (Green: Answered, Orange: Marked for Review, Red: Visited, Grey: Not Visited).
  - Clear response, save & next, mark for review workflows.
- **Comprehensive Test Results**: All-India Rank simulation, percentile calculation, score, and accuracy.
- **Subject-Wise Diagnostic Analytics**: Visual performance bars (Polity, Economy, Geography, History, Science & Tech) identifying strengths and weak areas.

### 6. UPSC Syllabus Completion Tracker
- **Subject-Wise Coverage**: Covers Indian Polity, Modern History, Geography, Economy, Environment & Ecology, Science & Tech, Ethics (GS-IV), and CSAT.
- **Interactive Topic Checklist**: Mark topics as *Not Started*, *In Progress*, or *Completed*.
- **Dynamic Overall Progress Bar**: Automatically calculates percentage completion across 50+ granular UPSC syllabus topics.

### 7. Digital Study Notes (CRUD)
- **Local Persistence**: Notes are saved to `shared_preferences` and persist across app restarts.
- **Rich Editor**: Title, Subject tagging, Topic association, and note content.
- **Actions**: Add, view, edit, delete, and bookmark revision summaries.

### 8. Aspirant Community & Discussion Forum
- **Categorized Feeds**: General Prelims/Mains, Optional Strategy, Book Recommendations, and Doubt Clearing.
- **Thread Details**: Full question prompt, educator/peer upvoting, and nested discussion replies.
- **Create Discussion**: Start new threads with custom tags and question descriptions.

### 9. Previous Year Questions (PYQs 2020–2025)
- **Year-by-Year Archive**: Filter questions by exam year (2020 to 2025) and subject.
- **Interactive Practice**: Reveal official UPSC answer key and detailed constitutional/historical explanations.
- **Trend Analysis**: Graphical breakdown of question distribution per subject across recent CSE Prelims.

### 10. Topper Talks & Strategy Sessions
- **Free Video Archive**: Strategy masterclasses by AIR 1, AIR 3, AIR 8, and AIR 14.
- **Booklist & Timetable Blueprints**: Downloadable booklists, mains answer writing templates, and interview prep guides.

### 11. Monetization & Subscription Tiers (Per University Case Study Spec)
- **Sankalp Plus Subscription**: Full live classes, all test series, offline downloads, mentor sessions — **₹24,999 / year**.
- **Prelims Test Series Pass**: 30 Full-length & sectional mock tests — **₹4,999**.
- **Individual Subject Masterclass**: Single subject deep dive — **₹2,499**.
- **Checkout & Payment Simulation**: Mock payment gateway with UPI, Debit/Credit Card, and Net Banking options, generating simulated order receipts.

---

## 🎨 Design System & Aesthetics

- **Primary Brand Color**: Deep Navy (`#0D1B2A` & `#1B263B`) representing trust, governance, and authority.
- **Accent Brand Color**: Warm Saffron / Terracotta (`#FF7A00` & `#E07A5F`) inspired by India's national colors and educational energy.
- **Surface & Backgrounds**: Clean neutral surfaces (`#FFFFFF` in light mode, `#152238` & `#0B131F` in dark mode).
- **Typography**: Google Fonts **Inter** (`displayLarge`, `headlineLarge`, `titleMedium`, `bodyMedium`).
- **Material 3 Theming**: Dynamic theme switching between Light Mode and Dark Mode with instant Provider notification.
- **Aesthetic Elements**: Rounded corners (`16px`), subtle borders (`1px`), clean drop shadows, and zero visual clutter.

---

## 📂 Project Structure

```
UnAcademy/
├── lib/
│   ├── main.dart                          # Application entry point
│   ├── app/
│   │   ├── app.dart                       # SankalpApp MaterialApp & Route Generator
│   │   ├── routes.dart                    # 38+ Named route definitions
│   │   └── theme.dart                     # Material 3 Light & Dark themes
│   ├── models/                            # 14 Strongly typed immutable data models
│   │   ├── user_model.dart
│   │   ├── educator_model.dart
│   │   ├── course_model.dart
│   │   ├── class_model.dart
│   │   ├── current_affairs_model.dart
│   │   ├── question_model.dart
│   │   ├── quiz_model.dart
│   │   ├── test_model.dart
│   │   ├── note_model.dart
│   │   ├── discussion_model.dart
│   │   ├── subscription_model.dart
│   │   ├── topic_model.dart
│   │   ├── pyq_model.dart
│   │   └── topper_talk_model.dart
│   ├── data/
│   │   └── mock_data.dart                 # Rich UPSC datasets (courses, tests, PYQs, faculty)
│   ├── services/
│   │   ├── app_state_provider.dart        # Central ChangeNotifier reactive state
│   │   ├── local_storage_service.dart     # SharedPreferences persistence wrapper
│   │   └── mock_auth_service.dart         # Authentication service & credential validation
│   ├── utils/
│   │   ├── constants.dart                 # Brand colors, strings, case study pricing
│   │   └── helpers.dart                   # Currency (₹), date, snackbars, difficulty badges
│   ├── widgets/                           # 20 Reusable atomic components
│   │   ├── primary_button.dart
│   │   ├── secondary_button.dart
│   │   ├── difficulty_badge.dart
│   │   ├── empty_state.dart
│   │   ├── section_header.dart
│   │   ├── search_bar.dart
│   │   ├── custom_app_bar.dart
│   │   ├── app_bottom_navigation.dart
│   │   ├── course_card.dart
│   │   ├── live_class_card.dart
│   │   ├── educator_card.dart
│   │   ├── test_card.dart
│   │   ├── current_affair_card.dart
│   │   ├── quiz_card.dart
│   │   ├── note_card.dart
│   │   ├── discussion_card.dart
│   │   ├── topic_progress_card.dart
│   │   ├── pyq_card.dart
│   │   ├── topper_talk_card.dart
│   │   └── progress_indicator_card.dart
│   └── screens/                           # 35+ Production-grade screens
│       ├── onboarding/                    # Splash and Onboarding screens
│       ├── auth/                          # Login and Signup screens
│       ├── home/                          # Home shell & dashboard
│       ├── live_classes/                  # Live class list & interactive classroom
│       ├── recorded/                      # Recorded video catalog & video player
│       ├── current_affairs/               # Daily editorial, detail, and quiz screens
│       ├── tests/                         # Test catalog, instructions, OMR attempt, analysis
│       ├── notes/                         # Notes list, rich note editor, note detail
│       ├── community/                     # Discussion forum, create post, thread detail
│       ├── educators/                     # Faculty list & educator profile
│       ├── syllabus/                      # Syllabus completion tracker & topic detail
│       ├── pyq/                           # PYQ archive (2020-2025) & subject trends
│       ├── courses/                       # Courses catalog & course syllabus breakdown
│       ├── subscription/                  # Pricing plans, checkout gateway, payment receipt
│       ├── topper_talks/                  # Topper talks catalog & strategy video player
│       └── profile/                       # User profile, edit profile, settings screen
├── test/
│   └── widget_test.dart                   # 6 Automated widget & state unit test suites
├── documentation/                         # 9 University case study submission documents
│   ├── 01_Project_Overview.md
│   ├── 02_BRD.md
│   ├── 03_SRS.md
│   ├── 04_Feature_Documentation.md
│   ├── 05_System_Architecture.md
│   ├── 06_UI_UX_Documentation.md
│   ├── 07_Testing_Documentation.md
│   ├── 08_User_Manual.md
│   └── 09_Future_Scope.md
└── pubspec.yaml                           # Flutter dependencies & metadata
```

---

## 🚀 How to Run the Application

### Prerequisites
- Flutter SDK (Version 3.24+ or 3.47+)
- Dart SDK (Version 3.5+ or 3.13+)
- Google Chrome, macOS Desktop, or an Android/iOS emulator

### Step 1: Clone & Navigate
```bash
cd /Users/sanchita/Desktop/UnAcademy
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Verify Code Quality & Tests
```bash
flutter analyze
flutter test
```
*Expected Result:*
- `flutter analyze`: **No issues found!**
- `flutter test`: **All tests passed! (6/6)**

### Step 4: Launch the Application
- **Run on macOS Desktop**:
  ```bash
  flutter run -d macos
  ```
- **Run in Google Chrome**:
  ```bash
  flutter run -d chrome
  ```
- **Run on Connected Mobile Device / Simulator**:
  ```bash
  flutter run
  ```

---

## 🔑 Demo Credentials

To test the application immediately without signing up:
- **Email**: `atharva@example.com`
- **Password**: `password123`
*(Or click "Quick Demo Login" on the Login Screen to log in with 1 tap).*

---

## 📋 Comprehensive Academic Documentation Index

Located inside the [`documentation/`](./documentation/) directory:
1. [`01_Project_Overview.md`](./documentation/01_Project_Overview.md) — Executive summary, vision, problem statement, and scope.
2. [`02_BRD.md`](./documentation/02_BRD.md) — Business Requirements Document & stakeholder analysis.
3. [`03_SRS.md`](./documentation/03_SRS.md) — Software Requirements Specification (IEEE 830 compliant).
4. [`04_Feature_Documentation.md`](./documentation/04_Feature_Documentation.md) — Complete breakdown of all 13 core modules & pricing matrix.
5. [`05_System_Architecture.md`](./documentation/05_System_Architecture.md) — Layered design, Provider state management, and data flow.
6. [`06_UI_UX_Documentation.md`](./documentation/06_UI_UX_Documentation.md) — Material 3 theming, color psychology, and wireframe specs.
7. [`07_Testing_Documentation.md`](./documentation/07_Testing_Documentation.md) — Automated testing matrix, unit tests, and QA checklist.
8. [`08_User_Manual.md`](./documentation/08_User_Manual.md) — Step-by-step student user manual and navigation guide.
9. [`09_Future_Scope.md`](./documentation/09_Future_Scope.md) — AI answer evaluation, WebRTC audio mentoring, and scalability roadmap.

---

## ⚖️ Academic Honor Code & Attribution

This project is created strictly for academic educational purposes as part of the B.Tech Semester V curriculum at ITM Skills University. It does not reproduce, scrape, or distribute any proprietary branding, copyrighted media, or intellectual property belonging to Sorting Hat Technologies Pvt. Ltd. (Unacademy) or any other commercial entity. All trademarks belong to their respective owners.
