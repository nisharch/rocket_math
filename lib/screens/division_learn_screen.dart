import 'package:flutter/material.dart';

class DivisionLearnScreen extends StatefulWidget {
  const DivisionLearnScreen({super.key});

  @override
  State<DivisionLearnScreen> createState() => _DivisionLearnScreenState();
}

class _DivisionLearnScreenState extends State<DivisionLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
      backgroundColor: Colors.amber.shade50, // Playful bright toybox canvas
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
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🍪 Step 1"),
            Tab(text: "🤝 Step 2"),
            Tab(text: "👣 Step 3"),
            Tab(text: "⚡ Step 4"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Sharing Equally! 🍪",
            child: const InteractiveCookieSharer(),
            borderColor: Colors.blueAccent,
          ),
          _buildToyboxMission(
            title: "Meet the Division Friends! 🤝",
            child: const InteractiveDivisionFriends(),
            borderColor: Colors.cyan.shade700,
          ),
          _buildToyboxMission(
            title: "Simple Division Engine! 👣",
            child: const InteractiveSimpleDivGrid(),
            borderColor: Colors.orange,
          ),
          _buildToyboxMission(
            title: "Long Division Machine! ⚡",
            child: const InteractiveLongDivisionMachine(),
            borderColor: Colors.purple,
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

// --- MODULE 1: INTERACTIVE COOKIE SHARER ---
class InteractiveCookieSharer extends StatefulWidget {
  const InteractiveCookieSharer({super.key});

  @override
  State<InteractiveCookieSharer> createState() => _InteractiveCookieSharerState();
}

class _InteractiveCookieSharerState extends State<InteractiveCookieSharer> {
  int totalCookies = 6;

  @override
  Widget build(BuildContext context) {
    int cookiesPerGroup = (totalCookies / 2).floor();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: List.generate(totalCookies, (index) => const Text("🍪", style: TextStyle(fontSize: 26))),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
          child: Text(
            "$totalCookies Cookies ÷ 2 Groups = $cookiesPerGroup Each!",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.blueAccent),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.blueAccent, size: 36),
              onPressed: totalCookies > 2 ? () => setState(() => totalCookies -= 2) : null,
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blueAccent, size: 36),
              onPressed: totalCookies < 8 ? () => setState(() => totalCookies += 2) : null,
            ),
          ],
        )
      ],
    );
  }
}

// --- MODULE 2: INTERACTIVE DIVISION FRIENDS MAP ---
class InteractiveDivisionFriends extends StatefulWidget {
  const InteractiveDivisionFriends({super.key});

  @override
  State<InteractiveDivisionFriends> createState() => _InteractiveDivisionFriendsState();
}

class _InteractiveDivisionFriendsState extends State<InteractiveDivisionFriends> {
  String highlightedFriend = "Tap a button below!";
  Color highlightColor = Colors.grey;

  void updateLabel(String name, Color color) {
    setState(() {
      highlightedFriend = name;
      highlightColor = color;
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
            decoration: BoxDecoration(
              color: Colors.cyan.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.shade200, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 30),
                    Text("12", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: highlightedFriend.contains("Quotient") ? Colors.cyan.shade800 : Colors.black87)),
                  ],
                ),
                Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 3, width: 60, color: Colors.black45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("2 ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: highlightedFriend.contains("Divisor") ? Colors.blue : Colors.black87)),
                    const Text(") ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45)),
                    Text("25", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: highlightedFriend.contains("Dividend") ? Colors.redAccent : Colors.black87)),
                  ],
                ),
                const SizedBox(height: 8),
                Text("1", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: highlightedFriend.contains("Remainder") ? Colors.purple : Colors.black38)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(color: highlightColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Text(highlightedFriend, style: TextStyle(fontWeight: FontWeight.w900, color: highlightColor, fontSize: 13), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _buildBuddyButton("Dividend", "🔴 Total amount inside", Colors.redAccent),
              _buildBuddyButton("Divisor", "🔵 Number of groups", Colors.blue),
              _buildBuddyButton("Quotient", "🟢 Answer on top", Colors.cyan.shade800),
              _buildBuddyButton("Remainder", "🟣 Leftovers at bottom", Colors.purple),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBuddyButton(String label, String details, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => updateLabel("$label: $details", color),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

// --- MODULE 3: COMPACT SIMPLE DIVISION GRID ---
class InteractiveSimpleDivGrid extends StatefulWidget {
  const InteractiveSimpleDivGrid({super.key});

  @override
  State<InteractiveSimpleDivGrid> createState() => _InteractiveSimpleDivGridState();
}

class _InteractiveSimpleDivGridState extends State<InteractiveSimpleDivGrid> {
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(showAnswer ? "3" : "?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: showAnswer ? Colors.orange : Colors.grey.shade300)),
          ],
        ),
        Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 3, width: 60, color: Colors.black26),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("2 ) ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.blue)),
            Text("6", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(showAnswer ? "−6" : "−?", style: TextStyle(fontSize: 22, color: showAnswer ? Colors.black45 : Colors.grey.shade200)),
          ],
        ),
        Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 60, color: Colors.black26),
        Text(showAnswer ? "0" : "?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: showAnswer ? Colors.green : Colors.grey.shade300)),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => setState(() => showAnswer = !showAnswer),
          child: Text(showAnswer ? "Hide Steps" : "Calculate 6 ÷ 2! 👣", style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }
}

// --- MODULE 4: RESPONSIVE LONG DIVISION ENGINE (🛠️ FIX: Converted to StatelessWidget) ---
class InteractiveLongDivisionMachine extends StatelessWidget {
  const InteractiveLongDivisionMachine({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InteractiveLongDivisionGrid(),
        ],
      ),
    );
  }
}

class InteractiveLongDivisionGrid extends StatefulWidget {
  const InteractiveLongDivisionGrid({super.key});

  @override
  State<InteractiveLongDivisionGrid> createState() => _InteractiveLongDivisionGridState();
}

class _InteractiveLongDivisionGridState extends State<InteractiveLongDivisionGrid> {
  int step = 0; // 0: clear, 1: step one, 2: complete

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.shade200, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 30),
                  Text(step >= 1 ? "1" : "?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: step == 1 ? Colors.purple : Colors.black87)),
                  Text(step == 2 ? "2" : "?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: step == 2 ? Colors.purple : Colors.black38)),
                ],
              ),
              Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 3, width: 60, color: Colors.black38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("2 ) ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.blue)),
                  Text("25", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.redAccent)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(step >= 1 ? "−2 " : "−? ", style: TextStyle(fontSize: 20, color: step >= 1 ? Colors.black45 : Colors.grey.shade300)),
                  const SizedBox(width: 15),
                ],
              ),
              Container(margin: const EdgeInsets.symmetric(vertical: 2), height: 2, width: 60, color: Colors.black26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 25),
                  Text(step >= 1 ? "0" : "?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: step >= 1 ? Colors.black54 : Colors.grey.shade300)),
                  Text(step >= 1 ? "5" : "?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: step >= 1 ? Colors.black87 : Colors.grey.shade300)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 25),
                  Text(step == 2 ? "−4" : "−?", style: TextStyle(fontSize: 20, color: step == 2 ? Colors.black45 : Colors.grey.shade300)),
                ],
              ),
              Container(margin: const EdgeInsets.symmetric(vertical: 2), height: 2, width: 60, color: Colors.black26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 25),
                  Text(step == 2 ? "1" : "?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: step == 2 ? Colors.purple : Colors.grey.shade300)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: step == 1 ? Colors.purple : Colors.grey.shade200,
                foregroundColor: step == 1 ? Colors.white : Colors.black87,
              ),
              onPressed: () => setState(() => step = 1),
              child: const Text("Step 1", style: TextStyle(fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: step == 2 ? Colors.purple : Colors.grey.shade200,
                foregroundColor: step == 2 ? Colors.white : Colors.black87,
              ),
              onPressed: step >= 1 ? () => setState(() => step = 2) : null,
              child: const Text("Step 2", style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ],
    );
  }
}