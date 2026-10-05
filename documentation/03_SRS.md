# 03. Software Requirements Specification (SRS) — Sankalp

> **Academic Course**: Cross-Platform Application Development (Flutter)  
> **Institution**: ITM Skills University  
> **Standard**: IEEE Std 830-1998 Compliant Specification  
> **Document Ref**: SRS-SK-2026-V1.0  

---

## 1. Introduction

### 1.1 Purpose
This document specifies the software requirements for **Sankalp**, an educational technology cross-platform client application dedicated to UPSC Civil Services Examination preparation. It defines both functional and non-functional requirements for academic evaluation and future production engineering.

### 1.2 Scope of the System
Sankalp encompasses user authentication, curriculum browsing, interactive video and live classroom simulations, editorial digests, timed assessments with negative marking algorithms, digital notebook management, syllabus completion tracking, and community discussion boards.

### 1.3 Definitions, Acronyms, and Abbreviations
- **UPSC**: Union Public Service Commission
- **CSE**: Civil Services Examination
- **GS**: General Studies (Papers I, II, III, IV)
- **CSAT**: Civil Services Aptitude Test (Paper-II)
- **PYQ**: Previous Year Question
- **OMR**: Optical Mark Recognition (simulated answer sheet)
- **AIR**: All India Rank
- **CRUD**: Create, Read, Update, Delete
- **M3**: Material Design Version 3

---

## 2. Overall Description

### 2.1 Product Perspective
Sankalp is a client-side Flutter application designed with clean layered architecture:
```
+-------------------------------------------------------------+
| Presentation Layer: Widgets, Screens, Material 3 Theming    |
+-------------------------------------------------------------+
| State Management Layer: Provider (AppStateProvider)         |
+-------------------------------------------------------------+
| Service Layer: LocalStorageService, MockAuthService         |
+-------------------------------------------------------------+
| Data / Model Layer: Dart Domain Models & Mock Repositories  |
+-------------------------------------------------------------+
```

### 2.2 Operating Environment
- **Operating Systems**: macOS (12.0+), Android (API 21+), iOS (13.0+), Modern Web Browsers (Chrome 100+, Safari, Edge).
- **Target Resolution**: Fluid responsive layout adaptable from mobile portrait (360x640) to desktop/tablet landscape (1920x1080).

---

## 3. Specific Functional Requirements

### FR-01: Authentication & Onboarding
- **FR-01.1**: The system shall render an animated splash screen displaying the brand logo, app name, and tagline.
- **FR-01.2**: If the user is launching the application for the first time, the system shall display a 3-page onboarding walkthrough.
- **FR-01.3**: The system shall provide a login screen supporting email and password validation, plus a 1-tap "Quick Demo Login" shortcut.

### FR-02: Home Dashboard
- **FR-02.1**: The home screen shall display the user's active streak (in days), questions solved, tests completed, and target exam year.
- **FR-02.2**: The system shall provide a search bar that filters courses, lectures, and mock tests in real-time as the user types.
- **FR-02.3**: The system shall display horizontal carousels of featured courses, upcoming live lectures, top educators, and current affairs.

### FR-03: Live & Video Classrooms
- **FR-03.1**: The system shall render a mock video player interface with playback controls (play/pause, timeline scrubber, 1.0x/1.25x/1.5x speed).
- **FR-03.2**: In live mode, the system shall provide an active live chat stream where the user can submit instant messages.
- **FR-03.3**: The system shall feature an interactive poll with vote submission, instant percentage calculation, and educator explanation.
- **FR-03.4**: The system shall allow users to submit doubts to a dedicated doubt queue.

### FR-04: Daily Current Affairs & Quizzes
- **FR-04.1**: The system shall list curated daily articles categorized by GS Paper with bookmarking and text highlighting capabilities.
- **FR-04.2**: The system shall feature a timed 5-question daily quiz with a 5-minute countdown timer.
- **FR-04.3**: The system shall calculate quiz scores with +2.0 marks for correct answers and -0.66 marks for wrong answers.

### FR-05: Prelims Test Series & Diagnostic Analytics
- **FR-05.1**: The system shall support full-length (100 Qs / 200 Marks) and sectional (25-50 Qs) tests with configurable time limits.
- **FR-05.2**: The test attempt screen shall feature a question status palette tracking *Answered*, *Marked for Review*, *Visited*, and *Not Visited*.
- **FR-05.3**: Upon submission, the system shall generate a detailed result scorecard with score, accuracy, simulated AIR, and subject-wise accuracy bars.

### FR-06: Syllabus Tracker
- **FR-06.1**: The system shall list 8 core UPSC subjects subdivided into 50+ granular topics.
- **FR-06.2**: The user shall be able to toggle any topic status (*Not Started* -> *In Progress* -> *Completed*).
- **FR-06.3**: The system shall dynamically compute and display subject-wise and overall percentage progress.

### FR-07: Digital Notebook (CRUD)
- **FR-07.1**: The user shall be able to create notes with title, subject, topic, and rich text body.
- **FR-07.2**: The system shall persist notes locally using `shared_preferences` serialized as JSON.
- **FR-07.3**: The user shall be able to edit, delete, and bookmark notes.

### FR-08: Subscription & Checkout
- **FR-08.1**: The system shall display 3 subscription tiers (Plus @ ₹24,999/yr, Tests @ ₹4,999, Course @ ₹2,499).
- **FR-08.2**: The checkout screen shall break down base price, 10% coupon discount, and 18% GST.
- **FR-08.3**: Upon payment confirmation, the system shall generate a unique Order ID receipt and unlock the purchased item in state.

---

## 4. Non-Functional Requirements (NFRs)

### 4.1 Performance Requirements
- **Frame Rate**: UI shall render smoothly at 60 FPS without frame drops during scroll and page transitions.
- **Screen Transition Latency**: Internal screen navigation shall occur within 150 milliseconds.
- **Local Storage I/O**: Reads and writes to `shared_preferences` shall execute asynchronously without blocking the UI isolate.

### 4.2 Usability & Aesthetic Requirements
- **Aesthetic Excellence**: Follow Material 3 guidelines with harmonious palettes (Deep Navy `#0D1B2A`, Warm Saffron `#FF7A00`).
- **Dark Mode Support**: Seamless dynamic theme switching between Light Mode and Dark Mode with high-contrast text legibility.
- **Typography**: Utilize Google Fonts **Inter** across all display, headline, title, and body text styles.

### 4.3 Reliability & Resilience
- **Zero Null Crashes**: Fallback mock models provided for every named route to prevent null pointer exceptions if routes are launched directly.
- **Offline Tolerance**: Application shall launch and function fully without an active internet connection.

---

## 5. System Models & State Transition Diagram

```
[Splash Screen] 
       | (Check Onboarding Flag)
       +---> [Onboarding Carousel] ---> [Login Screen]
       |                                      | (Auth Success)
       +--------------------------------------+
       |
       v
[Main Home Shell (5 Tabs)]
  ├── Tab 0: Home Dashboard
  ├── Tab 1: Live Classes
  ├── Tab 2: Test Series
  ├── Tab 3: Current Affairs
  └── Tab 4: User Profile
```
