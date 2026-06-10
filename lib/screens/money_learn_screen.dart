import 'package:flutter/material.dart';

class MoneyLearnScreen extends StatefulWidget {
  const MoneyLearnScreen({super.key});

  @override
  State<MoneyLearnScreen> createState() => _MoneyLearnScreenState();
}

class _MoneyLearnScreenState extends State<MoneyLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int totalRupees = 0;

  // Shopping Game States
  int walletCash = 100;
  int totalBill = 50;
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50, // Play-school warm canvas
      appBar: AppBar(
        title: const Text("💰 Indian Money Workshop", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🇮🇳 Currency"),
            Tab(text: "🐖 Piggy Bank"),
            Tab(text: "⚡ Conversion"),
            Tab(text: "🛍️ Shopping"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Indian Rupees & Paise! 🇮🇳",
            summary: "Tap to view the magical formula of money scale tokens.",
            borderColor: Colors.green.shade600,
            child: _buildCurrencyIntroDiagram(),
          ),
          _buildToyboxMission(
            title: "Feed Your Piggy Bank! 🐖",
            summary: "Tap note bills below to feed your piggy bank savings coins!",
            borderColor: Colors.amber.shade800,
            child: _buildPiggyBankGame(),
          ),
          _buildToyboxMission(
            title: "Fast Conversion Trick! ⚡",
            summary: "Rupees to Paise? Just add TWO ZEROS at the end!",
            borderColor: Colors.blueAccent,
            child: _buildConversionVisualizer(),
          ),
          _buildToyboxMission(
            title: "Toy Store Checkout! 🛍️",
            summary: "Buy the stationary combo items and calculate your change return!",
            borderColor: Colors.purpleAccent,
            child: _buildShoppingBillDiagram(),
          ),
        ],
      ),
    );
  }

  Widget _buildToyboxMission({
    required String title,
    required String summary,
    required Color borderColor,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor),
            ),
            const SizedBox(height: 2),
            Text(
              summary,
              style: const TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.center,
                child: Center(child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MODULE 1: CURRENCY INTRO GRAPHIC ---
  Widget _buildCurrencyIntroDiagram() {
    return SizedBox(
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green.shade200, width: 1.5)),
            alignment: Alignment.center,
            child: Text(
              "₹ Sign = Indian Rupee",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.green.shade800),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text("↔️", style: TextStyle(fontSize: 20, color: Colors.black26)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1.5)),
            alignment: Alignment.center,
            child: const Text(
              "₹1 Rupee = 100 Paise",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODULE 2: PIGGY BANK ---
  Widget _buildPiggyBankGame() {
    String piggyEmoji = totalRupees == 0 ? "🐖" : (totalRupees < 100 ? "🐷" : "👑🐖");
    String piggyMood = totalRupees == 0 ? "Feed Me!" : (totalRupees < 100 ? "Yum! More!" : "Wow! Super Rich!");

    return SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(piggyEmoji, style: const TextStyle(fontSize: 45)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("₹ $totalRupees", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.amber.shade900)),
                    Text(piggyMood, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber.shade700)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _buildDepositButton("+ ₹10 💵", Colors.brown.shade400, () => setState(() => totalRupees += 10)),
              _buildDepositButton("+ ₹20 💵", Colors.yellow.shade800, () => setState(() => totalRupees += 20)),
              _buildDepositButton("+ ₹50 💵", Colors.cyan.shade600, () => setState(() => totalRupees += 50)),
              _buildDepositButton("Reset 🔄", Colors.redAccent, () => setState(() => totalRupees = 0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepositButton(String label, Color tintColor, VoidCallback action) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: tintColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: action,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }

  // --- MODULE 3: CONVERSION LAB MATRIX ---
  Widget _buildConversionVisualizer() {
    return SizedBox(
      width: 240,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Rupees", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blueAccent, fontSize: 14)),
                Text("Paise (p)", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.deepOrangeAccent, fontSize: 14)),
              ],
            ),
            const Divider(height: 12, thickness: 1.5),
            _buildConversionRow("₹ 2", "200 p"),
            _buildConversionRow("₹ 5", "500 p"),
            _buildConversionRow("₹ 9", "900 p"),
            _buildConversionRow("₹ 15", "1500 p"),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionRow(String rupees, String paise) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(rupees, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          const Text("➡️", style: TextStyle(color: Colors.black26, fontSize: 11)),
          Text(paise, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.deepOrangeAccent)),
        ],
      ),
    );
  }

  // --- MODULE 4: BILL CHECKOUT RECEIPT (🛠️ FIXED OVERFLOW BUG) ---
  Widget _buildShoppingBillDiagram() {
    int changeReturn = walletCash - totalBill;

    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🛠️ Fixed: Optimized vertical padding inside this box to give the text rows breathing room
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.2), width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // 🛠️ Fixed Typo: Clear, standard alignment call
              children: [
                _buildVisualItemCard("✏️ Pencil", "₹10"),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text("➕", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 14)),
                ),
                _buildVisualItemCard("📓 Book", "₹40"),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text("=", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 14)),
                ),
                _buildVisualItemCard("🧾 Total", "₹50", isTotal: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Text("Your Cash 💵", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45)),
                    Text("₹100", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                  ],
                ),
                const Text("−", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                Column(
                  children: const [
                    Text("Bill 🧾", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45)),
                    Text("₹50", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.purple)),
                  ],
                ),
                const Text("=", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black26)),
                Column(
                  children: [
                    const Text("Change Back 🔄", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45)),
                    Text(isPaid ? "₹$changeReturn" : "❓", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isPaid ? Colors.grey : Colors.purpleAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => setState(() => isPaid = !isPaid),
              icon: Icon(isPaid ? Icons.celebration : Icons.shopping_bag, size: 16),
              label: Text(
                isPaid ? "TAP TO REOPEN STORE" : "PAY ₹100 NOTE NOW!",
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualItemCard(String label, String price, {bool isTotal = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 🛠️ Fixed: Pulls content inward tightly to prevent clipping bounds
      children: [
        Text(label.split(" ").last, style: const TextStyle(fontSize: 20)), // Reduced emoji size to safe footprint
        const SizedBox(height: 2),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 14 : 12,
            fontWeight: FontWeight.w900,
            color: isTotal ? Colors.green.shade700 : Colors.purple.shade800,
          ),
        ),
      ],
    );
  }
}