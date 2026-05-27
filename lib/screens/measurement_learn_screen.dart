import 'package:flutter/material.dart';

class MeasurementLearnScreen extends StatefulWidget {
  const MeasurementLearnScreen({super.key});

  @override
  State<MeasurementLearnScreen> createState() => _MeasurementLearnScreenState();
}

class _MeasurementLearnScreenState extends State<MeasurementLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("📏 Measurement Lab"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // কার্টুন রোবট গাইড মাসকট
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // ১. দৈর্ঘ্য পরিমাপ (সম্পূর্ণ নতুন এবং আকর্ষণীয় পেন্সিল স্কেল সহ)
          AnimatedLearnCard(
            title: "1. Length (কতটা লম্বা?) 📏",
            content: "We measure how LONG or tall something is using Length! "
                     "For small things (like a pencil), we use Centimeters (cm). "
                     "For big things (like a room), we use Meters (m)!\n\n"
                     "✨ Ruler Magic: 1 Meter (m) = 100 Centimeters (cm)",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange,
            bottomChild: _buildLengthRulerDiagram(),
          ),

          // ২. ওজন পরিমাপ
          AnimatedLearnCard(
            title: "2. Weight (কতটা ভারী?) ⚖️",
            content: "Weight tells us how HEAVY an object is! "
                     "For light things (like an apple), we use Grams (g). "
                     "For heavy things (like your school bag), we use Kilograms (kg)!\n\n"
                     "✨ Weight Magic: 1 Kilogram (kg) = 1000 Grams (g)",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildWeightScaleDiagram(),
          ),

          // ৩. তরল পরিমাপ
          AnimatedLearnCard(
            title: "3. Capacity (কতটা তরল ধরবে?) 🧪",
            content: "Capacity tells us how much LIQUID a container can hold! "
                     "For a few drops (like medicine), we use Milliliters (ml). "
                     "For big bottles (like a water bottle), we use Liters (l)!\n\n"
                     "✨ Liquid Magic: 1 Liter (l) = 1000 Milliliters (ml)",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildCapacityLiquidDiagram(),
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
        boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.teal.withOpacity(0.2), width: 2),
      ),
      child: Row(
        children: [
          const Text("🤖", style: TextStyle(fontSize: 50)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Measurement Station! 🚀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                SizedBox(height: 2),
                Text("Let's measure length, weight, and capacity!", style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ১ নম্বর কার্ড: রুলার বা স্কেল ডায়াগ্রাম (LayoutBuilder সহ পারফেক্টলি অ্যালাইনড)
  Widget _buildLengthRulerDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // কাস্টম পেন্সিল গ্রাফিক্স
          Row(
            children: [
              const SizedBox(width: 15), // স্কেলের '০' এর চিহ্নের সাথে মিলানোর জন্য স্পেস
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // মোট স্কেলের ১০ ভাগের ৭ ভাগ জায়গা জুড়ে পেন্সিলটি থাকবে (৭ সেমি বোঝাতে)
                    double pencilWidth = constraints.maxWidth * (7 / 10);
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: pencilWidth,
                        height: 14,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.amber, Colors.orangeAccent]),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                          border: Border.all(color: Colors.orange.shade700, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // পেন্সিলের কিউট ইরেজার অংশ (পেছনে)
                            Container(width: 8, color: Colors.pinkAccent),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  "✏️ 7 cm",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // রিয়েল কার্টুন স্কেল ডিজাইন (০ থেকে ১০ নম্বর দাগ সহ)
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.orange.shade200, width: 2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(11, (index) {
                bool isMajor = index % 5 == 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: isMajor ? 14 : 7,
                      width: 2,
                      color: Colors.brown.shade600,
                    ),
                    const Spacer(),
                    Text(
                      "$index",
                      style: TextStyle(
                        fontSize: isMajor ? 11 : 9,
                        fontWeight: isMajor ? FontWeight.w900 : FontWeight.bold,
                        color: isMajor ? Colors.brown.shade800 : Colors.brown.shade400,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ২ নম্বর কার্ড: ওজন মাপার স্কেল ডায়াগ্রাম
  Widget _buildWeightScaleDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🍎", style: TextStyle(fontSize: 26)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(12)),
            child: const Text(
              "Weight = 200 g",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.blueAccent),
            ),
          ),
          const SizedBox(width: 8),
          const Text("⚖️", style: TextStyle(fontSize: 26)),
        ],
      ),
    );
  }

  // ৩ নম্বর কার্ড: তরল পরিমাপের বিকার ডায়াগ্রাম (ফিক্সড)
  Widget _buildCapacityLiquidDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 50,
                width: 35,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple.shade300, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 35,
                width: 31,
                margin: const EdgeInsets.only(bottom: 2, left: 2, right: 2),
                color: Colors.purple.shade200,
              ),
            ],
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
            child: const Text(
              "Capacity = 1 Liter (l)",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.purple),
            ),
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