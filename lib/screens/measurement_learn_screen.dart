import 'package:flutter/material.dart';

class MeasurementLearnScreen extends StatefulWidget {
  const MeasurementLearnScreen({super.key});

  @override
  State<MeasurementLearnScreen> createState() => _MeasurementLearnScreenState();
}

class _MeasurementLearnScreenState extends State<MeasurementLearnScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.amber.shade50, // Play-school warm canvas
      appBar: AppBar(
        title: const Text("📏 Measurement Toybox", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "📏 Length"),
            Tab(text: "⚖️ Weight"),
            Tab(text: "🧪 Capacity"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Scale Radar Scanner! 🔍",
            child: const InteractiveLengthRuler(),
            borderColor: Colors.orange,
          ),
          _buildToyboxMission(
            title: "How Heavy Is It? ⚖️",
            child: const InteractiveWeightScale(),
            borderColor: Colors.blueAccent,
          ),
          _buildToyboxMission(
            title: "Liquid Color Mixer! 🧪",
            child: const InteractiveCapacityFlask(),
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
}

// --- MODULE 1: INTERACTIVE LENGTH LAB ---
class InteractiveLengthRuler extends StatefulWidget {
  const InteractiveLengthRuler({super.key});

  @override
  State<InteractiveLengthRuler> createState() => _InteractiveLengthRulerState();
}

class _InteractiveLengthRulerState extends State<InteractiveLengthRuler> {
  String selectedObject = "Pencil ✏️";
  double objectSize = 6.0;
  String unit = "cm";

  void changeObject(String name, double baseSize, String currentUnit) {
    setState(() {
      selectedObject = name;
      objectSize = baseSize;
      unit = currentUnit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(selectedObject.split(" ").last, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Text(
                  "${objectSize.toInt()} $unit",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.orange),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.orange.shade200, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(11, (index) {
                bool isMajor = index % 5 == 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(height: isMajor ? 12 : 6, width: 2, color: Colors.brown.shade600),
                    const Spacer(),
                    Text(
                      "${(index * (objectSize / 10)).toInt()}",
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.brown.shade700),
                    ),
                    const SizedBox(height: 2),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _buildObjectBtn("Ant 🐜", 5.0, "mm"),
              _buildObjectBtn("Pencil ✏️", 15.0, "cm"),
              _buildObjectBtn("Car 🚗", 4.0, "m"),
              _buildObjectBtn("Rocket 🚀", 300.0, "m"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildObjectBtn(String name, double size, String u) {
    bool isSelected = selectedObject == name;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => changeObject(name, size, u),
      child: Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

// --- MODULE 2: INTERACTIVE WEIGHT SCALE ---
class InteractiveWeightScale extends StatefulWidget {
  const InteractiveWeightScale({super.key});

  @override
  State<InteractiveWeightScale> createState() => _InteractiveWeightScaleState();
}

class _InteractiveWeightScaleState extends State<InteractiveWeightScale> {
  String selectedItem = "Apple 🍎";
  String calculatedWeightText = "200 Grams (g)";

  void switchWeight(String entryName, String balanceMetricText) {
    setState(() {
      selectedItem = entryName;
      calculatedWeightText = balanceMetricText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    selectedItem.split(" ").last, 
                    key: ValueKey<String>(selectedItem),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 14),
                const Text("⚖️", style: TextStyle(fontSize: 32)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            calculatedWeightText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.blueAccent),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedItem.contains("Apple") ? Colors.blueAccent : Colors.grey.shade200,
                  foregroundColor: selectedItem.contains("Apple") ? Colors.white : Colors.black87,
                ),
                onPressed: () => switchWeight("Apple 🍎", "200 Grams (g)"),
                child: const Text("Apple 🍎", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedItem.contains("Bag") ? Colors.blueAccent : Colors.grey.shade200,
                  foregroundColor: selectedItem.contains("Bag") ? Colors.white : Colors.black87,
                ),
                onPressed: () => switchWeight("Bag 🎒", "3 Kilograms (kg)"),
                child: const Text("Bag 🎒", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- MODULE 3: UPGRADED ACCURATE COLOR LIQUID MIXER LAB ---
class InteractiveCapacityFlask extends StatefulWidget {
  const InteractiveCapacityFlask({super.key});

  @override
  State<InteractiveCapacityFlask> createState() => _InteractiveCapacityFlaskState();
}

class _InteractiveCapacityFlaskState extends State<InteractiveCapacityFlask> {
  int liquidVolumeMl = 500;
  Color liquidColor = Colors.blueAccent;
  String liquidName = "Water 💧";
  String containerName = "Bottle 🍼";

  // 🛠️ Handles dynamic context calculation changes for both exact volumes, liquid colors, and can styles
  void fillLiquid(String name, Color shade, int amount, String containerType) {
    setState(() {
      liquidName = name;
      liquidColor = shade;
      liquidVolumeMl = amount;
      containerName = containerType;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Maps the fluid filling ratios nicely on mobile displays
    double scaleHeightFactor = (liquidVolumeMl / 1000) * 85;
    if (liquidVolumeMl == 5) scaleHeightFactor = 12.0; // Medicine spoon minimum bump visibility

    return SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Graphic Glass Cylinder Beaker Block
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Outer glass line container
              Container(
                height: 95,
                width: 65,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple.shade300, width: 3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
              // 🎨 Dynamic color fluid height indicator matching button properties
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: scaleHeightFactor,
                width: 59,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: liquidColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            liquidVolumeMl == 1000 ? "1 Liter (1000 ml)" : "$liquidVolumeMl ml",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: liquidColor == const Color(0xFFF5F5F5) ? Colors.blueGrey : liquidColor),
          ),
          Text(
            "Container: $containerName ($liquidName)",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          // Interactive Fluid Injection Buttons (4 Distinct Color & Can Layout Types)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLiquidSelector("Syrup 🧪", const Color(0xFF9C27B0), 5, "Spoon 🥄"), // Purple fluid
                  const SizedBox(width: 8),
                  _buildLiquidSelector("Juice 🧃", const Color(0xFFFF9800), 250, "Juice Box 📦"), // Orange fluid
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLiquidSelector("Water 💧", const Color(0xFF03A9F4), 500, "Bottle 🍼"), // Sky blue fluid
                  const SizedBox(width: 8),
                  _buildLiquidSelector("Milk 🥛", const Color(0xFFE0E0E0), 1000, "Big Can 🪣"), // Milky off-white fluid
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLiquidSelector(String name, Color color, int amount, String containerType) {
    bool isSelected = liquidName == name;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? (color == const Color(0xFFE0E0E0) ? Colors.grey.shade400 : color) : Colors.grey.shade100,
        foregroundColor: isSelected ? (color == const Color(0xFFE0E0E0) ? Colors.black87 : Colors.white) : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isSelected ? 3 : 1,
      ),
      onPressed: () => fillLiquid(name, color, amount, containerType),
      child: Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}