# 04. Feature Documentation — Sankalp

> **Academic Course**: Cross-Platform Application Development (Flutter)  
> **Institution**: ITM Skills University  
> **Topic**: Granular Module Breakdown & Pricing Logic  

---

## Overview of System Features

Sankalp is architected into 13 cohesive, modular subsystems designed to simulate the full operational scope of a premier UPSC EdTech platform:

```
                      +-------------------+
                      |    Sankalp App    |
                      +---------+---------+
                                |
       +------------------------+------------------------+
       |                        |                        |
[Core Pedagogy]          [Evaluation & Testing]    [Tools & Community]
 • Live Classrooms        • All-India Mock Tests    • Syllabus Tracker
 • Recorded Catalog       • Diagnostic Analytics    • Digital Notebook
 • Current Affairs        • PYQ Archive (2020-25)   • Peer Forum
 • Topper Masterclasses   • Daily Timed Quizzes     • Subscription & Pay
```

---

## 1. Onboarding & Authentication Module

### Screens
- `SplashScreen`: Animated entrance with scale and fade interpolations, automated redirect check.
- `OnboardingScreen`: Interactive PageView with animated smooth dot indicators and skip/continue controls.
- `LoginScreen`: Form validation with instant regex check, password visibility toggle, and one-tap demo account login.
- `SignupScreen`: Registration form collecting Full Name, Email, Password, Target Exam Year, and Optional Subject.

### Business Rules
- Email must match standard RFC-5322 regex.
- Password minimum length is 6 characters.
- "Quick Demo Login" pre-populates state with candidate `Atharva Suryawanshi` (`atharva@example.com`).

---

## 2. Home Dashboard & Navigation Shell

### Screens & Components
- `HomeScreen`: Central 5-tab shell using `AppBottomNavigation`.
- `ProgressIndicatorCard`: Visual streak counter (12 Days 🔥), questions solved (1,248), tests taken (18), and overall syllabus completion circle.
- `QuickActions`: 5 quick-jump tiles (Syllabus Tracker, PYQs, Topper Talks, Community, Notes).
- `Horizontal Carousels`: Featured batches, live streams, mentor faculty, and daily editorial cards.

---

## 3. Live Classroom Simulation Module

### Screens
- `LiveClassesScreen`: Tabbed list separating *Ongoing Live Now* (with pulsing red indicator) and *Upcoming Scheduled Batches*.
- `LiveClassDetailScreen`: Multi-panel classroom layout featuring:
  - **Video Header**: Simulated stream with live viewer count badge, full-screen toggle, and audio controls.
  - **Live Chat Stream**: Real-time message list with instant user chat submission.
  - **Interactive Live Poll**: Question prompt with 4 options, radio selection, real-time submission, and instant percentage bar animations.
  - **Doubts Queue**: Tab to submit questions directly to faculty.

---

## 4. Recorded Video Library Module

### Screens
- `RecordedClassesScreen`: Searchable on-demand library filterable by subject (Polity, Economy, Geography, History, Ethics).
- `VideoDetailScreen`: Player interface with play/pause, slider scrubbing, 1.0x/1.25x/1.5x playback speed toggling, lecture summary notes, and downloadable PDF study material links.

---

## 5. Daily Current Affairs & Editorial Digest

### Screens
- `CurrentAffairsScreen`: Date-stamped editorial articles mapped to GS Papers (GS-I to GS-IV) with read-time and tag filtering.
- `CurrentAffairDetailScreen`: Deep article reader featuring:
  - Constitutional context & background.
  - Key takeaways & Prelims facts.
  - Mains practice question.
  - Interactive "Save to My Notes" action.
  - Bookmark & text highlight toggles.
- `CurrentAffairsQuizScreen`: Daily 5-question timed quiz (5:00 min timer) with negative marking simulation.
- `QuizResultScreen`: Score summary, accuracy %, time taken, and question-by-question rationales.

---

## 6. All-India Mock Test Series Engine

### Screens
- `TestsScreen`: Test catalog divided into *All Tests*, *Full-Length Mocks*, *Sectional Tests*, and *CSAT Paper-II*.
- `TestDetailScreen`: Test syllabus, duration, marks, instructions, and ranking criteria.
- `TestAttemptScreen`: Comprehensive exam engine featuring:
  - **Countdown Timer**: 120-minute countdown with automatic submission at 00:00.
  - **Interactive OMR Grid**: Side-drawer question palette displaying status colors:
    - 🟩 Green: Answered
    - 🟧 Orange: Marked for Review
    - 🟥 Red: Visited (Unanswered)
    - ⬜ Grey: Not Visited
  - **Action Toolbar**: "Clear Response", "Mark for Review", and "Save & Next".
- `TestResultScreen`: Scorecard displaying All-India Rank, percentile (e.g. 96.4th percentile), score out of 200, correct vs. incorrect counts.
- `TestAnalysisScreen`: Diagnostic subject-wise breakdown bars (Polity, Economy, Geography, Environment, History) isolating strengths and critical revision areas.

---

## 7. UPSC Syllabus Completion Tracker

### Screens
- `SyllabusTrackerScreen`: Complete mapping of 8 UPSC GS & CSAT subjects.
- `TopicDetailScreen`: Granular topics with 3-state toggling (*Not Started*, *In Progress*, *Completed*).
- **Dynamic Logic**: Overall progress percentage updates reactively in real time across the entire app.

---

## 8. Digital Study Notes Module (CRUD)

### Screens
- `NotesScreen`: Filterable collection of student-created notes with subject tags and search bar.
- `NoteEditorScreen`: Rich creation/edit form with title, subject selection, topic linking, and content.
- `NoteDetailScreen`: Clean distraction-free note view with bookmarking and delete actions.
- **Persistence**: Saved to `shared_preferences` as JSON, surviving app termination.

---

## 9. Aspirant Community & Discussion Forum

### Screens
- `CommunityScreen`: Community threads with upvote counter, reply counter, and category chips (*Prelims Strategy*, *Mains Answer Writing*, *Booklists*, *Doubts*).
- `DiscussionDetailScreen`: Thread view with user comments and nested reply submission form.
- `CreateDiscussionScreen`: Post creation interface with title, tag, and inquiry body.

---

## 10. Previous Year Questions Archive (2020–2025)

### Screens
- `PYQScreen`: Filterable by year (2025 down to 2020) and subject.
- `PYQCard`: Expandable question card with "Show Official Answer Key" toggle revealing official UPSC justification.
- `PYQAnalysisScreen`: Historical subject weightage trends showing question count distribution over the last 6 exam cycles.

---

## 11. Topper Talks & Strategy Masterclasses

### Screens
- `TopperTalksScreen`: Free video lectures by UPSC CSE toppers (AIR 1, AIR 3, AIR 8, AIR 14).
- `TopperVideoScreen`: Strategy video player, biography, timetable blueprints, and recommended booklists.

---

## 12. Faculty & Mentor Profiles

### Screens
- `EducatorsScreen`: List of renowned GS and Optional faculty.
- `EducatorProfileScreen`: Faculty bio, years of experience, courses taught, student ratings, and follow toggle.

---

## 13. Subscription Tiers & Checkout Simulation

### Pricing Matrix (Per Case Study Requirements)

| Plan Name | Price | Period | Inclusions |
|---|---|---|---|
| **Sankalp Plus** | **₹24,999** | 1 Year | All live courses, test series, offline downloads, mentor sessions |
| **Prelims Test Series Pass** | **₹4,999** | 1 Year | 30 full-length mocks, 20 sectional tests, AI ranking |
| **Individual Subject Batch** | **₹2,499** | Lifetime | Single subject comprehensive lectures + notes |

### Checkout Logic
- Base Price: Configured per plan.
- Special Discount: Automatically applies 10% coupon (`CIVIL10`).
- Tax Calculation: 18% GST added to net amount.
- Payment Simulation: Simulates UPI, Cards, and Net Banking with unique order generation (`ORD-2026-XXXXX`).
