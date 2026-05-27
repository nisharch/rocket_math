import 'package:flutter/material.dart';
import 'chapter_screen.dart';
import 'dashboard_screen.dart';
import 'unending_quiz_screen.dart'; 
import '../models/student_model.dart';

class ClassSelectionScreen extends StatefulWidget {
  const ClassSelectionScreen({super.key});

  @override
  State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2F1B7A), Color(0xFF6C5CE7), Color(0xFFE0F7FA)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: const Text("🚀", style: TextStyle(fontSize: 85)),
                  ),
                  const SizedBox(height: 10),
                  
                  Text(
                    "ROCKET MATH",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.yellowAccent.shade100,
                      letterSpacing: 3,
                      shadows: const [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    "Select Your Mission Code! 🛸",
                    style: TextStyle(
                      fontSize: 18, 
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  AnimatedClassCard(
                    classNum: 3,
                    emoji: "🌱",
                    titleText: "CLASS 3",
                    subtitle: "🌟 9 Chapters • Addition to Shapes",
                    color1: const Color(0xFF00FFCC),
                    color2: const Color(0xFF00A8FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChapterScreen(selectedClass: 3),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  AnimatedClassCard(
                    classNum: 4,
                    emoji: "🔥",
                    titleText: "CLASS 4",
                    subtitle: "⚡ 11 Chapters • Big Numbers to Area",
                    color1: const Color(0xFFFF9F43),
                    color2: const Color(0xFFFF4757),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChapterScreen(selectedClass: 4),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 35),

                  _buildCentralQuizButton(context),

                  const SizedBox(height: 16),

                  AnimatedDashboardButton(
                    onTap: () {
                      final student = Student(id: "S1", selectedClass: 3);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DashboardScreen(student: student),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCentralQuizButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF4757), 
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 5,
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        icon: const Text("🎯", style: TextStyle(fontSize: 24)),
        label: const Text(
          "Mega Quiz Challenge Arena ⚡",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _showClassSelectionForQuiz(context);
        },
      ),
    );
  }

  void _showClassSelectionForQuiz(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("🎮 Choose Your Grade", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2F1B7A)), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text("🌱", style: TextStyle(fontSize: 24)),
              title: const Text("Class 3 Quiz Mission", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _showCentralChapterSelection(context, 3);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Text("🔥", style: TextStyle(fontSize: 24)),
              title: const Text("Class 4 Quiz Mission", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _showCentralChapterSelection(context, 4);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCentralChapterSelection(BuildContext context, int selectedClass) {
    final List<Map<String, String>> class3Chapters = [
      {"display": "➕ Addition (যোগ)", "id": "Addition"},
      {"display": "➖ Subtraction (বিয়োগ)", "id": "Subtraction"},
      {"display": "✖️ Multiplication (গুণ)", "id": "Multiplication"},
      {"display": "➗ Division (ভাগ)", "id": "Division"},
      {"display": "📏 Measurement (পরিমাপ)", "id": "Measurement"},
      {"display": "⏰ Time (সময়)", "id": "Time"},
      {"display": "💰 Money (টাকা-পয়সা)", "id": "Money"},
      {"display": "📐 Shapes (আকৃতি)", "id": "Shapes"},
    ];

    final List<Map<String, String>> class4Chapters = [
      {"display": "🔢 Large Numbers (বড় সংখ্যা)", "id": "Large Numbers"},
      {"display": "✖️ Advanced Multiplication", "id": "Adv Multiplication"},
      {"display": "➗ Long Division (লং ডিভিশন)", "id": "Long Division"},
      {"display": "🍕 Fractions (ভগ্নাংশ)", "id": "Fractions"},
      {"display": "📊 Data Handling (উপাত্ত বিন্যাস)", "id": "Data Handling"},
      {"display": "🔄 Perimeter & Area (পরিসীমা ও ক্ষেত্রফল)", "id": "Perimeter Area"},
    ];

    final targetChapters = selectedClass == 3 ? class3Chapters : class4Chapters;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          "🚀 Class $selectedClass Missions", 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2F1B7A)),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: targetChapters.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: selectedClass == 3 ? Colors.teal.shade50 : Colors.orange.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: const Icon(Icons.play_circle_filled, color: Color(0xFF6C5CE7)),
                  title: Text(
                    targetChapters[index]["display"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pop(context); 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UnendingQuizScreen(
                          chapterName: targetChapters[index]["id"]!,
                          classLevel: selectedClass, 
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {}); 
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AnimatedClassCard extends StatefulWidget {
  final int classNum;
  final String emoji;
  final String titleText;
  final String subtitle;
  final Color color1;
  final Color color2;
  final VoidCallback onTap;

  const AnimatedClassCard({
    super.key,
    required this.classNum,
    required this.emoji,
    required this.titleText,
    required this.subtitle,
    required this.color1,
    required this.color2,
    required this.onTap,
  });

  @override
  State<AnimatedClassCard> createState() => _AnimatedClassCardState();
}

class _AnimatedClassCardState extends State<AnimatedClassCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double transformY = _isPressed ? 2.0 : (_isHovered ? -8.0 : 0.0);
    double scale = _isPressed ? 0.97 : (_isHovered ? 1.03 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          transform: Matrix4.identity()
            ..translate(0.0, transformY)
            ..scale(scale),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color1, widget.color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: widget.color2.withOpacity(_isHovered ? 0.6 : 0.4),
                blurRadius: _isHovered ? 25 : 15,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(_isHovered ? 1.2 : 1.0),
                child: Text(widget.emoji, style: const TextStyle(fontSize: 55)),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titleText,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..translate(_isHovered ? 5.0 : 0.0),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.black87,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedDashboardButton extends StatefulWidget {
  final VoidCallback onTap;
  const AnimatedDashboardButton({super.key, required this.onTap});

  @override
  State<AnimatedDashboardButton> createState() => _AnimatedDashboardButtonState();
}

class _AnimatedDashboardButtonState extends State<AnimatedDashboardButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered ? Colors.yellowAccent : Colors.purpleAccent, 
              width: 3,
            ),
            boxShadow: _isHovered 
                ? [BoxShadow(color: Colors.purpleAccent.withOpacity(0.5), blurRadius: 15)] 
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🏆", style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Text(
                "View My Dashboard",
                style: TextStyle(
                  color: _isHovered ? const Color(0xFF2F1B7A) : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}