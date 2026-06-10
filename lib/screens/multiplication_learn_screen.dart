import 'package:flutter/material.dart';

class MultiplicationLearnScreen extends StatefulWidget {
  const MultiplicationLearnScreen({super.key});

  @override
  State<MultiplicationLearnScreen> createState() => _MultiplicationLearnScreenState();
}

class _MultiplicationLearnScreenState extends State<MultiplicationLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
      backgroundColor: Colors.amber.shade50, // Warm, soft background
      appBar: AppBar(
        title: const Text("✖️ Multiplication Toybox", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.orangeAccent,
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
            Tab(text: "🍎 Step 1"),
            Tab(text: "📊 Step 2"),
            Tab(text: "👣 Step 3"),
            Tab(text: "⚡ Step 4"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Adding Over & Over! 🔁",
            child: const InteractiveRepeatedAddition(),
            borderColor: Colors.blueAccent,
          ),
          _buildToyboxMission(
            title: "Magic Table Matrix! 📊",
            child: const InteractiveTimesTableGrid(),
            borderColor: Colors.green,
          ),
          _buildToyboxMission(
            title: "Ones & Tens Engine! 👣",
            child: const InteractiveSimpleMulGrid(),
            borderColor: Colors.orangeAccent,
          ),
          _buildToyboxMission(
            title: "The Carry Magic Room! ⚡",
            child: const InteractiveCarryMulMachine(),
            borderColor: Colors.purpleAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildToyboxMission({required String title, required Widget child, required Color borderColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Center(
                child: SingleChildScrollView(child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MODULE 1: REPEATED ADDITION ---
class InteractiveRepeatedAddition extends StatefulWidget {
  const InteractiveRepeatedAddition({super.key});

  @override
  State<InteractiveRepeatedAddition> createState() => _InteractiveRepeatedAdditionState();
}

class _InteractiveRepeatedAdditionState extends State<InteractiveRepeatedAddition> {
  int groupCount = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(groupCount, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("🍎🍎", style: TextStyle(fontSize: 24)),
                if (index < groupCount - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("+", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.w900)),
                  ),
              ],
            );
          }),
        ),
        const SizedBox(height: 20),
        Text(
          "$groupCount Groups of 2 = ${groupCount * 2}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.blueAccent),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.blueAccent, size: 36),
              onPressed: groupCount > 1 ? () => setState(() => groupCount--) : null,
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blueAccent, size: 36),
              onPressed: groupCount < 5 ? () => setState(() => groupCount++) : null,
            ),
          ],
        )
      ],
    );
  }
}

// --- MODULE 2: INTERACTIVE TIMES TABLE MATRIX (NO SCROLL / NO FIXED HEIGHT) ---
class InteractiveTimesTableGrid extends StatefulWidget {
  const InteractiveTimesTableGrid({super.key});

  @override
  State<InteractiveTimesTableGrid> createState() => _InteractiveTimesTableGridState();
}

class _InteractiveTimesTableGridState extends State<InteractiveTimesTableGrid> {
  int selectedTable = 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // Keeps rows neatly fitted together
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🛠️ Fixed: Changed Container height constraint to let all 10 items show smoothly at once with compact padding
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(10, (i) {
                int factor = i + 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.5), // Tighter item gap
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$selectedTable × $factor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green.shade800)),
                      const Text("=", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black26)),
                      Text("${selectedTable * factor}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Colors.deepOrangeAccent)),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          // Horizontal Selector
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                int tableNum = index + 1;
                bool isCurrent = tableNum == selectedTable;
                return GestureDetector(
                  onTap: () => setState(() => selectedTable = tableNum),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 38,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: isCurrent ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isCurrent ? Colors.green.shade700 : Colors.grey.shade300, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$tableNum",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: isCurrent ? Colors.white : Colors.green.shade800),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- MODULE 3: COMPACT COLUMN GRID ---
class InteractiveSimpleMulGrid extends StatefulWidget {
  const InteractiveSimpleMulGrid({super.key});

  @override
  State<InteractiveSimpleMulGrid> createState() => _InteractiveSimpleMulGridState();
}

class _InteractiveSimpleMulGridState extends State<InteractiveSimpleMulGrid> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text("T", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: activeStep == 2 ? Colors.orange : Colors.grey.shade300)),
            const SizedBox(width: 35),
            Text("O", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: activeStep == 1 ? Colors.orange : Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text("2", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: activeStep == 2 ? Colors.orange : Colors.black87)),
            const SizedBox(width: 30),
            Text("3", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: activeStep == 1 ? Colors.orange : Colors.black87)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("×", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.orange)),
            const SizedBox(width: 45),
            Text("3", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: activeStep > 0 ? Colors.orange : Colors.black87)),
          ],
        ),
        Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 3, width: 110, color: Colors.black26),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text(activeStep == 2 ? "6" : "?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: activeStep == 2 ? Colors.orange : Colors.grey.shade300)),
            const SizedBox(width: 30),
            Text(activeStep >= 1 ? "9" : "?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: activeStep == 1 ? Colors.orange : (activeStep == 2 ? Colors.black87 : Colors.grey.shade300))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 36,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeStep == 1 ? Colors.orange : Colors.grey.shade200,
                  foregroundColor: activeStep == 1 ? Colors.white : Colors.black87,
                ),
                onPressed: () => setState(() => activeStep = 1),
                child: const Text("1. Ones", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeStep == 2 ? Colors.orange : Colors.grey.shade200,
                  foregroundColor: activeStep == 2 ? Colors.white : Colors.black87,
                ),
                onPressed: activeStep >= 1 ? () => setState(() => activeStep = 2) : null,
                child: const Text("2. Tens", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- MODULE 4: COMPACT CARRY ENGINE ---
class InteractiveCarryMulMachine extends StatefulWidget {
  const InteractiveCarryMulMachine({super.key});

  @override
  State<InteractiveCarryMulMachine> createState() => _InteractiveCarryMulMachineState();
}

class _InteractiveCarryMulMachineState extends State<InteractiveCarryMulMachine> {
  bool showMagic = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: showMagic ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.purpleAccent, shape: BoxShape.circle),
                child: const Text("1", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
            const SizedBox(width: 35),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(width: 30),
            Text("T", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.purpleAccent)),
            SizedBox(width: 35),
            Text("O", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
          ],
        ),
        Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 1, width: 100, color: Colors.black12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(width: 30),
            Text("2", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87)),
            SizedBox(width: 30),
            Text("4", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("×", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purpleAccent)),
            SizedBox(width: 45),
            Text("3", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
          ],
        ),
        Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 3, width: 100, color: Colors.black26),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text(showMagic ? "7" : "?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: showMagic ? Colors.purpleAccent : Colors.grey.shade300)),
            const SizedBox(width: 30),
            Text(showMagic ? "2" : "?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: showMagic ? Colors.purpleAccent : Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purpleAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => setState(() => showMagic = !showMagic),
          child: Text(
            showMagic ? "Hide Magic" : "Trigger Carry! ⚡",
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          ),
        ),
      ],
    );
  }
}