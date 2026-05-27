import 'package:flutter/material.dart';

class NumbersLearnScreen extends StatelessWidget {
  const NumbersLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: const Text("🔢 Numbers Adventure"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // কার্টুন রোবট মাসকট টকিং অ্যানিমেশন সহ
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: _buildHeaderMascot(),
          ),
          const SizedBox(height: 24),

          // ১. কাউন্টিং নাম্বার কার্ড
          AnimatedLearnCard(
            title: "Counting Numbers 🚀",
            content: "1, 2, 3, 4, 5 ... We count from 1 to 100 and beyond! 🌟",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildNumberLineDiagram(),
          ),

          // ২. প্লেস ভ্যালু ডায়াগ্রাম কার্ড (বিস্তারিত ব্যাখ্যা ও নতুন উদাহরণ সহ)
          AnimatedLearnCard(
            title: "Place Value 🏠",
            content: "Every digit has a special house and power! Let's look at the magical number 438:\n\n"
                     "• 8 is in Ones house (O) → It means 8 single ones (8 × 1 = 8) 🪙\n"
                     "• 3 is in Tens house (T) → It means 3 groups of ten (3 × 10 = 30) 💵\n"
                     "• 4 is in Hundreds house (H) → It means 4 groups of hundred (4 × 100 = 400) 💳\n\n"
                     "✨ Expanded Form: 438 = 400 + 30 + 8",
            bgColor: Colors.green.shade50,
            borderColor: Colors.green,
            bottomChild: _buildPlaceValueHouseDiagram(),
          ),

          // ৩. কম্পেয়ারিং নাম্বার কার্ড
          AnimatedLearnCard(
            title: "Comparing Numbers ⚖️",
            content: "Use >, < or =\n• 56 > 45  (56 is GREATER)\n• 30 < 80  (30 is SMALLER)\n• 77 = 77  (both EQUAL)",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange,
            bottomChild: _buildComparisonDiagram(),
          ),

          // ৪. অর্ডারিং নাম্বার কার্ড
          AnimatedLearnCard(
            title: "Ordering Numbers 📊",
            content: "Ascending: 12 → 25 → 38 → 50 (Small to Big)\nDescending: 50 → 38 → 25 → 12 (Big to Small)",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
          ),

          const SizedBox(height: 10),
          
          _buildTip("💡 Tip: Always look at the HUNDREDS digit first when comparing big numbers!"),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // কার্টুন রোবট গাইড মাসকট
  Widget _buildHeaderMascot() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.15), 
                blurRadius: 15, 
                offset: const Offset(0, 5)
              )
            ],
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 3),
          ),
          child: Row(
            children: [
              const Text("🤖", style: TextStyle(fontSize: 55)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Hi, I am Robo-Math! ⚡", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Let's click the cards below to see magic!", 
                      style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w600)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          left: 15,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "NEW MISSION", 
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
            ),
          ),
        )
      ],
    );
  }

  // ১ নম্বর কার্ডের জন্য নাম্বার লাইন ডায়াগ্রাম
  Widget _buildNumberLineDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          int num = (index + 1) * 10;
          return Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  "$num", 
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueAccent)
                ),
              ),
              if (index < 4) const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
            ],
          );
        }),
      ),
    );
  }

  // ২ নম্বর কার্ডের জন্য নতুন উদাহরণ (438) সহ প্লেস ভ্যালু হাউসের ডায়াগ্রাম
  Widget _buildPlaceValueHouseDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          const Text(
            "🏠 Place Value Map for 438",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _houseBox("Hundreds (H)", "4", "400", Colors.red.shade400),
              _houseBox("Tens (T)", "3", "30", Colors.amber.shade600),
              _houseBox("Ones (O)", "8", "8", Colors.green.shade400),
            ],
          ),
        ],
      ),
    );
  }

  // প্লেস ভ্যালু বক্সের কাস্টম উইজেট যা রিয়েল ভ্যালুও দেখায়
  Widget _houseBox(String label, String digit, String realValue, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 55,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Center(
            child: Text(
              digit, 
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label, 
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black54)
        ),
        Text(
          "Value = $realValue", 
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)
        ),
      ],
    );
  }

  // ৩ নম্বর কার্ডের জন্য ভিজ্যুয়াল কম্প্যারিসন ডায়াগ্রাম
  Widget _buildComparisonDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("56", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Chip(
              label: Text(" > ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              backgroundColor: Colors.deepOrangeAccent,
            ),
          ),
          Text("45", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.4), width: 2),
      ),
      child: Row(
        children: [
          const Text("💡", style: TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip, 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 14)
            )
          ),
        ],
      ),
    );
  }
}

// অল-প্ল্যাটফর্ম ইন্টারেক্টিভ হোভার ও টাচ অ্যানিমেটেড উইজেট কার্ড
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
          padding: const EdgeInsets.all(20),
          transform: Matrix4.identity()
            ..translate(0.0, transformY)
            ..scale(scale),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered ? widget.borderColor : widget.borderColor.withOpacity(0.4), 
              width: _isHovered ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.borderColor.withOpacity(_isHovered ? 0.25 : 0.08),
                blurRadius: _isHovered ? 16.0 : 4.0,
                offset: Offset(0, _isHovered ? 8.0 : 2.0),
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
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: widget.borderColor),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1.0 : 0.3,
                    child: Text("⭐", style: TextStyle(fontSize: _isHovered ? 22 : 16)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 16, 
                  height: 1.5, 
                  color: Colors.black87, 
                  fontWeight: FontWeight.w500
                ),
              ),
              if (widget.bottomChild != null) widget.bottomChild!,
            ],
          ),
        ),
      ),
    );
  }
}