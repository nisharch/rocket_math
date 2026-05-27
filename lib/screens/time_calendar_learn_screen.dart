import 'package:flutter/material.dart';

class TimeCalendarLearnScreen extends StatefulWidget {
  const TimeCalendarLearnScreen({super.key});

  @override
  State<TimeCalendarLearnScreen> createState() => _TimeCalendarLearnScreenState();
}

class _TimeCalendarLearnScreenState extends State<TimeCalendarLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text("⏰ Time & Calendar Station"),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cartoon Mascot Guide
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // 1. Reading Time & AM/PM
          AnimatedLearnCard(
            title: "1. Reading the Clock! 🕒",
            content: "A clock has two main hands:\n"
                "• Short Hand = Hours 🔴\n"
                "• Long Hand = Minutes 🔵\n\n"
                "☀️ AM (Ante Meridiem): Before Noon (12:00 midnight to 12:00 noon)\n"
                "🌙 PM (Post Meridiem): After Noon (12:00 noon to 12:00 midnight)",
            bgColor: Colors.white,
            borderColor: Colors.amber.shade700,
            bottomChild: _buildClockDiagram(),
          ),

          // 2. Time Conversion Formula Rules
          AnimatedLearnCard(
            title: "2. Magical Time Magic! ⚡",
            content: "To convert bigger time units into smaller ones, we multiply! Remember these golden rules:\n"
                "• 1 Hour = 60 Minutes\n"
                "• 1 Minute = 60 Seconds\n"
                "• 1 Day = 24 Hours",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildConversionFormulaCard(),
          ),

          // 3. Step-by-Step Conversion Example (Hours to Minutes)
          AnimatedLearnCard(
            title: "3. Let's Convert Hours! 🚀",
            content: "Example: Convert 3 Hours 15 Minutes into total minutes.\n\n"
                "• Step 1: Multiply the hours by 60\n"
                "  3 × 60 = 180 minutes\n\n"
                "• Step 2: Add the extra remaining minutes\n"
                "  180 + 15 = 195 minutes\n\n"
                "🎉 Total Answer = 195 Minutes!",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange.shade800,
          ),

          // 4. The Magical Knuckle Hand Trick
          AnimatedLearnCard(
            title: "4. The Knuckle Hand Trick! 👊",
            content: "How can you easily remember how many days are in each month? Make a fist and count on your knuckles!\n\n"
                "⛰️ High Knuckle Part = 31 Days!\n"
                "🕳️ Low Valley Part = 30 Days! (Except Feb which has 28 or 29 days)",
            bgColor: Colors.teal.shade50,
            borderColor: Colors.teal.shade700,
            bottomChild: _buildKnuckleTrickDiagram(),
          ),

          // 5. Calendar Secrets & Leap Year
          AnimatedLearnCard(
            title: "5. The Calendar Secrets! 📅",
            content: "A regular year has 365 days, but every 4 years, we get a Leap Year with 366 days! Feb has 29 days then!\n\n"
                "How to find a Leap Year? Divide the year by 4. If the remainder is 0, it's a Leap Year! ✨",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildLeapYearCheckDiagram(),
          ),

          // 6. Practical Practice Questions For Students
          AnimatedLearnCard(
            title: "6. Try it Yourself! 📝",
            content: "Can you solve these smart Class 4 questions?\n\n"
                "Q1. How many minutes are there in 4 hours?\n"
                "Answer: 4 × 60 = 240 Minutes!\n\n"
                "Q2. Is the year 2028 a Leap Year?\n"
                "Answer: Yes! 2028 ÷ 4 leaves a remainder of 0!",
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
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.amber.withOpacity(0.2), width: 2),
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
                  "Time Orbit Station! 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's master clocks, hours, and calendars together!",
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

  // Visual clock guide UI diagram
  Widget _buildClockDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  "⏰",
                  style: TextStyle(
                    fontSize: 32,
                    shadows: [
                      Shadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("🔴 Short Hand = Hours (1 to 12)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                  SizedBox(height: 4),
                  Text("🔵 Long Hand = Minutes (0 to 60)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              )
            ],
          ),
          const Divider(height: 20, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeTag("☀️ AM", "Morning\n(12 AM to 12 PM)", Colors.orange),
              _buildTimeTag("🌙 PM", "Evening\n(12 PM to 12 AM)", Colors.indigo),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimeTag(String label, String sub, Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: themeColor, fontSize: 14)),
          const SizedBox(height: 2),
          Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Conversion rule relationship diagram block
  Widget _buildConversionFormulaCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Hours ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
              Text(" ➡️ ( × 60 ) ➡️ "),
              Text(" Minutes", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Minutes ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              Text(" ➡️ ( × 60 ) ➡️ "),
              Text(" Seconds", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  // Visual UI Mapping for the Knuckle Hand Trick
  Widget _buildKnuckleTrickDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          const Text(
            "👊 Knuckle Counting Map",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMonthNode("Jan", "31", true),
                _buildMonthArrow(),
                _buildMonthNode("Feb", "28/29", false),
                _buildMonthArrow(),
                _buildMonthNode("Mar", "31", true),
                _buildMonthArrow(),
                _buildMonthNode("Apr", "30", false),
                _buildMonthArrow(),
                _buildMonthNode("May", "31", true),
                _buildMonthArrow(),
                _buildMonthNode("Jun", "30", false),
                _buildMonthArrow(),
                _buildMonthNode("Jul", "31", true),
                _buildMonthArrow(),
                _buildMonthNode("Aug", "31", true),
                _buildMonthArrow(),
                _buildMonthNode("Sep", "30", false),
                _buildMonthArrow(),
                _buildMonthNode("Oct", "31", true),
                _buildMonthArrow(),
                _buildMonthNode("Nov", "30", false),
                _buildMonthArrow(),
                _buildMonthNode("Dec", "31", true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "⭐ Note: July and August BOTH land on High Knuckles! So both have 31 days!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMonthNode(String name, String days, bool isHigh) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isHigh ? Colors.orange.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHigh ? Colors.orange.shade400 : Colors.blue.shade400,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            isHigh ? "⛰️ High" : "🕳️ Valley",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isHigh ? Colors.orange.shade900 : Colors.blue.shade900),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text("$days Days", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildMonthArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
    );
  }

  // Leap Year long division rule validation diagram
  Widget _buildLeapYearCheckDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text("Let's test the Year 2024:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.purple)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 28),
              Text("506", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purple.shade700)),
            ],
          ),
          Container(margin: const EdgeInsets.only(left: 28, top: 2, bottom: 2), height: 1.5, width: 60, color: Colors.black38),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("4 ) ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              Text("2024", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 20),
              Text("−2024", style: TextStyle(fontSize: 16, color: Colors.black45)),
            ],
          ),
          Container(margin: const EdgeInsets.only(left: 28, top: 2, bottom: 2), height: 1.5, width: 60, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 28),
              Text("0 ✨", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 6),
          const Text("🎉 Remainder is 0! So 2024 is a Leap Year!", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
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