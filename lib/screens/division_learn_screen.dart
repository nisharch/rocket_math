import 'package:flutter/material.dart';

class DivisionLearnScreen extends StatefulWidget {
  const DivisionLearnScreen({super.key});

  @override
  State<DivisionLearnScreen> createState() => _DivisionLearnScreenState();
}

class _DivisionLearnScreenState extends State<DivisionLearnScreen> {
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
          // কার্টুন রোবট গাইড মাসকট
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // ১. ভাগের বেসিক কনসেপ্ট
          AnimatedLearnCard(
            title: "1. What is Division? 🍕",
            content: "Division means sharing or dividing into EQUAL groups! "
                     "We use the Divide (÷) sign, and the final answer is called Quotient! ✨",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildEqualSharingDiagram(),
          ),

          // ২. ভাগের ৪টি বিশেষ বন্ধু (আপনার স্ক্রিনশট অনুযায়ী স্ট্যান্ডার্ড ফরম্যাট)
          AnimatedLearnCard(
            title: "2. Meet the Division Friends! 🤝",
            content: "Look at the standard long division layout below to remember their names!",
            bgColor: Colors.white,
            borderColor: Colors.cyan.shade700,
            bottomChild: _buildStandardDivisionFriendsDiagram(),
          ),

          // ৩. সাধারণ ভাগ (Simple Division - No Remainder)
          AnimatedLearnCard(
            title: "3. Simple Division 👣",
            content: "Let's divide 6 ÷ 2. Think of your 2 times table! "
                     "How many times 2 goes into 6? 2 × 3 = 6!\n\n"
                     "🎉 So, the Quotient is 3!",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange,
            bottomChild: _buildSimpleDivDiagram(),
          ),

          // ৪. ভাগশেষ সহ ভাগ (আপনার দেওয়া ২৫ ÷ ২ এর এক্সাক্ট লং ডিভিশন উদাহরণ)
          AnimatedLearnCard(
            title: "4. Remaining Leftovers! ⚡",
            content: "Let's divide 25 ÷ 2 step-by-step using Long Division!\n\n"
                     "• Step 1: Look at 2. 2 × 1 = 2. Subtract 2 − 2 = 0. Bring down 5.\n"
                     "• Step 2: Look at 5. 2 × 2 = 4. Subtract 5 − 4 = 1.\n\n"
                     "🚀 Quotient is 12 and Remainder is 1!",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildLongDivisionExampleDiagram(),
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
        boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
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
                Text("Division Station! 🚀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyan.shade700)),
                const SizedBox(height: 2),
                const Text("Let's share cookies and numbers equally!", style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // পিৎজা ইমোজি ডায়াগ্রাম
  Widget _buildEqualSharingDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      width: double.infinity,
      child: Center(
        child: Column(
          children: const [
            Text("🍕🍕   ➕   🍕🍕   ➕   🍕🍕", style: TextStyle(fontSize: 16)),
            SizedBox(height: 6),
            Text("6 Slices shared into 3 equal groups = 2 each!", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }

  // ২ নম্বর কার্ড: স্ট্যান্ডার্ড লং ডিভিশন লেবেলিং মানচিত্র (স্ক্রিনশট ফরম্যাট)
  Widget _buildStandardDivisionFriendsDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyan.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 45),
              Text("12", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.cyan.shade900)), // Quotient
              const Text("  ⬅️ Quotient (Answer)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
          Container(margin: const EdgeInsets.only(left: 45, top: 2, bottom: 2), height: 2, width: 60, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Divisor ➡️  ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
              const Text("2 ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)), // Divisor
              const Text(") ", style: TextStyle(fontSize: 22, color: Colors.black54)),
              const Text("25", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)), // Dividend
              const Text("  ⬅️ Dividend (Total)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 35),
              Text("1", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purple)), // Remainder
              Text("  ⬅️ Remainder (Leftover)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  // ৩ নম্বর কার্ড: সাধারণ ভাগ (6 ÷ 2 = 3)
  Widget _buildSimpleDivDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("3", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.orange.shade700)),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(vertical: 2), height: 2, width: 50, color: Colors.black38),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("2 ) ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              Text("6", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 24),
              Text("−6", style: TextStyle(fontSize: 18, color: Colors.black54)),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(vertical: 2), height: 1.5, width: 50, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 24),
              Text("0", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  // ৪ নম্বর কার্ড: আপনার ছবি অনুযায়ী একদম নিখুঁত লং ডিভিশন প্রসেস (25 ÷ 2)
  Widget _buildLongDivisionExampleDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 28),
              Text("12", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.purple)), // Quotient
            ],
          ),
          Container(margin: const EdgeInsets.only(left: 28, top: 2, bottom: 2), height: 2, width: 50, color: Colors.black38),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("2 ) ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)), // Divisor
              Text("25", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)), // Dividend
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 15),
              Text("−2", style: TextStyle(fontSize: 18, color: Colors.black54)),
              SizedBox(width: 15),
            ],
          ),
          Container(margin: const EdgeInsets.only(left: 28, top: 2, bottom: 2), height: 1.5, width: 50, color: Colors.black38),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 28),
              Text("05", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 28),
              Text("−4", style: TextStyle(fontSize: 18, color: Colors.black54)),
            ],
          ),
          Container(margin: const EdgeInsets.only(left: 28, top: 2, bottom: 2), height: 1.5, width: 50, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 28),
              Text("1", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.red)), // Remainder
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