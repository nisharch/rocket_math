import 'package:flutter/material.dart';

class MoneyTransactionLearnScreen extends StatefulWidget {
  const MoneyTransactionLearnScreen({super.key});

  @override
  State<MoneyTransactionLearnScreen> createState() => _MoneyTransactionLearnScreenState();
}

class _MoneyTransactionLearnScreenState extends State<MoneyTransactionLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text("🪙 Money & Bazaar Station"),
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

          // 1. Indian Currency Symbols & Basics
          AnimatedLearnCard(
            title: "1. Meet Indian Currency! 🇮🇳",
            content: "In India, money is counted in Rupees (₹) and Paise (p).\n\n"
                "• Golden Rule: ₹1 = 100 Paise!\n"
                "• To change Rupees into Paise, just multiply by 100 (or add two zeros at the end!).",
            bgColor: Colors.white,
            borderColor: Colors.indigo.shade700,
            bottomChild: _buildCurrencyConversionCard(),
          ),

          // 2. Rupee to Paise Step Conversion Example
          AnimatedLearnCard(
            title: "2. Rupee to Paise Magic! ⚡",
            content: "Example: Convert ₹7 and 25 Paise into total Paise.\n\n"
                "• Step 1: Multiply Rupees by 100\n"
                "  7 × 100 = 700 paise\n\n"
                "• Step 2: Add the extra remaining paise\n"
                "  700 + 25 = 725 paise\n\n"
                "🎉 Total Answer = 725 Paise!",
            bgColor: Colors.blue.shade50,
            borderColor: Colors.blueAccent,
          ),

          // 3. Billing & Shopping Transaction Run
          AnimatedLearnCard(
            title: "3. Space Bazaar Bill Calculation! 🛒",
            content: "Imagine you buy an alien toy and a cosmic book from the bazaar shop. Let's make your item bill receipt!",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange.shade800,
            bottomChild: _buildBazaarReceiptDiagram(),
          ),

          // 4. Calculating Return Change (Step-by-Step Interactive Track)
          AnimatedLearnCard(
            title: "4. Cashier Return Mission! 🚀",
            content: "Mission Target: Your total bill is ₹65. You hand a clean ₹100 note to the shopkeeper. How much back?",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            bottomChild: _buildReturnChangeTrack(),
          ),

          // 5. Practical Classroom Quiz Challenge
          AnimatedLearnCard(
            title: "5. Try it Yourself! 📝",
            content: "Q1. Convert ₹15 into total paise.\n"
                "Answer: 15 × 100 = 1500 Paise!\n\n"
                "Q2. A chocolate box costs ₹45.50 and juice costs ₹20.00. Total?\n"
                "Answer: ₹45.50 + ₹20.00 = ₹65.50!",
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
                  "Bazaar Station! 🪙",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's master shopping bills, Indian currency notes, and exchange change!",
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

  // Visual layout mapping for Indian Currency multiplication properties
  Widget _buildCurrencyConversionCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(12)),
            child: const Text("Rupees (₹)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text("➡️  × 100  ➡️", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45, fontSize: 12)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
            child: const Text("Paise (p)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ),
        ],
      ),
    );
  }

  // Custom Itemized Bill Receipt Layout component block
  Widget _buildBazaarReceiptDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          const Text("📜 BAZAAR SHOP RECEIPT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 1)),
          const Divider(height: 16, thickness: 1, color: Colors.black12),
          _buildReceiptRow("🚀 Alien Toy", "₹ 40.00"),
          const SizedBox(height: 6),
          _buildReceiptRow("📚 Cosmic Book", "₹ 25.00"),
          const Divider(height: 20, thickness: 1.5, color: Colors.black38),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Total Amount:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              Text("₹ 65.00", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.orange)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String itemName, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(itemName, style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600)),
        Text(price, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Attractive step timeline visualization layout for calculating return balances
  Widget _buildReturnChangeTrack() {
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
          _buildTrackNode(
            stepNum: "1",
            stepTitle: "Paid Cash 💵",
            description: "You hand over a standard: ₹100 note",
            themeColor: Colors.blue.shade600,
          ),
          _buildTrackDivider(),
          _buildTrackNode(
            stepNum: "2",
            stepTitle: "Minus Bill Cost 🛒",
            description: "Subtract items total: ₹100 − ₹65",
            themeColor: Colors.red.shade600,
          ),
          _buildTrackDivider(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withOpacity(0.3), width: 1.5),
            ),
            child: Row(
              children: [
                const Text("💰", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Shopkeeper Returns Change:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                    SizedBox(height: 2),
                    Text("₹ 35.00 Balance back!", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.green)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTrackNode({
    required String stepNum,
    required String stepTitle,
    required String description,
    required Color themeColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: themeColor,
          child: Text(stepNum, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stepTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: themeColor)),
            Text(description, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }

  Widget _buildTrackDivider() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
        height: 14,
        width: 2,
        color: Colors.purple.withOpacity(0.2),
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