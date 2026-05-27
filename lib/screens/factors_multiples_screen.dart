import 'package:flutter/material.dart';

class FactorsMultiplesScreen extends StatefulWidget {
  const FactorsMultiplesScreen({super.key});

  @override
  State<FactorsMultiplesScreen> createState() => _FactorsMultiplesScreenState();
}

class _FactorsMultiplesScreenState extends State<FactorsMultiplesScreen> {
  final TextEditingController _numberController = TextEditingController(text: "12");
  List<int> _calculatedFactors = [1, 2, 3, 4, 6, 12];
  String _inputError = "";

  // Helper method to dynamically calculate factors for the student input
  void _calculateFactorsForInput() {
    final String text = _numberController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _inputError = "Type a number first!";
        _calculatedFactors = [];
      });
      return;
    }

    final int? parsedNum = int.tryParse(text);
    if (parsedNum == null || parsedNum <= 0 || parsedNum > 1000) {
      setState(() {
        _inputError = "Enter a valid number between 1 and 1000!";
        _calculatedFactors = [];
      });
      return;
    }

    List<int> factors = [];
    for (int i = 1; i <= parsedNum; i++) {
      if (parsedNum % i == 0) {
        factors.add(i);
      }
    }

    setState(() {
      _inputError = "";
      _calculatedFactors = factors;
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text("🔢 Factors & Multiples"),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. What are Factors?
          AnimatedLearnCard(
            title: "1. What are Factors? 🧩",
            content: "Factors are the magic numbers that multiply together to make another number perfectly, without leaving any remainder!\n\n"
                "Think of them as the building blocks of a number.",
            bgColor: Colors.white,
            borderColor: Colors.indigo.shade700,
            bottomChild: _buildFactorsRainbowDiagram(),
          ),

          // 2. What are Multiples?
          AnimatedLearnCard(
            title: "2. What are Multiples? 🚂",
            content: "Multiples are the numbers you get when you multiply a number by 1, 2, 3, 4, and so on!\n\n"
                "It is exactly like skip-counting or reading out your favorite times tables!",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildMultiplesTrainDiagram(),
          ),

          // 3. Key Differences Table
          AnimatedLearnCard(
            title: "3. Factors vs Multiples Rules 📊",
            content: "Let's look at the secret differences so you never get confused:",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange.shade800,
            bottomChild: _buildComparisonTableDiagram(),
          ),

          // NEW SECTION: 4. The Interactive Factor Lab Sandbox
          AnimatedLearnCard(
            title: "4. Interactive Factor Lab! 🧪",
            content: "Type any number below to activate your space scanner and find all its hidden factors instantly!",
            bgColor: Colors.teal.shade50,
            borderColor: Colors.teal.shade700,
            bottomChild: _buildFactorSandboxLab(),
          ),

          // 5. Interactive Space Quiz Challenge
          AnimatedLearnCard(
            title: "5. Space Academy Quiz! 📝",
            content: "Q1. Find all the factors of 6.\n"
                "Answer: 1, 2, 3, and 6! (Because 1×6=6 and 2×3=6)\n\n"
                "Q2. What are the first three multiples of 5?\n"
                "Answer: 5, 10, and 15! (5×1, 5×2, 5×3)",
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
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.indigo.withOpacity(0.2), width: 2),
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
                  "Factor Station! 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's split numbers into factor blocks and skip-count multiples!",
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

  // Live sandbox widget allowing students to enter custom numbers
  Widget _buildFactorSandboxLab() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "e.g. 4, 12, 20",
                      labelText: "Enter Target Number",
                      labelStyle: const TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _calculateFactorsForInput,
                icon: const Icon(Icons.search, size: 18, color: Colors.white),
                label: const Text("Scan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              )
            ],
          ),
          if (_inputError.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_inputError, style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
          const Divider(height: 24, thickness: 1),
          const Text(
            "Found Factor Blocks:",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black45),
          ),
          const SizedBox(height: 10),
          _calculatedFactors.isEmpty
              ? const Center(
                  child: Text("No blocks found. Scan a number!", style: TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w500)),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _calculatedFactors.map((factor) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.shade300, width: 1.5),
                      ),
                      child: Text(
                        "$factor",
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.teal),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  // Visual layout drawing Factor Pairs for the number 12
  Widget _buildFactorsRainbowDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text(
            "Factor Pairs for 12:",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFactorPill("1 × 12"),
              _buildFactorPill("2 × 6"),
              _buildFactorPill("3 × 4"),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "✨ Factors of 12 are: 1, 2, 3, 4, 6, 12",
            style: TextStyle(fontSize: 12, color: Colors.indigo.shade900, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildFactorPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.indigo.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo),
      ),
    );
  }

  // Multiples skip-counting train track map blocks
  Widget _buildMultiplesTrainDiagram() {
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
          const Text(
            "Multiples of 4 Skip-Counting Train:",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTrainCar("4", "4×1"),
                _buildTrainConnector(),
                _buildTrainCar("8", "4×2"),
                _buildTrainConnector(),
                _buildTrainCar("12", "4×3"),
                _buildTrainConnector(),
                _buildTrainCar("16", "4×4"),
                _buildTrainConnector(),
                _buildTrainCar("20", "4×5"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainCar(String num, String equation) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade400, width: 1.5),
      ),
      child: Column(
        children: [
          Text(num, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.blue.shade900)),
          Text(equation, style: TextStyle(fontSize: 9, color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTrainConnector() {
    return Container(
      width: 12,
      height: 4,
      color: Colors.blue.shade300,
    );
  }

  // Clean layout comparing features side by side
  Widget _buildComparisonTableDiagram() {
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
          _buildComparisonRow("Meaning 💡", "Numbers that divide it evenly", "Numbers you get by multiplying"),
          const Divider(height: 16),
          _buildComparisonRow("Count 🔢", "Limited (Finite list)", "Endless (Infinite list)"),
          const Divider(height: 16),
          _buildComparisonRow("Size 📏", "Smaller or equal to number", "Greater or equal to number"),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String property, String factorRule, String multipleRule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(property, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text("• $factorRule", style: TextStyle(fontSize: 11, color: Colors.indigo.shade900, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text("• $multipleRule", style: TextStyle(fontSize: 11, color: Colors.blue.shade900, fontWeight: FontWeight.w500)),
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