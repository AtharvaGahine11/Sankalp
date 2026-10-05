# 01. Project Overview — Sankalp

> **Academic Submission**: B.Tech CSE & AI, Semester V  
> **Course**: Cross-Platform Application Development (Flutter)  
> **Institution**: ITM Skills University  
> **Project Title**: Sankalp — UPSC CSE Learning Platform  
> **Author**: Atharva Suryawanshi  

---

## 1. Executive Summary

The Union Public Service Commission (UPSC) Civil Services Examination (CSE) is widely acknowledged as one of the most intellectually demanding, competitive, and grueling examinations in the world. Annually, over one million aspirants compete for fewer than a thousand coveted positions in the Indian Administrative Service (IAS), Indian Police Service (IPS), Indian Foreign Service (IFS), and other premier central services.

Historically, preparing for this multi-tiered examination (comprising the Preliminary Examination, Main Written Examination, and Personality Test/Interview) required candidates to relocate to coaching hubs such as Old Rajinder Nagar and Mukherjee Nagar in New Delhi, incurring exorbitant expenses on tuition and living costs. 

**Sankalp** democratizes high-quality, structured, and mentored UPSC preparation by delivering a world-class digital learning ecosystem directly to smartphones and laptops across the nation. Developed purely in **Flutter & Dart**, Sankalp bridges geographical and financial barriers with live masterclasses, comprehensive video archives, daily editorial analyses, All-India Prelims Test Series with real-time OMR simulations, an interactive UPSC syllabus completion tracker, a local digital notebook, and an active peer community.

---

## 2. Vision and Mission

### Vision
To empower every UPSC aspirant in India—regardless of socio-economic background or geographical location—with an affordable, top-tier, and technology-driven examination preparation companion that maximizes retention and builds administrative competence.

### Mission
1. **Accessibility**: Provide comprehensive GS, CSAT, and Optional preparation on any modern Android, iOS, macOS, or Web client.
2. **Pedagogical Rigor**: Align every lecture, daily current affairs summary, and mock test strictly with the official UPSC CSE syllabus and recent question patterns (2020–2025).
3. **Actionable Analytics**: Move beyond passive video viewing by measuring syllabus coverage, speed, accuracy, and subject-wise diagnostic strengths and weaknesses.
4. **Community Collaboration**: Foster peer discussions, doubt clearance, and mentorship from previous toppers without toxicity or distractions.

---

## 3. Problem Statement & Market Need

| Traditional Challenges | Sankalp Solution |
|---|---|
| **High Financial Barrier**: Relocation and coaching fees exceed ₹2,50,000 to ₹4,00,000 per year. | **Affordable Digital Model**: Full Plus access at ₹24,999/yr, individual test series at ₹4,999, and free topper masterclasses. |
| **Information Overload**: Aspirants read 3–4 newspapers daily without knowing what is relevant for Prelims vs. Mains. | **Curated Daily Digest**: Editorial summaries mapped directly to GS-I, GS-II, GS-III, and GS-IV with daily 5-question quizzes. |
| **Lack of Syllabus Tracking**: Candidates lose track of massive static and dynamic syllabi. | **Interactive Syllabus Tracker**: 50+ topics with *Not Started*, *In Progress*, and *Completed* state tracking and percentage progress. |
| **Passive Learning**: Video lectures without instant engagement lead to low retention. | **Interactive Classrooms**: Integrated live chat, real-time educator polls, and doubt submission queues. |
| **Unrealistic Test Practice**: Solving MCQs on paper or simple websites without timer or OMR feedback. | **Simulated Prelims OMR Engine**: All-India Rank simulation, negative marking (-0.66 marks), and diagnostic accuracy charts. |

---

## 4. Key Target Audience

1. **Full-Time College Aspirants**: Undergraduate and postgraduate students targeting CSE in 2026/2027 who require structured self-paced modules alongside college coursework.
2. **Working Professionals**: Aspirants balancing demanding employment schedules who rely on recorded video playback at 1.5x speed, concise downloadable notes, and weekend mock tests.
3. **Tier-2 & Tier-3 City Candidates**: Students unable to afford New Delhi coaching hubs, seeking mentorship from top faculty and retired civil servants.
4. **Repeat Aspirants**: Candidates who cleared Prelims previously and need specialized sectional test series, current affairs consolidation, and mains answer enrichment.

---

## 5. Technology Stack Selection Rationale

```
+-------------------------------------------------------+
|                    Sankalp App                        |
+-------------------------------------------------------+
|  UI / Presentation : Flutter Material 3 + GoogleFonts  |
|  State Management  : Provider (ChangeNotifier)        |
|  Local Storage     : shared_preferences               |
|  Data Layer        : Local Mock Repositories (Dart)   |
|  Target Platforms  : Android, iOS, macOS Desktop, Web |
+-------------------------------------------------------+
```

- **Why Flutter?**: Single codebase allows identical native-speed experiences across mobile, desktop, and web with high-performance 60fps animations.
- **Why Provider?**: Clean separation of UI and business logic, fully native to the Flutter ecosystem, highly readable and maintainable for academic review.
- **Why Material 3?**: Contemporary design language featuring tonal palettes, elevation tokens, dynamic light/dark theming, and accessibility compliance.
