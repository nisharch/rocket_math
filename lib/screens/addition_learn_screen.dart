import 'package:flutter/material.dart';

class AdditionLearnScreen extends StatelessWidget {
  const AdditionLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text("➕ Addition Adventure"),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // কার্টুন রোবট গাইড মাসকট
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
          

          // ১. যোগ অংকের বেসিক কনসেপ্ট
          AnimatedLearnCard(
            title: "What is Addition? 🤔",
            content: "Addition means putting things TOGETHER! 🎒\n"
                     "We use Plus (+) sign, and the total answer is called Sum! 🌟",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
            bottomChild: _buildStarsCombinationDiagram(),
          ),

          // ২. কীভাবে সাধারণ যোগ করতে হয়
          AnimatedLearnCard(
            title: "How to Add? 👣",
            content: "Let's add 24 + 13. Always start from the ONES side first!\n\n"
                     "• Ones (O) side ➡️ 4 + 3 = 7\n"
                     "• Tens (T) side ➡️ 2 + 1 = 3\n\n"
                     "🎉 Total Sum = 37!",
            bgColor: Colors.green.shade50,
            borderColor: Colors.green,
            bottomChild: _buildAdditionGridDiagram(),
          ),

          // ৩. ক্যারি ওভার বা হাতে রেখে যোগ (FontWeight.w900 ফিক্সড)
          AnimatedLearnCard(
            title: "The Carry Over Magic! ⚡",
            content: "Let's add 28 + 15! Remember, Ones house cannot hold more than 9!\n\n"
                     "• Ones side ➡️ 8 + 5 = 13 (Keep 3, Carry 1 to Tens house!)\n"
                     "• Tens side ➡️ 2 + 1 + 1 (Magic Guest) = 4\n\n"
                     "🚀 Final Answer = 43!",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange,
            bottomChild: _buildCarryOverGridDiagram(),
          ),

          const SizedBox(height: 10),
          _buildTip("💡 Robo-Tip: Always start adding from the Ones side! ➡️"),
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
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.15), 
                blurRadius: 15, 
                offset: const Offset(0, 5)
              )
            ],
            border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3), width: 3),
          ),
          child: Row(
            children: [
              const Text("🤖", style: TextStyle(fontSize: 50)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Captain Robo! ⚡", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Short & sweet math missions for you!", 
                      style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ১ নম্বরカードের স্টার ডায়াগ্রাম
  Widget _buildStarsCombinationDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("⭐⭐⭐", style: TextStyle(fontSize: 18)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text("+", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ),
          Text("⭐⭐", style: TextStyle(fontSize: 18)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text("=", style: TextStyle(fontSize: 18, color: Colors.black38)),
          ),
          Text("⭐⭐⭐⭐⭐", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // ২ নম্বর কার্ডের সাধারণ ম্যাথ গ্রিড (24 + 13)
  Widget _buildAdditionGridDiagram() {
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
              Text("4", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("+", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(width: 15),
              Text("1", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 40),
              Text("3", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 120, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("3", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.green)),
              SizedBox(width: 40),
              Text("7", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  // ৩ নম্বর কার্ডের জন্য স্পেশাল ক্যারি ওভার গ্রিড (28 + 15) [FIXED]
  Widget _buildCarryOverGridDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.3), width: 1.5),
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
                decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
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
              Text("8", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("+", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
              SizedBox(width: 15),
              Text("1", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 40),
              Text("5", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 120, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("4", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.deepOrange)),
              SizedBox(width: 40),
              Text("3", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.deepOrange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade100, 
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          const Text("💡", style: TextStyle(fontSize: 26)),
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
          transform: Matrix4.identity()..translate(0.0, transformY)..scale(scale),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered ? widget.borderColor : widget.borderColor.withOpacity(0.4), 
              width: _isHovered ? 3 : 2
            ),
            boxShadow: [
              BoxShadow(
                color: widget.borderColor.withOpacity(_isHovered ? 0.25 : 0.08), 
                blurRadius: _isHovered ? 16.0 : 4.0, 
                offset: Offset(0, _isHovered ? 8.0 : 2.0)
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.borderColor)
                    )
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
                style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87, fontWeight: FontWeight.w500)
              ),
              if (widget.bottomChild != null) widget.bottomChild!,
            ],
          ),
        ),
      ),
    );
  }
}