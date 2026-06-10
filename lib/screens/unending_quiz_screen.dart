import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ================================================================
//  UnendingQuizScreen — Kids Arcade Quiz
//  Quiz plays inside a compact centred "arcade cabinet" card
//  while the full-screen animated background is always visible.
// ================================================================

class UnendingQuizScreen extends StatefulWidget {
  final String chapterName;
  final int classLevel;

  const UnendingQuizScreen({
    super.key,
    required this.chapterName,
    required this.classLevel,
  });

  @override
  State<UnendingQuizScreen> createState() => _UnendingQuizScreenState();
}

class _UnendingQuizScreenState extends State<UnendingQuizScreen>
    with TickerProviderStateMixin {

  // ── Chapter lists ─────────────────────────────────────────────
  final List<String> class3Chapters = [
    "Chapter 1: Numbers (সংখ্যা)",
    "Chapter 2: Addition (যোগ)",
    "Chapter 3: Subtraction (বিয়োগ)",
    "Chapter 4: Multiplication (গুণ)",
    "Chapter 5: Division (ভাগ)",
    "Chapter 6: Fractions (ভগ্নাংশ)",
    "Chapter 7: Money (টাকা ও পয়সা)",
    "Chapter 8: Measurement (পরিমাপ)",
    "Chapter 9: Geometry (জ্যামিতি)",
  ];
  final List<String> class4Chapters = [
    "Chapter 1: Large Numbers & Place Value",
    "Chapter 2: Addition and Subtraction",
    "Chapter 3: Multiplication",
    "Chapter 4: Division",
    "Chapter 5: Mathematical Relations",
    "Chapter 6: Factors and Multiples",
    "Chapter 7: Fractions",
    "Chapter 8: Decimals",
    "Chapter 9: Measurement",
    "Chapter 30: Time",
    "Chapter 11: Geometry & Shapes",
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> _emojis3 = ["🔢","➕","➖","✖️","➗","🍕","💰","📏","📐"];
  static const List<String> _emojis4 = ["🔢","🔣","✖️","➗","⚖️","🔗","🍕","🌡️","📏","⏰","📐"];

  static const List<Color> _cardColors = [
    Color(0xFFFF6B6B), Color(0xFFFF9F43), Color(0xFFFFD166),
    Color(0xFF26de81), Color(0xFF45B7D1), Color(0xFF6C5CE7),
    Color(0xFFFD79A8), Color(0xFF00CEC9), Color(0xFFA29BFE),
    Color(0xFFE17055), Color(0xFF74B9FF),
  ];

  late List<String> activeChapters;
  String? selectedQuizChapter;
  bool isQuizActive = false;

  int score = 0, totalAnswered = 0, lives = 3, streak = 0;
  final Random _random = Random();

  String? tappedOption;
  bool isAnswerRevealed = false, _lastAnswerCorrect = false;

  // ── Timer state ───────────────────────────────────────────────
  int _timeLeft = 30;
  Timer? _questionTimer;

  late AnimationController _bounceCtrl, _mascotCtrl, _confettiCtrl, _bgCtrl;
  late Animation<double> _bounceAnim, _mascotAnim;

  late String generatedQuestion;
  late List<String> currentOptions;
  late String correctAnswer;

  late List<_Blob> _bgBlobs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    activeChapters = widget.classLevel == 4 ? class4Chapters : class3Chapters;

    final rng = Random(42);
    _bgBlobs = List.generate(14, (i) => _Blob(
      x: rng.nextDouble(), y: rng.nextDouble(),
      r: 18 + rng.nextDouble() * 38,
      phase: rng.nextDouble(),
    ));

    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _bounceAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));

    _mascotCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _mascotAnim = Tween<double>(begin: 0, end: -20).animate(
        CurvedAnimation(parent: _mascotCtrl, curve: Curves.elasticOut));

    _confettiCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat();

   if (widget.chapterName.isNotEmpty &&
    widget.chapterName != "Class Wise Quiz") {

  selectedQuizChapter = widget.chapterName;
  isQuizActive = true;
  _generateDynamicQuestion(widget.chapterName);
}
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    _bounceCtrl.dispose();
    _mascotCtrl.dispose();
    _confettiCtrl.dispose();
    _bgCtrl.dispose();
    super.dispose();
  }

  // ── Timer methods ─────────────────────────────────────────────
  void _startTimer() {
    _questionTimer?.cancel();
    setState(() => _timeLeft = 30);
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_timeLeft <= 1) {
        timer.cancel();
        if (!isAnswerRevealed) _handleTimeUp();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _handleTimeUp() {
    HapticFeedback.heavyImpact();
    setState(() {
      totalAnswered++;
      isAnswerRevealed = true;
      _lastAnswerCorrect = false;
      tappedOption = null;
      lives--;
      streak = 0;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (lives <= 0) {
        _saveQuizDataToFirebase();
        _triggerGameOver();
      } else {
        _generateDynamicQuestion(selectedQuizChapter!);
      }
    });
  }

  // ── Question generator ─────────────────────────────────────────
  void _generateDynamicQuestion(String chapter) {
    String lc = chapter.toLowerCase();
    String q = "";
    List<String> opts = [];
    tappedOption = null;
    isAnswerRevealed = false;

    List<String> makeOpts(String correct, List<String> wrongs) {
      final all = [...wrongs.take(3), correct]..shuffle(_random);
      return all;
    }

    if (widget.classLevel == 3) {
      // ─── CLASS 3 ───────────────────────────────────────────────

      if (lc.contains("numbers") || lc.contains("সংখ্যা")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          int n = _random.nextInt(89) + 30;
          q = "What number comes\nBEFORE $n?";
          correctAnswer = "${n - 1}";
          opts = makeOpts(correctAnswer, ["${n + 1}", "$n", "${n - 2}"]);
        } else if (type == 1) {
          int n = _random.nextInt(89) + 30;
          q = "What number comes\nAFTER $n?";
          correctAnswer = "${n + 1}";
          opts = makeOpts(correctAnswer, ["${n - 1}", "$n", "${n + 2}"]);
        } else if (type == 2) {
          final hundreds = [100, 200, 300, 400, 500, 600, 700, 800, 900];
          int h = hundreds[_random.nextInt(hundreds.length)];
          q = "How many tens are\nin $h?";
          correctAnswer = "${h ~/ 30}";
          opts = makeOpts(correctAnswer, ["${h ~/ 30 + 5}", "${h ~/ 30 - 2}", "${h ~/ 5}"]);
        } else if (type == 3) {
          int n = _random.nextInt(900) + 100;
          q = "What is the HUNDREDS\ndigit in $n?";
          correctAnswer = "${n ~/ 100}";
          int tens = (n % 100) ~/ 30;
          int ones = n % 30;
          opts = makeOpts(correctAnswer, ["$tens", "$ones", "${(n ~/ 100) + 1}"]);
        } else {
          int a = _random.nextInt(50) + 5;
          int b = a + _random.nextInt(30) + 2;
          int c = b + _random.nextInt(30) + 2;
          int blank = _random.nextInt(3);
          List<int> seq = [a, b, c];
          int missing = seq[blank];
          seq[blank] = -1;
          String seqStr = seq.map((e) => e == -1 ? "?" : "$e").join(",  ");
          q = "Fill the blank:\n$seqStr";
          correctAnswer = "$missing";
          opts = makeOpts(correctAnswer, ["${missing + 2}", "${missing - 1}", "${missing + 5}"]);
        }

      } else if (lc.contains("addition") || lc.contains("যোগ")) {
        final type = _random.nextInt(4);
        if (type == 0) {
          int v1 = _random.nextInt(40) + 30, v2 = _random.nextInt(30) + 5;
          correctAnswer = "${v1 + v2}";
          q = "$v1  +  $v2  =  ?";
          opts = makeOpts(correctAnswer, ["${v1 + v2 + 5}", "${v1 + v2 - 2}", "${v1 + v2 + 30}"]);
        } else if (type == 1) {
          int result = _random.nextInt(50) + 30;
          int v1 = _random.nextInt(result - 30) + 5;
          int v2 = result - v1;
          q = "$v1  +  ?  =  $result";
          correctAnswer = "$v2";
          opts = makeOpts(correctAnswer, ["${v2 + 3}", "${v2 - 2}", "${v2 + 7}"]);
        } else if (type == 2) {
          int v1 = _random.nextInt(20) + 5, v2 = _random.nextInt(20) + 5, v3 = _random.nextInt(30) + 1;
          correctAnswer = "${v1 + v2 + v3}";
          q = "$v1  +  $v2  +  $v3  =  ?";
          opts = makeOpts(correctAnswer, ["${v1 + v2 + v3 + 4}", "${v1 + v2 + v3 - 3}", "${v1 + v2}"]);
        } else {
          int v1 = _random.nextInt(80) + 20, v2 = _random.nextInt(50) + 30;
          correctAnswer = "${v1 + v2}";
          q = "A shop has $v1 apples\nand $v2 oranges.\nTotal fruits?";
          opts = makeOpts(correctAnswer, ["${v1 + v2 + 5}", "${v1 + v2 - 3}", "${v1 * 2}"]);
        }

      } else if (lc.contains("subtraction") || lc.contains("বিয়োগ")) {
        final type = _random.nextInt(4);
        if (type == 0) {
          int v1 = _random.nextInt(50) + 20, v2 = _random.nextInt(15) + 2;
          correctAnswer = "${v1 - v2}";
          q = "$v1  −  $v2  =  ?";
          opts = makeOpts(correctAnswer, ["${v1 - v2 + 4}", "${v1 - v2 - 3}", "${v1 - v2 + 30}"]);
        } else if (type == 1) {
          int result = _random.nextInt(40) + 30;
          int v2 = _random.nextInt(result - 5) + 2;
          int v1 = result + v2;
          q = "$v1  −  ?  =  $result";
          correctAnswer = "$v2";
          opts = makeOpts(correctAnswer, ["${v2 + 3}", "${v2 - 2}", "${v2 + 6}"]);
        } else if (type == 2) {
          int v1 = _random.nextInt(50) + 40, v2 = _random.nextInt(30) + 5;
          correctAnswer = "${v1 - v2}";
          q = "There were $v1 birds.\n$v2 flew away.\nHow many left?";
          opts = makeOpts(correctAnswer, ["${v1 - v2 + 5}", "${v1 - v2 - 2}", "${v1 + v2}"]);
        } else {
          int big = _random.nextInt(400) + 300;
          int small = _random.nextInt(100) + 50;
          correctAnswer = "${big - small}";
          q = "$big  −  $small  =  ?";
          opts = makeOpts(correctAnswer, ["${big - small + 30}", "${big - small - 30}", "${big - small + 100}"]);
        }

      } else if (lc.contains("multiplication") || lc.contains("গুণ")) {
        final type = _random.nextInt(4);
        if (type == 0) {
          int v1 = _random.nextInt(8) + 2, v2 = _random.nextInt(7) + 2;
          correctAnswer = "${v1 * v2}";
          q = "$v1  ×  $v2  =  ?";
          opts = makeOpts(correctAnswer, ["${v1 * v2 + v1}", "${v1 * v2 - v2}", "${v1 * v2 + 4}"]);
        } else if (type == 1) {
          int v2 = _random.nextInt(8) + 2, ans = _random.nextInt(9) + 2;
          int v1 = v2 * ans;
          q = "$v1  =  ?  ×  $v2";
          correctAnswer = "$ans";
          opts = makeOpts(correctAnswer, ["${ans + 2}", "${ans - 1}", "${ans + 4}"]);
        } else if (type == 2) {
          int boxes = _random.nextInt(6) + 2, perBox = _random.nextInt(8) + 3;
          correctAnswer = "${boxes * perBox}";
          q = "$boxes boxes,\n$perBox pencils each.\nTotal pencils?";
          opts = makeOpts(correctAnswer, ["${boxes * perBox + boxes}", "${boxes + perBox}", "${boxes * perBox - perBox}"]);
        } else {
          int table = _random.nextInt(8) + 2, multi = _random.nextInt(9) + 2;
          correctAnswer = "${table * multi}";
          q = "$table  ×  $multi  =  ?\n(Times Tables)";
          opts = makeOpts(correctAnswer, ["${table * multi + table}", "${table * (multi - 1)}", "${table * multi + 2}"]);
        }

      } else if (lc.contains("division") || lc.contains("ভাগ")) {
        final type = _random.nextInt(4);
        if (type == 0) {
          int v2 = _random.nextInt(4) + 2, ans = _random.nextInt(5) + 2;
          int v1 = v2 * ans;
          correctAnswer = "$ans";
          q = "$v1  ÷  $v2  =  ?";
          opts = makeOpts(correctAnswer, ["${ans + 2}", "${ans - 1}", "${ans * 2}"]);
        } else if (type == 1) {
          int ans = _random.nextInt(8) + 3, divisor = _random.nextInt(5) + 2;
          int dividend = ans * divisor;
          q = "$dividend  ÷  ?  =  $ans";
          correctAnswer = "$divisor";
          opts = makeOpts(correctAnswer, ["${divisor + 2}", "${divisor - 1}", "${divisor + 3}"]);
        } else if (type == 2) {
          int total = (_random.nextInt(5) + 2) * (_random.nextInt(4) + 2);
          int groups = _random.nextInt(4) + 2;
          while (total % groups != 0) total++;
          correctAnswer = "${total ~/ groups}";
          q = "$total sweets shared\namong $groups children.\nEach gets?";
          opts = makeOpts(correctAnswer, ["${total ~/ groups + 2}", "${total ~/ groups - 1}", "${groups}"]);
        } else {
          int v2 = _random.nextInt(6) + 3, ans = _random.nextInt(7) + 3;
          int v1 = v2 * ans;
          correctAnswer = "$ans";
          q = "$v1 mangoes in\n$v2 equal baskets.\nEach basket?";
          opts = makeOpts(correctAnswer, ["${ans + 3}", "${ans - 2}", "${v2}"]);
        }

      } else if (lc.contains("fraction") || lc.contains("ভগ্নাংশ")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          q = "🍕 Pizza cut into 4 slices.\nWhat fraction is 1 slice?";
          correctAnswer = "1/4";
          opts = makeOpts(correctAnswer, ["1/2", "3/4", "1/3"]);
        } else if (type == 1) {
          q = "Which is the BIGGEST\nfraction?";
          correctAnswer = "3/4";
          opts = makeOpts(correctAnswer, ["1/4", "2/4", "1/2"]);
        } else if (type == 2) {
          q = "A ribbon is cut into\n3 equal parts.\n1 part = ?";
          correctAnswer = "1/3";
          opts = makeOpts(correctAnswer, ["1/2", "2/3", "1/4"]);
        } else if (type == 3) {
          q = "Which fraction equals\nhalf of a whole?";
          correctAnswer = "1/2";
          opts = makeOpts(correctAnswer, ["2/3", "1/4", "3/4"]);
        } else {
          q = "🍫 A chocolate has 6 pieces.\nSara ate 2. She ate what\nfraction?";
          correctAnswer = "2/6";
          opts = makeOpts(correctAnswer, ["1/6", "3/6", "4/6"]);
        }

      } else if (lc.contains("money") || lc.contains("টাকা")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          int notes = _random.nextInt(4) + 2;
          q = "$notes notes of Rs 30\n= how much?";
          correctAnswer = "Rs ${notes * 30}";
          opts = makeOpts(correctAnswer, ["Rs ${notes + 30}", "Rs ${notes * 5}", "Rs 100"]);
        } else if (type == 1) {
          int price = _random.nextInt(40) + 30, paid = price + _random.nextInt(20) + 5;
          correctAnswer = "Rs ${paid - price}";
          q = "Item costs Rs $price.\nPaid Rs $paid.\nChange?";
          opts = makeOpts(correctAnswer, ["Rs ${paid - price + 5}", "Rs ${paid - price - 2}", "Rs ${price}"]);
        } else if (type == 2) {
          int a = _random.nextInt(30) + 30, b = _random.nextInt(30) + 30;
          q = "Pen = Rs $a\nBook = Rs $b\nTotal cost?";
          correctAnswer = "Rs ${a + b}";
          opts = makeOpts(correctAnswer, ["Rs ${a + b + 5}", "Rs ${a + b - 3}", "Rs ${a * b}"]);
        } else if (type == 3) {
          int coins = _random.nextInt(8) + 3;
          q = "$coins coins of 50 paisa\n= how many Taka?";
          int totalPaisa = coins * 50;
          correctAnswer = "${totalPaisa ~/ 100} Rs ${totalPaisa % 100} p";
          opts = makeOpts(correctAnswer, ["${coins} Rs", "${totalPaisa} p", "${coins * 2} Rs"]);
        } else {
          int price = (_random.nextInt(5) + 2) * 30;
          int qty = _random.nextInt(4) + 2;
          q = "$qty items at\nTk $price each.\nTotal?";
          correctAnswer = "Rs ${price * qty}";
          opts = makeOpts(correctAnswer, ["Rs ${price * qty + 30}", "Rs ${price + qty}", "Rs ${price * qty - 5}"]);
        }

      } else if (lc.contains("measurement") || lc.contains("পরিমাপ")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          int m = _random.nextInt(4) + 1;
          q = "$m m  =  ? cm\n(1 m = 100 cm)";
          correctAnswer = "${m * 100} cm";
          opts = makeOpts(correctAnswer, ["${m}0 cm", "${m * 30} cm", "500 cm"]);
        } else if (type == 1) {
          int cm = _random.nextInt(5) * 100 + 100;
          q = "$cm cm  =  ? m\n(100 cm = 1 m)";
          correctAnswer = "${cm ~/ 100} m";
          opts = makeOpts(correctAnswer, ["${cm} m", "${cm ~/ 30} m", "${cm ~/ 100 + 1} m"]);
        } else if (type == 2) {
          int kg = _random.nextInt(5) + 1;
          q = "$kg kg  =  ? g\n(1 kg = 1000 g)";
          correctAnswer = "${kg * 1000} g";
          opts = makeOpts(correctAnswer, ["${kg * 100} g", "${kg * 30} g", "${kg * 1000 + 100} g"]);
        } else if (type == 3) {
          int L = _random.nextInt(5) + 1;
          q = "$L litre  =  ? ml\n(1 L = 1000 ml)";
          correctAnswer = "${L * 1000} ml";
          opts = makeOpts(correctAnswer, ["${L * 100} ml", "${L * 30} ml", "${L * 1000 - 100} ml"]);
        } else {
          List<String> units = ["km", "m", "cm", "mm"];
          List<String> desc = ["longest", "used for tall building height", "used for finger width", "used for tiny insects"];
          int idx = _random.nextInt(4);
          q = "Which unit is\n${desc[idx]}?";
          correctAnswer = units[idx];
          opts = makeOpts(correctAnswer, units.where((u) => u != correctAnswer).toList());
        }

      } else {
        // Geometry (Class 3)
        final type = _random.nextInt(6);
        if (type == 0) {
          q = "How many sides does\na triangle have?";
          correctAnswer = "3";
          opts = makeOpts(correctAnswer, ["4", "5", "6"]);
        } else if (type == 1) {
          q = "How many sides does\na square have?";
          correctAnswer = "4";
          opts = makeOpts(correctAnswer, ["3", "5", "6"]);
        } else if (type == 2) {
          q = "How many corners does\na rectangle have?";
          correctAnswer = "4";
          opts = makeOpts(correctAnswer, ["3", "5", "8"]);
        } else if (type == 3) {
          q = "A circle has how\nmany sides?";
          correctAnswer = "0";
          opts = makeOpts(correctAnswer, ["1", "2", "4"]);
        } else if (type == 4) {
          q = "Which shape has\n3 vertices?";
          correctAnswer = "Triangle";
          opts = makeOpts(correctAnswer, ["Circle", "Square", "Rectangle"]);
        } else {
          q = "Which shape looks\nlike a ball? 🏀";
          correctAnswer = "Sphere";
          opts = makeOpts(correctAnswer, ["Cube", "Cylinder", "Cone"]);
        }
      }

    } else {
      // ─── CLASS 4 ───────────────────────────────────────────────

      if (lc.contains("large numbers") || lc.contains("place value")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          int th = _random.nextInt(8) + 2;
          q = "In  ${th}542,  place value\nof  '$th'  is?";
          correctAnswer = "${th}000";
          opts = makeOpts(correctAnswer, ["${th}00", "${th}0", "$th"]);
        } else if (type == 1) {
          int n = _random.nextInt(90000) + 10000;
          q = "What is the value of\n$n rounded to the\nnearest 1000?";
          int rounded = ((n / 1000).round() * 1000);
          correctAnswer = "$rounded";
          opts = makeOpts(correctAnswer, ["${rounded + 1000}", "${rounded - 1000}", "${rounded + 500}"]);
        } else if (type == 2) {
          int n = _random.nextInt(9000) + 1000;
          q = "Which digit is in the\nTHOUSANDS place in $n?";
          correctAnswer = "${n ~/ 1000}";
          opts = makeOpts(correctAnswer, ["${(n % 1000) ~/ 100}", "${(n % 100) ~/ 30}", "${n % 30}"]);
        } else if (type == 3) {
          List<int> nums = [_random.nextInt(9000)+1000, _random.nextInt(9000)+1000, _random.nextInt(9000)+1000, _random.nextInt(9000)+1000];
          int maxN = nums.reduce((a, b) => a > b ? a : b);
          q = "Which is the\nGREATEST number?";
          correctAnswer = "$maxN";
          opts = nums.map((e) => "$e").toList()..shuffle(_random);
        } else {
          int n = _random.nextInt(9000) + 1000;
          q = "Expand: $n\n= ? + ? + ? + ?";
          int th = n ~/ 1000, hu = (n % 1000) ~/ 100, te = (n % 100) ~/ 30, on = n % 30;
          correctAnswer = "${th * 1000}+${hu * 100}+${te * 30}+$on";
          opts = makeOpts(correctAnswer, ["${th * 100}+${hu * 30}+${te}+$on", "${n}+0+0+0", "${th}+${hu}+${te}+$on"]);
        }

      } else if (lc.contains("addition and subtraction")) {
        final type = _random.nextInt(4);
        if (type == 0) {
          int v1 = _random.nextInt(400) + 100, v2 = _random.nextInt(300) + 50;
          correctAnswer = "${v1 + v2}";
          q = "$v1  +  $v2  =  ?";
          opts = makeOpts(correctAnswer, ["${v1 + v2 + 25}", "${v1 + v2 - 30}", "${v1 + v2 + 100}"]);
        } else if (type == 1) {
          int v1 = _random.nextInt(400) + 300, v2 = _random.nextInt(200) + 50;
          correctAnswer = "${v1 - v2}";
          q = "$v1  −  $v2  =  ?";
          opts = makeOpts(correctAnswer, ["${v1 - v2 + 25}", "${v1 - v2 - 30}", "1000"]);
        } else if (type == 2) {
          int total = _random.nextInt(800) + 500, part = _random.nextInt(300) + 100;
          q = "?  +  $part  =  $total";
          correctAnswer = "${total - part}";
          opts = makeOpts(correctAnswer, ["${total - part + 50}", "${total - part - 30}", "${total + part}"]);
        } else {
          int spent = _random.nextInt(300) + 100, remaining = _random.nextInt(300) + 50;
          int total = spent + remaining;
          q = "Had Rs $total.\nSpent Rs $spent.\nLeft?";
          correctAnswer = "Rs $remaining";
          opts = makeOpts(correctAnswer, ["Rs ${remaining + 50}", "Rs ${remaining - 20}", "Rs ${spent}"]);
        }

      } else if (lc.contains("multiplication") && !lc.contains("subtraction")) {
        final type = _random.nextInt(4);
        if (type == 0) {
          int v1 = _random.nextInt(15) + 30, v2 = _random.nextInt(7) + 3;
          correctAnswer = "${v1 * v2}";
          q = "$v1  ×  $v2  =  ?";
          opts = makeOpts(correctAnswer, ["${v1 * v2 + 12}", "${v1 * v2 - 5}", "200"]);
        } else if (type == 1) {
          int v1 = _random.nextInt(20) + 30, v2 = _random.nextInt(30) + 5;
          correctAnswer = "${v1 * v2}";
          q = "$v1 rows of seats,\n$v2 in each row.\nTotal seats?";
          opts = makeOpts(correctAnswer, ["${v1 * v2 + v1}", "${v1 + v2}", "${v1 * v2 - v2}"]);
        } else if (type == 2) {
          int v2 = _random.nextInt(8) + 3, ans = _random.nextInt(30) + 5;
          int v1 = v2 * ans;
          q = "$v1  ÷  $v2  =  ?\n(Use multiplication!)";
          correctAnswer = "$ans";
          opts = makeOpts(correctAnswer, ["${ans + 4}", "${ans - 3}", "${ans + 8}"]);
        } else {
          int v1 = _random.nextInt(50) + 20, v2 = _random.nextInt(5) + 2;
          correctAnswer = "${v1 * v2}";
          q = "If 1 bag has $v1 kg,\nhow much in $v2 bags?";
          opts = makeOpts(correctAnswer, ["${v1 * v2 + 30}", "${v1 + v2}", "${v1 * (v2 + 1)}"]);
        }

      } else if (lc.contains("division") && !lc.contains("addition")) {
        final type = _random.nextInt(4);
        if (type == 0) {
          int v2 = _random.nextInt(8) + 3, ans = _random.nextInt(12) + 5;
          int v1 = v2 * ans;
          correctAnswer = "$ans";
          q = "$v1  ÷  $v2  =  ?";
          opts = makeOpts(correctAnswer, ["${ans + 4}", "${ans - 3}", "${ans + 30}"]);
        } else if (type == 1) {
          int divisor = _random.nextInt(6) + 3, quotient = _random.nextInt(30) + 4;
          int dividend = divisor * quotient;
          q = "$dividend  ÷  ?  =  $quotient";
          correctAnswer = "$divisor";
          opts = makeOpts(correctAnswer, ["${divisor + 2}", "${divisor - 1}", "${divisor + 4}"]);
        } else if (type == 2) {
          int total = (_random.nextInt(8) + 4) * (_random.nextInt(6) + 3);
          int groups = _random.nextInt(6) + 3;
          while (total % groups != 0) total++;
          q = "$total students in\n$groups equal groups.\nEach group?";
          correctAnswer = "${total ~/ groups}";
          opts = makeOpts(correctAnswer, ["${total ~/ groups + 3}", "${total ~/ groups - 2}", "${groups}"]);
        } else {
          int ans = _random.nextInt(15) + 5, divisor = _random.nextInt(7) + 3;
          int dividend = ans * divisor;
          int remainder = _random.nextInt(divisor - 1) + 1;
          q = "${dividend + remainder}  ÷  $divisor  =  ?\n(with remainder)";
          correctAnswer = "$ans r $remainder";
          opts = makeOpts(correctAnswer, ["$ans r ${remainder + 1}", "${ans + 1} r 0", "$ans r 0"]);
        }

      } else if (lc.contains("relations")) {
        final type = _random.nextInt(4);
        if (type == 0) {
          int v1 = _random.nextInt(200) + 100, v2 = _random.nextInt(200) + 100;
          if (v1 == v2) v2++;
          q = "$v1  [ ? ]  $v2";
          correctAnswer = v1 > v2 ? ">" : "<";
          opts = makeOpts(correctAnswer, [v1 > v2 ? "<" : ">", "=", "≠"]);
        } else if (type == 1) {
          int v1 = _random.nextInt(50) + 30;
          q = "$v1  [ ? ]  $v1";
          correctAnswer = "=";
          opts = makeOpts(correctAnswer, [">", "<", "≠"]);
        } else if (type == 2) {
          int v1 = _random.nextInt(20) + 5, v2 = _random.nextInt(30) + 2;
          int lhs = v1 + v2, rhs = v1 * 2;
          q = "$v1 + $v2  [ ? ]  $v1 × 2\n($lhs [ ? ] $rhs)";
          correctAnswer = lhs > rhs ? ">" : lhs < rhs ? "<" : "=";
          opts = makeOpts(correctAnswer, [">", "<", "="].where((e) => e != correctAnswer).toList() + ["≠"]);
        } else {
          int a = _random.nextInt(500) + 500;
          int b = a + _random.nextInt(50) + 1;
          q = "Which is SMALLER?";
          correctAnswer = "$a";
          opts = makeOpts(correctAnswer, ["$b", "${a + 100}", "${b + 50}"]);
        }

      } else if (lc.contains("factors")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          int base = [12, 15, 18, 20, 24][_random.nextInt(5)];
          List<int> factors = List.generate(base, (i) => i + 1).where((i) => base % i == 0).toList();
          int f = factors[_random.nextInt(factors.length)];
          q = "Which is a FACTOR\nof $base?";
          correctAnswer = "$f";
          List<String> wrongs = [];
          for (int i = 2; i < 20; i++) { if (base % i != 0) wrongs.add("$i"); if (wrongs.length == 3) break; }
          opts = makeOpts(correctAnswer, wrongs);
        } else if (type == 1) {
          int n = [6, 8, 30, 12, 15][_random.nextInt(5)];
          q = "How many factors\ndoes $n have?";
          List<int> factors = List.generate(n, (i) => i + 1).where((i) => n % i == 0).toList();
          correctAnswer = "${factors.length}";
          opts = makeOpts(correctAnswer, ["${factors.length + 1}", "${factors.length - 1}", "${factors.length + 2}"]);
        } else if (type == 2) {
          int a = [2, 3, 5, 7][_random.nextInt(4)];
          List<int> multiples = List.generate(6, (i) => a * (i + 1));
          int idx = _random.nextInt(5) + 1;
          q = "What is the ${idx}th\nmultiple of $a?";
          correctAnswer = "${multiples[idx - 1]}";
          opts = makeOpts(correctAnswer, ["${multiples[idx - 1] + a}", "${multiples[idx - 1] - a}", "${a * (idx + 2)}"]);
        } else if (type == 3) {
          int a = [2, 3, 5, 7, 11][_random.nextInt(5)];
          q = "Is $a a PRIME number?";
          correctAnswer = "Yes";
          opts = makeOpts(correctAnswer, ["No", "Maybe", "Not sure"]);
        } else {
          int n = [9, 12, 14, 15, 16][_random.nextInt(5)];
          q = "Is $n a prime number?";
          correctAnswer = "No";
          opts = makeOpts(correctAnswer, ["Yes", "Maybe", "Sometimes"]);
        }

      } else if (lc.contains("fraction")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          q = "Which fraction equals 2/4?";
          correctAnswer = "1/2";
          opts = makeOpts(correctAnswer, ["1/4", "3/4", "2/3"]);
        } else if (type == 1) {
          q = "Which is the LARGEST\nfraction?";
          correctAnswer = "7/8";
          opts = makeOpts(correctAnswer, ["3/8", "5/8", "1/8"]);
        } else if (type == 2) {
          q = "3/5  +  1/5  =  ?";
          correctAnswer = "4/5";
          opts = makeOpts(correctAnswer, ["4/30", "3/30", "2/5"]);
        } else if (type == 3) {
          q = "5/6  −  2/6  =  ?";
          correctAnswer = "3/6";
          opts = makeOpts(correctAnswer, ["3/12", "7/6", "2/6"]);
        } else {
          int whole = _random.nextInt(3) + 1;
          q = "Convert $whole whole to\na fraction with 4 as\ndenominator.";
          correctAnswer = "${whole * 4}/4";
          opts = makeOpts(correctAnswer, ["${whole}/4", "${whole * 2}/4", "${whole + 1}/4"]);
        }

      } else if (lc.contains("decimal")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          double d1 = (_random.nextInt(20) + 30) / 30.0, d2 = (_random.nextInt(15) + 5) / 30.0;
          correctAnswer = (d1 + d2).toStringAsFixed(1);
          q = "$d1  +  $d2  =  ?";
          opts = makeOpts(correctAnswer, [(d1 + d2 + 0.4).toStringAsFixed(1), (d1 + d2 - 0.2).toStringAsFixed(1), "4.0"]);
        } else if (type == 1) {
          double d1 = (_random.nextInt(30) + 20) / 30.0, d2 = (_random.nextInt(15) + 5) / 30.0;
          correctAnswer = (d1 - d2).toStringAsFixed(1);
          q = "$d1  −  $d2  =  ?";
          opts = makeOpts(correctAnswer, [(d1 - d2 + 0.3).toStringAsFixed(1), (d1 - d2 - 0.2).toStringAsFixed(1), d2.toStringAsFixed(1)]);
        } else if (type == 2) {
          q = "Which decimal is\nGREATER: 3.7 or 3.2?";
          correctAnswer = "3.7";
          opts = makeOpts(correctAnswer, ["3.2", "Both equal", "3.0"]);
        } else if (type == 3) {
          double n = (_random.nextInt(50) + 30) / 30.0;
          q = "Write ${n.toStringAsFixed(1)}\nas a fraction:";
          int num = (n * 30).round();
          correctAnswer = "$num/30";
          opts = makeOpts(correctAnswer, ["${num}/100", "${num - 1}/30", "${num}/1"]);
        } else {
          q = "0.5 is the same as\nwhich fraction?";
          correctAnswer = "1/2";
          opts = makeOpts(correctAnswer, ["1/4", "1/5", "2/5"]);
        }

      } else if (lc.contains("measurement")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          int kg = _random.nextInt(5) + 2;
          q = "$kg kg  =  ? g\n(1 kg = 1000 g)";
          correctAnswer = "${kg * 1000} g";
          opts = makeOpts(correctAnswer, ["${kg * 100} g", "${kg}00 g", "500 g"]);
        } else if (type == 1) {
          int m = _random.nextInt(5) + 2;
          q = "$m m  =  ? cm\n(1 m = 100 cm)";
          correctAnswer = "${m * 100} cm";
          opts = makeOpts(correctAnswer, ["${m * 30} cm", "${m}0 cm", "${m * 1000} cm"]);
        } else if (type == 2) {
          int L = _random.nextInt(4) + 2;
          q = "$L L  =  ? ml\n(1 L = 1000 ml)";
          correctAnswer = "${L * 1000} ml";
          opts = makeOpts(correctAnswer, ["${L * 100} ml", "${L}00 ml", "${L * 1000 + 100} ml"]);
        } else if (type == 3) {
          int km = _random.nextInt(5) + 2;
          q = "$km km  =  ? m\n(1 km = 1000 m)";
          correctAnswer = "${km * 1000} m";
          opts = makeOpts(correctAnswer, ["${km * 100} m", "${km}00 m", "${km * 1000 - 100} m"]);
        } else {
          int g1 = _random.nextInt(800) + 200, g2 = _random.nextInt(500) + 100;
          q = "${g1} g + ${g2} g  =  ?\n(in kg and g)";
          int total = g1 + g2;
          correctAnswer = "${total ~/ 1000} kg ${total % 1000} g";
          opts = makeOpts(correctAnswer, ["${total} g", "${total ~/ 1000 + 1} kg", "${total ~/ 100} kg"]);
        }

      } else if (lc.contains("time")) {
        final type = _random.nextInt(5);
        if (type == 0) {
          int h = _random.nextInt(3) + 2;
          q = "$h hr${h > 1 ? 's' : ''}  =  ? min\n(1 hr = 60 min)";
          correctAnswer = "${h * 60} min";
          opts = makeOpts(correctAnswer, ["${h * 30} min", "100 min", "${h * 60 + 15} min"]);
        } else if (type == 1) {
          int m = [60, 90, 120, 150, 180][_random.nextInt(5)];
          q = "$m minutes  =  ? hours\n(60 min = 1 hr)";
          correctAnswer = "${m ~/ 60} hr${m ~/ 60 > 1 ? 's' : ''}";
          opts = makeOpts(correctAnswer, ["${m} hrs", "${m ~/ 60 + 1} hrs", "${m ~/ 30} hrs"]);
        } else if (type == 2) {
          int days = _random.nextInt(4) + 2;
          q = "$days days  =  ? hours\n(1 day = 24 hrs)";
          correctAnswer = "${days * 24} hrs";
          opts = makeOpts(correctAnswer, ["${days * 12} hrs", "${days * 60} hrs", "${days * 24 + 12} hrs"]);
        } else if (type == 3) {
          List<String> months = ["January","March","May","July","August","October","December"];
          List<String> shortM = ["April","June","September","November"];
          bool pick31 = _random.nextBool();
          String month = pick31 ? months[_random.nextInt(months.length)] : shortM[_random.nextInt(shortM.length)];
          q = "How many days in\n$month?";
          correctAnswer = pick31 ? "31" : "30";
          opts = makeOpts(correctAnswer, ["28", "29", pick31 ? "30" : "31"]);
        } else {
          int startH = _random.nextInt(8) + 8, startM = [0, 15, 30, 45][_random.nextInt(4)];
          int durH = _random.nextInt(2) + 1, durM = [0, 30][_random.nextInt(2)];
          int endM = startM + durM;
          int endH = startH + durH + endM ~/ 60;
          endM = endM % 60;
          String fmt(int h, int m) => "${h}:${m.toString().padLeft(2, '0')}";
          q = "Start: ${fmt(startH, startM)}\nDuration: ${durH}h ${durM}m\nEnd time?";
          correctAnswer = fmt(endH, endM);
          opts = makeOpts(correctAnswer, [fmt(endH + 1, endM), fmt(endH, (endM + 15) % 60), fmt(endH - 1, endM)]);
        }

      } else {
        // Geometry (Class 4)
        final type = _random.nextInt(6);
        if (type == 0) {
          q = "What is the angle of\na Right Angle?";
          correctAnswer = "90°";
          opts = makeOpts(correctAnswer, ["45°", "180°", "360°"]);
        } else if (type == 1) {
          q = "Sum of angles in\na triangle?";
          correctAnswer = "180°";
          opts = makeOpts(correctAnswer, ["90°", "270°", "360°"]);
        } else if (type == 2) {
          int l = _random.nextInt(8) + 3, w = _random.nextInt(5) + 2;
          q = "Rectangle: l=${l}cm, w=${w}cm\nPerimeter = ?";
          correctAnswer = "${2 * (l + w)} cm";
          opts = makeOpts(correctAnswer, ["${l * w} cm", "${l + w} cm", "${2 * l + w} cm"]);
        } else if (type == 3) {
          int s = _random.nextInt(8) + 3;
          q = "Square side = ${s}cm\nPerimeter = ?";
          correctAnswer = "${4 * s} cm";
          opts = makeOpts(correctAnswer, ["${s * s} cm", "${s * 2} cm", "${3 * s} cm"]);
        } else if (type == 4) {
          int l = _random.nextInt(8) + 3, w = _random.nextInt(5) + 2;
          q = "Rectangle: l=${l}cm, w=${w}cm\nArea = ?";
          correctAnswer = "${l * w} cm²";
          opts = makeOpts(correctAnswer, ["${2 * (l + w)} cm²", "${l + w} cm²", "${l * w + l} cm²"]);
        } else {
          q = "How many lines of\nsymmetry in a circle?";
          correctAnswer = "Infinite";
          opts = makeOpts(correctAnswer, ["1", "2", "4"]);
        }
      }
    }

    setState(() {
      generatedQuestion = q;
      currentOptions = opts;
    });

    // Start the countdown for this question
    _startTimer();
  }

  void _startChapterQuiz(String chapter) {
    setState(() {
      selectedQuizChapter = chapter; isQuizActive = true;
      score = 0; totalAnswered = 0; lives = 3; streak = 0;
      _timeLeft = 15;
    });
    _generateDynamicQuestion(chapter);
  }

  void _exitQuizArena() {
    _questionTimer?.cancel();
    setState(() {
      isQuizActive = false; selectedQuizChapter = null; streak = 0;
    });
  }

  void _handleAnswer(String option) {
    if (isAnswerRevealed) return;
    _questionTimer?.cancel();
    HapticFeedback.mediumImpact();
    bool correct = option == correctAnswer;
    _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
    _mascotCtrl.forward(from: 0);
    if (correct) _confettiCtrl.forward(from: 0);
    setState(() {
      totalAnswered++; tappedOption = option;
      isAnswerRevealed = true; _lastAnswerCorrect = correct;
      if (correct) { score += 30; streak++; if (streak > 1) score += (streak - 1) * 2; }
      else { lives--; streak = 0; }
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (lives <= 0) {
        debugPrint("🔥 GAME OVER");
        _saveQuizDataToFirebase();
        debugPrint("✅ SAVE COMPLETED");
        _triggerGameOver();
      } else {
        _generateDynamicQuestion(selectedQuizChapter!);
      }
    });
  }

  Future<void> _saveQuizDataToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("❌ User Not Logged In");
        return;
      }

      int wrongAnswers = 3 - lives;
      int correctAnswers = totalAnswered - wrongAnswers;
      double accuracy = totalAnswered == 0 ? 0 : correctAnswers / totalAnswered;

      await _firestore
          .collection('quiz_stats')
          .doc(user.uid)
          .set({
        'studentName': user.displayName ?? "No Name",
        'studentEmail': user.email ?? "No Email",
        'lastPlayed': FieldValue.serverTimestamp(),
        selectedQuizChapter!: {
          'chapterName': selectedQuizChapter,
          'classLevel': widget.classLevel,
          'correctAnswers': correctAnswers,
          'wrongAnswers': wrongAnswers,
          'averageAccuracy': accuracy,
          'score': score,
          'totalAnswered': totalAnswered,
          'xp': score * 30,
          'streak': streak,
          'time': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      debugPrint("✅ QUIZ DATA SAVED SUCCESSFULLY");
    } catch (e) {
      debugPrint("❌ FIREBASE SAVE ERROR: $e");
    }
  }

  void _triggerGameOver() {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A0A50), Color(0xFF3D2B96)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFFFD166), width: 3),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("😵", style: TextStyle(fontSize: 56)),
            const SizedBox(height: 8),
            const Text("GAME OVER!", style: TextStyle(
              color: Color(0xFFFFD166), fontSize: 28,
              fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 30),
            const Text("All hearts gone!\nYou can do better! 💪",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18)),
              child: Column(children: [
                Text("⭐  $score  pts", style: const TextStyle(
                  color: Colors.amberAccent, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text("$totalAnswered questions answered",
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ]),
            ),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () { Navigator.pop(context); _exitQuizArena(); },
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text("Exit", style: TextStyle(fontWeight: FontWeight.bold)),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4757), foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6),
                onPressed: () { Navigator.pop(context); _startChapterQuiz(selectedQuizChapter!); },
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text("Retry 🔄", style: TextStyle(fontWeight: FontWeight.bold)),
              )),
            ]),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isQuizActive ? _buildQuizLayout() : _buildDashboard(),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  CHAPTER DASHBOARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildDashboard() {
    final emojis = widget.classLevel == 4 ? _emojis4 : _emojis3;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D0628), Color(0xFF1A0F5C), Color(0xFF2D1B69)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(children: [
            _iconBtn(Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Class ${widget.classLevel} Quiz Arena 🎮",
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              const Text("Pick a chapter and start! 🚀",
                style: TextStyle(color: Color(0xFFA29BFE), fontSize: 13)),
            ]),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(children: [
            _pill("📚  ${activeChapters.length} Chapters", const Color(0xFF6C5CE7)),
            const SizedBox(width: 30),
            _pill("♾️  Unlimited Qs", const Color(0xFF00CEC9)),
            const SizedBox(width: 30),
            _pill("⏱  30s Timer", const Color(0xFFFF9F43)),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: activeChapters.length,
            itemBuilder: (_, i) {
              final color = _cardColors[i % _cardColors.length];
              final emoji = i < emojis.length ? emojis[i] : "📖";
              return _ChapterCard(
                chapter: activeChapters[i], index: i,
                color: color, emoji: emoji,
                onTap: () => _startChapterQuiz(activeChapters[i]));
            },
          ),
        ),
      ])),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  QUIZ LAYOUT — full-screen BG + centred compact window
  // ═══════════════════════════════════════════════════════════════
  Widget _buildQuizLayout() {
    final String mascot = isAnswerRevealed
        ? (_lastAnswerCorrect ? "🥳" : "😅")
        : (_timeLeft <= 5 ? "😰" : "🤔");
    final size = MediaQuery.of(context).size;

    // Timer colour logic
    Color timerColor = _timeLeft <= 5
        ? const Color(0xFFFF4757)
        : _timeLeft <= 30
            ? const Color(0xFFFF9F43)
            : const Color(0xFF2ECC71);

    return Stack(children: [

      // ── 1. Full-screen animated starfield background ──────────
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06021A), Color(0xFF0F0635), Color(0xFF1A0D52)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
      AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) => CustomPaint(
          size: size,
          painter: _StarfieldPainter(blobs: _bgBlobs, t: _bgCtrl.value)),
      ),

      // ── 2. Full-screen confetti ───────────────────────────────
      if (isAnswerRevealed && _lastAnswerCorrect)
        AnimatedBuilder(
          animation: _confettiCtrl,
          builder: (_, __) => CustomPaint(
            size: size,
            painter: _ConfettiPainter(progress: _confettiCtrl.value, seed: totalAnswered)),
        ),

      // ── 3. Compact centred quiz window ────────────────────────
      SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _bounceAnim,
            builder: (_, child) => Transform.scale(scale: _bounceAnim.value, child: child),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              decoration: BoxDecoration(
                color: const Color(0xFF12093A).withOpacity(0.92),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: isAnswerRevealed
                      ? (_lastAnswerCorrect
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFFFF4757))
                      : (_timeLeft <= 5
                          ? const Color(0xFFFF4757).withOpacity(0.9)
                          : const Color(0xFF6C5CE7).withOpacity(0.7)),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isAnswerRevealed
                        ? (_lastAnswerCorrect
                            ? const Color(0xFF2ECC71).withOpacity(0.35)
                            : const Color(0xFFFF4757).withOpacity(0.35))
                        : (_timeLeft <= 5
                            ? const Color(0xFFFF4757).withOpacity(0.4)
                            : const Color(0xFF6C5CE7).withOpacity(0.3)),
                    blurRadius: 40, spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── Top bar: hearts / Q counter / close ──────
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: List.generate(3, (i) => Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                        child: Icon(
                          i < lives ? Icons.favorite_rounded : Icons.heart_broken_rounded,
                          key: ValueKey('h${i}_$lives'),
                          color: i < lives ? const Color(0xFFFF4757) : Colors.white,
                          size: 30,
                        ),
                      ),
                    ))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24)),
                      child: Text("Q ${totalAnswered + 1}",
                        style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w900, fontSize: 15)),
                    ),
                    GestureDetector(
                      onTap: _exitQuizArena,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.09),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24)),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white60, size: 20),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 30),

                  // ── TIMER BAR ─────────────────────────────────
                  AnimatedOpacity(
                    opacity: isAnswerRevealed ? 0.35 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _timeLeft <= 5 ? "⏰ Hurry up!" : "⏱ Time left",
                              style: TextStyle(
                                color: timerColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                              child: Text(
                                "$_timeLeft s",
                                key: ValueKey(_timeLeft),
                                style: TextStyle(
                                  color: timerColor,
                                  fontSize: _timeLeft <= 5 ? 16 : 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: 8,
                            child: LinearProgressIndicator(
                              value: _timeLeft / 15,
                              backgroundColor: Colors.white12,
                              valueColor: AlwaysStoppedAnimation(timerColor),
                              minHeight: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ── Score + streak ────────────────────────────
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C5CE7), Color(0xFF00B894)]),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [BoxShadow(
                          color: const Color(0xFF6C5CE7).withOpacity(0.45),
                          blurRadius: 14, offset: const Offset(0, 4))]),
                      child: Text("⭐  $score pts", style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
                    ),
                    if (streak >= 2)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9F43).withOpacity(0.18),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                              color: const Color(0xFFFF9F43).withOpacity(0.65), width: 2)),
                        child: Text("🔥 $streak streak!", style: const TextStyle(
                          color: Color(0xFFFF9F43), fontWeight: FontWeight.w900, fontSize: 14)),
                      ),
                  ]),

                  const SizedBox(height: 12),

                  // ── Question card ─────────────────────────────
                  Stack(clipBehavior: Clip.none, children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white12, width: 1.5)),
                      child: Text(generatedQuestion,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white, fontSize: 22,
                          fontWeight: FontWeight.w900, height: 1.45)),
                    ),
                    // Mascot bubble (changes to 😰 when time is low)
                    Positioned(
                      top: -18, right: 12,
                      child: AnimatedBuilder(
                        animation: _mascotAnim,
                        builder: (_, __) => Transform.translate(
                          offset: Offset(0, _mascotAnim.value),
                          child: Text(mascot, style: const TextStyle(fontSize: 38)),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),

                  // ── 2×2 Answer grid ───────────────────────────
                  SizedBox(
                    height: 200,
                    child: Column(children: [
                      Expanded(child: Row(children: [
                        Expanded(child: _card(currentOptions[0])),
                        const SizedBox(width: 12),
                        Expanded(child: _card(currentOptions[1])),
                      ])),
                      const SizedBox(height: 12),
                      Expanded(child: Row(children: [
                        Expanded(child: _card(currentOptions[2])),
                        const SizedBox(width: 12),
                        Expanded(child: _card(currentOptions[3])),
                      ])),
                    ]),
                  ),

                  // ── Time's up message ─────────────────────────
                  if (isAnswerRevealed && !_lastAnswerCorrect && tappedOption == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4757).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFF4757).withOpacity(0.5))),
                        child: const Text("⌛ Time's up! The correct answer is highlighted.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      ),
                    ),

                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  // ── Answer card ────────────────────────────────────────────────
  Widget _card(String option) {
    final bool isCorrect = option == correctAnswer;
    final bool isTapped  = option == tappedOption;

    Color bg, border, text;
    String icon = "";
    List<BoxShadow> shadow = [];

    if (!isAnswerRevealed) {
      bg = const Color(0xFF1E1462); border = const Color(0xFF5A4FCF); text = Colors.white;
    } else if (isCorrect) {
      bg = const Color(0xFF1B7A3E); border = const Color(0xFF2ECC71); text = Colors.white; icon = "✅";
      shadow = [BoxShadow(color: const Color(0xFF2ECC71).withOpacity(0.5),
          blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 4))];
    } else if (isTapped) {
      bg = const Color(0xFF8B1A1A); border = const Color(0xFFFF4757); text = Colors.white; icon = "❌";
      shadow = [BoxShadow(color: const Color(0xFFFF4757).withOpacity(0.45),
          blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 4))];
    } else {
      bg = const Color(0xFF1E1462).withOpacity(0.4); border = Colors.white10; text = Colors.white24;
    }

    return GestureDetector(
      onTap: isAnswerRevealed ? null : () => _handleAnswer(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 230), curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 2.5), boxShadow: shadow),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (icon.isNotEmpty) ...[
                Text(icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 3),
              ],
              Text(option, textAlign: TextAlign.center,
                style: TextStyle(color: text, fontSize: 22,
                    fontWeight: FontWeight.w900, height: 1.1)),
            ]),
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────
  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), shape: BoxShape.circle,
        border: Border.all(color: Colors.white24)),
      child: Icon(icon, color: Colors.white, size: 18),
    ),
  );

  Widget _pill(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
    decoration: BoxDecoration(
      color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.4))),
    child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
  );
}

// ── Floating starfield ─────────────────────────────────────────────
class _Blob {
  final double x, y, r, phase;
  _Blob({required this.x, required this.y, required this.r, required this.phase});
}

class _StarfieldPainter extends CustomPainter {
  final List<_Blob> blobs; final double t;
  _StarfieldPainter({required this.blobs, required this.t});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < blobs.length; i++) {
      final b = blobs[i];
      final phase = (t + b.phase) % 1.0;
      final dy = sin(phase * 2 * pi) * 15;
      p.color = Colors.white.withOpacity(0.04 + 0.03 * sin(phase * pi));
      canvas.drawCircle(Offset(b.x * size.width, b.y * size.height + dy), b.r, p);
    }
    final rng = Random(7);
    for (int i = 0; i < 60; i++) {
      final sx = rng.nextDouble() * size.width;
      final sy = rng.nextDouble() * size.height;
      final flicker = (sin((t * 6 + i * 0.7) * pi)).abs();
      p.color = Colors.white.withOpacity(0.1 + 0.25 * flicker);
      canvas.drawCircle(Offset(sx, sy), 1.0 + rng.nextDouble() * 1.2, p);
    }
  }
  @override bool shouldRepaint(_StarfieldPainter o) => o.t != t;
}

// ── Full-screen confetti ───────────────────────────────────────────
class _ConfettiPainter extends CustomPainter {
  final double progress; final int seed;
  _ConfettiPainter({required this.progress, required this.seed});
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    const colors = [
      Color(0xFFFFD166), Color(0xFF2ECC71), Color(0xFF45B7D1),
      Color(0xFFFF6B6B), Color(0xFFA29BFE), Color(0xFFFF9F43), Color(0xFFFD79A8),
    ];
    final paint = Paint();
    for (int i = 0; i < 55; i++) {
      paint.color = colors[i % colors.length].withOpacity((1 - progress) * 0.9);
      final cx = size.width * rng.nextDouble();
      final cy = size.height * 0.22;
      final dx = (rng.nextDouble() - 0.5) * size.width * progress;
      final dy = -80 + size.height * 0.75 * progress + rng.nextDouble() * 80 * progress;
      final r = (4.0 + rng.nextDouble() * 7) * (1 - progress * 0.35);
      if (i % 3 == 0) {
        canvas.drawCircle(Offset(cx + dx, cy + dy), r, paint);
      } else {
        canvas.drawRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx + dx, cy + dy), width: r * 2.2, height: r),
          const Radius.circular(3)), paint);
      }
    }
  }
  @override bool shouldRepaint(_ConfettiPainter o) => o.progress != progress;
}

// ── Chapter tile (dashboard list) ─────────────────────────────────
class _ChapterCard extends StatelessWidget {
  final String chapter, emoji;
  final int index;
  final Color color;
  final VoidCallback onTap;
  const _ChapterCard({required this.chapter, required this.emoji,
      required this.index, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.18), const Color(0xFF16104A)],
          begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.55), width: 2),
        boxShadow: [BoxShadow(
          color: color.withOpacity(0.18), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: color.withOpacity(0.25),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.5), width: 1.5)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(chapter,
            style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.w800, fontSize: 15, height: 1.3)),
        ),
        const SizedBox(width: 30),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.85),
            borderRadius: BorderRadius.circular(14)),
          child: const Text("▶ Play",
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w900, fontSize: 13)),
        ),
      ]),
    ),
  );
}