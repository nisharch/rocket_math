import 'package:flutter/material.dart';

class DivisionRemainderScreen extends StatefulWidget {
  const DivisionRemainderScreen({super.key});

  @override
  State<DivisionRemainderScreen> createState() => _DivisionRemainderScreenState();
}

class _DivisionRemainderScreenState extends State<DivisionRemainderScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.amber.shade50, // Premium warm toybox theme canvas
      appBar: AppBar(
        title: const Text("➗ Division Orbit Lab", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.cyan.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🍩 Leftovers"),
            Tab(text: "⚡ Step Engine"),
            Tab(text: "🔑 Verification"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "What is a Remainder? 🍩",
            summary: "Sometimes, when we share numbers into equal groups, a few items are left over! That leftover amount is our remainder.",
            tip: "💡 Robo-Tip: Try adding or removing donuts below to see how leftovers appear when sharing with 2 friends!",
            borderColor: Colors.cyan.shade700,
            child: const InteractiveDonutSharer(),
          ),
          _buildToyboxMission(
            title: "Long Division Machine! ⚡",
            summary: "Let's divide 25 ÷ 2. Tap the interactive step tokens to build out the calculation rows completely live!",
            tip: "💡 Robo-Tip: A remainder must ALWAYS be smaller than your divisor number, or you can keep dividing!",
            borderColor: Colors.purple,
            child: const InteractiveLongDivisionGrid(),
          ),
          _buildToyboxMission(
            title: "The Magical Verification Check! 🔑",
            summary: "Unlock the secret math superpower formula to check if your calculation answers are 100% correct.",
            tip: "Equation Balance Sheet:\nDividend = (Divisor × Quotient) + Remainder\n25 = (2 × 12) + 1 ➡️ 24 + 1 = 25! Mission Checked!",
            borderColor: Colors.orange.shade800,
            child: const VerificationVaultToy(),
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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: borderColor == Colors.orange.shade800 ? Colors.orange.shade900 : borderColor, height: 1.3),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TAB 1: INTERACTIVE DONUT SHARER SYSTEM ---
class InteractiveDonutSharer extends StatefulWidget {
  const InteractiveDonutSharer({super.key});

  @override
  State<InteractiveDonutSharer> createState() => _InteractiveDonutSharerState();
}

class _InteractiveDonutSharerState extends State<InteractiveDonutSharer> {
  int itemsCount = 7;

  @override
  Widget build(BuildContext context) {
    int groupShare = (itemsCount / 2).floor();
    int remainderValue = itemsCount % 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFriendPile("Friend 1 👦", groupShare),
            _buildFriendPile("Friend 2 👧", groupShare),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: remainderValue > 0 ? Colors.red.shade50 : Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: remainderValue > 0 ? Colors.red.shade200 : Colors.green.shade200),
          ),
          child: Text(
            remainderValue > 0 ? "🚨 Leftover: $remainderValue Donut! (Remainder)" : "🎉 Perfect Split! Remainder = 0",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: remainderValue > 0 ? Colors.red.shade800 : Colors.green.shade800),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.cyan, size: 36),
              onPressed: itemsCount > 4 ? () => setState(() => itemsCount--) : null,
            ),
            const SizedBox(width: 16),
            Text("$itemsCount Total Donuts", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.blueGrey)),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.cyan, size: 36),
              onPressed: itemsCount < 9 ? () => setState(() => itemsCount++) : null,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildFriendPile(String name, int count) {
    return Container(
      width: 95,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.cyan.withOpacity(0.2))),
      child: Column(
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(count == 0 ? "Empty" : List.generate(count, (i) => "🍩").join(""), style: const TextStyle(fontSize: 14), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// --- TAB 2: INTERACTIVE STEP ENGINE CALCULATOR ---
class InteractiveLongDivisionGrid extends StatefulWidget {
  const InteractiveLongDivisionGrid({super.key});

  @override
  State<InteractiveLongDivisionGrid> createState() => _InteractiveLongDivisionGridState();
}

class _InteractiveLongDivisionGridState extends State<InteractiveLongDivisionGrid> {
  int activeStep = 0; // 0: baseline, 1: divide tens, 2: drop down, 3: divide ones/complete

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  const SizedBox(width: 32),
                  Text(activeStep >= 1 ? "1" : "?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: activeStep == 1 ? Colors.purple : Colors.black87)),
                  Text(activeStep >= 3 ? "2" : "?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: activeStep == 3 ? Colors.purple : Colors.black38)),
                ],
              ),
              Container(margin: const EdgeInsets.only(left: 32, top: 2, bottom: 4), height: 2.5, width: 50, color: Colors.black38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("2 ) ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.blue)),
                  Text("25", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.red.shade700)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(activeStep >= 1 ? "−2" : "−?", style: TextStyle(fontSize: 18, color: activeStep >= 1 ? Colors.black45 : Colors.grey.shade300, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 14),
                ],
              ),
              Container(margin: const EdgeInsets.only(left: 32, top: 2, bottom: 2), height: 1.5, width: 50, color: Colors.black26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 32),
                  Text(activeStep >= 2 ? "0" : "?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: activeStep >= 2 ? Colors.black38 : Colors.grey.shade300)),
                  Text(activeStep >= 2 ? "5" : "?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: activeStep >= 2 ? Colors.black87 : Colors.grey.shade300)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 32),
                  Text(activeStep >= 3 ? "−4" : "−?", style: TextStyle(fontSize: 18, color: activeStep >= 3 ? Colors.black45 : Colors.grey.shade300, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(margin: const EdgeInsets.only(left: 32, top: 2, bottom: 2), height: 2, width: 50, color: Colors.black87),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 32),
                  Text(activeStep >= 3 ? "1" : "?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: activeStep >= 3 ? Colors.red : Colors.grey.shade300)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEngineControl("Step 1", activeStep == 1, () => setState(() => activeStep = 1)),
            const SizedBox(width: 4),
            _buildEngineControl("Step 2", activeStep == 2, activeStep >= 1 ? () => setState(() => activeStep = 2) : null),
            const SizedBox(width: 4),
            _buildEngineControl("Step 3", activeStep == 3, activeStep >= 2 ? () => setState(() => activeStep = 3) : null),
          ],
        ),
      ],
    );
  }

  Widget _buildEngineControl(String label, bool active, VoidCallback? operation) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: active ? Colors.purple : Colors.grey.shade100,
          foregroundColor: active ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: operation,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
      ),
    );
  }
}

// --- TAB 3: VERIFICATION SYSTEM CODES ---
class VerificationVaultToy extends StatefulWidget {
  const VerificationVaultToy({super.key});

  @override
  State<VerificationVaultToy> createState() => _VerificationVaultToyState();
}

class _VerificationVaultToyState extends State<VerificationVaultToy> {
  String activelySelectedToken = "None";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.orange.shade300, width: 2),
            ),
            child: Column(
              children: [
                const Text("🔍 Formula Verification Deck", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.orangeAccent)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFormulaToken("25", activelySelectedToken == "Dividend", Colors.red.shade700),
                    const Text(" = (", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
                    _buildFormulaToken("2", activelySelectedToken == "Divisor", Colors.blue),
                    const Text(" × ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black38)),
                    _buildFormulaToken("12", activelySelectedToken == "Quotient", Colors.purple),
                    const Text(") + ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
                    _buildFormulaToken("1", activelySelectedToken == "Remainder", Colors.deepOrange),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: [
              _buildSelectorBtn("Dividend", Colors.red.shade700),
              _buildSelectorBtn("Divisor", Colors.blue),
              _buildSelectorBtn("Quotient", Colors.purple),
              _buildSelectorBtn("Remainder", Colors.deepOrange),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFormulaToken(String num, bool picked, Color tone) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: picked ? tone : tone.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: tone, width: picked ? 2 : 1),
      ),
      child: Text(num, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: picked ? Colors.white : tone)),
    );
  }

  Widget _buildSelectorBtn(String identifier, Color designColor) {
    bool selected = activelySelectedToken == identifier;
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? designColor : Colors.grey.shade100,
          foregroundColor: selected ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => setState(() => activelySelectedToken = identifier),
        child: Text(identifier, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
      ),
    );
  }
}