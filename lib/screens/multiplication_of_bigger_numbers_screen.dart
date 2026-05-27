import 'package:flutter/material.dart';

class MultiplicationBigNumbersScreen extends StatefulWidget {
  const MultiplicationBigNumbersScreen({super.key});

  @override
  State<MultiplicationBigNumbersScreen> createState() => _MultiplicationBigNumbersScreenState();
}

class _MultiplicationBigNumbersScreenState extends State<MultiplicationBigNumbersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("✖️ Big Numbers Multiplication"),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. Concept of Multiplication Friends
          AnimatedLearnCard(
            title: "1. Meet the Multiplication Friends! 👥",
            content: "Before we multiply big numbers, let's remember the names of our math positions:\n\n"
                "• Multiplicand: The big number you want to multiply.\n"
                "• Multiplier: How many times you are multiplying it.\n"
                "• Product: The final space answer you calculate! 🎉",
            bgColor: Colors.white,
            borderColor: Colors.deepPurple.shade700,
          ),

          // 2. Beautifully Redesigned Zero Shortcut Trick Section
          AnimatedLearnCard(
            title: "2. The Magical Zero Shortcut Trick! ⚡",
            content: "When multiplying by numbers ending in zeroes, hide the zeroes, multiply the normal numbers, and snap them back at the end!",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildAttractiveZeroShortcutTrack(),
          ),

          // 3. Step-by-Step Box/Expanded Method Strategy
          AnimatedLearnCard(
            title: "3. 2-Digit Step Mission! 🚀",
            content: "Mission Target: Let's calculate 32 × 14 using standard vertical multi-step tracking lines.",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildMultiplicationStepTrack(),
          ),

          // 4. Practical Class 4 Word Problem Question
          AnimatedLearnCard(
            title: "4. Space Academy Quiz! 📝",
            content: "Problem: A box holds 125 cosmic tokens. How many tokens are there inside 5 boxes altogether?\n\n"
                "• Step 1: Align the digits vertically ➡️ 125 × 5\n"
                "• Step 2: Multiply 5 × 5 = 25 (Carry over 2)\n"
                "• Step 3: Multiply 2 × 5 = 10 + 2 = 12 (Carry over 1)\n"
                "• Step 4: Multiply 1 × 5 = 5 + 1 = 6\n\n"
                "🎉 Total Answer = 625 Cosmic Tokens!",
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
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2), width: 2),
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
                  "Multiplication Base! 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's learn how to multiply large 2-digit and 3-digit numbers cleanly!",
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

  // Visual Horizontal Runway layout for the Zero Shortcut Step Trick
  Widget _buildAttractiveZeroShortcutTrack() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Target Calculation: 45 × 20",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueAccent),
            ),
          ),
          const SizedBox(height: 12),
          _buildZeroStepRow(
            stepNum: "1",
            title: "Hide Zeroes 🕳️",
            mathBlock: "45 × 2 [ 0 ]",
            color: Colors.orange.shade700,
          ),
          _buildZeroConnector(),
          _buildZeroStepRow(
            stepNum: "2",
            title: "Multiply Core Numbers 🧠",
            mathBlock: "45 × 2 = 90",
            color: Colors.blue.shade700,
          ),
          _buildZeroConnector(),
          _buildZeroStepRow(
            stepNum: "3",
            title: "Bring Back the Zero! ✨",
            mathBlock: "90 + [ 0 ] ➡️ 900",
            color: Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildZeroStepRow({
    required String stepNum,
    required String title,
    required String mathBlock,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: color,
          child: Text(stepNum, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                Text(mathBlock, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black87)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildZeroConnector() {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 2, bottom: 2),
      height: 12,
      width: 2,
      color: Colors.blueAccent.withOpacity(0.2),
    );
  }

  // Vertical layout tracking double step partial product systems
  Widget _buildMultiplicationStepTrack() {
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
                const Text("32", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("× ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
                    Text("14", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  ],
                ),
                Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 1.5, width: 55, color: Colors.black38),
                const Text("128", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue, letterSpacing: 2)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("+ ", style: TextStyle(fontSize: 12, color: Colors.black38)),
                    Text("320", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.orange, letterSpacing: 2)),
                  ],
                ),
                Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 55, color: Colors.black87),
                const Text("448", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green, letterSpacing: 2)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              children: [
                _buildTrackNode("1", "Ones Power", "Multiply 32 × 4 Ones ➡️ 128", Colors.blue),
                _buildTrackLine(),
                _buildTrackNode("2", "Magic Space", "Put a '0' placeholder in the Ones place.", Colors.orange),
                _buildTrackLine(),
                _buildTrackNode("3", "Tens Power", "Multiply 32 × 1 Tens ➡️ 320", Colors.purple),
                _buildTrackLine(),
                _buildTrackNode("4", "Total Combine", "Add both parts: 128 + 320 = 448! ✨", Colors.green),
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