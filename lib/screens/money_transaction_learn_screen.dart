import 'package:flutter/material.dart';

class MoneyTransactionLearnScreen extends StatefulWidget {
  const MoneyTransactionLearnScreen({super.key});

  @override
  State<MoneyTransactionLearnScreen> createState() => _MoneyTransactionLearnScreenState();
}

class _MoneyTransactionLearnScreenState extends State<MoneyTransactionLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text("🪙 Money & Bazaar Lab", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🇮🇳 Exchange"),
            Tab(text: "🛒 Bazaar Shelf"),
            Tab(text: "🚀 Cashier"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Rupees to Paise Engine 🇮🇳",
            summary: "Indian currency golden rule: ₹1 = 100 Paise. Use the slider to convert units instantly!",
            tip: "💡 Robo-Tip: To convert Rupees into Paise, simply multiply by 100 or add two zeros to the end!",
            borderColor: Colors.indigo.shade700,
            child: const InteractiveCurrencyConverter(),
          ),
          _buildToyboxMission(
            title: "Bazaar Shelf 🛒",
            summary: "Pick items from the shelf to generate a digital bill receipt.",
            tip: "💡 Robo-Tip: Add your item prices carefully to find the total basket amount!",
            borderColor: Colors.orange.shade800,
            child: const InteractiveBazaarReceipt(),
          ),
          _buildToyboxMission(
            title: "Cashier Mission 🚀",
            summary: "Calculate the return change for a customer paying with a ₹100 note.",
            tip: "💡 Robo-Tip: Change = Amount Paid - Total Bill. Accuracy is the mark of a pro cashier!",
            borderColor: Colors.purple,
            child: const InteractiveCashierTrack(),
          ),
        ],
      ),
    );
  }

  Widget _buildToyboxMission({required String title, required String summary, required String tip, required Color borderColor, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor, width: 3), boxShadow: [BoxShadow(color: borderColor.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(summary, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Expanded(child: Center(child: child)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: borderColor.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor.withOpacity(0.2), width: 1.5)),
              child: Text(tip, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: borderColor, height: 1.3), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TAB 1: CURRENCY CONVERTER ---
class InteractiveCurrencyConverter extends StatefulWidget {
  const InteractiveCurrencyConverter({super.key});
  @override
  State<InteractiveCurrencyConverter> createState() => _InteractiveCurrencyConverterState();
}

class _InteractiveCurrencyConverterState extends State<InteractiveCurrencyConverter> {
  double rupees = 5;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("₹ ${rupees.toInt()} = ${rupees.toInt() * 100} Paise", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.indigo)),
        Slider(value: rupees, min: 1, max: 20, divisions: 19, onChanged: (v) => setState(() => rupees = v)),
      ],
    );
  }
}

// --- TAB 2: BAZAAR SHELF ---
class InteractiveBazaarReceipt extends StatefulWidget {
  const InteractiveBazaarReceipt({super.key});
  @override
  State<InteractiveBazaarReceipt> createState() => _InteractiveBazaarReceiptState();
}

class _InteractiveBazaarReceiptState extends State<InteractiveBazaarReceipt> {
  final Map<String, double> items = {"Alien Toy": 40.0, "Cosmic Book": 25.0, "Space Pen": 15.0};
  Set<String> cart = {};

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, item) => sum + items[item]!);
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: items.keys.map((name) => CheckboxListTile(
              title: Text("$name (₹${items[name]!.toInt()})"),
              value: cart.contains(name),
              onChanged: (v) => setState(() => v! ? cart.add(name) : cart.remove(name)),
            )).toList(),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(12)),
          child: Text("Cart Total: ₹ ${total.toInt()}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ),
      ],
    );
  }
}

// --- TAB 3: SMART CASHIER ---
class InteractiveCashierTrack extends StatefulWidget {
  const InteractiveCashierTrack({super.key});
  @override
  State<InteractiveCashierTrack> createState() => _InteractiveCashierTrackState();
}

class _InteractiveCashierTrackState extends State<InteractiveCashierTrack> {
  int bill = 65;
  int payment = 100;
  String message = "Calculate the change!";

  void _checkChange(int userAns) {
    setState(() {
      message = (userAns == (payment - bill)) ? "Correct! 🎉" : "Try again! 🤖";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Bill: ₹$bill | Paid: ₹$payment", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        const SizedBox(height: 20),
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Enter Change Amount", border: OutlineInputBorder()),
          onSubmitted: (v) => _checkChange(int.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 10),
        Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo)),
      ],
    );
  }
}