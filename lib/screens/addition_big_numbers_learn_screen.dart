import 'package:flutter/material.dart';

class AdditionBigNumbersLearnScreen extends StatefulWidget {
  const AdditionBigNumbersLearnScreen({super.key});

  @override
  State<AdditionBigNumbersLearnScreen> createState() => _AdditionBigNumbersLearnScreenState();
}

class _AdditionBigNumbersLearnScreenState extends State<AdditionBigNumbersLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("🚀 Class 4 Big Numbers Addition"),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. Core Concept of Regrouping Columns
          AnimatedLearnCard(
            title: "1. The Place Value Grid Blueprint 🗺️",
            content: "Always align your numbers perfectly from right to left! For 3 and 4 digits, we track columns up to the Thousands place:\n\n"
                "• Th = Thousands (1,000s)\n"
                "• H = Hundreds (100s)\n"
                "• T = Tens (10s)\n"
                "• O = Ones (1s)",
            bgColor: Colors.white,
            borderColor: Colors.teal.shade700,
            bottomChild: _buildPlaceValueHeaders(),
          ),

          // 2. Training Mission: 3-Digit Run
          AnimatedLearnCard(
            title: "2. Warm-Up Mission: 3-Digit Run! ⚡",
            content: "Let's review a standard 3-digit addition problem with carry-overs: 468 + 254.",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _build3DigitAdditionTrack(),
          ),

          // 3. Main Mission: 4-Digit Conquest
          AnimatedLearnCard(
            title: "3. Main Mission: 4-Digit Conquest! 🚀",
            content: "Now let's step up to bigger numbers! Let's calculate 4,582 + 2,743 step-by-step.",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _build4DigitAdditionTrack(),
          ),

          // 4. Practical Class 4 Practice Quiz Challenge
          AnimatedLearnCard(
            title: "4. Space Academy Quiz! 📝",
            content: "Problem: A cargo train carries 3,450 kg of rice sacks and 2,870 kg of wheat sacks. What is the total mass combined?\n\n"
                "• Step 1: Ones Column ➡️ 0 + 0 = 0\n"
                "• Step 2: Tens Column ➡️ 5 + 7 = 12 (Write 2, Carry 1 to Hundreds)\n"
                "• Step 3: Hundreds Column ➡️ 4 + 8 + 1 (Carry) = 13 (Write 3, Carry 1 to Thousands)\n"
                "• Step 4: Thousands Column ➡️ 3 + 2 + 1 (Carry) = 6\n\n"
                "🎉 Total Combined Weight = 6,320 kg altogether!",
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
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.teal.withOpacity(0.2), width: 2),
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
                  "Large Numbers Orbit! 🪐",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's master 3-digit and 4-digit addition columns with carry-over powers cleanly!",
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

  // Place value header row map labels
  Widget _buildPlaceValueHeaders() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.teal.shade50.withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text("Th\n(Thousands)", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal)),
          Text("H\n(Hundreds)", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
          Text("T\n(Tens)", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
          Text("O\n(Ones)", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        ],
      ),
    );
  }

  // 3-Digit vertical calculation tracking section
  Widget _build3DigitAdditionTrack() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("1", style: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.bold)),
                    SizedBox(width: 14),
                    Text("1", style: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.bold)),
                    SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 4),
                const Text("4  6  8", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 6)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("+ ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    Text("2  5  4", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 6)),
                  ],
                ),
                Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 2, width: 75, color: Colors.black87),
                const Text("7  2  2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.green, letterSpacing: 6)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                _buildTrackNode("1", "Ones place", "8 + 4 = 12. Write 2, carry over 1 to Tens.", Colors.blue),
                _buildTrackLine(),
                _buildTrackNode("2", "Tens place", "6 + 5 + 1 (Carry) = 12. Write 2, carry over 1 to Hundreds.", Colors.orange),
                _buildTrackLine(),
                _buildTrackNode("3", "Hundreds place", "4 + 2 + 1 (Carry) = 7. Total sum = 722!", Colors.green),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 4-Digit vertical calculation tracking section
  Widget _build4DigitAdditionTrack() {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("1", style: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.bold)),
                    SizedBox(width: 14),
                    Text("1", style: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.bold)),
                    SizedBox(width: 44),
                  ],
                ),
                const SizedBox(height: 4),
                const Text("4  5  8  2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 6)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("+ ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple)),
                    Text("2  7  4  3", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 6)),
                  ],
                ),
                Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 2, width: 90, color: Colors.black87),
                const Text("7  3  2  5", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.green, letterSpacing: 6)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                _buildTrackNode("1", "Ones & Tens", "2+3=5. Then 8+4=12 (Write 2, carry over 1 to Hundreds).", Colors.blue),
                _buildTrackLine(),
                _buildTrackNode("2", "Hundreds Column", "5 + 7 + 1 (Carry) = 13. Write 3, carry over 1 to Thousands.", Colors.orange),
                _buildTrackLine(),
                _buildTrackNode("3", "Thousands Column", "4 + 2 + 1 (Carry) = 7. Write 7 down.", Colors.purple),
                _buildTrackLine(),
                _buildTrackNode("4", "Mission Clear!", "Your total 4-digit sum calculation is 7,325! ✨", Colors.green),
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
        color: Colors.grey.shade200,
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