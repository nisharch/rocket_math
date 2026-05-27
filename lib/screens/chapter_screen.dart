import 'package:flutter/material.dart';
import 'package:rocket_math/screens/addition_big_numbers_learn_screen.dart';
import '../core/class3_chapters.dart';
import '../core/class4_chapters.dart';
import '../models/chapter_model.dart';

import 'numbers_learn_screen.dart';
import 'addition_learn_screen.dart';
import 'subtraction_learn_screen.dart';
import 'multiplication_learn_screen.dart';
import 'division_learn_screen.dart';
import 'measurement_learn_screen.dart';
import 'time_learn_screen.dart';
import 'money_learn_screen.dart';
import 'shapes_learn_screen.dart';
import 'fractions_learn_screen.dart';
import 'large_numbers_learn_screen.dart';
import 'subtraction_big_numbers_screen.dart';
import 'multiplication_of_bigger_numbers_screen.dart';
import 'division_remainder_screen.dart';
import 'factors_multiples_screen.dart';
import 'decimals_basic_learn_screen.dart';
import 'time_calendar_learn_screen.dart';
import 'money_transaction_learn_screen.dart';
import 'perimeter_area_learn_screen.dart';

class ChapterScreen extends StatelessWidget {
  final int selectedClass;

  const ChapterScreen({super.key, required this.selectedClass});

  @override
  Widget build(BuildContext context) {
    final List<Chapter> chapters =
        selectedClass == 3 ? class3Chapters : class4Chapters;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFFFF9C4)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // হেডিং স্পেসটিকে এখানে চিকন (Thin) করা হয়েছে
            SliverAppBar(
              expandedHeight: 70.0, // হাইট কমিয়ে স্লিক ও চিকন করা হয়েছে
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF6C5CE7),
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20), // কর্নার রেডিয়াস একটু কমানো হয়েছে ম্যাচ করার জন্য
                ),
              ),
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("🚀 ", style: TextStyle(fontSize: 18)),
                  Text(
                    "Class $selectedClass Adventures! ✨",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18, // স্ক্রিনের সাথে মানানসই ফন্ট সাইজ
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            // চ্যাপ্টার লিস্ট
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chapter = chapters[index];
                    return HoverAnimatedChapterCard(
                      chapter: chapter,
                      index: index,
                      onTap: () => _navigateToChapter(context, chapter.title),
                      emoji: _getChapterEmoji(chapter.title),
                      cardColor: _getChapterColor(index),
                    );
                  },
                  childCount: chapters.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getChapterColor(int index) {
    List<Color> kidColors = [
      const Color(0xFFFF7675),
      const Color(0xFF74B9FF),
      const Color(0xFF55E6C1),
      const Color(0xFFF1C40F),
      const Color(0xFFA29BFE),
      const Color(0xFFFF9F43),
    ];
    return kidColors[index % kidColors.length];
  }

  void _navigateToChapter(BuildContext context, String title) {
    Widget? screen;

    if (title.contains("Addition(Big Numbers)")) {
      screen = const AdditionBigNumbersLearnScreen();
    } else if (title.contains("Subtraction(Big Numbers)")) {
      screen = const SubtractionBigNumbersScreen();
    } else if (title.contains('Multiplication(Big Numbers)')) {
      screen = const MultiplicationBigNumbersScreen();
    } else if (title.contains('Division with Remainders')) {
      screen = const DivisionRemainderScreen();
    } else if (title.contains('Factors and Multiples')) {
      screen = const FactorsMultiplesScreen();
    } else if (title.contains('Understanding Fractions')) {
      screen = const FractionLearnScreen();
    } else if (title.contains('Decimals(Basic)')) {
      screen = const DecimalsBasicLearnScreen();
    } else if (title.contains('Time and Calendar')) {
      screen = const TimeCalendarLearnScreen();
    } else if (title.contains('Money and Transactions')) {
      screen = const MoneyTransactionLearnScreen();
    } else if (title.contains('Perimeter and Area')) {
      screen = const PerimeterAreaLearnScreen();
    } else if (title.contains("Large Numbers")) {
      screen = const LargeNumbersLearnScreen();
    } else if (title.contains("Numbers")) {
      screen = const NumbersLearnScreen();
    } else if (title.contains("Addition")) {
      screen = const AdditionLearnScreen();
    } else if (title.contains("Subtraction")) {
      screen = const SubtractionLearnScreen();
    } else if (title.contains("Multiplication")) {
      screen = const MultiplicationLearnScreen();
    } else if (title.contains("Division")) {
      screen = const DivisionLearnScreen();
    } else if (title.contains("Measurement")) {
      screen = const MeasurementLearnScreen();
    } else if (title.contains("Time")) {
      screen = const TimeLearnScreen();
    } else if (title.contains("Money")) {
      screen = const MoneyLearnScreen();
    } else if (title.contains("Shape")) {
      screen = const ShapesLearnScreen();
    } else if (title.contains("Fraction")) {
      screen = const FractionLearnScreen();
    }

    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("🚀 $title is loading... Get Ready!"),
          backgroundColor: const Color(0xFF6C5CE7),
        ),
      );
    }
  }

  String _getChapterEmoji(String title) {
    if (title.contains("Numbers")) return "🔢";
    if (title.contains("Addition")) return "➕";
    if (title.contains("Subtraction")) return "➖";
    if (title.contains("Multiplication")) return "✖️";
    if (title.contains("Division")) return "➗";
    if (title.contains("Measurement")) return "📏";
    if (title.contains("Time")) return "⏰";
    if (title.contains("Money")) return "🪙";
    if (title.contains("Shape")) return "🔷";
    if (title.contains("Fraction")) return "🍕";
    if (title.contains("Decimal")) return "🔬";
    if (title.contains("Factor")) return "🧪";
    if (title.contains("Perimeter")) return "📐";
    return "📚";
  }
}

class HoverAnimatedChapterCard extends StatefulWidget {
  final Chapter chapter;
  final int index;
  final VoidCallback onTap;
  final String emoji;
  final Color cardColor;

  const HoverAnimatedChapterCard({
    super.key,
    required this.chapter,
    required this.index,
    required this.onTap,
    required this.emoji,
    required this.cardColor,
  });

  @override
  State<HoverAnimatedChapterCard> createState() => _HoverAnimatedChapterCardState();
}

class _HoverAnimatedChapterCardState extends State<HoverAnimatedChapterCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double transformY = _isPressed ? 2.0 : (_isHovered ? -6.0 : 0.0);
    double scale = _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0);
    double shadowBlur = _isHovered ? 16.0 : 8.0;
    double shadowOffset = _isHovered ? 10.0 : 5.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(vertical: 10),
          transform: Matrix4.identity()
            ..translate(0.0, transformY)
            ..scale(scale),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: widget.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.cardColor.withOpacity(_isHovered ? 0.5 : 0.35),
                blurRadius: shadowBlur,
                offset: Offset(0, shadowOffset),
              ),
            ],
            border: Border.all(
              color: _isHovered ? Colors.white : Colors.white70, 
              width: _isHovered ? 3 : 2,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
                child: Center(
                  child: Text(
                    widget.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.chapter.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(_isHovered ? 1.15 : 1.0),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFF6C5CE7),
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}