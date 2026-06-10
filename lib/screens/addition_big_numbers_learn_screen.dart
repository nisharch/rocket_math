import 'package:flutter/material.dart';

class AdditionBigNumbersLearnScreen extends StatefulWidget {
  const AdditionBigNumbersLearnScreen({super.key});

  @override
  State<AdditionBigNumbersLearnScreen> createState() => _AdditionBigNumbersLearnScreenState();
}

class _AdditionBigNumbersLearnScreenState extends State<AdditionBigNumbersLearnScreen> with SingleTickerProviderStateMixin {
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
        title: const Text("🚀 Large Numbers Orbit", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🗺️ Grid Spawn"),
            Tab(text: "⚡ Dual Engine"),
            Tab(text: "📦 Cargo Scale"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxCard(
            borderColor: Colors.teal.shade700,
            child: const InteractiveGridSpawner(),
          ),
          _buildToyboxCard(
            borderColor: Colors.purple,
            child: const InteractiveDualAdditionEngine(),
          ),
          _buildToyboxCard(
            borderColor: Colors.orange.shade800,
            child: const CargoScaleToy(),
          ),
        ],
      ),
    );
  }

  Widget _buildToyboxCard({required Color borderColor, required Widget child}) {
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
        child: Center(child: child),
      ),
    );
  }
}

// --- TAB 1: INTERACTIVE GRID SPAWNER ---
class InteractiveGridSpawner extends StatefulWidget {
  const InteractiveGridSpawner({super.key});

  @override
  State<InteractiveGridSpawner> createState() => _InteractiveGridSpawnerState();
}

class _InteractiveGridSpawnerState extends State<InteractiveGridSpawner> {
  int activeColumn = -1; // -1: none, 0: Th, 1: H, 2: T, 3: O

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("🗺️ Tap a Column to See its Weight Value!", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.blueGrey)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSpawnColumn("Th", "1000s", Colors.teal, activeColumn == 0, () => setState(() => activeColumn = 0)),
            _buildSpawnColumn("H", "100s", Colors.purple, activeColumn == 1, () => setState(() => activeColumn = 1)),
            _buildSpawnColumn("T", "10s", Colors.orange.shade800, activeColumn == 2, () => setState(() => activeColumn = 2)),
            _buildSpawnColumn("O", "1s", Colors.blueAccent, activeColumn == 3, () => setState(() => activeColumn = 3)),
          ],
        ),
        const SizedBox(height: 24),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: activeColumn == -1 ? Colors.grey.shade100 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          width: 240,
          alignment: Alignment.center,
          child: Text(
            activeColumn == 0 ? "⚡ Thousands Multiplier block!\nHolds: 1000, 2000, 3000..." :
            activeColumn == 1 ? "🔮 Hundreds Room pack!\nHolds: 100, 200, 300..." :
            activeColumn == 2 ? "🔸 Tens Rod station!\nHolds: 10, 20, 30, 40..." :
            activeColumn == 3 ? "💎 Single Ones units tokens!\nHolds: 1, 2, 3, 4, 5..." : "Click a card station above!",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87, height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSpawnColumn(String name, String sub, Color col, bool selected, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 52,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: selected ? col : col.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: col, width: selected ? 3 : 1.5),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: selected ? Colors.white : col)),
            Text(sub, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: selected ? Colors.white70 : Colors.black45)),
          ],
        ),
      ),
    );
  }
}

// --- TAB 2: INTERACTIVE DUAL CALCULATOR ENGINE ---
class InteractiveDualAdditionEngine extends StatefulWidget {
  const InteractiveDualAdditionEngine({super.key});

  @override
  State<InteractiveDualAdditionEngine> createState() => _InteractiveDualAdditionEngineState();
}

class _InteractiveDualAdditionEngineState extends State<InteractiveDualAdditionEngine> {
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
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.purple.withOpacity(0.3), width: 2),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isFourDigitMode) ...[
                    _buildCarryIcon(currentStep >= 4),
                    const SizedBox(width: 25),
                  ],
                  _buildCarryIcon(currentStep >= 3),
                  const SizedBox(width: 25),
                  _buildCarryIcon(currentStep >= 2),
                  const SizedBox(width: 25),
                  _buildCarryIcon(false),
                  const SizedBox(width: 15),
                ],
              ),
              const SizedBox(height: 4),
              Column(
                children: [
                  Text(
                    isFourDigitMode ? "  4  5  8  2" : "  4  6  8",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 6),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("+", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.purple, fontSize: 16)),
                      Text(
                        isFourDigitMode ? "  2  7  4  3" : "  2  5  4",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 6),
                      ),
                    ],
                  ),
                ],
              ),
              Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 3, width: 140, color: Colors.black38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isFourDigitMode 
                  ? [
                      _buildFinalDigit(currentStep >= 4 ? "7" : "?", currentStep == 4),
                      _buildFinalDigit(currentStep >= 3 ? "3" : "?", currentStep == 3),
                      _buildFinalDigit(currentStep >= 2 ? "2" : "?", currentStep == 2),
                      _buildFinalDigit(currentStep >= 1 ? "5" : "?", currentStep == 1),
                    ]
                  : [
                      _buildFinalDigit(currentStep >= 3 ? "7" : "?", currentStep == 3),
                      _buildFinalDigit(currentStep >= 2 ? "2" : "?", currentStep == 2),
                      _buildFinalDigit(currentStep >= 1 ? "2" : "?", currentStep == 1),
                    ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxSteps, (i) {
            int target = i + 1;
            bool active = currentStep == target;
            return GestureDetector(
              onTap: () => setState(() => currentStep = target),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? Colors.purple : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.withOpacity(0.3)),
                ),
                child: Text(
                  "Step $target",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: active ? Colors.white : Colors.purple),
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
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: active ? Colors.white : Colors.black54)),
      ),
    );
  }

  Widget _buildCarryIcon(bool highlighted) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: highlighted ? Colors.deepOrangeAccent : Colors.transparent, shape: BoxShape.circle),
      child: Text(highlighted ? "1" : "", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
    );
  }

  Widget _buildFinalDigit(String char, bool active) {
    return Container(
      width: 32,
      alignment: Alignment.center,
      child: Text(
        char,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: active ? Colors.purple : (char != "?" ? Colors.green.shade700 : Colors.black26),
        ),
      ),
    );
  }
}

// --- TAB 3: CARGO SCALE TOY (🛠️ FIX: HIGH-CONTRAST ACCESSIBILITY COLOR MODIFICATIONS) ---
class CargoScaleToy extends StatefulWidget {
  const CargoScaleToy({super.key});

  @override
  State<CargoScaleToy> createState() => _CargoScaleToyState();
}

class _CargoScaleToyState extends State<CargoScaleToy> {
  double scaleWeightValue = 3000;

  @override
  Widget build(BuildContext context) {
    bool isMatch = scaleWeightValue.toInt() == 6320;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade300, width: 2),
          ),
          child: Column(
            children: [
              const Text("📦 TARGET WEIGHT manifest: 6,320 kg", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.orangeAccent)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("⚖️ Current Load: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  Text(
                    "${scaleWeightValue.toInt()} kg",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: isMatch ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: scaleWeightValue,
          min: 3000,
          max: 7000,
          divisions: 400,
          activeColor: isMatch ? Colors.green : Colors.orange.shade800,
          inactiveColor: Colors.orange.shade100,
          onChanged: (val) => setState(() => scaleWeightValue = val),
        ),
        const SizedBox(height: 4),
        // 🛠️ Fixed: Converted text visibility parameters to high contrast bold configs
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isMatch ? Colors.green : Colors.orange.shade100, // Safe warm background tint
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isMatch ? Colors.green : Colors.orange.shade300, width: 1.5),
          ),
          child: Text(
            isMatch ? "🎉 MATCH CLEAR! ROCKET LAUNCHED!" : "Slide Slider to match 6,320 kg exactly!",
            style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 12, 
              color: isMatch ? Colors.white : Colors.black87, // Strong dark grey color definition
            ),
          ),
        ),
      ],
    );
  }
}