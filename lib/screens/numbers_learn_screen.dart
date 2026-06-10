import 'package:flutter/material.dart';

class NumbersLearnScreen extends StatefulWidget {
  const NumbersLearnScreen({super.key});

  @override
  State<NumbersLearnScreen> createState() => _NumbersLearnScreenState();
}

class _NumbersLearnScreenState extends State<NumbersLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text("🔢 Numbers Lab (Class 3)", style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.blueAccent,
        bottom: TabBar(controller: _tabController, isScrollable: true, tabs: const [
          Tab(text: "⭐ Counting"), Tab(text: "🏠 Place Value"), Tab(text: "🐊 Compare"), Tab(text: "⬆️ Order")
        ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        _buildMission("Counting Stars!", "👆 TAP each star to start counting! Can you reach the target?", Colors.blue, const InteractiveStarCounter()),
        _buildMission("Place Value Lab", "See how hundreds, tens, and ones build a number!", Colors.green, const InteractivePlaceValue()),
        _buildMission("Crocodile Time!", "Which number is bigger?", Colors.orange, const InteractiveCrocodile()),
        _buildMission("Number Stairs", "Order the blocks from smallest to biggest!", Colors.purple, const InteractiveStairs()),
      ]),
    );
  }

  Widget _buildMission(String title, String summary, Color color, Widget child) {
    return Padding(padding: const EdgeInsets.all(20), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: color, width: 3)), child: Column(children: [Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)), const SizedBox(height: 10), Text(summary, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center), const SizedBox(height: 20), Expanded(child: Center(child: child))])));
  }
}

// --- 1. COUNTING (MISSION CONTROL) ---
class InteractiveStarCounter extends StatefulWidget {
  const InteractiveStarCounter({super.key});
  @override
  State<InteractiveStarCounter> createState() => _InteractiveStarCounterState();
}
class _InteractiveStarCounterState extends State<InteractiveStarCounter> {
  int count = 0;
  int target = 5;
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _mBtn("Lvl 1 (5)", 5), _mBtn("Lvl 2 (8)", 8), _mBtn("Lvl 3 (10)", 10),
    ]),
    const SizedBox(height: 20),
    Text("Count: $count / $target", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    Wrap(children: List.generate(target, (i) => IconButton(onPressed: () => setState(() => count = i + 1), icon: Icon(Icons.star, color: count > i ? Colors.amber : Colors.grey.shade300, size: 50)))),
  ]);
  Widget _mBtn(String label, int t) => ElevatedButton(onPressed: () => setState(() { target = t; count = 0; }), child: Text(label));
}

// --- 2. PLACE VALUE ---
class InteractivePlaceValue extends StatefulWidget {
  const InteractivePlaceValue({super.key});
  @override
  State<InteractivePlaceValue> createState() => _InteractivePlaceValueState();
}
class _InteractivePlaceValueState extends State<InteractivePlaceValue> {
  int h = 1, t = 2, o = 3;
  @override
  Widget build(BuildContext context) => Column(children: [
    Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)), child: Text("${h*100 + t*10 + o}", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w900, color: Colors.green))),
    const SizedBox(height: 20),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _pBtn("H", h, (v) => h = v), _pBtn("T", t, (v) => t = v), _pBtn("O", o, (v) => o = v),
    ]),
    const Text("Example: 123 (100+20+3) | 245 (200+40+5)", style: TextStyle(fontStyle: FontStyle.italic))
  ]);
  Widget _pBtn(String l, int v, Function(int) upd) => Column(children: [Text(l, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), IconButton(onPressed: () => setState(() => upd(v + 1)), icon: const Icon(Icons.add_circle, size: 40))]);
}

// --- 3. CROCODILE ---
class InteractiveCrocodile extends StatefulWidget {
  const InteractiveCrocodile({super.key});
  @override
  State<InteractiveCrocodile> createState() => _InteractiveCrocodileState();
}
class _InteractiveCrocodileState extends State<InteractiveCrocodile> {
  String msg = "Which is bigger?";
  @override
  Widget build(BuildContext context) => Column(children: [
    const Text("Ex 1: 8 vs 5 | Ex 2: 12 vs 19", style: TextStyle(fontSize: 14)),
    const SizedBox(height: 20),
    const Text("8 vs 5", style: TextStyle(fontSize: 40)),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(onPressed: () => setState(() => msg = "Correct! 8 is bigger! 🎉"), child: const Text("8 > 5")),
      const SizedBox(width: 10),
      ElevatedButton(onPressed: () => setState(() => msg = "Oops! Try again."), child: const Text("5 > 8")),
    ]),
    Text(msg, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
  ]);
}

// --- 4. ORDERING STAIRS ---
class InteractiveStairs extends StatefulWidget {
  const InteractiveStairs({super.key});
  @override
  State<InteractiveStairs> createState() => _InteractiveStairsState();
}
class _InteractiveStairsState extends State<InteractiveStairs> {
  String res = "";
  @override
  Widget build(BuildContext context) => Column(children: [
    const Text("Ex 1: 5, 2, 8 | Ex 2: 10, 4, 15", style: TextStyle(fontSize: 14)),
    const SizedBox(height: 20),
    Wrap(spacing: 15, children: [_b("2"), _b("5"), _b("8")]),
    const SizedBox(height: 20),
    ElevatedButton(onPressed: () => setState(() => res = "2 -> 5 -> 8. Correct! 🏆"), child: const Text("Show Order", style: TextStyle(fontSize: 18))),
    Text(res, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
  ]);
  Widget _b(String n) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.purple.shade200, borderRadius: BorderRadius.circular(10)), child: Text(n, style: const TextStyle(fontSize: 30, color: Colors.white)));
}