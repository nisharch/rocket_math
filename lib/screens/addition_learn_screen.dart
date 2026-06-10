import 'package:flutter/material.dart';

class AdditionLearnScreen extends StatefulWidget {
  const AdditionLearnScreen({super.key});

  @override
  State<AdditionLearnScreen> createState() => _AdditionLearnScreenState();
}

class _AdditionLearnScreenState extends State<AdditionLearnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text("➕ Addition Lab", style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.blue.shade700,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: "Count"), Tab(text: "Columns"), Tab(text: "Carry")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          InteractiveStarCombiner(),
          InteractiveColumnAdder(),
          CarryAdditionScreen(),
        ],
      ),
    );
  }
}

// --- 1. COUNTING STARS ---
class InteractiveStarCombiner extends StatefulWidget {
  const InteractiveStarCombiner({super.key});
  @override
  State<InteractiveStarCombiner> createState() => _InteractiveStarCombinerState();
}

class _InteractiveStarCombinerState extends State<InteractiveStarCombiner> {
  int groupA = 2;
  int groupB = 3;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Tap stars to add: ${groupA + groupB}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(onPressed: () => setState(() => groupA++), icon: const Icon(Icons.add_circle, color: Colors.amber, size: 40)),
        Wrap(children: List.generate(groupA, (_) => const Icon(Icons.star, color: Colors.amber, size: 40))),
      ]),
      const Text("+", style: TextStyle(fontSize: 30)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(onPressed: () => setState(() => groupB++), icon: const Icon(Icons.add_circle, color: Colors.amber, size: 40)),
        Wrap(children: List.generate(groupB, (_) => const Icon(Icons.star, color: Colors.amber, size: 40))),
      ]),
    ]);
  }
}

// --- 2. TRADITIONAL COLUMN ADDITION ---
class InteractiveColumnAdder extends StatefulWidget {
  const InteractiveColumnAdder({super.key});
  @override
  State<InteractiveColumnAdder> createState() => _InteractiveColumnAdderState();
}

class _InteractiveColumnAdderState extends State<InteractiveColumnAdder> {
  int top = 24, bottom = 13;
  bool showOnes = false;
  bool showTens = false;

  @override
  Widget build(BuildContext context) {
    int ones = (top % 10) + (bottom % 10);
    int tens = (top ~/ 10) + (bottom ~/ 10);

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text("$top", style: const TextStyle(fontSize: 40, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
          Text("+ $bottom", style: const TextStyle(fontSize: 40, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
          Container(height: 2, width: 100, color: Colors.black),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(showTens ? "$tens" : " ", style: const TextStyle(fontSize: 40, fontFamily: 'Courier', color: Colors.green, fontWeight: FontWeight.bold)),
            Text(showOnes ? "$ones" : " ", style: const TextStyle(fontSize: 40, fontFamily: 'Courier', color: Colors.orange, fontWeight: FontWeight.bold)),
          ]),
        ]),
      ),
      const SizedBox(height: 30),
      Wrap(spacing: 10, children: [
        ElevatedButton(onPressed: () => setState(() => showOnes = true), child: const Text("1. Add Ones")),
        ElevatedButton(onPressed: () => setState(() => showTens = true), child: const Text("2. Add Tens")),
      ]),
    ]);
  }
}

// --- 3. CARRY OVER & STORY MATH ---
class CarryAdditionScreen extends StatefulWidget {
  const CarryAdditionScreen({super.key});
  @override
  State<CarryAdditionScreen> createState() => _CarryAdditionScreenState();
}

class _CarryAdditionScreenState extends State<CarryAdditionScreen> {
  bool showCarry = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 40),
      // Traditional Layout
      Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text("2 7", style: TextStyle(fontSize: 50, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
            const Text("+ 8", style: TextStyle(fontSize: 50, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
            Container(height: 2, width: 100, color: Colors.black),
            Text(showCarry ? "3 5" : " ", style: const TextStyle(fontSize: 50, fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Colors.blue)),
          ]),
        ),
        if (showCarry)
          const Positioned(top: 0, left: 40, child: Text("1", style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold))),
      ]),
      const SizedBox(height: 40),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
        onPressed: () => setState(() => showCarry = !showCarry),
        child: Text(showCarry ? "Hide Steps" : "Show Carry & Answer", style: const TextStyle(color: Colors.white)),
      ),
      const SizedBox(height: 40),
      
      // Story Math Section
      Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50, 
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade200)
        ),
        child: Column(children: [
          const Text("📖 Story Math", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Riya had 27 stickers in her book. She got 8 more as a prize from her teacher. How many stickers does she have now?",
            style: TextStyle(fontSize: 16), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          if (showCarry) 
            const Text(
              "Calculation: 27 + 8 = 35", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)
            ),
        ]),
      ),
    ]),
  );
}