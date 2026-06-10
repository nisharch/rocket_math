import 'package:flutter/material.dart';


class FractionLearnScreen extends StatefulWidget {
  const FractionLearnScreen({super.key});

  @override
  State<FractionLearnScreen> createState() => _FractionLearnScreenState();
}

class _FractionLearnScreenState extends State<FractionLearnScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.amber.shade50, // Premium warm toybox theme background
      appBar: AppBar(
        title: const Text("🍕 Fraction Orbit Station", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          tabs: const [
            Tab(text: "🍰 Slice Blocks"),
            Tab(text: "🗺️ Position Map"),
            Tab(text: "🏷️ Fraction Type"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "What is a Fraction? 🍰",
            summary: "A fraction tells us how many EQUAL parts of a whole shape we have collected together!",
            tip: "💡 Robo-Tip: Try tapping the adjustment controls below to add cake pieces onto your tray visualizer!",
            borderColor: Colors.orange.shade700,
            child: const InteractiveCakeSlicer(),
          ),
          _buildToyboxMission(
            title: "Meet the Fraction Numbers! 👥",
            summary: "A fraction consists of two parts divided by a single central dividing fraction line bar.",
            tip: "💡 Robo-Tip: Tap a variable component area block below to view its functional place meaning!",
            borderColor: Colors.blueAccent,
            child: const InteractiveTermsMap(),
          ),
          _buildToyboxMission(
            title: "Types of Fraction Families! 🏷️",
            summary: "In Class 4, fractions belong to special groups based on whether their top or bottom is heavier.",
            tip: "💡 Robo-Tip: Tap any category tag below to pull up its respective description block live!",
            borderColor: Colors.purple,
            child: const InteractiveFractionFamilies(),
          ),
        ],
      ),
    );
  }

  Widget _buildToyboxMission({
    required String title,
    required String summary,
    required String tip,
    required Color borderColor,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              summary,
              style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: Center(child: child),
              ),
            ),
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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: borderColor, height: 1.3),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TAB 1: INTERACTIVE CAKE SLICER TOY ---
class InteractiveCakeSlicer extends StatefulWidget {
  const InteractiveCakeSlicer({super.key});

  @override
  State<InteractiveCakeSlicer> createState() => _InteractiveCakeSlicerState();
}

class _InteractiveCakeSlicerState extends State<InteractiveCakeSlicer> {
  int collectedSlices = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            bool isCollected = index < collectedSlices;
            return Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isCollected ? Colors.orange.shade300 : Colors.orange.shade50.withOpacity(0.2),
                border: Border.all(color: Colors.orange.shade600, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(isCollected ? "🍰" : "", style: const TextStyle(fontSize: 18)),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
          child: Text(
            "Selected: $collectedSlices out of 4 Total Parts = $collectedSlices/4",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.orange.shade900),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.orange, size: 36),
              onPressed: collectedSlices > 1 ? () => setState(() => collectedSlices--) : null,
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.orange, size: 36),
              onPressed: collectedSlices < 4 ? () => setState(() => collectedSlices++) : null,
            ),
          ],
        ),
      ],
    );
  }
}

// --- TAB 2: ENLARGED INTERACTIVE POSITION MAP ---
class InteractiveTermsMap extends StatefulWidget {
  const InteractiveTermsMap({super.key});

  @override
  State<InteractiveTermsMap> createState() => _InteractiveTermsMapState();
}

class _InteractiveTermsMapState extends State<InteractiveTermsMap> {
  String selectedPosition = "Numerator";

  @override
  Widget build(BuildContext context) {
    bool isNumActive = selectedPosition == "Numerator";
    bool isDenActive = selectedPosition == "Denominator";

    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isNumActive ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Text(
                    "3",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: isNumActive ? Colors.blue.shade800 : Colors.black45,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 5,
                  width: 90,
                  color: Colors.blueGrey.shade400,
                ),
                AnimatedScale(
                  scale: isDenActive ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Text(
                    "4",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: isDenActive ? Colors.blue.shade800 : Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 🛠️ Fixed: 'minTransientExtent' cleanly removed to ensure compilation stability
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 1.5),
            ),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              isNumActive ? "⭐ Numerator (Top Number):\nCounts how many pieces you have taken!" : "🧩 Denominator (Bottom Number):\nTotal equal chunks the whole item is split into!",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.blue.shade900, height: 1.3),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSelectorBtn("Numerator", isNumActive),
              const SizedBox(width: 8),
              _buildSelectorBtn("Denominator", isDenActive),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSelectorBtn(String area, bool currentActive) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: currentActive ? Colors.blue.shade700 : Colors.grey.shade100,
          foregroundColor: currentActive ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: currentActive ? 3 : 0,
        ),
        onPressed: () => setState(() => selectedPosition = area),
        child: Text(area, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
      ),
    );
  }
}

// --- TAB 3: ENLARGED FRACTION FAMILIES TOY ---
class InteractiveFractionFamilies extends StatefulWidget {
  const InteractiveFractionFamilies({super.key});

  @override
  State<InteractiveFractionFamilies> createState() => _InteractiveFractionFamiliesState();
}

class _InteractiveFractionFamiliesState extends State<InteractiveFractionFamilies> {
  String selectedType = "Proper";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.purple.withOpacity(0.3), width: 3),
            ),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  selectedType == "Proper" ? "2 / 5" : selectedType == "Improper" ? "7 / 4" : "1 ¾",
                  style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.purple, letterSpacing: 2),
                ),
                const SizedBox(height: 12),
                Text(
                  selectedType == "Proper" ? "Top Numerator is SMALLER!\nValue is less than 1 whole shape." :
                  selectedType == "Improper" ? "Top Numerator is HEAVIER!\nValue is greater than 1 whole shape." :
                  "Combines complete whole shapes together alongside minor fraction units!",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.purple.shade900, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _buildTypeTab("Proper"),
              _buildTypeTab("Improper"),
              _buildTypeTab("Mixed"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTypeTab(String name) {
    bool current = selectedType == name;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: current ? Colors.purple : Colors.grey.shade100,
        foregroundColor: current ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: current ? 3 : 1,
      ),
      onPressed: () => setState(() => selectedType = name),
      child: Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
    );
  }
}