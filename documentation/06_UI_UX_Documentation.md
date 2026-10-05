# 06. UI/UX Design System Documentation — Sankalp

> **Academic Course**: Cross-Platform Application Development (Flutter)  
> **Institution**: ITM Skills University  
> **Design Specification**: Material 3 & Modern EdTech Aesthetic  

---

## 1. Design Philosophy & Aesthetic Intent

Sankalp is designed to evoke a sense of **academic rigor, administrative authority, and technological elegance**. In the context of UPSC preparation, students spend 4 to 8 hours daily studying on their digital devices. The UI must avoid sensory fatigue, cognitive clutter, and distracting animations while maintaining high engagement through purposeful micro-interactions and high-contrast typography.

---

## 2. Color Palette & Psychological Rationale

```
+-------------------------------------------------------------+
|                     BRAND COLOR TOKENS                      |
+--------------------+-------------------+--------------------+
| Deep Navy Primary  | Saffron Secondary | Terracotta Accent  |
|     #0D1B2A        |     #FF7A00       |     #E07A5F        |
| (Trust & Authority)| (Energy & India)  | (Warm Academic)    |
+--------------------+-------------------+--------------------+
| Success Green      | Warning Amber     | Error / Live Red   |
|     #2A9D8F        |     #E9C46A       |     #E63946        |
| (Correct / Done)   | (Review / Pending)| (Live Tag / Loss)  |
+--------------------+-------------------+--------------------+
```

### Color Psychology
- **Deep Navy (`#0D1B2A`, `#1B263B`)**: Associated with government institutions, the civil secretariat, and stability.
- **Warm Saffron (`#FF7A00`, `#E07A5F`)**: Rooted in Indian national iconography; stimulates focus, optimism, and alertness during prolonged study sessions.
- **Surface Neutrals**: Soft off-white (`#F8F9FA`) in light mode prevents eye strain compared to harsh `#FFFFFF`; deep slate navy (`#0B131F`, `#152238`) in dark mode minimizes OLED battery consumption and glare.

---

## 3. Typography Hierarchy: Google Fonts Inter

The platform strictly uses Google Fonts **Inter**, renowned for its optical clarity at small mobile sizes:

| Text Style | Weight | Size (px) | Line Height | Purpose |
|---|---|---|---|---|
| `displayLarge` | 800 (Bold) | 32 | 1.2 | Splash title, Hero banners |
| `headlineMedium`| 700 (Bold) | 22 | 1.3 | Screen titles, Section headers |
| `titleMedium` | 600 (Semi) | 16 | 1.4 | Card headings, Question titles |
| `bodyMedium` | 400 (Regular) | 14 | 1.5 | Article paragraphs, options |
| `labelSmall` | 500 (Medium) | 11 | 1.2 | Metadata chips, time badges |

---

## 4. Atomic Widget Design System

The application is assembled from 20 encapsulated, reusable components in `lib/widgets/`:

```
                 Atomic Widget Catalog
  +----------------------+----------------------+
  | Actions & Buttons    | Data Visualization   |
  |  • PrimaryButton     |  • TopicProgressCard |
  |  • SecondaryButton   |  • ProgressIndicator |
  +----------------------+----------------------+
  | Navigation & Header  | Cards & Media        |
  |  • CustomAppBar      |  • LiveClassCard     |
  |  • AppBottomNav      |  • CourseCard        |
  |  • SectionHeader     |  • TestCard          |
  |  • SearchBarWidget   |  • CurrentAffairCard |
  +----------------------+----------------------+
  | Content & Feedback   | Interactive Chips    |
  |  • EmptyStateWidget  |  • DifficultyBadge   |
  |  • NoteCard          |  • PYQCard           |
  |  • DiscussionCard    |  • TopperTalkCard    |
  +----------------------+----------------------+
```

---

## 5. Responsive Layout Strategy

- **Mobile Viewport (360px - 480px)**: Single column layouts, horizontal scrolling carousels with peek margins (`padding: EdgeInsets.symmetric(horizontal: 16)`), fixed bottom navigation.
- **Tablet / Desktop Viewport (768px - 1440px)**: Grid scaling with adaptive cross-axis counts, scrollable content with maximum content constraints (`maxWidth: 800px` for article reading modes).
- **Safe Area & Notch Insets**: Full wrapping with `SafeArea` ensuring zero overlap with device notches, status bars, and home indicators.

---

## 6. Light & Dark Theme Adaptation Matrix

| UI Component | Light Mode Value | Dark Mode Value |
|---|---|---|
| **Scaffold Background** | `#F8F9FA` | `#0B131F` |
| **Card Surface** | `#FFFFFF` (Border `#E9ECEF`) | `#1C2C48` (Border `#263A5C`) |
| **Primary Text** | `#1B1B1E` | `#F8F9FA` |
| **Secondary Text** | `#6C757D` | `#ADB5BD` |
| **AppBar Surface** | `#FFFFFF` | `#152238` |
| **Elevated Button** | Deep Navy `#0D1B2A` | Warm Saffron `#FF7A00` |
| **Active Nav Icon** | Deep Navy `#0D1B2A` | Warm Saffron `#FF7A00` |
