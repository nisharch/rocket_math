import 'package:flutter/material.dart';

class FractionLearnScreen extends StatefulWidget {
  const FractionLearnScreen({super.key});

  @override
  State<FractionLearnScreen> createState() => _FractionLearnScreenState();
}

class _FractionLearnScreenState extends State<FractionLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("🍕 Understanding Fractions"),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. What is a Fraction?
          AnimatedLearnCard(
            title: "1. What is a Fraction? 🍰",
            content: "A fraction tells us how many EQUAL parts of a whole we have! "
                "Think of cutting a delicious chocolate cake into shared pieces.",
            bgColor: Colors.white,
            borderColor: Colors.orange.shade700,
            bottomChild: _buildFractionPizzaDiagram(),
          ),

          // 2. Numerator vs Denominator
          AnimatedLearnCard(
            title: "2. Meet the Fraction Numbers! 👥",
            content: "A fraction has two parts divided by a fraction line bar:\n\n"
                "• Top Number (Numerator): How many pieces you get! ⭐\n"
                "• Bottom Number (Denominator): Total pieces the whole was cut into! 🧩",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildTermsLabelDiagram(),
          ),

          // 3. Types of Fractions Comparison
          AnimatedLearnCard(
            title: "3. Types of Fraction Families! 🏷️",
            content: "In Class 4, we observe three special types of fraction layouts:",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildFractionTypesTrack(),
          ),

          // 4. Mini Challenge Interactive Practice
          AnimatedLearnCard(
            title: "4. Space Academy Quiz! 📝",
            content: "Q1. What is the denominator in 5/8?\n"
                "Answer: 8 (The bottom total parts number!)\n\n"
                "Q2. What type of fraction is 7/3?\n"
                "Answer: Improper Fraction! (Because the top Numerator is heavier than the bottom!)",
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
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.orange.withOpacity(0.2), width: 2),
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
                  "Fraction Orbit! 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's split up shapes into clean equal chunks smoothly!",
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

  // Visual layout drawing equal parts blocks for 3/4 representation
  Widget _buildFractionPizzaDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            "Visual Block Example: Three-Fourths (3/4)",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade900), // FIXED here
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: index < 3 ? Colors.orange.shade300 : Colors.orange.shade50.withOpacity(0.2),
                  border: Border.all(color: Colors.orange.shade600, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    index < 3 ? "🍰" : "",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "3 Eaten Parts 👥 out of 4 Total Parts = 3/4",
            style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  // Interactive Label stack detailing the numerator vs denominator structures
  Widget _buildTermsLabelDiagram() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("3", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.blue.shade700)),
              const SizedBox(width: 15),
              const Text("➡️  Numerator (Selected Pieces)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 3,
            width: 180,
            color: Colors.grey.shade400,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("4", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.blue.shade900)),
              const SizedBox(width: 15),
              const Text("➡️  Denominator (Total Cut Parts)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  // Gamified step tracking design for mapping proper, improper, mixed families
  Widget _buildFractionTypesTrack() {
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
          _buildTypeNode(
            badgeText: "Proper",
            description: "Top is Smaller! (Example: 2/5)",
            subDetail: "Value is less than 1 whole shape.",
            themeColor: Colors.teal.shade600,
          ),
          _buildTrackDivider(),
          _buildTypeNode(
            badgeText: "Improper",
            description: "Top is Heavier/Equal! (Example: 7/4)",
            subDetail: "Value is larger than 1 whole shape.",
            themeColor: Colors.red.shade600,
          ),
          _buildTrackDivider(),
          _buildTypeNode(
            badgeText: "Mixed",
            description: "Whole Number + Fraction! (Example: 1 ¾)",
            subDetail: "Combines fully complete items with partials.",
            themeColor: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeNode({
    required String badgeText,
    required String description,
    required String subDetail,
    required Color themeColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              badgeText,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
              Text(subDetail, style: const TextStyle(fontSize: 11, color: Colors.black45, fontWeight: FontWeight.w500)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTrackDivider() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 38, top: 4, bottom: 4),
        height: 14,
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