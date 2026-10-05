# 02. Business Requirements Document (BRD) — Sankalp

> **Academic Course**: Cross-Platform Application Development (Flutter)  
> **Institution**: ITM Skills University  
> **Project**: Sankalp (UPSC Preparation Platform)  
> **Document Code**: BRD-SK-2026-V1.0  

---

## 1. Project Objectives & Business Goals

The primary objective of Sankalp is to provide a viable digital alternative to expensive offline coaching institutes for UPSC Civil Services aspirants across India.

### Measurable Business & Pedagogical Goals
1. **Curriculum Coverage**: 100% mapping of UPSC CSE Preliminary (GS-I & CSAT) and Main examination syllabus.
2. **Engagement Metric**: Maintain user study streak with interactive notifications, daily 5-question quizzes, and live lecture reminders.
3. **Assessment Integrity**: Replicate exact UPSC Preliminary examination conditions (+2.0 marks per correct answer, -0.66 marks per wrong answer, 120-minute countdown timer).
4. **Offline Capability**: Retain user-generated notes, bookmarks, and syllabus completion states offline through local persistence.
5. **Freemium Monetization Model**: Offer substantial free content (Topper Talks, PYQs, Sample Quizzes, Daily Editorials) while providing premium high-touch subscriptions.

---

## 2. Stakeholder Matrix

| Stakeholder | Roles & Responsibilities | Key Needs & Expectations |
|---|---|---|
| **Aspirant / Student** | Primary consumer of the application. | High-quality lectures, intuitive test engines, syllabus clarity, zero lag, dark mode. |
| **Educator / Faculty** | Content delivery and mentor. | Interactive tools (polls, live chat, doubt answering), profile showcase, student analytics. |
| **Academic Evaluator (Viva)** | Professor evaluating software engineering practices. | Clean code, idiomatic Dart, robust tests, proper state architecture, verifiable requirements. |
| **Platform Administrator** | Oversees content quality and subscription fulfillment. | Simple catalog management, order tracking, clear monetization flows. |

---

## 3. High-Level User Stories

### Epic 1: Onboarding & Authentication
- **US1.1**: As a new aspirant, I want an engaging onboarding walkthrough so I understand the platform's core offerings.
- **US1.2**: As an existing user, I want quick demo login capability so that I can immediately access my study materials without re-entering credentials.

### Epic 2: Live & Video Learning
- **US2.1**: As an aspirant, I want to participate in live lectures with simulated real-time polls so that I can test my understanding against other students.
- **US2.2**: As a working professional, I want to watch recorded classes at 1.25x or 1.5x speed and download lecture notes for quick weekend revision.

### Epic 3: Daily Current Affairs & Editorial Analysis
- **US3.1**: As a candidate, I want daily editorial summaries organized by GS Paper (GS-I to GS-IV) so I don't waste time on irrelevant news.
- **US3.2**: As an aspirant, I want a daily 5-question timed quiz to test my daily newspaper retention with immediate answer rationales.

### Epic 4: Assessment & All-India Mock Test Series
- **US4.1**: As an aspirant, I want to simulate full-length 100-question UPSC Prelims exams with negative marking to build exam temperament.
- **US4.2**: As a candidate, I want an OMR-style palette showing answered, unanswered, and marked questions to strategically manage my 120 minutes.
- **US4.3**: As a student, I want diagnostic charts showing accuracy per subject (Polity vs. Economy vs. Environment) to prioritize my revision.

### Epic 5: Syllabus Tracking & Productivity
- **US5.1**: As an aspirant, I want an interactive checklist of the entire UPSC syllabus so I can visually see what percentage of each subject I have mastered.
- **US5.2**: As a student, I want to create, edit, and search my revision notes directly within the app so I have a centralized digital notebook.

---

## 4. Monetization Strategy & Case Study Pricing Matrix

Per the academic case study specifications, Sankalp operates on a transparent, aspirational freemium model:

| Tier / Item | Pricing | Entitlements & Access | Target User Segment |
|---|---|---|---|
| **Sankalp Free Tier** | **₹0 (Free)** | Daily Current Affairs Digest, PYQ Archive (2020–2025), Topper Talks, Community Forum, Syllabus Tracker. | Beginners and self-study aspirants exploring the platform. |
| **Individual Subject Masterclass** | **₹2,499** (one-time) | Full lifetime access to one dedicated subject batch (e.g., *Indian Polity & Governance Comprehensive Batch*), all lecture notes, and sectional tests. | Candidates needing focused strengthening in a specific weak subject. |
| **All-India Prelims Test Series Pass** | **₹4,999** (annual) | 30 Full-Length Mocks + 20 Sectional GS Tests + 10 CSAT Tests, complete All-India Rank benchmarking, and detailed performance analytics. | Aspirants who completed static syllabus and need intensive testing. |
| **Sankalp Plus Annual Subscription** | **₹24,999** / year | Unlimited access to ALL live and recorded courses, all test series, offline PDF downloads, educator doubt sessions, and priority mentorship. | Dedicated full-time candidates seeking an end-to-end coaching alternative. |

---

## 5. Business Constraints & Academic Assumptions

1. **Non-Transactional Sandbox**: Payment gateway execution is a realistic simulation (`Future.delayed` mock authorization), outputting authentic order confirmations (`ORD-2026-XXXXX`) without charging real funds.
2. **Zero Cloud Dependency**: Application runs completely self-contained with offline/mock persistence to guarantee 100% demo reliability during academic viva presentations regardless of Wi-Fi stability.
3. **Intellectual Property Respect**: Zero use of proprietary commercial assets, trademarks, or copyrighted media from Unacademy or external commercial entities.
