import 'package:flutter/material.dart';

class PerimeterAreaLearnScreen extends StatefulWidget {
  const PerimeterAreaLearnScreen({super.key});

  @override
  State<PerimeterAreaLearnScreen> createState() => _PerimeterAreaLearnScreenState();
}

class _PerimeterAreaLearnScreenState extends State<PerimeterAreaLearnScreen> with SingleTickerProviderStateMixin {
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
        title: const Text("📐 Perimeter & Area Lab", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.lightGreen.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🧱 Perimeter"),
            Tab(text: "🟧 Area Tile"),
            Tab(text: "🏆 Formulas"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "What is Perimeter? 🧱",
            summary: "Perimeter is the total boundary line around the OUTSIDE of any shape. Think of it as a fence.",
            tip: "💡 Robo-Tip: To find the perimeter, simply ADD up all the outer side lengths together!",
            borderColor: Colors.lightGreen.shade700,
            child: const InteractivePerimeterToy(),
          ),
          _buildToyboxMission(
            title: "What is Area? 🟧",
            summary: "Area is the total amount of flat space INSIDE a shape! Tap tiles to fill the space.",
            tip: "💡 Robo-Tip: Area is always measured in square units, like square cm or square meters!",
            borderColor: Colors.blueAccent,
            child: const InteractiveAreaToy(),
          ),
          _buildToyboxMission(
            title: "Master Formulas! 🏆",
            summary: "Use these superpower formulas to calculate sizes instantly without counting tiles.",
            tip: "💡 Robo-Tip: Perimeter is for the edge, while Area is for the inside surface!",
            borderColor: Colors.orange.shade800,
            child: const InteractiveFormulaVault(),
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

// --- TAB 1: PERIMETER TOY ---
class InteractivePerimeterToy extends StatelessWidget {
  const InteractivePerimeterToy({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120, height: 80,
          decoration: BoxDecoration(border: Border.all(color: Colors.redAccent, width: 4)),
          child: const Center(child: Text("5cm + 3cm\n+ 5cm + 3cm", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 16),
        const Text("Total Perimeter = 16 cm", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.redAccent)),
      ],
    );
  }
}

// --- TAB 2: INTERACTIVE AREA TOY ---
class InteractiveAreaToy extends StatefulWidget {
  const InteractiveAreaToy({super.key});
  @override
  State<InteractiveAreaToy> createState() => _InteractiveAreaToyState();
}

class _InteractiveAreaToyState extends State<InteractiveAreaToy> {
  Set<int> paintedTiles = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          children: List.generate(16, (i) {
            bool isPainted = paintedTiles.contains(i);
            return GestureDetector(
              onTap: () => setState(() => isPainted ? paintedTiles.remove(i) : paintedTiles.add(i)),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: isPainted ? Colors.blue.shade400 : Colors.blue.shade50, border: Border.all(color: Colors.blue.shade200)),
                child: Center(child: Text(isPainted ? "1" : "", style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(10)),
          child: Text("Current Area: ${paintedTiles.length} Sq. units", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.blueAccent)),
        ),
      ],
    );
  }
}

// --- TAB 3: FORMULA VAULT (WITH EASY EXAMPLE) ---
class InteractiveFormulaVault extends StatefulWidget {
  const InteractiveFormulaVault({super.key});
  @override
  State<InteractiveFormulaVault> createState() => _InteractiveFormulaVaultState();
}

class _InteractiveFormulaVaultState extends State<InteractiveFormulaVault> {
  bool isSquare = true;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: [!isSquare, isSquare],
          onPressed: (i) => setState(() => isSquare = i == 1),
          children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Rectangle")), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Square"))],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Text(isSquare ? "Easy Square (Side 4m)" : "Easy Rect (L 6m, W 4m)", style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Text(
                isSquare 
                ? "Perimeter: 4 × 4 = 16m\nArea: 4 × 4 = 16 sq.m" 
                : "Perimeter: 2 × (6+4) = 20m\nArea: 6 × 4 = 24 sq.m",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}