import 'package:flutter/material.dart';

class MoneyLearnScreen extends StatefulWidget {
  const MoneyLearnScreen({super.key});

  @override
  State<MoneyLearnScreen> createState() => _MoneyLearnScreenState();
}

class _MoneyLearnScreenState extends State<MoneyLearnScreen> {
  int totalRupees = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text("💰 Indian Money Workshop"),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // কার্টুন রোবট গাইড মাসকট (টাইপো ফিক্সড)
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // ১. ইন্ডিয়ান কারেন্সি পরিচিতি
          AnimatedLearnCard(
            title: "1. Indian Rupees & Paise 🇮🇳",
            content: "In India, we use Rupees (₹) and Paise (p) to buy things like toys and chocolates!\n\n"
                     "🪙 Coins we use: ₹1, ₹2, ₹5, ₹10, ₹20\n"
                     "💵 Notes we use: ₹10, ₹20, ₹50, ₹100, ₹200, ₹500\n\n"
                     "✨ Money Magic Formula:\n"
                     "👉 ₹1 (1 Rupee) = 100 Paise",
            bgColor: Colors.green.shade50,
            borderColor: Colors.green,
            bottomChild: _buildCurrencyIntroDiagram(),
          ),

          // ২. ইন্টারেক্টিভ ইন্ডিয়ান পিগি ব্যাংক গেম
          AnimatedLearnCard(
            title: "2. Your Indian Piggy Bank! 🐖",
            content: "Tap the Indian currency buttons below to add real money into your savings bank!",
            bgColor: Colors.white,
            borderColor: Colors.amber.shade700,
            bottomChild: _buildPiggyBankGame(),
          ),

          // ৩. টাকা ও পয়সার কনভার্সন
          AnimatedLearnCard(
            title: "3. Fast Conversion Trick! ⚡",
            content: "Want to change Rupees into Paise? Just add TWO ZEROS at the end! 🎯\n\n"
                     "• ₹5 ➡️ 5 + 00 = 500 Paise\n"
                     "• ₹12 ➡️ 12 + 00 = 1200 Paise\n\n"
                     "• To go back (Paise to Rupees), just remove the last two zeros! (700 p = ₹7)",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
          ),

          // ৪. বাজার করার অংক
          AnimatedLearnCard(
            title: "4. Let's Go Shopping! 🛍️",
            content: "Imagine you go to a shop to buy some stationary items:\n\n"
                     "✏️ Pencil = ₹10\n"
                     "📓 Notebook = ₹40\n\n"
                     "➕ Total Bill = ₹10 + ₹40 = ₹50!\n"
                     "💵 If you give a ₹100 Note, the shopkeeper returns: ₹100 − ₹50 = ₹50 back!",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildShoppingBillDiagram(),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ফিক্সড: অতিরিক্ত কালারস কিউওয়ার্ড রিমুভ করা হয়েছে
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
        border: Border.all(
          color: Colors.amber.withOpacity(0.2), 
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Text("🤖", style: TextStyle(fontSize: 50)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Money Master Station! 🚀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                SizedBox(height: 2),
                Text("Let's count real Indian notes and coins!", style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyIntroDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
            child: const Text(
              "₹ Sign = Rupee",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.green),
            ),
          ),
          const SizedBox(width: 15),
          const Text("↔️", style: TextStyle(fontSize: 20, color: Colors.black38)),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(12)),
            child: const Text(
              "100 p = ₹1",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPiggyBankGame() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text("🐖 Savings Box Balance:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(
            "₹ $totalRupees",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.amber.shade900),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade300, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ).buildElevatedButton(
                onPressed: () => setState(() => totalRupees += 10),
                child: const Text("+ ₹10 Note 💵", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ).buildElevatedButton(
                onPressed: () => setState(() => totalRupees += 20),
                child: const Text("+ ₹20 Note 💵", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan.shade400, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ).buildElevatedButton(
                onPressed: () => setState(() => totalRupees += 50),
                child: const Text("+ ₹50 Note 💵", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ).buildElevatedButton(
                onPressed: () => setState(() => totalRupees = 0),
                child: const Text("Reset 🔄", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingBillDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const Text("🧾 Your Stationary Bill", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  Text("✏️ Pencil", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text("₹ 10", style: TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text("➕", style: TextStyle(color: Colors.black26)),
              Column(
                children: const [
                  Text("📓 Book", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text("₹ 40", style: TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text("=", style: TextStyle(color: Colors.black38, fontSize: 18)),
              Column(
                children: const [
                  Text("🛒 Total", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                  Text("₹ 50", style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
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
                    child: const Text("⭐", style: TextStyle(fontSize: 16)),
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

extension on ButtonStyle {
  Widget buildElevatedButton({required VoidCallback? onPressed, required Widget child}) {
    return ElevatedButton(
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
}