import 'package:flutter/material.dart';

class TimeLearnScreen extends StatefulWidget {
  const TimeLearnScreen({super.key});

  @override
  State<TimeLearnScreen> createState() => _TimeLearnScreenState();
}

class _TimeLearnScreenState extends State<TimeLearnScreen> {
  // AM এবং PM অ্যানিমেশন ট্র্যাক করার জন্য স্টেট ভেরিয়েবল
  bool isAmSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text("⏰ Time Adventure"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // কার্টুন রোবট গাইড মাসকট
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // ১. ঘড়ির কাঁটা পরিচিতি
          AnimatedLearnCard(
            title: "1. Meet the Clock Hands! ⏰",
            content: "A clock has numbers from 1 to 12 and two main ticking hands:\n\n"
                     "• Short Hand ➡️ Hour Hand. It tells the hour!\n"
                     "• Long Hand ➡️ Minute Hand. It tells the minutes!\n\n"
                     "✨ Rule: When the long hand points to 12, it's 'O'Clock'!",
            bgColor: Colors.amber.shade50,
            borderColor: Colors.amber.shade700,
            bottomChild: _buildClockDiagram(),
          ),

          // ২. সময়ের হিসাব
          AnimatedLearnCard(
            title: "2. Magical Time Units ⏳",
            content: "Time moves in a loop! Let's remember the secret codes:\n\n"
                     "🚀 1 Hour (hr) = 60 Minutes (min)\n"
                     "⚡ 1 Minute (min) = 60 Seconds (sec)\n"
                     "☀️ 1 Day = 24 Hours",
            bgColor: Colors.green.shade50,
            borderColor: Colors.green,
          ),

          // ৩. এএম এবং পিএম (লাইভ ইন্টারেক্টিভ ও অ্যানিমেটেড ডে-নাইট সুইচার সহ)
          AnimatedLearnCard(
            title: "3. AM and PM Magic! ☀️🌙",
            content: "A day has 24 hours, so the clock goes around TWICE!\n"
                     "Tap the AM/PM buttons below to see the magic change!",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildAnimatedAmPmSky(),
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
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.indigo.withOpacity(0.2), width: 2),
      ),
      child: Row(
        children: [
          const Text("🤖", style: TextStyle(fontSize: 50)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Time Station! 🚀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                SizedBox(height: 2),
                Text("Let's learn how to read clock hands easily!", style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ১ নম্বর কার্ড: কাস্টম ঘড়ি ডায়াগ্রাম (৩:০০ টা বাজার ভিজ্যুয়াল)
  Widget _buildClockDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Text("⏰ It is 3 O'Clock! (৩:০০ টা)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 15),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.amber.shade600, width: 4),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(top: 4, child: Text("12", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.brown))),
                const Positioned(right: 6, child: Text("3", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.brown))),
                Positioned(
                  top: 15,
                  child: Container(height: 35, width: 3, color: Colors.blueAccent),
                ),
                Positioned(
                  right: 18,
                  child: Container(height: 3, width: 32, color: Colors.redAccent),
                ),
                Container(height: 8, width: 8, decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ৩ নম্বর কার্ড: সম্পূর্ণ অ্যানিমেটেড লাইভ ডে-নাইট উইজেট (AM vs PM)
  Widget _buildAnimatedAmPmSky() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          // ইন্টারেক্টিভ ক্লিক বাটন কন্ট্রোল (AM এবং PM সুইচার)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.styleFrom(
                backgroundColor: isAmSelected ? Colors.orangeAccent : Colors.grey.shade200,
                elevation: isAmSelected ? 4 : 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ).buildElevatedButton(
                onPressed: () => setState(() => isAmSelected = true),
                child: Text(
                  "☀️ AM (Morning)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAmSelected ? Colors.white : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.styleFrom(
                backgroundColor: !isAmSelected ? Colors.indigo.shade900 : Colors.grey.shade200,
                elevation: !isAmSelected ? 4 : 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ).buildElevatedButton(
                onPressed: () => setState(() => isAmSelected = false),
                child: Text(
                  "🌙 PM (Night)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !isAmSelected ? Colors.white : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // লাইভ অ্যানিমেটেড কন্টেইনার আকাশ (যা স্মুথলি কালার এবং উইজেট চেঞ্জ করবে)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              // AM হলে উজ্জ্বল হলুদ-কমলা আকাশ, PM হলে রাতের ডার্ক ব্লু আকাশ
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isAmSelected
                    ? [Colors.amber.shade300, Colors.orange.shade100]
                    : [const Color(0xFF0F2027), const Color(0xFF203A43)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // আইকন এবং টেক্সট অ্যানিমেশন পপ-আপ ইফেক্ট সহ
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: Text(
                      isAmSelected ? "☀️" : "🌙✨",
                      key: ValueKey<bool>(isAmSelected),
                      style: const TextStyle(fontSize: 45),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAmSelected ? "Good Morning! 🚀" : "Sweet Dreams! 😴",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isAmSelected ? Colors.brown.shade800 : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAmSelected
                              ? "Time for breakfast, sunrise, and getting ready for school! 🎒"
                              : "Time for homework, dinner, and sleeping in a dark room! 🌌",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isAmSelected ? Colors.brown.shade600 : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// অল-প্ল্যাটফর্ম রেসপন্সিভ হোভার ও টাচ অ্যানিমেটেড লার্ন কার্ড উইজেট
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

// ElevatedButton এর জন্য কাস্টম এক্সটেনশন মেথড (কোড এরর ফ্রি রাখার জন্য)
extension on ButtonStyle {
  Widget buildElevatedButton({required VoidCallback? onPressed, required Widget child}) {
    return ElevatedButton(
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
}