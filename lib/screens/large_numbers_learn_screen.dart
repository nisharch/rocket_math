import 'package:flutter/material.dart';

class LargeNumbersLearnScreen extends StatefulWidget {
  const LargeNumbersLearnScreen({super.key});

  @override
  State<LargeNumbersLearnScreen> createState() => _LargeNumbersLearnScreenState();
}

class _LargeNumbersLearnScreenState extends State<LargeNumbersLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text("🚀 Thousands Space Station"),
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. Introduction to 4-Digit Numbers
          AnimatedLearnCard(
            title: "1. Welcome to the 4th Digit! 🌌",
            content: "You already know that 999 is the biggest 3-digit number. If we add just 1 more block to it, we blast off into a brand new column orbit:\n\n"
                "• 999 + 1 = 1,000 (One Thousand!)\n"
                "• 1,000 is the smallest 4-digit number, introducing our new friend: the Thousands column!",
            bgColor: Colors.white,
            borderColor: Colors.blueGrey.shade700,
          ),

          // 2. High-Attraction 4-Digit Place Value Chart
          AnimatedLearnCard(
            title: "2. The 4-Digit Control Map 🗺️",
            content: "To read big numbers easily, we place them into four colorful column rooms. Look at how the number 4,375 sits inside its station:",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildAttractivePlaceValueChart(),
          ),

          // 3. Rocket Blast Expanded Form Breakdown
          AnimatedLearnCard(
            title: "3. Place Value Rocket Blaster! 💥",
            content: "• Face Value: The digit itself. It never changes! (Face value of 3 is always 3).\n"
                "• Place Value: The real math power based on its column seat! Let's blast open 4,375:",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildAttractiveRocketBreakdown(),
          ),

          // 4. Practical Class 4 Reading & Writing Quiz
          AnimatedLearnCard(
            title: "4. Space Academy Quiz! 📝",
            content: "Q1. Write the number name for: 5,408\n"
                "Answer: Five thousand, four hundred eight!\n\n"
                "Q2. Write the numeral for: Eight thousand, three hundred fifteen.\n"
                "Answer: 8,315!\n\n"
                "Q3. What is the place value of 7 in 6,724?\n"
                "Answer: 700 (Because it sits in the Hundreds room!)",
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
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.blueGrey.withOpacity(0.2), width: 2),
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
                  "4-Digit Space Base! 🪐",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's chart place value rooms, separate columns, and crack expanded form models!",
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

  // Beautifully Redesigned 4-Digit Place Value Columns (Th, H, T, O)
  Widget _buildAttractivePlaceValueChart() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildControlRoomColumn("Th", "4", Colors.indigo.shade50, Colors.indigo.shade700),
              const SizedBox(width: 4),
              _buildControlRoomColumn("H", "3", Colors.orange.shade50, Colors.deepOrange),
              const SizedBox(width: 4),
              _buildControlRoomColumn("T", "7", Colors.orange.shade50, Colors.deepOrange),
              const SizedBox(width: 4),
              _buildControlRoomColumn("O", "5", Colors.orange.shade50, Colors.deepOrange),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildControlRoomColumn(String codeName, String digitValue, Color bg, Color textThemeColor) {
    return Expanded(
      child: Column(
        children: [
          Text(codeName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black38)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: textThemeColor.withOpacity(0.2), width: 1.5),
            ),
            child: Center(
              child: Text(
                digitValue,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textThemeColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Rocket multi-stage timeline sequence for 4-Digit Expanded Form Breakdown
  Widget _buildAttractiveRocketBreakdown() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          const Center(
            child: Text(
              "🚀 Rocket Launch Expanded Form: 4,375",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.purple),
            ),
          ),
          const SizedBox(height: 14),
          _buildRocketStageRow("4", "Thousands place", "4,000", Colors.indigo.shade600),
          _buildRocketLine(),
          _buildRocketStageRow("3", "Hundreds place", "300", Colors.orange.shade700),
          _buildRocketLine(),
          _buildRocketStageRow("7", "Tens place", "70", Colors.teal.shade600),
          _buildRocketLine(),
          _buildRocketStageRow("5", "Ones place", "5", Colors.green.shade600),
          const Divider(height: 24, thickness: 1),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.withOpacity(0.2)),
            ),
            child: const Text(
              "📝 Combined Blueprint String:\n4,000 + 300 + 70 + 5",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.purple, height: 1.4),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRocketStageRow(String digit, String placeTitle, String mathValue, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: color,
          child: Text(digit, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Text(
          placeTitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            mathValue,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color, letterSpacing: 0.5),
          ),
        )
      ],
    );
  }

  Widget _buildRocketLine() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
        height: 12,
        width: 2,
        color: Colors.purple.withOpacity(0.15),
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