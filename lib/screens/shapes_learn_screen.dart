import 'dart:math';
import 'package:flutter/material.dart';

class ShapesLearnScreen extends StatefulWidget {
  const ShapesLearnScreen({super.key});

  @override
  State<ShapesLearnScreen> createState() => _ShapesLearnScreenState();
}

class _ShapesLearnScreenState extends State<ShapesLearnScreen> {
  // প্রশ্ন-উত্তরের স্টেট ট্র্যাকিং ভেরিয়েবল
  bool _showAnswer1 = false;
  bool _showAnswer2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("📐 Shapes Kingdom"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // কার্টুন রোবট গাইড মাসকট
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // ১. ২D ফ্ল্যাট আকৃতি
          AnimatedLearnCard(
            title: "1. Flat Shapes (২D আকৃতি) 🍕",
            content: "These shapes are completely FLAT like a drawing on paper! Let's see them around us:",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange,
            bottomChild: _buildAnimated2DWorld(),
          ),

          // ২. ৩D সলিড আকৃতি
          AnimatedLearnCard(
            title: "2. Solid Shapes (৩D আকৃতি) 🎲",
            content: "These shapes are SOLID! They are fat, take up space, and you can hold them in your hand!",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildAnimated3DWorld(),
          ),

          // ৩. ইন্টারেক্টিভ প্রশ্ন-উত্তর সেকশন (Shape Riddles!)
          AnimatedLearnCard(
            title: "3. Fun Shape Riddles! 🕵️‍♂️💬",
            content: "Can you guess these secret shapes? Tap to reveal the answer!",
            bgColor: Colors.green.shade50,
            borderColor: Colors.green,
            bottomChild: _buildQuestionAnswerSection(),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // কার্টুন রোবট গাইড মাসকট উইজেট
  Widget _buildHeaderMascot() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(
          color: Colors.deepPurple.withOpacity(0.2), 
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Text("🤖", style: TextStyle(fontSize: 50)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Shape Match Adventure! 🚀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                SizedBox(height: 2),
                Text("Look around! Everything has a beautiful shape!", style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ২D ফ্ল্যাট শেপ গ্রিড (সিঙাড়া ও জন্মদিনের টুপি উদাহরণ সহ)
  Widget _buildAnimated2DWorld() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildShapeAvatar("🔺", "Triangle", "Samosa / Hat 🥳", Colors.red.shade100),
          _buildShapeAvatar("🟪", "Square", "Biscuit 🔲", Colors.amber.shade100),
          _buildShapeAvatar("🟡", "Circle", "Coin 🪙", Colors.blue.shade100),
        ],
      ),
    );
  }

  // ৩D সলিড শেপ গ্রিড
  Widget _buildAnimated3DWorld() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildShapeAvatar("🎲", "Cube", "Playing Dice", Colors.purple.shade50),
          _buildShapeAvatar("🍦", "Cone", "Ice Cream 🍦", Colors.orange.shade100),
          _buildShapeAvatar("🌍", "Sphere", "Our Earth 🌍", Colors.green.shade100),
        ],
      ),
    );
  }

  // বাউন্সি শেপ অবতার জেনারেটর
  Widget _buildShapeAvatar(String emoji, String shapeName, String realExample, Color itemBg) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.85, end: 1.1),
          duration: Duration(milliseconds: 500 + Random().nextInt(300)),
          curve: Curves.easeInOutSine,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: itemBg, shape: BoxShape.circle),
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(height: 6),
        Text(shapeName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black87)),
        const SizedBox(height: 2),
        Text(realExample, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
      ],
    );
  }

  // ৩ নম্বর কার্ডের ভেতরের কুইজ উইজেট
  Widget _buildQuestionAnswerSection() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildRiddleCard(
          question: "❓ I am round and round, I have 0 corners and 0 edges. Who am I?",
          answer: "🎯 Answer: I am a Circle! 🟡 (or Sphere!)",
          showAnswer: _showAnswer1,
          onTap: () => setState(() => _showAnswer1 = !_showAnswer1),
        ),
        const SizedBox(height: 12),
        _buildRiddleCard(
          question: "❓ I look like a delicious Samosa and I have exactly 3 sharp corners. Who am I?",
          answer: "🎯 Answer: I am a Triangle! 🔺",
          showAnswer: _showAnswer2,
          onTap: () => setState(() => _showAnswer2 = !_showAnswer2),
        ),
      ],
    );
  }

  // কুইজের জন্য কাস্টম ট্যাপেবল রিডল কার্ড
  Widget _buildRiddleCard({required String question, required String answer, required bool showAnswer, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: showAnswer ? 10 : 0),
                padding: showAnswer ? const EdgeInsets.all(10) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: showAnswer ? Colors.green.shade50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: showAnswer 
                    ? Text(answer, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.green))
                    : Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                          child: const Text("Tap to Reveal 👁️", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black45)),
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

// অল-প্ল্যাটফর্ম রেসপন্সিভ হোভার ও টাচ অ্যানিমেটেড লার্ন কার্ড উইজেট
class AnimatedLearnCard extends StatefulWidget {
  final String title;
  final String content;
  final Color bgColor;
  final Color borderColor;
  final Widget? bottomChild;

  const AnimatedLearnCard({
    super.key,
    required this.title,
    required this.content,
    required this.bgColor,
    required this.borderColor,
    this.bottomChild,
  });

  @override
  State<AnimatedLearnCard> createState() => _AnimatedLearnCardState();
}

class _AnimatedLearnCardState extends State<AnimatedLearnCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double transformY = _isPressed ? 2.0 : (_isHovered ? -6.0 : 0.0);
    double scale = _isPressed ? 0.98 : (_isHovered ? 1.02 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(18),
          transform: Matrix4.identity()..translate(0.0, transformY)..scale(scale),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _isHovered ? widget.borderColor : widget.borderColor.withOpacity(0.4), width: _isHovered ? 3 : 2),
            boxShadow: [
              BoxShadow(
                color: widget.borderColor.withOpacity(_isHovered ? 0.2 : 0.06),
                blurRadius: _isHovered ? 14.0 : 4.0,
                offset: Offset(0, _isHovered ? 6.0 : 2.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(widget.title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.borderColor))),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1.0 : 0.3,
                    child: const Text("⭐", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(widget.content, style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87, fontWeight: FontWeight.w500)),
              if (widget.bottomChild != null) widget.bottomChild!,
            ],
          ),
        ),
      ),
    );
  }
}