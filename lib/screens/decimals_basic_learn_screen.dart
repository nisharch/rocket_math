import 'package:flutter/material.dart';

class DecimalsBasicLearnScreen extends StatefulWidget {
  const DecimalsBasicLearnScreen({super.key});

  @override
  State<DecimalsBasicLearnScreen> createState() => _DecimalsBasicLearnScreenState();
}

class _DecimalsBasicLearnScreenState extends State<DecimalsBasicLearnScreen> with SingleTickerProviderStateMixin {
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
        title: const Text("🔢 Decimal Station", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
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
            Tab(text: "🔴 Splitter"),
            Tab(text: "🟧 Grid Map"),
            Tab(text: "🚀 Decoder"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "What is a Decimal Point? 🔴",
            summary: "A decimal point (.) is a magical dot separating whole numbers from smaller fractional parts.",
            tip: "💡 Robo-Tip: Left of the dot is the 'Whole Number', right of the dot is the 'Fraction Part'!",
            borderColor: Colors.teal.shade700,
            child: const InteractiveDecimalSplitter(),
          ),
          _buildToyboxMission(
            title: "Tenths & Hundredths! 🟧",
            summary: "Understand parts by looking at how a whole block is divided into 10 or 100 tiny pieces.",
            tip: "💡 Robo-Tip: 1 Tenth (0.1) is 1/10th, while 1 Hundredth (0.01) is 1/100th of the block!",
            borderColor: Colors.blueAccent,
            child: const InteractiveTenthsGrid(),
          ),
          _buildToyboxMission(
            title: "Mission: Reading Decimals! 🚀",
            summary: "Master the art of reading decimals aloud step-by-step without getting tripped up!",
            tip: "💡 Robo-Tip: Read the whole number, say 'point', then read digits on the right one-by-one!",
            borderColor: Colors.purple,
            child: const InteractiveDecimalDecoder(),
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
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor), textAlign: TextAlign.center),
            const SizedBox(height: 4),
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

// --- TAB 1: INTERACTIVE DECIMAL SPLITTER ---
class InteractiveDecimalSplitter extends StatelessWidget {
  const InteractiveDecimalSplitter({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadge("Whole Part (25)", Colors.blue),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("🔴", style: TextStyle(fontSize: 20))),
            _buildBadge("Decimal Part (7)", Colors.orange.shade800),
          ],
        ),
        const SizedBox(height: 16),
        const Text("25 . 7", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.teal)),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color)),
    );
  }
}

// --- TAB 2: TENTHS GRID VISUALIZER ---
class InteractiveTenthsGrid extends StatefulWidget {
  const InteractiveTenthsGrid({super.key});
  @override
  State<InteractiveTenthsGrid> createState() => _InteractiveTenthsGridState();
}

class _InteractiveTenthsGridState extends State<InteractiveTenthsGrid> {
  int shaded = 4;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(10, (i) => Container(
            width: 22, height: 40,
            decoration: BoxDecoration(color: i < shaded ? Colors.blue.shade300 : Colors.blue.shade50.withOpacity(0.5), border: Border.all(color: Colors.blueAccent, width: 0.5)),
          )),
        ),
        const SizedBox(height: 12),
        Text("Shaded: $shaded/10 = 0.$shaded", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        Slider(value: shaded.toDouble(), min: 0, max: 10, divisions: 10, onChanged: (v) => setState(() => shaded = v.toInt())),
      ],
    );
  }
}

// --- TAB 3: DECODER ENGINE ---
class InteractiveDecimalDecoder extends StatefulWidget {
  const InteractiveDecimalDecoder({super.key});
  @override
  State<InteractiveDecimalDecoder> createState() => _InteractiveDecimalDecoderState();
}

class _InteractiveDecimalDecoderState extends State<InteractiveDecimalDecoder> {
  int step = 0; 

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.purple.shade200, width: 2)),
          child: Text(
            step == 0 ? "14 . 358" : step == 1 ? "14" : step == 2 ? "14 . " : step == 3 ? "14 . 3" : step == 4 ? "14 . 35" : "14 . 358",
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.purple, letterSpacing: 2),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
          child: Text(
            step == 0 ? "Tap the Scanner Buttons below to decode 14.358!" :
            step == 1 ? "14: The WHOLE NUMBER (Fourteen)." :
            step == 2 ? "Point: The divider that separates whole from fractional parts." :
            step == 3 ? "3: Sits in the TENTHS room (3/10)." : 
            step == 4 ? "5: Sits in the HUNDREDTHS room (5/100)." : "8: Sits in the THOUSANDTHS room (8/1000).",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _buildBtn("Whole", step == 1, () => setState(() => step = 1)),
            _buildBtn("Point", step == 2, () => setState(() => step = 2)),
            _buildBtn("Tenths", step == 3, () => setState(() => step = 3)),
            _buildBtn("H-ths", step == 4, () => setState(() => step = 4)),
            _buildBtn("Th-ths", step == 5, () => setState(() => step = 5)),
          ],
        )
      ],
    );
  }

  Widget _buildBtn(String t, bool a, VoidCallback o) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: a ? Colors.purple : Colors.white, 
      foregroundColor: a ? Colors.white : Colors.purple,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ), 
    onPressed: o, 
    child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900))
  );
}