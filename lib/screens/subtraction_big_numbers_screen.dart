import 'package:flutter/material.dart';

class SubtractionBigNumbersScreen extends StatefulWidget {
  const SubtractionBigNumbersScreen({super.key});

  @override
  State<SubtractionBigNumbersScreen> createState() => _SubtractionBigNumbersScreenState();
}

class _SubtractionBigNumbersScreenState extends State<SubtractionBigNumbersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text("➖ Big Numbers Subtraction"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. Concept of Subtraction Terms
          AnimatedLearnCard(
            title: "1. The Subtraction Terms! 👥",
            content: "Let's learn the secret names of the numbers when we subtract:\n\n"
                "• Minuend: The big number at the top you start with.\n"
                "• Subtrahend: The number you are taking away.\n"
                "• Difference: The final answer left over! 🏁",
            bgColor: Colors.white,
            borderColor: Colors.red.shade700,
          ),

          // 2. Place Value Vertical Alignment Map
          AnimatedLearnCard(
            title: "2. Line Up the Columns! 🗺️",
            content: "Always line up your big numbers correctly by their place values! Start subtracting from the Ones column on the right, then move left.",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildPlaceValueAlignmentDiagram(),
          ),

          // 3. Step-by-Step Borrowing Mission (Regrouping) with Individual Cross-outs
          AnimatedLearnCard(
            title: "3. Mission: Borrowing Over Zeros! 🚀",
            content: "What do you do if the top number is too small? You borrow from your neighbor! Let's solve 503 − 267 step-by-step.",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildBorrowingStepTrack(),
          ),

          // 4. Practical Class 4 Challenge Quiz
          AnimatedLearnCard(
            title: "4. Space Academy Quiz! 📝",
            content: "Problem: A cargo rocket carries 4,500 kg of fuel. It uses 1,250 kg during takeoff. How much fuel is left?\n\n"
                "• Step 1: Align digits vertically ➡️ 4500 − 1250\n"
                "• Step 2: Ones place ➡️ 0 − 0 = 0\n"
                "• Step 3: Tens place ➡️ Borrow! 10 − 5 = 5\n"
                "• Step 4: Hundreds place ➡️ 4 − 2 = 2\n"
                "• Step 5: Thousands place ➡️ 4 − 1 = 3\n\n"
                "🎉 Total Answer = 3,250 kg Leftover!",
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
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.red.withOpacity(0.2), width: 2),
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
                  "Subtraction Base! 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Master borrowing and column regrouping for large numbers easily!",
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

  // Vertical grid mapping out place value columns
  Widget _buildPlaceValueAlignmentDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlaceValueColumn("H", "Hundreds", Colors.black54),
          _buildPlaceValueColumn("T", "Tens", Colors.black54),
          _buildPlaceValueColumn("O", "Ones", Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildPlaceValueColumn(String shortHand, String fullName, Color textTheme) {
    return Column(
      children: [
        Text(shortHand, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textTheme)),
        const SizedBox(height: 4),
        Text(fullName, style: const TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Vertical mathematical layout with clean individual row digit tracking crossouts
  Widget _buildBorrowingStepTrack() {
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
          // Vertical equation block with isolated individual digit cross-outs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Top carry/borrow indicators explicitly aligned with columns
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("4", style: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.bold)),
                    SizedBox(width: 14),
                    Text("9", style: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Text("13", style: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                // Minuend row showing individual clean number strikethroughs
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("5", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, decorationColor: Colors.purple, decorationThickness: 2)),
                    SizedBox(width: 12),
                    Text("0", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, decorationColor: Colors.purple, decorationThickness: 2)),
                    SizedBox(width: 12),
                    Text("3", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), 
                  ],
                ),
                // Subtrahend row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("− ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                    Text("2", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 12),
                    Text("6", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 12),
                    Text("7", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 2, width: 75, color: Colors.black87),
                // Final product difference row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("2", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green)),
                    SizedBox(width: 12),
                    Text("3", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green)),
                    SizedBox(width: 12),
                    Text("6", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Step tracking timeline descriptions
          Expanded(
            child: Column(
              children: [
                _buildTrackNode("1", "Ones Power", "3 − 7 is impossible! Go to borrow.", Colors.blue),
                _buildTrackLine(),
                _buildTrackNode("2", "Zero Cross", "Tens is 0! Borrow from Hundreds. 5 gets crossed out and becomes 4. Tens becomes 10.", Colors.orange),
                _buildTrackLine(),
                _buildTrackNode("3", "Share Back", "Now Tens lends to Ones! 10 gets crossed out and becomes 9. 3 turns into 13.", Colors.purple),
                _buildTrackLine(),
                _buildTrackNode("4", "Final Run", "Subtract column by column: 13−7=6, 9−6=3, 4−2=2. Answer = 236!", Colors.green),
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