import 'package:flutter/material.dart';

class MultiplicationLearnScreen extends StatefulWidget {
  const MultiplicationLearnScreen({super.key});

  @override
  State<MultiplicationLearnScreen> createState() => _MultiplicationLearnScreenState();
}

class _MultiplicationLearnScreenState extends State<MultiplicationLearnScreen> {
  int selectedTable = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("✖️ Multiplication World"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // কার্টুন রোবট গাইড মাসকট
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // ১. গুণের বেসিক কনসেপ্ট কার্ড (Repeated Addition)
          AnimatedLearnCard(
            title: "1. What is Multiplication? 🔁",
            content: "Multiplying means adding the SAME number over and over again! "
                     "We use the Times (×) sign, and the final answer is called Product! ✨",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildRepeatedAdditionDiagram(),
          ),

          // ২. টাইমস টেবিল এক্সপ্লোরার
          AnimatedLearnCard(
            title: "2. Times Table Explorer 📊",
            content: "Pick a number from the box below to see its magical math table!",
            bgColor: Colors.white,
            borderColor: Colors.green,
            bottomChild: _buildTimesTableExplorer(),
          ),

          // ৩. সাধারণ গুণ (Simple Multiplication - No Carry)
          AnimatedLearnCard(
            title: "3. Simple Multiplication 👣",
            content: "Let's multiply 23 × 3. Always start from the ONES side first!\n\n"
                     "• Ones (O) side ➡️ 3 × 3 = 9\n"
                     "• Tens (T) side ➡️ 2 × 3 = 6\n\n"
                     "🎉 Total Product = 69!",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange,
            bottomChild: _buildSimpleMulDiagram(),
          ),

          // ৪. হাতে রেখে গুণ (Carry Over / Regrouping)
          AnimatedLearnCard(
            title: "4. The Carry Over Magic! ⚡",
            content: "Let's multiply 24 × 3. Remember, if Ones house gets more than 9, carry it over to Tens house!\n\n"
                     "• Ones side ➡️ 4 × 3 = 12 (Keep 2, Carry 1 to Tens house!)\n"
                     "• Tens side ➡️ 2 × 3 = 6 + 1 (Magic Guest) = 7\n\n"
                     "🚀 Final Answer = 72!",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildCarryMulDiagram(),
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
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 2),
      ),
      child: Row(
        children: [
          const Text("🤖", style: TextStyle(fontSize: 50)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Multiplication Station! 🚀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                SizedBox(height: 2),
                Text("Let's master simple and carry over math!", style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // আপেল ইমোজি ডায়াগ্রাম গ্রিড
  Widget _buildRepeatedAdditionDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      width: double.infinity,
      child: Center(
        child: Column(
          children: const [
            Text("🍎🍎🍎🍎   ➕   🍎🍎🍎🍎   ➕   🍎🍎🍎🍎", style: TextStyle(fontSize: 16)),
            SizedBox(height: 6),
            Text("3 Groups of 4 = 12 total!", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }

  // টাইমস টেবিল এক্সপ্লোরার
  Widget _buildTimesTableExplorer() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(10, (i) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Text(
                "$selectedTable × ${i + 1} = ${selectedTable * (i + 1)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
              ),
            );
          }),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🛸 Choose Table: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<int>(
                value: selectedTable,
                underline: const SizedBox(),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                items: List.generate(10, (i) => DropdownMenuItem(value: i + 1, child: Text("${i + 1}"))),
                onChanged: (v) => setState(() => selectedTable = v!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ৩ নম্বর কার্ডের সাধারণ গুণের ডায়াগ্রাম (23 x 3 = 69)
  Widget _buildSimpleMulDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("T", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              SizedBox(width: 40),
              Text("O", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            ],
          ),
          const Divider(height: 8, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 40),
              Text("3", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("×", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
              SizedBox(width: 55),
              Text("3", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 120, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("6", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.orange)),
              SizedBox(width: 40),
              Text("9", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  // ৪ নম্বর কার্ডের জন্য ক্যারি ওভার গুণের ডায়াগ্রাম (24 x 3 = 72)
  Widget _buildCarryMulDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          // ক্যারি ওভার গেস্ট রো
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 30),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                child: const Text("1", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(width: 40),
              const SizedBox(width: 20), 
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("T", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              SizedBox(width: 40),
              Text("O", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            ],
          ),
          const Divider(height: 6, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 40),
              Text("4", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("×", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
              SizedBox(width: 55),
              Text("3", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 120, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("7", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.purple)),
              SizedBox(width: 40),
              Text("2", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }
}

// অল-প্ল্যাটফর্ম রেসপন্সিভ হোভার অ্যানিমেটেড লার্ন কার্ড উইজেট
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
                    child: Text("⭐", style: TextStyle(fontSize: _isHovered ? 21 : 16)),
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