import 'package:flutter/material.dart';
import 'dart:math';

class ShapesLearnScreen extends StatefulWidget {
  const ShapesLearnScreen({super.key});

  @override
  State<ShapesLearnScreen> createState() => _ShapesLearnScreenState();
}

class _ShapesLearnScreenState extends State<ShapesLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Quiz State Tracking Variables
  bool _showAnswer1 = false;
  bool _showAnswer2 = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50, // Warm play-school background canvas
      appBar: AppBar(
        title: const Text("📐 Shapes Kingdom", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          tabs: const [
            Tab(text: "🔺 2D Flat"),
            Tab(text: "🎲 3D Solid"),
            Tab(text: "🕵️‍♂️ Riddles"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Flat Shapes (২D আকৃতি) 🍕",
            summary: "These shapes are completely FLAT like a drawings on paper! Look around your house to find them.",
            tip: "💡 Robo-Tip: 2D shapes only have Length and Width. They do not have any thickness at all!",
            borderColor: Colors.orange,
            child: _buildAnimated2DWorld(),
          ),
          _buildToyboxMission(
            title: "Solid Shapes (৩D আকৃতি) 🎲",
            summary: "These shapes are SOLID! They take up physical space, and you can hold them right in your hand!",
            tip: "💡 Robo-Tip: 3D shapes have length, width, and depth. They can contain things inside them!",
            borderColor: Colors.blueAccent,
            child: _buildAnimated3DWorld(),
          ),
          _buildToyboxMission(
            title: "Fun Shape Riddles! 🕵️‍♂️💬",
            summary: "Can you decode the hidden properties to guess these secret shapes? Tap to open the doors!",
            tip: "👑 Keep going! Crack all the riddles to earn your badge as a Master Shape Detective!",
            borderColor: Colors.green.shade600,
            child: _buildQuestionAnswerSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildToyboxMission({
    required String title,
    required String summary,
    required String tip,
    required Color borderColor,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor),
            ),
            const SizedBox(height: 6),
            Text(
              summary,
              style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: Center(child: child),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor.withOpacity(0.2), width: 1.5),
              ),
              child: Text(
                tip,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: borderColor == Colors.green.shade600 ? Colors.green.shade800 : borderColor, height: 1.3),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MODULE 1: ENLARGED 2D FLAT SHAPES GRID ---
  Widget _buildAnimated2DWorld() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShapeAvatar("🔺", "Triangle", "Samosa 🥳", Colors.red.shade50),
          const SizedBox(width: 16),
          _buildShapeAvatar("🟪", "Square", "Biscuit 🔲", Colors.amber.shade50),
          const SizedBox(width: 16),
          _buildShapeAvatar("🟡", "Circle", "Coin 🪙", Colors.blue.shade50),
        ],
      ),
    );
  }

  // --- MODULE 2: ENLARGED 3D SOLID SHAPES GRID ---
  Widget _buildAnimated3DWorld() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShapeAvatar("🎲", "Cube", "Dice 🎲", Colors.purple.shade50),
          const SizedBox(width: 16),
          _buildShapeAvatar("🍦", "Cone", "Ice Cream 🍦", Colors.orange.shade50),
          const SizedBox(width: 16),
          _buildShapeAvatar("🌍", "Sphere", "Earth 🌍", Colors.green.shade50),
        ],
      ),
    );
  }

  // 🛠️ Updated: Significantly enlarged parameters for higher kid interaction
  Widget _buildShapeAvatar(String emoji, String shapeName, String realExample, Color itemBg) {
    return SizedBox(
      width: 100, // Expanded avatar stack boundaries
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.9, end: 1.05),
            duration: Duration(milliseconds: 600 + Random().nextInt(200)),
            curve: Curves.easeInOutSine,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              padding: const EdgeInsets.all(18), // Increased avatar ring sizes
              decoration: BoxDecoration(color: itemBg, shape: BoxShape.circle),
              child: Text(emoji, style: const TextStyle(fontSize: 42)), // Huge cartoon shape size
            ),
          ),
          const SizedBox(height: 12),
          Text(
            shapeName, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black87), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis
          ),
          const SizedBox(height: 4),
          Text(
            realExample, 
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade600), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis
          ),
        ],
      ),
    );
  }

  // --- MODULE 3: BRIGHT LIGHT-THEME INTERACTIVE RIDDLES ---
  Widget _buildQuestionAnswerSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRiddleCard(
          question: "❓ I am round, I have 0 corners and 0 straight edges. Who am I?",
          answer: "🎯 Answer: I am a Circle! 🟡",
          showAnswer: _showAnswer1,
          onTap: () => setState(() => _showAnswer1 = !_showAnswer1),
        ),
        const SizedBox(height: 12),
        _buildRiddleCard(
          question: "❓ I look like a delicious Samosa with exactly 3 sharp corners. Who am I?",
          answer: "🎯 Answer: I am a Triangle! 🔺",
          showAnswer: _showAnswer2,
          onTap: () => setState(() => _showAnswer2 = !_showAnswer2),
        ),
      ],
    );
  }

  Widget _buildRiddleCard({required String question, required String answer, required bool showAnswer, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 270,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Pure clean light-mode card base
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.shade300, width: 2.5), // Stronger cartoon edges
          boxShadow: const [
            BoxShadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🛠️ Updated: Enlarged font configurations for questions
            Text(
              question, 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black87, height: 1.4)
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: showAnswer ? 12 : 0),
                padding: showAnswer ? const EdgeInsets.all(12) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: showAnswer ? Colors.green.shade50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                // 🛠️ Updated: High contrast bold texts for answer cards
                child: showAnswer 
                    ? Text(
                        answer, 
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.green.shade800)
                      )
                    : Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600, // Vibrant tag visibility
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Tap to Reveal 👁️", 
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}