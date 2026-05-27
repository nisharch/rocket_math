import 'package:flutter/material.dart';

class DivisionRemainderScreen extends StatefulWidget {
  const DivisionRemainderScreen({super.key});

  @override
  State<DivisionRemainderScreen> createState() => _DivisionRemainderScreenState();
}

class _DivisionRemainderScreenState extends State<DivisionRemainderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade50,
      appBar: AppBar(
        title: const Text("➗ Division Orbit"),
        backgroundColor: Colors.cyan.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. Core Concept of Remainder
          AnimatedLearnCard(
            title: "1. What is a Remainder? 🍩",
            content: "Sometimes, when we share numbers into equal groups, a few items are left over! "
                "That leftover number is called the Remainder.\n\n"
                "• Example: If you share 7 donuts between 2 friends, each gets 3 donuts, and 1 donut is left over!",
            bgColor: Colors.white,
            borderColor: Colors.cyan.shade700,
            bottomChild: _buildVisualSharingDiagram(),
          ),

          // 2. Meet the Long Division Layout
          AnimatedLearnCard(
            title: "2. The Long Division Map 🗺️",
            content: "Look at how the division friends sit together when we solve problems step-by-step:",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildStandardDivisionDiagram(),
          ),

          // 3. Step-by-Step Long Division Track
          AnimatedLearnCard(
            title: "3. Long Division Mission! 🚀",
            content: "Mission Target: Let's divide 25 ÷ 2 step-by-step to find our remainder balance!",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildLongDivisionStepTrack(),
          ),

          // 4. Checking Your Answer Formula Rule
          AnimatedLearnCard(
            title: "4. The Magical Verification Check! 🔑",
            content: "You can always check if your answer is 100% correct using this secret math superpower equation:\n\n"
                "💥 Dividend = (Divisor × Quotient) + Remainder\n\n"
                "Let's check our target: (2 × 12) + 1 = 24 + 1 = 25! It works!",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange.shade800,
          ),

          // 5. Practical Practice Quiz
          AnimatedLearnCard(
            title: "5. Space Academy Quiz! 📝",
            content: "Q1. Divide 16 by 3. What is the Quotient and Remainder?\n"
                "Answer: Think of your 3 times table! 3 × 5 = 15. \n"
                "Quotient = 5, Remainder = 1! (16 − 15 = 1)\n\n"
                "Q2. Can a remainder ever be bigger than your divisor?\n"
                "Answer: No, never! The remainder must ALWAYS be smaller than the divisor number!",
            bgColor: Colors.green.shade50,
            borderColor: Colors.green.shade700,
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Cartoon Robot Mascot Widget
  Widget _buildHeaderMascot() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.cyan.withOpacity(0.2), width: 2),
      ),
      child: Row(
        children: [
          const Text("🤖", style: TextStyle(fontSize: 50)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Division Station! 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's solve long division problems and track down remaining leftovers!",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Visual layout showing sharing groups
  Widget _buildVisualSharingDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.cyan.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyan.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGroupBadge("Friend 1 👦", "🍩🍩🍩", Colors.blue),
              _buildGroupBadge("Friend 2 👧", "🍩🍩🍩", Colors.pink),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
            child: const Text("🚨 Leftover: 🍩 (1 Remainder!)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red)),
          )
        ],
      ),
    );
  }

  Widget _buildGroupBadge(String name, String items, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(items, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Structural Long Division labeled layout
  Widget _buildStandardDivisionDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 45),
              Text("12", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.blue.shade900)),
              const Text("  ⬅️ Quotient (Answer)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
          Container(margin: const EdgeInsets.only(left: 45, top: 2, bottom: 2), height: 2, width: 60, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Divisor ➡️  ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
              const Text("2 ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
              const Text(") ", style: TextStyle(fontSize: 22, color: Colors.black54)),
              const Text("25", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              const Text("  ⬅️ Dividend (Total)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 35),
              Text("1", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purple)),
              Text("  ⬅️ Remainder (Leftover)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  // Labeled Step Timeline mapping logic track for long division execution
  Widget _buildLongDivisionStepTrack() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const Text("12", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purple)),
                Container(margin: const EdgeInsets.symmetric(vertical: 2), height: 2, width: 45, color: Colors.black38),
                Row(
                  children: const [
                    Text("2 ) ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text("25", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text("−2 ", style: TextStyle(fontSize: 16, color: Colors.black45)),
                // FIXED: Replaced standard generic color name with backward-safe opacity function logic
                Container(margin: const EdgeInsets.symmetric(vertical: 2), height: 1, width: 45, color: Colors.black.withOpacity(0.25)),
                const Text("05", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("−4 ", style: TextStyle(fontSize: 16, color: Colors.black45)),
                Container(margin: const EdgeInsets.symmetric(vertical: 2), height: 1.5, width: 45, color: Colors.black87),
                const Text("1", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              children: [
                _buildTrackNode("1", "Divide Tens", "2 ÷ 2 = 1. Write 1 on top, subtract 2 down.", Colors.blue),
                _buildTrackLine(),
                _buildTrackNode("2", "Bring Down", "Bring down 5 to make it 05.", Colors.orange),
                _buildTrackLine(),
                _buildTrackNode("3", "Divide Ones", "2 goes into 5 twice (2×2=4). Subtract 4.", Colors.green),
                _buildTrackLine(),
                _buildTrackNode("4", "Leftover!", "5 − 4 = 1. Remainder is 1!", Colors.red),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTrackNode(String stepNum, String title, String desc, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: color,
          child: Text(stepNum, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
              Text(desc, style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.2)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTrackLine() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 9, top: 2, bottom: 2),
        height: 12,
        width: 2,
        color: Colors.grey.shade300,
      ),
    );
  }
}

// Hover Responsive Animated Learn Card Widget
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
            border: Border.all(
              color: _isHovered ? widget.borderColor : widget.borderColor.withOpacity(0.4), 
              width: _isHovered ? 3 : 2,
            ),
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
                  Expanded(
                    child: Text(
                      widget.title, 
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.borderColor),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1.0 : 0.3,
                    child: Text("⭐", style: TextStyle(fontSize: _isHovered ? 21 : 16)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                widget.content, 
                style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              if (widget.bottomChild != null) widget.bottomChild!,
            ],
          ),
        ),
      ),
    );
  }
}