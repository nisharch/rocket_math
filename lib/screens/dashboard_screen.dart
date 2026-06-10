import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/student_model.dart';
import '../services/quiz_service.dart';
import 'unending_quiz_screen.dart';
import 'global_quiz.dart'; // ← your new file

class DashboardScreen extends StatelessWidget {
  final Student student;

  const DashboardScreen({
    super.key,
    required this.student,
  });

  // ── Fetch Global Quiz stats doc for the current user ──────────
  Stream<Map<String, dynamic>> _watchGlobalQuizStats() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('quiz_stats')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return {};
      final data = doc.data() ?? {};
      // The global quiz saves under key 'Global Quiz (Class 3 & 4)'
      final raw = data['Global Quiz (Class 3 & 4)'];
      if (raw == null) return {};
      return Map<String, dynamic>.from(raw as Map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: Text("🚀 Smart Dashboard • Class ${student.selectedClass}"),
        backgroundColor: const Color(0xFF2F1B7A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: QuizService().watchWeakestChapters(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chapters = snapshot.data!;

          int totalCorrect = 0;
          int totalWrong = 0;
          for (var chapter in chapters) {
            totalCorrect += chapter['correctAnswers'] as int;
            totalWrong   += chapter['wrongAnswers']   as int;
          }
          int totalQuestions    = totalCorrect + totalWrong;
          double overallAccuracy = totalQuestions == 0
              ? 0
              : (totalCorrect / totalQuestions) * 100;
          int xp    = totalCorrect * 10;
          int level = (xp ~/ 100) + 1;

          // AI recommendation
          String aiMessage = "Excellent progress Captain 🚀";
          if (chapters.isNotEmpty) {
            chapters.sort((a, b) =>
                (a['averageAccuracy'] as double)
                    .compareTo(b['averageAccuracy'] as double));
            final weakest  = chapters.first;
            double weakAcc = weakest['averageAccuracy'] * 100;
            if (weakAcc < 40) {
              aiMessage =
                  "🚨 Critical: Practice ${weakest['chapterName']} immediately.";
            } else if (weakAcc < 70) {
              aiMessage =
                  "🧠 AI Coach: Focus more on ${weakest['chapterName']}.";
            }
          }

          final weakTopics   = chapters.where((c) => (c['averageAccuracy'] as double) * 100 < 70).toList();
          final strongTopics = chapters.where((c) => (c['averageAccuracy'] as double) * 100 >= 85).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ════════════════════════════════════════
                // 🚀 PERFORMANCE OVERVIEW
                // ════════════════════════════════════════
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF4834D4)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("🚀 Performance Overview",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem("🎯", "$totalQuestions", "Questions"),
                          _buildStatItem("✅", "$totalCorrect",   "Correct"),
                          _buildStatItem("❌", "$totalWrong",     "Wrong"),
                          _buildStatItem("⭐", "${overallAccuracy.toStringAsFixed(0)}%", "Accuracy"),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniCard("🔥 XP",    "$xp"),
                          _buildMiniCard("🚀 Level", "$level"),
                          _buildMiniCard("🏆 Rank",
                              level >= 10 ? "Master" : level >= 5 ? "Pro" : "Beginner"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ════════════════════════════════════════
                // 📊 CHAPTER PROGRESS
                // ════════════════════════════════════════
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("📊 Chapter Progress",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F1B7A))),
                      const SizedBox(height: 20),
                      ...chapters.map((chapter) {
                        double accuracy =
                            (chapter['averageAccuracy'] as double) * 100;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(chapter['chapterName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text("${accuracy.toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: accuracy / 100,
                                  minHeight: 14,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation(
                                    accuracy >= 85
                                        ? Colors.green
                                        : accuracy >= 70
                                            ? Colors.orange
                                            : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ════════════════════════════════════════
                // ⚠️ WEAK TOPICS
                // ════════════════════════════════════════
                if (weakTopics.isNotEmpty)
                  _buildSectionTitle("⚠️ Weak Topics", Colors.red),
                ...weakTopics.map((item) {
                  double accuracy = item['averageAccuracy'] * 100;
                  return _buildTopicCard(
                      context, item['chapterName'], accuracy,
                      Colors.red, Icons.trending_down);
                }),

                // ════════════════════════════════════════
                // 💪 STRONG TOPICS
                // ════════════════════════════════════════
                if (strongTopics.isNotEmpty)
                  _buildSectionTitle("💪 Strong Topics", Colors.green),
                ...strongTopics.map((item) {
                  double accuracy = item['averageAccuracy'] * 100;
                  return _buildTopicCard(
                      context, item['chapterName'], accuracy,
                      Colors.green, Icons.star);
                }),

                const SizedBox(height: 24),

                // ════════════════════════════════════════
                // 🧠 AI RECOMMENDATION
                // ════════════════════════════════════════
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFF9F43), Color(0xFFFF6B6B)]),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("🧠 AI Coach Recommendation",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(aiMessage,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ════════════════════════════════════════
                // 🌍 GLOBAL QUIZ STATS  ← NEW SECTION
                // ════════════════════════════════════════
                _buildSectionTitle("🌍 Global Quiz Performance", const Color(0xFF6C5CE7)),

                StreamBuilder<Map<String, dynamic>>(
                  stream: _watchGlobalQuizStats(),
                  builder: (context, gSnap) {
                    if (!gSnap.hasData || gSnap.data!.isEmpty) {
                      // Not played yet — show invite card
                      return _buildGlobalQuizInviteCard(context);
                    }

                    final g = gSnap.data!;
                    final int gCorrect  = g['correctAnswers']  as int? ?? 0;
                    final int gWrong    = g['wrongAnswers']    as int? ?? 0;
                    final int gTotal    = gCorrect + gWrong;
                    final double gAcc   = gTotal == 0 ? 0 : (gCorrect / gTotal) * 100;
                    final int gScore    = g['score']           as int? ?? 0;
                    final int gAnswered = g['totalAnswered']   as int? ?? 0;
                    final int gStreak   = g['streak']          as int? ?? 0;
                    final int gXp       = g['xp']              as int? ?? 0;

                    // Derive weak/strong insight from chapter-level data
                    // Global quiz doesn't track per-chapter, so we show overall
                    // and compare against the per-chapter quiz to give advice.
                    String globalInsight;
                    if (gAcc >= 85) {
                      globalInsight = "🏆 You're dominating the Global Quiz! Keep it up!";
                    } else if (gAcc >= 65) {
                      globalInsight = "📈 Good effort! Work on weak chapters to boost your score.";
                    } else if (gAcc >= 40) {
                      globalInsight = "💪 Keep practising! Focus on Class 3 & 4 basics.";
                    } else {
                      globalInsight = "🚨 Needs improvement. Try chapter quizzes first, then revisit.";
                    }

                    Color accColor = gAcc >= 85
                        ? const Color(0xFF2ECC71)
                        : gAcc >= 65
                            ? const Color(0xFFFF9F43)
                            : const Color(0xFFFF4757);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 4))],
                      ),
                      child: Column(children: [

                        // ── Header gradient band ──────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6C5CE7), Color(0xFF00CEC9)]),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24)),
                          ),
                          child: Row(
                            children: [
                              const Text("🌍",
                                  style: TextStyle(fontSize: 30)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Global Quiz  (Class 3 & 4)",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900)),
                                    Text("Mixed chapter challenge",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.75),
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              // Big accuracy circle
                              Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.15),
                                  border: Border.all(
                                      color: accColor, width: 3)),
                                child: Center(
                                  child: Text(
                                    "${gAcc.toStringAsFixed(0)}%",
                                    style: TextStyle(
                                        color: accColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Stats grid ───────────────────────
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                _buildGlobalStat("🎯", "$gAnswered", "Answered"),
                                _buildGlobalStat("✅", "$gCorrect",  "Correct"),
                                _buildGlobalStat("❌", "$gWrong",    "Wrong"),
                                _buildGlobalStat("🔥", "$gStreak",   "Best Streak"),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                _buildGlobalStat("⭐", "$gScore",  "Score"),
                                _buildGlobalStat("💎", "$gXp",    "XP Earned"),
                                _buildGlobalStat("📊", "${gAcc.toStringAsFixed(0)}%", "Accuracy"),
                                _buildGlobalStat("🏅",
                                    gAcc >= 85 ? "Elite" : gAcc >= 65 ? "Rising" : "Rookie",
                                    "Global Rank"),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // ── Accuracy progress bar ────────
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Overall Accuracy",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: Color(0xFF2F1B7A))),
                                    Text(
                                        gAcc >= 85
                                            ? "🟢 Strong"
                                            : gAcc >= 65
                                                ? "🟡 Average"
                                                : "🔴 Needs Work",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: accColor)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: gAcc / 100,
                                    minHeight: 12,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor:
                                        AlwaysStoppedAnimation(accColor),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // ── AI insight for global quiz ───
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C5CE7).withOpacity(0.07),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF6C5CE7)
                                        .withOpacity(0.25))),
                              child: Text(globalInsight,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4834D4),
                                      height: 1.4)),
                            ),

                            const SizedBox(height: 16),

                            // ── Cross-reference weak chapters ─
                            if (weakTopics.isNotEmpty) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: Colors.red.withOpacity(0.2))),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text("📌 Chapters to focus on in Global Quiz:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                            color: Colors.red)),
                                    const SizedBox(height: 8),
                                    ...weakTopics.take(4).map((wt) {
                                      double wtAcc =
                                          (wt['averageAccuracy'] as double) *
                                              100;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 6),
                                        child: Row(children: [
                                          const Icon(
                                              Icons.arrow_right_rounded,
                                              size: 18,
                                              color: Colors.red),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              wt['chapterName'],
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: Color(0xFF333333)),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.red
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                            child: Text(
                                              "${wtAcc.toStringAsFixed(0)}%",
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ]),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            // ── Play Again button ─────────────
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6C5CE7),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)),
                                  elevation: 4,
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const GlobalQuizScreen()),
                                ),
                                icon: const Icon(Icons.play_arrow_rounded,
                                    size: 22),
                                label: const Text("Play Global Quiz Again 🌍",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    );
                  },
                ),

                const SizedBox(height: 24),

               
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  Global Quiz — invite card (first-time player)
  // ════════════════════════════════════════════════════════════════
  Widget _buildGlobalQuizInviteCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFF00CEC9)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6))],
      ),
      child: Column(children: [
        const Text("🌍", style: TextStyle(fontSize: 48)),
        const SizedBox(height: 10),
        const Text("You haven't tried the\nGlobal Quiz yet!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1.4)),
        const SizedBox(height: 8),
        const Text(
            "A mixed challenge with questions from ALL Class 3 & 4 chapters. "
            "Test yourself across every topic and see where you stand!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white70, fontSize: 13, height: 1.5)),
        const SizedBox(height: 18),
        // Feature chips
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            _featureChip("⏱ Adaptive Timer"),
            _featureChip("🔀 Mixed Topics"),
            _featureChip("🔥 Streak Bonus"),
            _featureChip("💎 XP Rewards"),
          ],
        ),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF6C5CE7),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const GlobalQuizScreen()),
          ),
          icon: const Icon(Icons.play_arrow_rounded, size: 22),
          label: const Text("Start Global Quiz 🚀",
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w900)),
        ),
      ]),
    );
  }

  Widget _featureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  Global quiz mini-stat cell
  // ════════════════════════════════════════════════════════════════
  Widget _buildGlobalStat(String emoji, String value, String label) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2F1B7A))),
      Text(label,
          style: const TextStyle(fontSize: 10, color: Colors.black45)),
    ]);
  }

  // ════════════════════════════════════════════════════════════════
  //  Existing helpers (unchanged)
  // ════════════════════════════════════════════════════════════════
  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 6),
      Text(value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold)),
      Text(label,
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ]);
  }

  Widget _buildMiniCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ]),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(title,
          style: TextStyle(
              color: color, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTopicCard(BuildContext context, String chapter, double accuracy,
      Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white)),
          title: Text(chapter),
          subtitle: Text(
              "Accuracy ${accuracy.toStringAsFixed(0)}%"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UnendingQuizScreen(
                chapterName: chapter,
                classLevel: student.selectedClass,
              ),
            ),
          ),
        ),
      ),
    );
  }
}