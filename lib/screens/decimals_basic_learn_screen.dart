import 'package:flutter/material.dart';

class DecimalsBasicLearnScreen extends StatefulWidget {
  const DecimalsBasicLearnScreen({super.key});

  @override
  State<DecimalsBasicLearnScreen> createState() => _DecimalsBasicLearnScreenState();
}

class _DecimalsBasicLearnScreenState extends State<DecimalsBasicLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("🔢 Decimals Station"),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. What is a Decimal?
          AnimatedLearnCard(
            title: "1. What is a Decimal Point? 🎯",
            content: "A decimal point (.) is a magical dot used to separate whole numbers from parts of a number (fractions)!\n\n"
                "Anything to the LEFT of the dot is a Whole Number.\n"
                "Anything to the RIGHT of the dot is a Fraction Part.",
            bgColor: Colors.white,
            borderColor: Colors.teal.shade700,
            bottomChild: _buildDecimalSplitDiagram(),
          ),

          // 2. Tenths and Hundredths Visualized
          AnimatedLearnCard(
            title: "2. Tenths & Hundredths! 🟧",
            content: "Let's count the columns to understand parts:\n"
                "• 1 Tenth (0.1) = 1 out of 10 equal parts.\n"
                "• 1 Hundredth (0.01) = 1 out of 100 equal parts.",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildTenthsGridDiagram(),
          ),

          // 3. Decimal Place Value Chart
          AnimatedLearnCard(
            title: "3. Decimal Place Value Chart 🗺️",
            content: "As you move right from the decimal point, the value gets smaller and smaller! Look at how we place the parts:",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange.shade800,
            bottomChild: _buildPlaceValueTable(),
          ),

          // 4. Reading & Writing Decimals Step-by-Step
          AnimatedLearnCard(
            title: "4. Mission: Reading Decimals! 🚀",
            content: "Mission Target: Let's learn how to read and write the number 14.35 correctly!",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildReadingDecimalsTrack(),
          ),

          // 5. Mini Practice Challenge
          AnimatedLearnCard(
            title: "5. Try it Yourself! 📝",
            content: "Q1. Write 5 tenths as a decimal.\n"
                "Answer: 5/10 = 0.5\n\n"
                "Q2. Write 7 hundredths as a decimal.\n"
                "Answer: 7/100 = 0.07\n\n"
                "Q3. Read out loud: 8.42\n"
                "Answer: Eight point four two! (Never say forty-two!)",
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
                  "Decimal Orbit! 🔢",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's break whole numbers into micro-fractions with the magic dot!",
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

  // Splitting diagram highlighting Left vs Right parts of a decimal number
  Widget _buildDecimalSplitDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.teal.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSplitBadge("Whole Part\n( 25 )", Colors.blue),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text("🔴\nDot", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14)),
          ),
          _buildSplitBadge("Decimal Part\n( 7 )", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSplitBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
    );
  }

  // Shaded fractional blocks showing 4 tenths shaded (4/10 = 0.4)
  Widget _buildTenthsGridDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text("Visual Model: 4 Tenths (0.4)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              10,
              (index) => Container(
                width: 22,
                height: 40,
                // FIXED: Moved background color and border assignment inside a common BoxDecoration
                decoration: BoxDecoration(
                  color: index < 4 ? Colors.blue.shade300 : Colors.blue.shade50.withOpacity(0.2),
                  border: Border.all(color: Colors.blueAccent, width: 0.5),
                ),
                child: Center(
                  child: Text(
                    index < 4 ? "⭐" : "",
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text("4 Blocks Shaded out of 10 = 4/10 = 0.4", style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Place Value block chart grid
  Widget _buildPlaceValueTable() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlaceValueColumn("Tens", "1", Colors.black54),
          _buildPlaceValueColumn("Ones", "4", Colors.black54),
          _buildPlaceValueColumn("DOT", ".", Colors.red),
          _buildPlaceValueColumn("Tenths\n(1/10)", "3", Colors.orange.shade700),
          _buildPlaceValueColumn("Hundredths\n(1/100)", "5", Colors.orange.shade700),
        ],
      ),
    );
  }

  Widget _buildPlaceValueColumn(String heading, String digit, Color valueColor) {
    return Column(
      children: [
        Text(heading, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: digit == "." ? Colors.transparent : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            digit,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: valueColor),
          ),
        )
      ],
    );
  }

  // Gamified step tracking design for decoding decimals rules
  Widget _buildReadingDecimalsTrack() {
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
          _buildTrackNode(
            stepNum: "1",
            stepTitle: "Read the Whole Number first 🟢",
            description: "Look at '14' ➡️ Read as 'Fourteen'",
            themeColor: Colors.green.shade600,
          ),
          _buildTrackDivider(),
          _buildTrackNode(
            stepNum: "2",
            stepTitle: "Say the Dot out loud 🔴",
            description: "Say the word 'Point' explicitly",
            themeColor: Colors.red.shade600,
          ),
          _buildTrackDivider(),
          _buildTrackNode(
            stepNum: "3",
            stepTitle: "Read right digits SEPARATELY 🔵",
            description: "Look at '35' ➡️ Read as 'Three Five' (Not thirty-five)",
            themeColor: Colors.blue.shade600,
          ),
          _buildTrackDivider(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.2)),
            ),
            child: const Text(
              "🗣️ Speak it together: 'Fourteen point three five'",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTrackNode({
    required String stepNum,
    required String stepTitle,
    required String description,
    required Color themeColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: themeColor,
          child: Text(stepNum, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stepTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: themeColor)),
            Text(description, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }

  Widget _buildTrackDivider() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 9, top: 4, bottom: 4),
        height: 14,
        width: 2,
        color: Colors.purple.withOpacity(0.2),
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