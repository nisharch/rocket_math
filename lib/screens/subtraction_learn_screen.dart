import 'package:flutter/material.dart';

class SubtractionLearnScreen extends StatefulWidget {
  const SubtractionLearnScreen({super.key});

  @override
  State<SubtractionLearnScreen> createState() => _SubtractionLearnScreenState();
}

class _SubtractionLearnScreenState extends State<SubtractionLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mango Muncher Game State
  int totalMangoes = 5;
  int eatenMangoes = 0;

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
      backgroundColor: Colors.amber.shade50, // Warm play-school background
      appBar: AppBar(
        title: const Text("➖ Subtraction Lab", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.redAccent,
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
            Tab(text: "🎒 Step 1"),
            Tab(text: "🥭 Step 2"),
            Tab(text: "👣 Step 3"),
            Tab(text: "⚡ Step 4"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Taking Things Away! 🎒",
            child: _buildIntroStarsDiagram(),
            borderColor: Colors.orange,
          ),
          _buildToyboxMission(
            title: "The Mango Muncher! 🥭",
            child: _buildMangoMuncherGame(),
            borderColor: Colors.amber.shade800,
          ),
          _buildToyboxMission(
            title: "Column Subtract Steps! 👣",
            child: const InteractiveNormalSubGrid(),
            borderColor: Colors.green,
          ),
          _buildToyboxMission(
            title: "The Borrowing Magic Engine! ⚡",
            child: const InteractiveBorrowMachine(),
            borderColor: Colors.purpleAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildToyboxMission({required String title, required Widget child, required Color borderColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 3), // Cartoon border
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
            const SizedBox(height: 20),
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

  // --- MODULE 1: VISUAL INTRODUCTION ---
  Widget _buildIntroStarsDiagram() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("⭐⭐⭐⭐⭐", style: TextStyle(fontSize: 22)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.orange.shade100, shape: BoxShape.circle),
              child: const Text("−", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.orange)),
            ),
            const Text("⭐⭐", style: TextStyle(fontSize: 22)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("=", style: TextStyle(fontSize: 22, color: Colors.black26, fontWeight: FontWeight.bold)),
            ),
            const Text("⭐⭐⭐", style: TextStyle(fontSize: 22)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
          child: const Text(
            "5 − 2 = 3 Leftovers!",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 15),
          ),
        )
      ],
    );
  }

  // --- MODULE 2: MANGO MUNCHER GAME MECHANIC ---
  Widget _buildMangoMuncherGame() {
    int currentMangoes = totalMangoes - eatenMangoes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            currentMangoes > 0 ? "🥭" * currentMangoes : "Empty Basket! 🧺",
            key: ValueKey<int>(currentMangoes),
            style: const TextStyle(fontSize: 28),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "$totalMangoes − $eatenMangoes = $currentMangoes",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.amber.shade900),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: eatenMangoes < totalMangoes ? () => setState(() => eatenMangoes++) : null,
              child: const Text("Eat One 🍽️", style: TextStyle(fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: eatenMangoes > 0 ? () => setState(() => eatenMangoes--) : null,
              child: const Text("Undo 🔄", style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        )
      ],
    );
  }
}

// --- MODULE 3: INTERACTIVE NORMAL GRID NAVIGATION ---
class InteractiveNormalSubGrid extends StatefulWidget {
  const InteractiveNormalSubGrid({super.key});

  @override
  State<InteractiveNormalSubGrid> createState() => _InteractiveNormalSubGridState();
}

class _InteractiveNormalSubGridState extends State<InteractiveNormalSubGrid> {
  int activeStep = 0; // 0: clear, 1: ones, 2: tens

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text("T", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: activeStep == 2 ? Colors.green : Colors.grey.shade300)),
            const SizedBox(width: 35),
            Text("O", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: activeStep == 1 ? Colors.green : Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text("3", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: activeStep == 2 ? Colors.green : Colors.black87)),
            const SizedBox(width: 30),
            Text("5", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: activeStep == 1 ? Colors.green : Colors.black87)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("−", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.green)),
            const SizedBox(width: 45),
            Text("1", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: activeStep == 2 ? Colors.green : Colors.black87)),
            const SizedBox(width: 30),
            Text("2", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: activeStep == 1 ? Colors.green : Colors.black87)),
          ],
        ),
        Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 3, width: 120, color: Colors.black26),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text(activeStep == 2 ? "2" : "?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: activeStep == 2 ? Colors.green : Colors.grey.shade300)),
            const SizedBox(width: 30),
            Text(activeStep >= 1 ? "3" : "?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: activeStep == 1 ? Colors.green : (activeStep == 2 ? Colors.black87 : Colors.grey.shade300))),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: activeStep == 1 ? Colors.green : Colors.grey.shade200,
                foregroundColor: activeStep == 1 ? Colors.white : Colors.black87,
              ),
              onPressed: () => setState(() => activeStep = 1),
              child: const Text("1. Ones (5−2)", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: activeStep == 2 ? Colors.green : Colors.grey.shade200,
                foregroundColor: activeStep == 2 ? Colors.white : Colors.black87,
              ),
              onPressed: activeStep >= 1 ? () => setState(() => activeStep = 2) : null,
              child: const Text("2. Tens (3−1)", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }
}

// --- MODULE 4: INTERACTIVE BORROW MACHINE ---
class InteractiveBorrowMachine extends StatefulWidget {
  const InteractiveBorrowMachine({super.key});

  @override
  State<InteractiveBorrowMachine> createState() => _InteractiveBorrowMachineState();
}

class _InteractiveBorrowMachineState extends State<InteractiveBorrowMachine> {
  bool isBorrowed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text(isBorrowed ? "(3)" : "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.purple.shade300)),
            const SizedBox(width: 35),
            Text(isBorrowed ? "(12)" : "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.purple.shade300)),
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
        Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 1, width: 110, color: Colors.black12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text("4", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, decoration: isBorrowed ? TextDecoration.lineThrough : null, decorationColor: Colors.red, color: isBorrowed ? Colors.black38 : Colors.black87)),
            const SizedBox(width: 30),
            Text("2", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, decoration: isBorrowed ? TextDecoration.lineThrough : null, decorationColor: Colors.red, color: isBorrowed ? Colors.black38 : Colors.blueAccent)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("−", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purpleAccent)),
            SizedBox(width: 45),
            Text("1", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            SizedBox(width: 30),
            Text("7", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
          ],
        ),
        Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 3, width: 110, color: Colors.black26),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Text(isBorrowed ? "2" : "?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: isBorrowed ? Colors.purpleAccent : Colors.grey.shade300)),
            const SizedBox(width: 30),
            Text(isBorrowed ? "5" : "?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: isBorrowed ? Colors.purpleAccent : Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purpleAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => setState(() => isBorrowed = !isBorrowed),
          child: Text(
            isBorrowed ? "Reset Power" : "Borrow 1 Ten! ⚡",
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          ),
        ),
      ],
    );
  }
}