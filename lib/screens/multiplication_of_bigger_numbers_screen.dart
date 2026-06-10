import 'package:flutter/material.dart';

class MultiplicationBigNumbersScreen extends StatefulWidget {
  const MultiplicationBigNumbersScreen({super.key});

  @override
  State<MultiplicationBigNumbersScreen> createState() => _MultiplicationBigNumbersScreenState();
}

class _MultiplicationBigNumbersScreenState extends State<MultiplicationBigNumbersScreen> with SingleTickerProviderStateMixin {
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
        title: const Text("✖️ Multiplication Base", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "👥 Math Positions"),
            Tab(text: "⚡ Zero Shortcut"),
            Tab(text: "🚀 Step Engine"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Multiplication Friends! 👥",
            summary: "Tap a mathematical tag selector button below to highlight its exact row position in the layout diagram core!",
            tip: "💡 Robo-Tip: Multiplication is simply adding the exact same number over and over again very quickly!",
            borderColor: Colors.deepPurple.shade700,
            child: const InteractiveMultiplicationFriends(),
          ),
          _buildToyboxMission(
            title: "Magical Zero Shortcut Trick! ⚡",
            summary: "Multiplying by numbers ending in zeroes? Hide them, multiply the core digits, then snap them back at the end!",
            tip: "💡 Robo-Tip: For 45 × 20, just calculate 45 × 2 = 90. Then slide the hidden zero back on to claim 900!",
            borderColor: Colors.blueAccent,
            child: const InteractiveZeroShortcutEngine(),
          ),
          _buildToyboxMission(
            title: "Multi-Stage Partial Products! 🚀",
            summary: "Toggle missions below. Tap sequential track buttons to compute individual product rows systematically.",
            tip: "💡 Robo-Tip: When stepping into the Tens column row, remember to put a '0' placeholder into the Ones column seat!",
            borderColor: Colors.purple,
            child: const InteractiveMultiStepEngine(),
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

// --- TAB 1: INTERACTIVE MULTIPLICATION FRIENDS ---
class InteractiveMultiplicationFriends extends StatefulWidget {
  const InteractiveMultiplicationFriends({super.key});

  @override
  State<InteractiveMultiplicationFriends> createState() => _InteractiveMultiplicationFriendsState();
}

class _InteractiveMultiplicationFriendsState extends State<InteractiveMultiplicationFriends> {
  String selectedFriend = "None";

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
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.2), width: 2),
            ),
            child: Column(
              children: [
                Text(
                  "125",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: selectedFriend == "Multiplicand" ? Colors.blue.shade700 : Colors.black87,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("× ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    Text(
                      "5",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: selectedFriend == "Multiplier" ? Colors.orange.shade800 : Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 2.5, width: 80, color: Colors.black38),
                Text(
                  "625",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: selectedFriend == "Product" ? Colors.green.shade700 : Colors.black26,
                  ),
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
              _buildFriendButton("Multiplicand", Colors.blue.shade700),
              _buildFriendButton("Multiplier", Colors.orange.shade800),
              _buildFriendButton("Product", Colors.green.shade700),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFriendButton(String name, Color col) {
    bool isCurrent = selectedFriend == name;
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isCurrent ? col : Colors.grey.shade100,
          foregroundColor: isCurrent ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => setState(() => selectedFriend = name),
        child: Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
      ),
    );
  }
}

// --- TAB 2: INTERACTIVE ZERO SHORTCUT ENGINE ---
class InteractiveZeroShortcutEngine extends StatefulWidget {
  const InteractiveZeroShortcutEngine({super.key});

  @override
  State<InteractiveZeroShortcutEngine> createState() => _InteractiveZeroShortcutEngineState();
}

class _InteractiveZeroShortcutEngineState extends State<InteractiveZeroShortcutEngine> {
  int currentTrickStep = 1; // 1: hide, 2: core mult, 3: snap back

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
            ),
            child: Column(
              children: [
                const Text("Target Problem: 45 × 20", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.blueGrey)),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    key: ValueKey<int>(currentTrickStep),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentTrickStep == 1 ? "Hide Zero 🕳️" : currentTrickStep == 2 ? "Core Calculation 🧠" : "Snap Back! ✨",
                          style: TextStyle(fontWeight: FontWeight.w900, color: currentTrickStep == 1 ? Colors.orange.shade800 : currentTrickStep == 2 ? Colors.blue.shade700 : Colors.green.shade700, fontSize: 12),
                        ),
                        Text(
                          currentTrickStep == 1 ? "45 × 2 [ 0 ]" : currentTrickStep == 2 ? "45 × 2 = 90" : "90 + [ 0 ] ➡️ 900",
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              int target = index + 1;
              bool active = currentTrickStep == target;
              return GestureDetector(
                onTap: () => setState(() => currentTrickStep = target),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? Colors.blueAccent : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.4), width: 1.5),
                  ),
                  child: Text(
                    "Step $target",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: active ? Colors.white : Colors.blueAccent),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// --- TAB 3: INTERACTIVE MULTI-STEP ENGINE ---
class InteractiveMultiStepEngine extends StatefulWidget {
  const InteractiveMultiStepEngine({super.key});

  @override
  State<InteractiveMultiStepEngine> createState() => _InteractiveMultiStepEngineState();
}

class _InteractiveMultiStepEngineState extends State<InteractiveMultiStepEngine> {
  bool isDoubleDigitMission = false; // false: 125x5, true: 32x14
  int activeGridStep = 0;

  @override
  Widget build(BuildContext context) {
    int maximumEngineSteps = isDoubleDigitMission ? 3 : 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToggleTab("1-Digit Combo", !isDoubleDigitMission, () => setState(() { isDoubleDigitMission = false; activeGridStep = 0; })),
            const SizedBox(width: 8),
            _buildToggleTab("2-Digit Combo", isDoubleDigitMission, () => setState(() { isDoubleDigitMission = true; activeGridStep = 0; })),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isDoubleDigitMission ? "32" : "125",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("× ", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.purple, fontSize: 16)),
                  Text(
                    isDoubleDigitMission ? "14" : "5",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4),
                  ),
                ],
              ),
              Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 2, width: 85, color: Colors.black38),
              
              // Conditional row rendering based on selected mission profile
              if (!isDoubleDigitMission) ...[
                Text(activeGridStep >= 1 ? "625" : "???", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: activeGridStep >= 1 ? Colors.green.shade700 : Colors.black26, letterSpacing: 4)),
              ] else ...[
                Text(activeGridStep >= 1 ? "128" : "???", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: activeGridStep >= 1 ? Colors.blue.shade700 : Colors.black26, letterSpacing: 4)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("+ ", style: TextStyle(fontSize: 12, color: Colors.black38)),
                    Text(activeGridStep >= 2 ? "320" : "???", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: activeGridStep >= 2 ? Colors.orange.shade800 : Colors.black26, letterSpacing: 4)),
                  ],
                ),
                Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 85, color: Colors.black87),
                Text(activeGridStep >= 3 ? "448" : "???", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: activeGridStep >= 3 ? Colors.green.shade700 : Colors.black26, letterSpacing: 4)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maximumEngineSteps, (i) {
            int target = i + 1;
            bool active = activeGridStep == target;
            return GestureDetector(
              onTap: () => setState(() => activeGridStep = target),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? Colors.purple : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple.withOpacity(0.4), width: 1.5),
                ),
                child: Text(
                  isDoubleDigitMission ? (target == 1 ? "Ones Layer" : target == 2 ? "Tens Layer" : "Total Combine") : "Calculate Core",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: active ? Colors.white : Colors.purple),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildToggleTab(String text, bool active, VoidCallback action) {
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
}