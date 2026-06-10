import 'package:flutter/material.dart';

class SubtractionBigNumbersLearnScreen extends StatefulWidget {
  const SubtractionBigNumbersLearnScreen({super.key});

  @override
  State<SubtractionBigNumbersLearnScreen> createState() => _SubtractionBigNumbersLearnScreenState();
}

class _SubtractionBigNumbersLearnScreenState extends State<SubtractionBigNumbersLearnScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.amber.shade50, // Premium warm toybox theme
      appBar: AppBar(
        title: const Text("🚀 Subtraction Space Lab", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.deepOrange.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🔮 Borrow Link"),
            Tab(text: "⚡ Dual Engine"),
            Tab(text: "🪣 Weight Vault"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "The Borrowing Power Link! 🔮",
            summary: "When a top digit is too small to subtract from, tap the link to borrow a 10s rod from its neighbor!",
            tip: "💡 Robo-Tip: Borrowing takes 1 away from the neighbor column on the left and adds a full 10 to your column!",
            borderColor: Colors.deepOrange.shade700,
            child: const InteractiveBorrowSpawner(),
          ),
          _buildToyboxMission(
            title: "Regrouping Subtraction Engine! ⚡",
            summary: "Switch between 3-Digit and 4-Digit missions. Tap the step buttons to see borrowing columns change live!",
            tip: "💡 Robo-Tip: Always start subtracting from the right side (Ones room) and move left column-by-column!",
            borderColor: Colors.purple,
            child: const InteractiveDualSubtractionEngine(),
          ),
          _buildToyboxMission(
            title: "Fuel Vault Weight Decrement! 🪣",
            summary: "The spaceship fuel bay is too heavy! Adjust the drainage valve to subtract fuel to the target value.",
            tip: "Manifest Subtraction Formula:\n8,000 L (Current Tank) − 3,170 L (Drained Fuel) = 4,830 L Target!",
            borderColor: Colors.teal.shade700,
            child: const CargoVaultToy(),
          ),
        ],
      ),
    );
  }

  // 🌟 Exactly mirrors the balanced card structure used in your Addition screen
  Widget _buildToyboxMission({
    required String title,
    required String summary,
    required String tip,
    required Color borderColor,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          children: [
            // Top Context
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              summary,
              style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // Centered Interactive Toy Panel
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.center,
                child: Center(child: child),
              ),
            ),
            // Bottom Robo-Tip Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor.withOpacity(0.2), width: 1.5),
              ),
              child: Text(
                tip,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: borderColor == Colors.teal.shade700 ? Colors.teal.shade900 : borderColor, height: 1.3),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TAB 1: INTERACTIVE BORROW SPAWNER ---
class InteractiveBorrowSpawner extends StatefulWidget {
  const InteractiveBorrowSpawner({super.key});

  @override
  State<InteractiveBorrowSpawner> createState() => _InteractiveBorrowSpawnerState();
}

class _InteractiveBorrowSpawnerState extends State<InteractiveBorrowSpawner> {
  bool isBorrowed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBorrowNode("Tens (T)", isBorrowed ? "5" : "6", Colors.orange.shade800, isBorrowed),
            const SizedBox(width: 16),
            const Text("➡️", style: TextStyle(fontSize: 22, color: Colors.black26, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            _buildBorrowNode("Ones (O)", isBorrowed ? "12" : "2", Colors.blueAccent, isBorrowed),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 40,
          width: 180,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isBorrowed ? Colors.grey : Colors.deepOrange.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => setState(() => isBorrowed = !isBorrowed),
            icon: Icon(isBorrowed ? Icons.undo : Icons.bolt),
            label: Text(isBorrowed ? "RESET COLUMNS" : "ACTIVATE BORROW! ⚡", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildBorrowNode(String title, String value, Color col, bool highlighted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 85,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlighted ? col.withOpacity(0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: highlighted ? col : Colors.grey.shade300, width: 2.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: col)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: col)),
        ],
      ),
    );
  }
}

// --- TAB 2: DUAL SUBTRACTION COLUMN ENGINE ---
class InteractiveDualSubtractionEngine extends StatefulWidget {
  const InteractiveDualSubtractionEngine({super.key});

  @override
  State<InteractiveDualSubtractionEngine> createState() => _InteractiveDualSubtractionEngineState();
}

class _InteractiveDualSubtractionEngineState extends State<InteractiveDualSubtractionEngine> {
  bool isFourDigitMode = false;
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    int maxSteps = isFourDigitMode ? 4 : 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeTab("3-Digit Mission", !isFourDigitMode, () => setState(() { isFourDigitMode = false; currentStep = 0; })),
            const SizedBox(width: 8),
            _buildModeTab("4-Digit Mission", isFourDigitMode, () => setState(() { isFourDigitMode = true; currentStep = 0; })),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.purple.withOpacity(0.3), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isFourDigitMode) ...[
                    _buildBorrowBadge(currentStep >= 4, "4"), 
                    const SizedBox(width: 16),
                    _buildBorrowBadge(currentStep >= 3, "11"), 
                    const SizedBox(width: 16),
                  ],
                  _buildBorrowBadge(currentStep >= 2, "5"), 
                  const SizedBox(width: 16),
                  _buildBorrowBadge(currentStep >= 1, "12"), 
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isFourDigitMode ? "  5  2  4  6" : "  4  6  2",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.blueGrey.shade900),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("−", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.purple, fontSize: 18)),
                  Text(
                    isFourDigitMode ? "  1  8  7  3" : "  2  5  8",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.blueGrey.shade900),
                  ),
                ],
              ),
              Container(margin: const EdgeInsets.symmetric(vertical: 8), height: 3, width: 150, color: Colors.black38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isFourDigitMode
                    ? [
                        _buildFinalDigit(currentStep >= 4 ? "3" : "?", currentStep == 4),
                        _buildFinalDigit(currentStep >= 3 ? "3" : "?", currentStep == 3),
                        _buildFinalDigit(currentStep >= 2 ? "7" : "?", currentStep == 2),
                        _buildFinalDigit(currentStep >= 1 ? "3" : "?", currentStep == 1),
                      ]
                    : [
                        _buildFinalDigit(currentStep >= 3 ? "2" : "?", currentStep == 3),
                        _buildFinalDigit(currentStep >= 2 ? "0" : "?", currentStep == 2),
                        _buildFinalDigit(currentStep >= 1 ? "4" : "?", currentStep == 1),
                      ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxSteps, (i) {
            int target = i + 1;
            bool active = currentStep == target;
            return GestureDetector(
              onTap: () => setState(() => currentStep = target),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? Colors.purple : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple.withOpacity(0.4), width: 1.5),
                ),
                child: Text(
                  "Step $target",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: active ? Colors.white : Colors.purple),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildModeTab(String text, bool active, VoidCallback action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.purple : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? Colors.purple.shade700 : Colors.grey.shade300, width: 1.5),
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: active ? Colors.white : Colors.black54)),
      ),
    );
  }

  Widget _buildBorrowBadge(bool active, String num) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: active ? Colors.deepOrangeAccent : Colors.transparent, shape: BoxShape.circle),
      child: Text(active ? num : "", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white)),
    );
  }

  Widget _buildFinalDigit(String char, bool active) {
    return Container(
      width: 32,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      child: Text(
        char,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: active ? Colors.purple : (char != "?" ? Colors.green.shade700 : Colors.black26),
        ),
      ),
    );
  }
}

// --- TAB 3: GAMIFIED VAULT SLIDER ---
class CargoVaultToy extends StatefulWidget {
  const CargoVaultToy({super.key});

  @override
  State<CargoVaultToy> createState() => _CargoVaultToyState();
}

class _CargoVaultToyState extends State<CargoVaultToy> {
  double currentVaultFuel = 8000;

  @override
  Widget build(BuildContext context) {
    bool isCleared = currentVaultFuel.toInt() == 4830;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.teal.shade300, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🔥 Current Tank: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
              Text(
                "${currentVaultFuel.toInt()} L",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: isCleared ? Colors.green : Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: currentVaultFuel,
          min: 4000,
          max: 8000,
          divisions: 400,
          activeColor: isCleared ? Colors.green : Colors.teal.shade700,
          inactiveColor: Colors.teal.shade100,
          onChanged: (val) => setState(() => currentVaultFuel = val),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isCleared ? Colors.green : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isCleared ? Colors.green : Colors.orange.shade300, width: 1.5),
          ),
          child: Text(
            isCleared ? "🎉 DRAIN VALVE SUCCESS! VAULT UNLOCKED!" : "Slide to subtract weight to 4,830 L exactly!",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              color: isCleared ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}