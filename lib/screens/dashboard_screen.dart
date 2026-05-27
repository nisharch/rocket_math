import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../state/shared_state.dart'; 
import '../widgets/weak_topic_dashboard_card.dart';
import 'unending_quiz_screen.dart'; 

class DashboardScreen extends StatefulWidget {
  final Student student;
  const DashboardScreen({super.key, required this.student});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _rocketController;
  late Animation<double> _rocketAnimation;
  late AnimationController _pulseController;

  List<Map<String, dynamic>> activePerformances = [];
  List<Map<String, dynamic>> recommendedMissions = [];
  List<Map<String, dynamic>> strongMissions = [];

  // ক্লাস ৩ এবং ক্লাস ৪ এর চ্যাপ্টার ফিল্টারিং লিস্ট ডিফাইন করা হলো
  final List<String> class3Chapters = ["subtraction", "multiplication", "division", "measurement", "time", "money", "shapes"];
  final List<String> class4Chapters = ["large numbers", "adv multiplication", "long division", "fractions", "perimeter area", "subtraction"];

  @override
  void initState() {
    super.initState();
    _loadAndAnalyzeData();

    _rocketController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _rocketAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _rocketController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  void _loadAndAnalyzeData() {
    // ১. গ্লোবাল AppStateManager থেকে সব চ্যাপ্টারের আসল লাইভ ডাটা আনা হচ্ছে
    List<Map<String, dynamic>> allPerformances = AppStateManager.getChapterPerformanceList();

    // ২. বর্তমান স্টুডেন্টের সিলেক্ট করা ক্লাস (Class 3 নাকি Class 4) অনুযায়ী ডাটা ফিল্টার করা হচ্ছে
    List<String> currentClassFilter = widget.student.selectedClass == 4 ? class4Chapters : class3Chapters;
    
    activePerformances = allPerformances.where((perf) {
      return currentClassFilter.contains(perf["topic"].toLowerCase().trim());
    }).toList();

    // ৩. একিউরেসি (Accuracy) চেক করে শর্টিং করা হচ্ছে
    List<Map<String, dynamic>> sortedByWeakness = List.from(activePerformances);
    sortedByWeakness.sort((a, b) => a["accuracy"].compareTo(b["accuracy"]));

    setState(() {
      // একিউরেসি ৭৫% এর কম হলে মেরামত মিশন (Weak Chapters) এ সাজানো হবে
      recommendedMissions = sortedByWeakness.where((e) => e["accuracy"] < 75.0).take(3).toList();
      
      // একিউরেসি ৭৫% বা তার বেশি হলে মাস্টার্ড সেকশন (Strong Chapters) এ যাবে
      strongMissions = activePerformances.where((e) => e["accuracy"] >= 75.0).toList();
    });
  }

  @override
  void dispose() {
    _rocketController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int liveTotalXP = AppStateManager.getTotalXP();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // কাস্টম অ্যাপ বার প্যানেল
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context), 
                      ),
                      const Spacer(),
                      Text(
                        "🛸 CLASS ${widget.student.selectedClass} METEOR DASHBOARD",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), 
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // অ্যানিমেটেড ফ্লোٹنگ রকেট
                AnimatedBuilder(
                  animation: _rocketAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _rocketAnimation.value),
                      child: child,
                    );
                  },
                  child: const Text("🚀", style: TextStyle(fontSize: 80)),
                ),
                const SizedBox(height: 15),
                
                Text(
                  "Captain ${widget.student.id == 'S1' ? 'Kid' : widget.student.id}'s Status",
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  "Class ${widget.student.selectedClass} Space Explorer 🪐",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 25),

                // ডায়নামিক এনার্জি এক্সপি (XP) কার্ড মডিউল
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF00F260), Color(0xFF0575E6)]),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Text("👑", style: TextStyle(fontSize: 45)),
                      const SizedBox(width: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL ENERGY SCORE",
                            style: TextStyle(
                              color: const Color(0xFFEEEEEE).withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$liveTotalXP XP", 
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // সেফটি ফলব্যাক: এই ক্লাসের জন্য এখনো কোন কুইজ না খেললে ফাঁকা স্টেট দেখাবে
                if (activePerformances.isEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(24)),
                    child: Center(
                      child: Text(
                        "Radar Scan Empty for Class ${widget.student.selectedClass}! 🛰️\nPlay some dynamic quiz missions first to view analytics.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.4),
                      ),
                    ),
                  ),

                // ১. ইমপ্রুভমেন্ট সেকশন (Weak Chapters Recommendation Box)
                if (recommendedMissions.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text("🛠️ ", style: TextStyle(fontSize: 24)),
                          Text(
                            "Rocket Repair Missions",
                            style: TextStyle(color: Colors.orangeAccent.shade200, fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your engine shield is dropping here! Re-play to boost fuel! 🔥",
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    itemCount: recommendedMissions.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final topic = recommendedMissions[index];
                      return ScaleTransition(
                        scale: Tween<double>(begin: 0.97, end: 1.0).animate(
                          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                        ),
                        child: WeakTopicDashboardCard(
                          topicName: "${topic["topic"]} (${topic["accuracy"].toStringAsFixed(0)}% Accuracy)",
                          currentPoints: topic["points"],
                          onPlayPressed: () {
                            // কুইজ স্ক্রিন পুশ করে জেনারেট করা হচ্ছে
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UnendingQuizScreen(
                                  chapterName: topic["topic"],
                                  classLevel: widget.student.selectedClass,
                                ),
                              ),
                            ).then((value) {
                              // 🚀 কুইজ স্ক্রিন পপ হয়ে ড্যাশবোর্ডে ব্যাক করার সাথে সাথে ডাটা রি-অ্যানালাইসিস ট্রিগার হবে!
                              _loadAndAnalyzeData(); 
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                ],

                // ২. স্ট্রং চ্যাপ্টার সেকশন (Mastered Deep Space Sectors)
                if (strongMissions.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text("⭐ ", style: TextStyle(fontSize: 24)),
                          Text(
                            "Mastered Deep Space Sectors",
                            style: TextStyle(color: Colors.greenAccent.shade200, fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Incredible calculations! You are running maximum power in these sectors! 🚀",
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    itemCount: strongMissions.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final topic = strongMissions[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16162A),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Text("✅", style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(topic["topic"], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text("Accuracy: ${topic["accuracy"].toStringAsFixed(0)}% • Lvl ${topic["level"]}", style: const TextStyle(color: Colors.white60, fontSize: 12)),
                                ],
                              ),
                            ),
                            Text("⭐ ${topic["points"]} XP", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // ৩. রাডার স্ক্যান প্রগ্রেস বার লিস্ট
                if (activePerformances.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: const [
                          Text("🛰️ ", style: TextStyle(fontSize: 24)),
                          Text(
                            "All Space Radar Scans",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    itemCount: activePerformances.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final target = activePerformances[index];
                      double percentageFactor = target["accuracy"] / 100.0;
                      Color barColor = target["accuracy"] >= 75.0 ? Colors.greenAccent : (target["accuracy"] >= 45.0 ? Colors.orangeAccent : Colors.redAccent);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF16162A), borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(target["topic"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                Text("${target["accuracy"].toStringAsFixed(0)}% Accuracy", style: TextStyle(color: barColor, fontWeight: FontWeight.w900, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Stack(
                              children: [
                                Container(height: 8, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(6))),
                                FractionallySizedBox(
                                  widthFactor: percentageFactor.clamp(0.05, 1.0),
                                  child: Container(height: 8, decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(6))),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}