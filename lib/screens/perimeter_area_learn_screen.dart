import 'package:flutter/material.dart';

class PerimeterAreaLearnScreen extends StatefulWidget {
  const PerimeterAreaLearnScreen({super.key});

  @override
  State<PerimeterAreaLearnScreen> createState() => _PerimeterAreaLearnScreenState();
}

class _PerimeterAreaLearnScreenState extends State<PerimeterAreaLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade50,
      appBar: AppBar(
        title: const Text("📐 Perimeter & Area Orbit"),
        backgroundColor: Colors.lightGreen.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. Perimeter Concept
          AnimatedLearnCard(
            title: "1. What is Perimeter? 🧱",
            content: "Perimeter is the total boundary line around the OUTSIDE of any closed shape! "
                "Think of it like building a fence around your garden.\n\n"
                "• To find it: Simply ADD all the outer sides together!",
            bgColor: Colors.white,
            borderColor: Colors.lightGreen.shade700,
            bottomChild: _buildPerimeterVisualDiagram(),
          ),

          // 2. Area Concept
          AnimatedLearnCard(
            title: "2. What is Area? 🟧",
            content: "Area is the total amount of flat space INSIDE a shape! "
                "Think of it like counting how many square tiles you need to cover your bedroom floor.\n\n"
                "• Measured in: Square units (like sq. cm or sq. m)!",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildAreaGridDiagram(),
          ),

          // 3. Rectangle & Square Master Formulas
          AnimatedLearnCard(
            title: "3. Golden Shape Formulas! 🏆",
            content: "Use these superpower formulas to calculate quickly without counting squares manually:",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange.shade800,
            bottomChild: _buildFormulaTableDiagram(),
          ),

          // 4. Beautifully Redesigned Step-by-Step Interactive Mission Card
          AnimatedLearnCard(
            title: "4. Step-by-Step Mission! 🚀",
            content: "Mission Target: A playground is 6 meters long and 4 meters wide. Let's calculate its total size rules!",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildAttractiveMissionTrack(),
          ),

          // 5. Mini Challenge For Students
          AnimatedLearnCard(
            title: "5. Space Academy Quiz! 📝",
            content: "Q1. Find the perimeter of a square tile whose side is 5 cm.\n"
                "Answer: 4 × Side = 4 × 5 = 20 cm!\n\n"
                "Q2. Find the area of a square math notebook whose side is 8 cm.\n"
                "Answer: Side × Side = 8 × 8 = 64 sq. cm!",
            bgColor: Colors.teal.shade50,
            borderColor: Colors.teal.shade700,
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
            color: Colors.lightGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.lightGreen.withOpacity(0.2), width: 2),
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
                  "Geometry Orbit! 📐",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's measure fences and tile up floors like space engineers!",
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

  // Visual Roadmap Step Node Layout replacing the boring text
  Widget _buildAttractiveMissionTrack() {
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
          _buildMissionStepNode(
            stepNum: "1",
            stepTitle: "Perimeter Run 🔴",
            formula: "Formula: 2 × (Length + Width)",
            calculation: "2 × (6 + 4)  ➡️  2 × 10",
            result: "Result = 20 meters",
            themeColor: Colors.red.shade600,
          ),
          _buildMissionConnectorLine(),
          _buildMissionStepNode(
            stepNum: "2",
            stepTitle: "Area Conquest 🔵",
            formula: "Formula: Length × Width",
            calculation: "6 × 4",
            result: "Result = 24 Sq. meters",
            themeColor: Colors.blue.shade600,
          ),
          _buildMissionConnectorLine(),
          // Spectacular Win Badge celebrating the final answers
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber.shade400, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("👑", style: TextStyle(fontSize: 22)),
                SizedBox(width: 10),
                Text(
                  "Mission Cleared Successfully!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.orange), // FIXED: Colors.amberDeep error
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMissionStepNode({
    required String stepNum,
    required String stepTitle,
    required String formula,
    required String calculation,
    required String result,
    required Color themeColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: themeColor,
          child: Text(
            stepNum,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: themeColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stepTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: themeColor),
                ),
                const SizedBox(height: 4),
                Text(
                  formula,
                  style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  calculation,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const Divider(height: 12, thickness: 0.5),
                Text(
                  result,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: themeColor), // FIXED: FontWeight.black error
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMissionConnectorLine() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 13, top: 3, bottom: 3),
        height: 18,
        width: 3,
        color: Colors.purple.withOpacity(0.25),
      ),
    );
  }

  // Outer edge boundary perimeter mapping widget
  Widget _buildPerimeterVisualDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.lightGreen.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text(
            "Perimeter = Sum of All Sides",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 12),
          Container(
            width: 140,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.redAccent, width: 3),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: const [
                Positioned(top: -18, left: 55, child: Text("5 cm", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                Positioned(bottom: -18, left: 55, child: Text("5 cm", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                Positioned(left: -38, top: 35, child: Text("3 cm", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                Positioned(right: -38, top: 35, child: Text("3 cm", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                Center(child: Text("FENCE\n(Outside Line)", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            "📐 5 + 3 + 5 + 3 = 16 cm",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          )
        ],
      ),
    );
  }

  // Area tile grid visualization widget
  Widget _buildAreaGridDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text(
            "Area = Total Internal Square Tiles",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 12),
          Table(
            defaultColumnWidth: const FixedColumnWidth(30),
            border: TableBorder.all(color: Colors.blueAccent, width: 1.5),
            children: List.generate(
              3,
              (r) => TableRow(
                children: List.generate(
                  4,
                  (c) => Container(
                    height: 30,
                    color: Colors.blue.shade100.withOpacity(0.5),
                    child: const Center(
                      child: Text("1", style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "✨ Counted 12 tiles inside = 12 Sq. cm",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          )
        ],
      ),
    );
  }

  // Clean formula rows
  Widget _buildFormulaTableDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildFormulaRow("Rectangle 🟦", "P = 2 × (L + W)", "A = Length × Width"),
          const Divider(height: 16),
          _buildFormulaRow("Square 🟩", "P = 4 × Side", "A = Side × Side"),
        ],
      ),
    );
  }

  Widget _buildFormulaRow(String title, String perimeter, String area) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 95,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
            child: Text(perimeter, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.red.shade700)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
            child: Text(area, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.green.shade700)),
          ),
        ],
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