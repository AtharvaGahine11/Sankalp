# 07. Testing Documentation & Quality Assurance — Sankalp

> **Academic Course**: Cross-Platform Application Development (Flutter)  
> **Institution**: ITM Skills University  
> **Topic**: Verification, Validation, and Test Automation  

---

## 1. Testing Philosophy & Test Pyramid

To guarantee production readiness and defect-free execution during the academic evaluation, Sankalp is validated across three testing layers:

```
                  / \
                 /   \
                / E2E \       Manual User Journey Testing
               /-------\
              / Widget  \     Automated Flutter Widget Tests
             /-----------\
            /  Unit Tests \   State & Business Logic Unit Tests
           /---------------\
```

---

## 2. Automated Test Suite (`test/widget_test.dart`)

The project includes automated regression tests using `flutter_test`. All tests execute cleanly and pass with **0 failures**:

```bash
flutter test
```

### Verified Test Cases

| Test ID | Test Scope | Component Tested | Assertion / Expected Outcome |
|---|---|---|---|
| **TC-01** | Widget Test | `SplashScreen` & `SankalpApp` | App renders splash screen, finds `account_balance` emblem, displays `AppConstants.appTagline`, and handles timer lifecycle gracefully without leaks. |
| **TC-02** | Unit Test | `AppStateProvider` (Initialization) | Verified initial collections are populated (`courses`, `liveClasses`, `recordedClasses`, `currentAffairs`, `tests`, `notes`, `syllabus`, `discussions` are not empty). |
| **TC-03** | Unit Test | Note CRUD Operations | Adding note increments note count by 1; updating note title persists changes; deleting note removes it and restores original collection length. |
| **TC-04** | Unit Test | Bookmarking Mechanism | `toggleBookmark()` sets bookmark state to true; secondary toggle removes it cleanly from the bookmark Set. |
| **TC-05** | Unit Test | Syllabus Tracker State Mutation | `updateTopicStatus()` mutates topic from `notStarted` to `inProgress` and then `completed`, verified through state lookup. |
| **TC-06** | Unit Test | Case Study Pricing Specification | Confirms case study pricing constants: Plus = ₹24,999, Test Series = ₹4,999, Single Course = ₹2,499. |

---

## 3. Static Code Analysis (`flutter analyze`)

Static analysis is performed using Dart's official analyzer with the `flutter_lints` ruleset:

```bash
flutter analyze
```

### Result:
```
Analyzing UnAcademy...
No issues found! (ran in 2.7s)
```
- **Errors**: 0
- **Warnings**: 0
- **Linter Flags**: 0

---

## 4. Manual QA Test Matrix & Execution Checklist

| Module | Verification Step | Expected Behavior | Status |
|---|---|---|---|
| **Auth** | Click "Quick Demo Login" | Navigates to Home Dashboard immediately with demo user profile. | ✅ PASSED |
| **Search** | Type "Polity" into home search bar | Instantly filters courses and displays only Polity-related batches. | ✅ PASSED |
| **Live Class** | Tap "Join Live" on an active lecture | Opens simulated live classroom with video header, active chat, and live poll. | ✅ PASSED |
| **Live Poll** | Vote on poll question in live class | Radio option highlights, votes register, percentage bar animates. | ✅ PASSED |
| **Recorded Video**| Toggle speed to 1.5x | Playback speed button toggles between 1.0x, 1.25x, and 1.5x. | ✅ PASSED |
| **Daily Quiz** | Select answers & submit 5-question quiz | Generates scorecard with positive/negative marks (+2/-0.66) and rationales. | ✅ PASSED |
| **OMR Test Engine**| Navigate between questions using side drawer | Color codes update dynamically (Green for answered, Orange for review). | ✅ PASSED |
| **Test Analytics** | Submit mock test and view analysis | Displays All-India Rank, percentile, score, and subject breakdown bars. | ✅ PASSED |
| **Syllabus Tracker**| Tap topic checkbox to "Completed" | Overall syllabus completion progress bar increases dynamically. | ✅ PASSED |
| **Notes CRUD** | Create note, restart app, check notes list | Note persists in local storage across restarts. | ✅ PASSED |
| **Dark Mode** | Toggle dark theme switch in settings | Whole app flips instantly between clean Light and sleek Dark mode. | ✅ PASSED |
| **Checkout** | Complete mock subscription purchase | Generates simulated order receipt (`ORD-2026-XXXXX`) and unlocks item. | ✅ PASSED |
