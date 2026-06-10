import 'package:flutter/material.dart';

class LargeNumbersLearnScreen extends StatefulWidget {
  const LargeNumbersLearnScreen({super.key});

  @override
  State<LargeNumbersLearnScreen> createState() => _LargeNumbersLearnScreenState();
}

class _LargeNumbersLearnScreenState extends State<LargeNumbersLearnScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.amber.shade50, // Play-school toybox frame canvas
      appBar: AppBar(
        title: const Text("🚀 Thousands Space Station", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🌌 4th Orbit"),
            Tab(text: "🗺️ Value Map"),
            Tab(text: "💥 Rocket Blast"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxCard(
            borderColor: Colors.blueGrey.shade700,
            child: const OrbitTransitionToy(),
          ),
          _buildToyboxCard(
            borderColor: Colors.blueAccent,
            child: const PlaceValueMapToy(),
          ),
          _buildToyboxCard(
            borderColor: Colors.purpleAccent,
            child: const RocketExpandedToy(),
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

// --- TAB 1: ORBIT TRANSITION COMPASS (ZERO BORING TEXT) ---
class OrbitTransitionToy extends StatefulWidget {
  const OrbitTransitionToy({super.key});

  @override
  State<OrbitTransitionToy> createState() => _OrbitTransitionToyState();
}

class _OrbitTransitionToyState extends State<OrbitTransitionToy> {
  int displayValue = 999;

  @override
  Widget build(BuildContext context) {
    bool isThousand = displayValue == 1000;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("🌌 Tap the Engine Core to Cross the 4th Digit Orbit!", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.blueGrey)),
        const SizedBox(height: 24),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isThousand ? Colors.teal.shade50 : Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isThousand ? Colors.teal : Colors.blueGrey, width: 2.5),
          ),
          child: Column(
            children: [
              Text(
                isThousand ? "1,000" : "$displayValue",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: isThousand ? Colors.teal.shade800 : Colors.blueGrey.shade900),
              ),
              const SizedBox(height: 4),
              Text(
                isThousand ? "✨ Smallest 4-Digit Number! ✨" : "Biggest 3-Digit Number",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: isThousand ? Colors.teal.shade700 : Colors.black45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 44,
          width: 160,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isThousand ? Colors.blueGrey : Colors.deepOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => setState(() => displayValue = isThousand ? 999 : 1000),
            icon: Icon(isThousand ? Icons.refresh : Icons.add_box),
            label: Text(isThousand ? "RESET SYSTEM" : "ENGINE CORE +1", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
          ),
        )
      ],
    );
  }
}

// --- TAB 2: INTERACTIVE PLACE VALUE CHART MAP ---
class PlaceValueMapToy extends StatefulWidget {
  const PlaceValueMapToy({super.key});

  @override
  State<PlaceValueMapToy> createState() => _PlaceValueMapToyState();
}

class _PlaceValueMapToyState extends State<PlaceValueMapToy> {
  int currentNumberIndex = 0;
  final List<List<String>> dynamicNumbers = [
    ["4", "3", "7", "5"],
    ["8", "0", "4", "2"],
    ["5", "9", "1", "6"],
  ];

  @override
  Widget build(BuildContext context) {
    List<String> activeDigits = dynamicNumbers[currentNumberIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("🗺️ Tap a Satellite Link to Load Different Numbers!", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black45)),
        const SizedBox(height: 16),
        // Place value chart block rows
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMapNode("Th", activeDigits[0], Colors.indigo),
            _buildMapNode("H", activeDigits[1], Colors.deepOrange),
            _buildMapNode("T", activeDigits[2], Colors.teal.shade700),
            _buildMapNode("O", activeDigits[3], Colors.purple),
          ],
        ),
        const SizedBox(height: 24),
        // Horizontal Track Controls Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(dynamicNumbers.length, (index) {
            bool current = currentNumberIndex == index;
            String labelText = dynamicNumbers[index].join("");
            return GestureDetector(
              onTap: () => setState(() => currentNumberIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: current ? Colors.blueAccent : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: current ? Colors.blue.shade800 : Colors.grey.shade300, width: 1.5),
                ),
                child: Text(
                  "${labelText[0]},${labelText.substring(1)}",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: current ? Colors.white : Colors.blueAccent),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMapNode(String head, String value, Color paletteColor) {
    return Container(
      width: 54,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Text(head, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: paletteColor)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: paletteColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: paletteColor.withOpacity(0.3), width: 2),
            ),
            child: Center(
              child: Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: paletteColor)),
            ),
          )
        ],
      ),
    );
  }
}

// --- TAB 3: PLACE VALUE ROCKET EXPANDED FORM EXPLODER ---
class RocketExpandedToy extends StatefulWidget {
  const RocketExpandedToy({super.key});

  @override
  State<RocketExpandedToy> createState() => _RocketExpandedToyState();
}

class _RocketExpandedToyState extends State<RocketExpandedToy> {
  bool isBlasted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Core Target Shield Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(14)),
          child: const Text(
            "🚀 Target Model Capsule: 4,375",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.purple),
          ),
        ),
        const SizedBox(height: 16),
        // Fragment Value Layout Track Matrix
        SizedBox(
          width: 240,
          child: Column(
            children: [
              _buildValueRow("Thousands Room ➡️", isBlasted ? "4,000" : "????", Colors.indigo),
              _buildValueRow("Hundreds Room  ➡️", isBlasted ? "300" : "???", Colors.deepOrange),
              _buildValueRow("Tens Room      ➡️", isBlasted ? "70" : "??", Colors.teal.shade700),
              _buildValueRow("Ones Room      ➡️", isBlasted ? "5" : "?", Colors.purple),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Large Combined Result Board String
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 250,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isBlasted ? Colors.green.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isBlasted ? Colors.green : Colors.grey.shade300, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            isBlasted ? "💥 4,000 + 300 + 70 + 5" : "🔒 Expanded Blueprint Locked",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isBlasted ? Colors.green.shade800 : Colors.black38),
          ),
        ),
        const SizedBox(height: 16),
        // Trigger Handle Button
        SizedBox(
          height: 38,
          width: 180,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isBlasted ? Colors.grey : Colors.purpleAccent.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => setState(() => isBlasted = !isBlasted),
            icon: Icon(isBlasted ? Icons.lock : Icons.bolt),
            label: Text(isBlasted ? "REPACK ROCKET" : "FIRE EXPAND STAGE! ⚡", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
          ),
        )
      ],
    );
  }

  Widget _buildValueRow(String title, String currentOutput, Color blockTint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: blockTint.withOpacity(0.06), borderRadius: BorderRadius.circular(6)),
            child: Text(
              currentOutput,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: blockTint, letterSpacing: 0.5),
            ),
          )
        ],
      ),
    );
  }
}