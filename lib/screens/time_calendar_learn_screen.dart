import 'package:flutter/material.dart';
import 'dart:math';

class TimeCalendarLearnScreen extends StatefulWidget {
  const TimeCalendarLearnScreen({super.key});

  @override
  State<TimeCalendarLearnScreen> createState() => _TimeCalendarLearnScreenState();
}

class _TimeCalendarLearnScreenState extends State<TimeCalendarLearnScreen> with SingleTickerProviderStateMixin {
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
        title: const Text("⏰ Time & Calendar Lab", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "🕒 Clock Face"),
            Tab(text: "⚡ Convertor"),
            Tab(text: "📅 Leap Scanner"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToyboxMission(
            title: "Precision Clock Calibrator 🕒",
            summary: "Manually rotate the clock hands to set the exact time. The hour hand shifts automatically as minutes pass!",
            tip: "💡 Robo-Tip: AM is the morning sunlight, PM is the afternoon/night cycle. Watch the clock hands rotate 360 degrees!",
            borderColor: Colors.amber.shade800,
            child: const InteractiveClockToy(),
          ),
          _buildToyboxMission(
            title: "Time Conversion Turbine ⚡",
            summary: "Convert larger time units into smaller ones using the multiplier engine. Slide to see values update live.",
            tip: "💡 Robo-Tip: 1 Hour = 60 Minutes! To convert, simply multiply your hours by 60.",
            borderColor: Colors.blueAccent,
            child: const InteractiveConverterToy(),
          ),
          _buildToyboxMission(
            title: "Leap Year & Calendar 📅",
            summary: "Check any year to see if it's a Leap Year. Use the calendar logic scanner to verify days in months.",
            tip: "💡 Robo-Tip: A year is a Leap Year if it divides by 4 without a remainder! (February gets 29 days)",
            borderColor: Colors.teal.shade700,
            child: const InteractiveCalendarToy(),
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
          boxShadow: [BoxShadow(color: borderColor.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor), textAlign: TextAlign.center),
            const SizedBox(height: 6),
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

// --- TAB 1: PRECISION CLOCK ---
class InteractiveClockToy extends StatefulWidget {
  const InteractiveClockToy({super.key});
  @override
  State<InteractiveClockToy> createState() => _InteractiveClockToyState();
}

class _InteractiveClockToyState extends State<InteractiveClockToy> {
  double hourAngle = 0; // 0 to 11
  double minuteAngle = 0; // 0 to 59

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180, height: 180,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.amber.shade700, width: 5)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...List.generate(12, (i) {
                double angle = (i + 1) * 30 * (pi / 180) - 1.57;
                return Transform.translate(offset: Offset(65 * cos(angle), 65 * sin(angle)), child: Text("${i + 1}", style: const TextStyle(fontWeight: FontWeight.w900)));
              }),
              Transform.rotate(angle: (hourAngle * 30 + minuteAngle * 0.5) * (pi / 180), child: Container(width: 4, height: 50, color: Colors.red, margin: const EdgeInsets.only(bottom: 30))),
              Transform.rotate(angle: (minuteAngle * 6) * (pi / 180), child: Container(width: 2, height: 70, color: Colors.blue, margin: const EdgeInsets.only(bottom: 50))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [const Text("Hour", style: TextStyle(fontSize: 10)), Slider(value: hourAngle, min: 0, max: 11, divisions: 11, onChanged: (v) => setState(() => hourAngle = v))]),
            Column(children: [const Text("Min", style: TextStyle(fontSize: 10)), Slider(value: minuteAngle, min: 0, max: 59, divisions: 60, onChanged: (v) => setState(() => minuteAngle = v))]),
          ],
        )
      ],
    );
  }
}

// --- TAB 2: CONVERSION TURBINE ---
class InteractiveConverterToy extends StatefulWidget {
  const InteractiveConverterToy({super.key});
  @override
  State<InteractiveConverterToy> createState() => _InteractiveConverterToyState();
}

class _InteractiveConverterToyState extends State<InteractiveConverterToy> {
  double hours = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("${hours.toInt()} Hours = ${hours.toInt() * 60} Minutes", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
        Slider(value: hours, min: 1, max: 12, divisions: 11, onChanged: (v) => setState(() => hours = v)),
      ],
    );
  }
}

// --- TAB 3: CALENDAR LEAP SCANNER ---
class InteractiveCalendarToy extends StatefulWidget {
  const InteractiveCalendarToy({super.key});
  @override
  State<InteractiveCalendarToy> createState() => _InteractiveCalendarToyState();
}

class _InteractiveCalendarToyState extends State<InteractiveCalendarToy> {
  int year = 2026;
  @override
  Widget build(BuildContext context) {
    bool isLeap = (year % 4 == 0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Scan Year: $year", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: isLeap ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
          child: Text(isLeap ? "🎉 Leap Year! (29 Days in Feb)" : "📅 Normal Year (28 Days in Feb)", style: TextStyle(color: isLeap ? Colors.green.shade800 : Colors.red.shade800, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => setState(() => year--), child: const Text("-")),
            const SizedBox(width: 20),
            ElevatedButton(onPressed: () => setState(() => year++), child: const Text("+")),
          ],
        )
      ],
    );
  }
}