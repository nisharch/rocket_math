import 'package:flutter/material.dart';
import 'dart:math' as math;

class TimeLearnScreen extends StatefulWidget {
  const TimeLearnScreen({super.key});

  @override
  State<TimeLearnScreen> createState() => _TimeLearnScreenState();
}

class _TimeLearnScreenState extends State<TimeLearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isAmSelected = true;

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
      backgroundColor: Colors.amber.shade50, // Warm play-school theme canvas
      appBar: AppBar(
        title: const Text("⏰ Time Adventure", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "⏰ Hands"),
            Tab(text: "⏳ Units"),
            Tab(text: "☀️ AM/PM"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Meet the Clock Hands! ⏰",
            summary: "A clock shows 12 hours. The short hand tracks Hours, and the long hand tracks Minutes!",
            tip: "💡 Robo-Tip: When the long minute hand points exactly to 12, we always say O'Clock!",
            borderColor: Colors.amber.shade700,
            child: const InteractiveClockHands(),
          ),
          _buildToyboxMission(
            title: "Magical Time Units! ⏳",
            summary: "Time moves in structured loops! Tap the buttons to discover how secret cycles match our day.",
            tip: "💡 Robo-Tip: 1 full day lasts 24 hours because that is how long Earth takes to spin once!",
            borderColor: Colors.green,
            child: const InteractiveTimeUnits(), // 🛠️ Fixed: Works perfectly now!
          ),
          _buildToyboxMission(
            title: "AM and PM Timings! ☀️🌙",
            summary: "Because a day has 24 hours and a clock only has 12 numbers, the hands go around TWICE!",
            tip: "💡 Robo-Tip: 12:00 PM is lunchtime (Noon), while 12:00 AM is deep sleeping time (Midnight)!",
            borderColor: Colors.blueAccent,
            child: _buildAnimatedAmPmSky(),
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
        padding: const EdgeInsets.all(20),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: borderColor),
            ),
            const SizedBox(height: 6),
            Text(
              summary,
              style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: borderColor == Colors.green ? Colors.green.shade800 : borderColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedAmPmSky() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isAmSelected ? Colors.orangeAccent : Colors.grey.shade200,
                elevation: isAmSelected ? 3 : 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => setState(() => isAmSelected = true),
              child: Text(
                "☀️ AM",
                style: TextStyle(fontWeight: FontWeight.w900, color: isAmSelected ? Colors.white : Colors.black54),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: !isAmSelected ? Colors.indigo.shade900 : Colors.grey.shade200,
                elevation: !isAmSelected ? 3 : 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => setState(() => !isAmSelected ? null : isAmSelected = false),
              child: Text(
                "🌙 PM",
                style: TextStyle(fontWeight: FontWeight.w900, color: !isAmSelected ? Colors.white : Colors.black54),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          width: 260,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isAmSelected
                  ? [Colors.amber.shade300, Colors.orange.shade100]
                  : [const Color(0xFF0F2027), const Color(0xFF203A43)],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isAmSelected ? "12:00 Midnight\nto 11:59 Morning" : "12:00 Noon\nto 11:59 Night",
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, height: 1.3),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: Text(
                      isAmSelected ? "☀️" : "🌙✨",
                      key: ValueKey<bool>(isAmSelected),
                      style: const TextStyle(fontSize: 42),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAmSelected ? "Morning! 🚀" : "Night! 😴",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: isAmSelected ? Colors.brown.shade800 : Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAmSelected ? "Time for breakfast and school!" : "Time for dinner and sweet dreams!",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isAmSelected ? Colors.brown.shade600 : Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- MODULE 1: INTERACTIVE CLOCK HANDS ---
class InteractiveClockHands extends StatefulWidget {
  const InteractiveClockHands({super.key});

  @override
  State<InteractiveClockHands> createState() => _InteractiveClockHandsState();
}

class _InteractiveClockHandsState extends State<InteractiveClockHands> {
  int currentHour = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(12)),
          child: Text(
            "⏰ It is $currentHour O'Clock!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.amber.shade900),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber.shade600, width: 5.5),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...List.generate(12, (index) {
                int number = index == 0 ? 12 : index;
                double angle = (index * 30) * (math.pi / 180);
                double radius = 62.0;
                return Transform.translate(
                  offset: Offset(radius * math.sin(angle), -radius * math.cos(angle)),
                  child: Text(
                    "$number",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.brown),
                  ),
                );
              }),
              Positioned(
                top: 20,
                child: Container(height: 65, width: 4, color: Colors.blueAccent),
              ),
              AnimatedRotation(
                turns: (currentHour / 12),
                duration: const Duration(milliseconds: 300),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(height: 80, width: 80, color: Colors.transparent),
                    Positioned(
                      top: 14,
                      child: Container(height: 28, width: 5.5, color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
              Container(height: 11, width: 11, decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.amber, size: 40),
              onPressed: currentHour > 1 ? () => setState(() => currentHour--) : null,
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.amber, size: 40),
              onPressed: currentHour < 12 ? () => setState(() => currentHour++) : null,
            ),
          ],
        )
      ],
    );
  }
}

// --- MODULE 2: INTERACTIVE TIME UNITS TRACKER (🛠️ FIX: Clean State variables isolation) ---
class InteractiveTimeUnits extends StatefulWidget {
  const InteractiveTimeUnits({super.key});

  @override
  State<InteractiveTimeUnits> createState() => _InteractiveTimeUnitsState();
}

class _InteractiveTimeUnitsState extends State<InteractiveTimeUnits> {
  String selectedUnit = "1 Hour";
  String targetFormula = "60 Minutes";
  String practicalContextInfo = "About the duration of 1 full school class period! 🏫";

  void updateUnitData(String unit, String formula, String explanationText) {
    setState(() {
      selectedUnit = unit;
      targetFormula = formula;
      practicalContextInfo = explanationText;
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
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.green.shade300, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  "$selectedUnit = $targetFormula",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green.shade800),
                ),
                const SizedBox(height: 10),
                Text(
                  practicalContextInfo,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54, height: 1.3),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildUnitButton("1 Hour", "60 Minutes", "About the duration of 1 full school class period! 🏫"),
              _buildUnitButton("1 Minute", "60 Seconds", "The length of a short cartoon intro song video clip! 🎬"),
              _buildUnitButton("1 Second", "1 Tick-Tock", "As quick as a single snap of your fingers or a heartbeat! ❤️"),
              _buildUnitButton("1 Day", "24 Hours", "The total time it takes for the earth to rotate once! 🌍"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitButton(String unitTitle, String transformValue, String extraContext) {
    bool isCurrent = selectedUnit == unitTitle;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isCurrent ? Colors.green : Colors.grey.shade100,
        foregroundColor: isCurrent ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => updateUnitData(unitTitle, transformValue, extraContext),
      child: Text(unitTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}