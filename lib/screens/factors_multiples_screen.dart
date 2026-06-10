import 'package:flutter/material.dart';

class FactorsMultiplesScreen extends StatefulWidget {
  const FactorsMultiplesScreen({super.key});

  @override
  State<FactorsMultiplesScreen> createState() => _FactorsMultiplesScreenState();
}

class _FactorsMultiplesScreenState extends State<FactorsMultiplesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _numberController = TextEditingController(text: "12");
  List<int> _calculatedFactors = [1, 2, 3, 4, 6, 12];
  String _inputError = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _calculateFactorsForInput() {
    final String text = _numberController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _inputError = "Type a number first!";
        _calculatedFactors = [];
      });
      return;
    }

    final int? parsedNum = int.tryParse(text);
    if (parsedNum == null || parsedNum <= 0 || parsedNum > 1000) {
      setState(() {
        _inputError = "Enter a number between 1 and 1000!";
        _calculatedFactors = [];
      });
      return;
    }

    List<int> factors = [];
    for (int i = 1; i <= parsedNum; i++) {
      if (parsedNum % i == 0) {
        factors.add(i);
      }
    }

    setState(() {
      _inputError = "";
      _calculatedFactors = factors;
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50, // Premium warm toybox background canvas
      appBar: AppBar(
        title: const Text("🔢 Factors & Multiples Lab", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🧩 Factor Pairs"),
            Tab(text: "🚂 Multiples Train"),
            Tab(text: "🧪 Scanner Lab"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "What are Factors? 🧩",
            summary: "Factors are the magic building block numbers that multiply together to form another number perfectly!",
            tip: "💡 Robo-Tip: Tap the matching pair links below to see how different combinations multiply to reach 12.",
            borderColor: Colors.indigo.shade700,
            child: const InteractiveFactorPairs(),
          ),
          _buildToyboxMission(
            title: "What are Multiples? 🚂",
            summary: "Multiples are numbers you find inside times tables by skip-counting forward from 1, 2, 3, and onwards!",
            tip: "💡 Robo-Tip: Tap a base table switch button below to launch a customized, high-speed skip train track!",
            borderColor: Colors.blueAccent,
            child: const InteractiveMultiplesTrain(), // Contains our visual layout engine fix!
          ),
          _buildToyboxMission(
            title: "Interactive Factor Scanner! 🧪",
            summary: "Type any numeric target below to trigger a digital space sensor sweep for custom factor blocks.",
            tip: "💡 Robo-Tip: Factors are limited and always smaller or equal to the number, while multiples are infinite!",
            borderColor: Colors.teal.shade700,
            child: _buildFactorSandboxLab(),
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: borderColor == Colors.teal.shade700 ? Colors.teal.shade900 : borderColor, height: 1.3),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorSandboxLab() {
    return SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.teal),
                    decoration: InputDecoration(
                      hintText: "e.g. 12, 24",
                      labelText: "Target Number",
                      labelStyle: const TextStyle(color: Colors.teal, fontSize: 11, fontWeight: FontWeight.bold),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: _calculateFactorsForInput,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Scan", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                ),
              )
            ],
          ),
          if (_inputError.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(_inputError, style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
          const SizedBox(height: 12),
          const Text("Found Factor Blocks:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black38)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 75),
            child: _calculatedFactors.isEmpty
                ? const Center(child: Text("No blocks. Scan a number!", style: TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.bold)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _calculatedFactors.map((factor) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.teal.shade300, width: 1.5),
                          ),
                          child: Text(
                            "$factor",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.teal),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// --- TAB 1: INTERACTIVE FACTOR PAIRS ---
class InteractiveFactorPairs extends StatefulWidget {
  const InteractiveFactorPairs({super.key});

  @override
  State<InteractiveFactorPairs> createState() => _InteractiveFactorPairsState();
}

class _InteractiveFactorPairsState extends State<InteractiveFactorPairs> {
  String activePair = "None";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigo.withOpacity(0.2), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            activePair == "None" ? "Target: 12" : "✨ $activePair = 12 ✨",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.indigo.shade900),
          ),
        ),
        const SizedBox(height: 16),
        Wrap( // 🛠️ Safety upgrade: Safeguards custom pair selections against row overflows
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            _buildPairLink("1 × 12"),
            _buildPairLink("2 × 6"),
            _buildPairLink("3 × 4"),
          ],
        ),
      ],
    );
  }

  Widget _buildPairLink(String mathExpression) {
    bool current = activePair == mathExpression;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: current ? Colors.indigo.shade700 : Colors.grey.shade100,
        foregroundColor: current ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => setState(() => activePair = mathExpression),
      child: Text(mathExpression, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

// --- TAB 2: INTERACTIVE MULTIPLES TRAIN TRACKS (🛠️ FIX: OVERFLOW ELIMINATED) ---
class InteractiveMultiplesTrain extends StatefulWidget {
  const InteractiveMultiplesTrain({super.key});

  @override
  State<InteractiveMultiplesTrain> createState() => _InteractiveMultiplesTrainState();
}

class _InteractiveMultiplesTrainState extends State<InteractiveMultiplesTrain> {
  int baseMultiple = 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SingleChildScrollView preserves clean continuous horizontal train styling safely
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTrainCar("${baseMultiple * 1}", "${baseMultiple}×1"),
                _buildTrainLink(),
                _buildTrainCar("${baseMultiple * 2}", "${baseMultiple}×2"),
                _buildTrainLink(),
                _buildTrainCar("${baseMultiple * 3}", "${baseMultiple}×3"),
                _buildTrainLink(),
                _buildTrainCar("${baseMultiple * 4}", "${baseMultiple}×4"),
                _buildTrainLink(),
                _buildTrainCar("${baseMultiple * 5}", "${baseMultiple}×5"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 🛠️ Fixed: Swapped Rigid Row out for a responsive Wrap layer to prevent button tape clipping!
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _buildTableSelector(3),
              _buildTableSelector(4),
              _buildTableSelector(7),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTrainCar(String value, String formula) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade400, width: 2),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.blue.shade900)),
          Text(formula, style: TextStyle(fontSize: 10, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTrainLink() {
    return Container(width: 10, height: 4, color: Colors.blue.shade300);
  }

  Widget _buildTableSelector(int tableBase) {
    bool selected = baseMultiple == tableBase;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blueAccent : Colors.grey.shade100,
        foregroundColor: selected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => setState(() => baseMultiple = tableBase),
      child: Text("Table $tableBase", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}