# 09. Future Scope & Engineering Roadmap — Sankalp

> **Academic Course**: Cross-Platform Application Development (Flutter)  
> **Institution**: ITM Skills University  
> **Subject**: System Evolution, AI Integration, and Production Scale  

---

## 1. Overview of Future Roadmap

While the current version of **Sankalp** fully fulfills the academic requirements of **Case Study 125** with a runnable, polished, and comprehensive client-side architecture, the system is designed with extensibility in mind.

This document outlines the strategic technical enhancements planned for production scaling:

```
                Sankalp Engineering Roadmap
  +--------------------------------------------------------+
  | Phase 1 (Current): Self-Contained Client Architecture   |
  |  • Pure Flutter + Dart Material 3                      |
  |  • Provider State Management                           |
  |  • SharedPreferences Offline Persistence               |
  |  • Complete Mock Repositories & Simulated OMR Engine   |
  +---------------------------+----------------------------+
                              |
                              v
  +--------------------------------------------------------+
  | Phase 2: Cloud Backend & Real-Time Microservices       |
  |  • Firebase / PostgreSQL Backend with Go Microservices |
  |  • WebRTC Live Audio/Video Streaming Pipelines         |
  |  • Razorpay / Stripe Payment Gateway Integration       |
  +---------------------------+----------------------------+
                              |
                              v
  +--------------------------------------------------------+
  | Phase 3: Generative AI & Adaptive Learning Engine      |
  |  • Multimodal Mains Handwritten Answer Evaluation      |
  |  • Personalized AI UPSC Doubt Solving Tutor            |
  |  • Spaced Repetition Flashcards & Weak Area Predictor   |
  +--------------------------------------------------------+
```

---

## 2. Technical Roadmap Milestones

### Phase 2: Cloud Infrastructure & Real-Time Sync (Q1–Q2 2027)

1. **Distributed Cloud Backend**:
   - Transition from local mock data to a cloud backend powered by **Go (Golang) microservices** and **PostgreSQL** hosted on Google Cloud Platform (GCP).
   - Real-time chat and live poll synchronization via **WebSockets** and **Redis Pub/Sub**.

2. **Production Video Streaming with DRM**:
   - Integration with HLS/DASH adaptive bitrate video delivery (via AWS CloudFront or Cloudflare Stream).
   - Widevine / FairPlay DRM encryption to protect proprietary educator lectures from unauthorized screen recording.

3. **True Production Payment Gateway**:
   - Replacement of simulated checkout with real **Razorpay** and **Stripe** SDK integrations supporting UPI Auto-Pay, EMI plans, and automated GST invoice dispatching.

---

### Phase 3: Artificial Intelligence & Adaptive Pedagogy (Q3–Q4 2027)

1. **Multimodal AI Mains Answer Evaluation**:
   - Integration with the **Gemini Multimodal API**: Aspirants can photograph their handwritten 10-mark or 15-mark UPSC Mains answers on unruled paper.
   - The AI OCR pipeline transcribes the handwriting, compares it against the standard UPSC model answer key, and evaluates:
     - *Introduction (Contextual framing)*
     - *Body (Dimensions: Social, Economic, Political, Environmental)*
     - *Conclusion (Forward-looking administrative vision)*
     - *Map/Diagram presence and score breakdown*.

2. **Adaptive Diagnostic Recommendation Engine**:
   - Machine learning algorithms analyzing student test performance down to individual sub-topics.
   - If a student repeatedly misses questions on *Article 356 (President's Rule)*, the algorithm automatically serves a 10-minute micro-lecture and 5 targeted practice questions.

3. **WebRTC Peer Study Rooms**:
   - Virtual study rooms enabling aspirants to conduct peer group discussions, mains answer peer-reviews, and interview mock drills using encrypted WebRTC mesh networking.

---

## 3. Academic Conclusion

The implementation of **Sankalp** demonstrates that complex, enterprise-grade EdTech applications can be engineered cleanly using **Flutter and Dart**. By combining structured layered architecture, responsive Material 3 design, comprehensive mock data grounding, and resilient unit/widget testing, Sankalp provides a state-of-the-art prototype that bridges technical excellence with profound social and educational value.
