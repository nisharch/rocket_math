import  'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ================================================================
//  GlobalQuizScreen — Chapter-by-chapter mixed Class 3 & 4 Quiz
//
//  Flow:
//   • All 20 chapters (9 from Class 3, 11 from Class 4) are shuffled
//   • Each chapter gives exactly 2 questions before moving to next
//   • After all 20 chapters (40 Qs) → loop with a fresh shuffle
//   • Current chapter name shown on the card
//
//  Adaptive timer mechanic:
//   • Starts at 30 s
//   • Every 4 consecutive correct answers → −1 s (floor 15 s)
//   • Any wrong / time-up → resets to 30 s
//
//  Firebase save:
//   • Per-chapter breakdown saved so dashboard can show weak chapters
//   • XP awarded: 10 XP per correct answer + streak bonus
// ================================================================

// ── Chapter descriptor ─────────────────────────────────────────
class _Chapter {
  final int classLevel;   // 3 or 4
  final String name;      // display name
  final int index;        // position inside its class list (for question picker)
  _Chapter(this.classLevel, this.name, this.index);
}

// ── Per-chapter stat tracker ───────────────────────────────────
class _ChapterStat {
  int correct = 0;
  int wrong   = 0;
  int xp      = 0;
}

class GlobalQuizScreen extends StatefulWidget {
  const GlobalQuizScreen({super.key});

  @override
  State<GlobalQuizScreen> createState() => _GlobalQuizScreenState();
}

class _GlobalQuizScreenState extends State<GlobalQuizScreen>
    with TickerProviderStateMixin {

  // ── Firebase ──────────────────────────────────────────────────
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── All chapters (both classes) ───────────────────────────────
  static final List<_Chapter> _allChapters = [
    // Class 3 — 9 chapters
    _Chapter(3, "Numbers (সংখ্যা)",        0),
    _Chapter(3, "Addition (যোগ)",           1),
    _Chapter(3, "Subtraction (বিয়োগ)",     2),
    _Chapter(3, "Multiplication (গুণ)",     3),
    _Chapter(3, "Division (ভাগ)",           4),
    _Chapter(3, "Fractions (ভগ্নাংশ)",     5),
    _Chapter(3, "Money (টাকা ও পয়সা)",    6),
    _Chapter(3, "Measurement (পরিমাপ)",    7),
    _Chapter(3, "Geometry (জ্যামিতি)",     8),
    // Class 4 — 11 chapters
    _Chapter(4, "Large Numbers & Place Value", 0),
    _Chapter(4, "Addition and Subtraction",    1),
    _Chapter(4, "Multiplication",              2),
    _Chapter(4, "Division",                    3),
    _Chapter(4, "Mathematical Relations",      4),
    _Chapter(4, "Factors and Multiples",       5),
    _Chapter(4, "Fractions",                   6),
    _Chapter(4, "Decimals",                    7),
    _Chapter(4, "Measurement",                 8),
    _Chapter(4, "Time",                        9),
    _Chapter(4, "Geometry & Shapes",          10),
  ];

  // ── Chapter-round state ───────────────────────────────────────
  late List<_Chapter> _shuffledChapters;
  int _chapterPointer  = 0;   // index into _shuffledChapters
  int _qInChapter      = 0;   // 0 or 1 (2 per chapter)
  int _roundNumber     = 1;

  _Chapter get _currentChapter => _shuffledChapters[_chapterPointer];

  // ── Per-chapter stats (keyed by "Class X: ChapterName") ───────
  final Map<String, _ChapterStat> _chapterStats = {};

  String get _currentChapterKey =>
      "Class ${_currentChapter.classLevel}: ${_currentChapter.name}";

  void _ensureChapterStat(String key) {
    _chapterStats.putIfAbsent(key, () => _ChapterStat());
  }

  // ── Quiz state ────────────────────────────────────────────────
  int score = 0, totalAnswered = 0, lives = 3, streak = 0;
  int totalXP = 0;  // cumulative XP this session
  final Random _random = Random();

  String? tappedOption;
  bool isAnswerRevealed = false, _lastAnswerCorrect = false;

  // ── Adaptive timer — starts at 30 s, floor 15 s ───────────────
  int _maxTime = 30;
  int _timeLeft = 30;
  Timer? _questionTimer;
  int _correctSinceReset = 0;

  // ── XP for current answer ─────────────────────────────────────
  int _earnedXP = 0;

  // ── Animations ────────────────────────────────────────────────
  late AnimationController _bounceCtrl, _mascotCtrl, _confettiCtrl, _bgCtrl;
  late Animation<double> _bounceAnim, _mascotAnim;

  // ── Question data ─────────────────────────────────────────────
  late String generatedQuestion;
  late List<String> currentOptions;
  late String correctAnswer;

  // ── Background blobs ──────────────────────────────────────────
  late List<_Blob> _bgBlobs;

  // ── Chapter transition overlay ────────────────────────────────
  bool _showingChapterBanner = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final rng = Random(42);
    _bgBlobs = List.generate(14, (i) => _Blob(
      x: rng.nextDouble(), y: rng.nextDouble(),
      r: 18 + rng.nextDouble() * 38,
      phase: rng.nextDouble(),
    ));

    _bounceCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 180));
    _bounceAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));

    _mascotCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 500));
    _mascotAnim = Tween<double>(begin: 0, end: -20).animate(
        CurvedAnimation(parent: _mascotCtrl, curve: Curves.elasticOut));

    _confettiCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900));

    _bgCtrl = AnimationController(vsync: this,
        duration: const Duration(seconds: 5))..repeat();

    _buildChapterOrder();
    _showChapterBanner();   // brief banner before Q1
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

  // ════════════════════════════════════════════════════════════════
  //  CHAPTER ORDER
  // ════════════════════════════════════════════════════════════════

  void _buildChapterOrder() {
    _shuffledChapters = List<_Chapter>.from(_allChapters)..shuffle(_random);
    _chapterPointer = 0;
    _qInChapter     = 0;
  }

  void _advanceChapterOrLoop() {
    _qInChapter++;
    if (_qInChapter >= 2) {
      // Done with this chapter's 2 questions
      _qInChapter = 0;
      _chapterPointer++;
      if (_chapterPointer >= _shuffledChapters.length) {
        // All 20 chapters done → new round
        _roundNumber++;
        _buildChapterOrder();
      }
      // Show brief banner for the new chapter
      _showChapterBanner();
      return; // banner will call _generateQuestion after delay
    }
    _generateQuestion();
  }

  // ── Brief chapter banner (0.9 s) ─────────────────────────────
  void _showChapterBanner() {
    _questionTimer?.cancel();
    setState(() => _showingChapterBanner = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _showingChapterBanner = false);
      _generateQuestion();
    });
  }

  // ════════════════════════════════════════════════════════════════
  //  ADAPTIVE TIMER  (30 s start, −1 s every 4 correct, floor 15 s)
  // ════════════════════════════════════════════════════════════════

  void _startTimer() {
    _questionTimer?.cancel();
    setState(() => _timeLeft = _maxTime);
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_timeLeft <= 1) {
        t.cancel();
        if (!isAnswerRevealed) _handleTimeUp();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _onCorrectAnswer() {
    _correctSinceReset++;
    if (_correctSinceReset % 4 == 0) {
      _maxTime = (_maxTime - 1).clamp(15, 30);   // floor 15 s, ceiling 30 s
    }
  }

  void _onWrongAnswer() {
    _correctSinceReset = 0;
    _maxTime = 30;   // reset to 30 s on any mistake
  }

  void _handleTimeUp() {
    HapticFeedback.heavyImpact();
    _onWrongAnswer();
    final key = _currentChapterKey;
    _ensureChapterStat(key);
    _chapterStats[key]!.wrong++;
    setState(() {
      totalAnswered++;
      isAnswerRevealed = true;
      _lastAnswerCorrect = false;
      _earnedXP = 0;
      tappedOption = null;
      lives--;
      streak = 0;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (lives <= 0) {
        _saveToFirebase();
        _triggerGameOver();
      } else {
        _advanceChapterOrLoop();
      }
    });
  }

  // ════════════════════════════════════════════════════════════════
  //  ANSWER HANDLING
  // ════════════════════════════════════════════════════════════════

  void _handleAnswer(String option) {
    if (isAnswerRevealed) return;
    _questionTimer?.cancel();
    HapticFeedback.mediumImpact();
    bool correct = option == correctAnswer;

    _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
    _mascotCtrl.forward(from: 0);
    if (correct) _confettiCtrl.forward(from: 0);

    final key = _currentChapterKey;
    _ensureChapterStat(key);

    int xpEarned = 0;
    if (correct) {
      _onCorrectAnswer();
      // XP: 10 base + 2 per streak level above 1 + 1 bonus per 5 s remaining
      xpEarned = 10 + (streak >= 1 ? (streak) * 2 : 0) + (_timeLeft ~/ 5);
      _chapterStats[key]!.correct++;
      _chapterStats[key]!.xp += xpEarned;
    } else {
      _onWrongAnswer();
      _chapterStats[key]!.wrong++;
    }

    setState(() {
      totalAnswered++;
      tappedOption = option;
      isAnswerRevealed = true;
      _lastAnswerCorrect = correct;
      _earnedXP = xpEarned;
      if (correct) {
        score += 10;
        streak++;
        if (streak > 1) score += (streak - 1) * 2;
        totalXP += xpEarned;
      } else {
        lives--;
        streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (lives <= 0) {
        _saveToFirebase();
        _triggerGameOver();
      } else {
        _advanceChapterOrLoop();
      }
    });
  }

  // ════════════════════════════════════════════════════════════════
  //  QUESTION GENERATOR — dispatcher
  // ════════════════════════════════════════════════════════════════

  void _generateQuestion() {
    tappedOption = null;
    isAnswerRevealed = false;
    _earnedXP = 0;
    final ch = _currentChapter;
    if (ch.classLevel == 3) {
      _genClass3(ch.index);
    } else {
      _genClass4(ch.index);
    }
    _startTimer();
  }

  List<String> _opts(String correct, List<String> wrongs) {
    final all = [...wrongs.take(3), correct]..shuffle(_random);
    return all;
  }

  // ════════════════════════════════════════════════════════════════
  //  CLASS 3 — 9 chapters
  // ════════════════════════════════════════════════════════════════

  void _genClass3(int idx) {
    String q = ""; List<String> opts = [];
    switch (idx) {

      // ── 0: Numbers ─────────────────────────────────────────────
      case 0:
        final t = _random.nextInt(5);
        if (t == 0) {
          int n = _random.nextInt(89) + 10;
          q = "What number comes\nBEFORE $n?";
          correctAnswer = "${n-1}";
          opts = _opts(correctAnswer, ["${n+1}", "$n", "${n-2}"]);
        } else if (t == 1) {
          int n = _random.nextInt(89) + 10;
          q = "What number comes\nAFTER $n?";
          correctAnswer = "${n+1}";
          opts = _opts(correctAnswer, ["${n-1}", "$n", "${n+2}"]);
        } else if (t == 2) {
          final hs = [100,200,300,400,500,600,700,800,900];
          int h = hs[_random.nextInt(hs.length)];
          q = "How many tens\nin $h?";
          correctAnswer = "${h~/10}";
          opts = _opts(correctAnswer, ["${h~/10+5}", "${h~/10-2}", "${h~/5}"]);
        } else if (t == 3) {
          int n = _random.nextInt(900) + 100;
          q = "HUNDREDS digit\nin $n?";
          correctAnswer = "${n~/100}";
          opts = _opts(correctAnswer, ["${(n%1000)~/100}", "${(n%100)~/10}", "${n%10}"]);
        } else {
          int a=_random.nextInt(50)+5, b=a+_random.nextInt(10)+2, c=b+_random.nextInt(10)+2;
          int blank=_random.nextInt(3); List<int> seq=[a,b,c];
          int missing=seq[blank]; seq[blank]=-1;
          String s=seq.map((e)=>e==-1?"?":"$e").join(",  ");
          q = "Fill the blank:\n$s";
          correctAnswer = "$missing";
          opts = _opts(correctAnswer, ["${missing+2}", "${missing-1}", "${missing+5}"]);
        }
        break;

      // ── 1: Addition ────────────────────────────────────────────
      case 1:
        final t = _random.nextInt(4);
        if (t == 0) {
          int v1=_random.nextInt(40)+10, v2=_random.nextInt(30)+5;
          q = "$v1  +  $v2  =  ?";
          correctAnswer = "${v1+v2}";
          opts = _opts(correctAnswer, ["${v1+v2+5}", "${v1+v2-2}", "${v1+v2+10}"]);
        } else if (t == 1) {
          int r=_random.nextInt(50)+30, v1=_random.nextInt(r-10)+5, v2=r-v1;
          q = "$v1  +  ?  =  $r";
          correctAnswer = "$v2";
          opts = _opts(correctAnswer, ["${v2+3}", "${v2-2}", "${v2+7}"]);
        } else if (t == 2) {
          int v1=_random.nextInt(20)+5, v2=_random.nextInt(20)+5, v3=_random.nextInt(10)+1;
          q = "$v1 + $v2 + $v3 = ?";
          correctAnswer = "${v1+v2+v3}";
          opts = _opts(correctAnswer, ["${v1+v2+v3+4}", "${v1+v2+v3-3}", "${v1+v2}"]);
        } else {
          int v1=_random.nextInt(80)+20, v2=_random.nextInt(50)+10;
          q = "Shop: $v1 apples &\n$v2 oranges. Total?";
          correctAnswer = "${v1+v2}";
          opts = _opts(correctAnswer, ["${v1+v2+5}", "${v1+v2-3}", "${v1*2}"]);
        }
        break;

      // ── 2: Subtraction ─────────────────────────────────────────
      case 2:
        final t = _random.nextInt(4);
        if (t == 0) {
          int v1=_random.nextInt(50)+20, v2=_random.nextInt(15)+2;
          q = "$v1  −  $v2  =  ?";
          correctAnswer = "${v1-v2}";
          opts = _opts(correctAnswer, ["${v1-v2+4}", "${v1-v2-3}", "${v1-v2+10}"]);
        } else if (t == 1) {
          int r=_random.nextInt(40)+10, v2=_random.nextInt(r-5)+2, v1=r+v2;
          q = "$v1  −  ?  =  $r";
          correctAnswer = "$v2";
          opts = _opts(correctAnswer, ["${v2+3}", "${v2-2}", "${v2+6}"]);
        } else if (t == 2) {
          int v1=_random.nextInt(50)+40, v2=_random.nextInt(30)+5;
          q = "$v1 birds, $v2 flew\naway. Left?";
          correctAnswer = "${v1-v2}";
          opts = _opts(correctAnswer, ["${v1-v2+5}", "${v1-v2-2}", "${v1+v2}"]);
        } else {
          int big=_random.nextInt(400)+300, sm=_random.nextInt(100)+50;
          q = "$big  −  $sm  =  ?";
          correctAnswer = "${big-sm}";
          opts = _opts(correctAnswer, ["${big-sm+10}", "${big-sm-10}", "${big-sm+100}"]);
        }
        break;

      // ── 3: Multiplication ──────────────────────────────────────
      case 3:
        final t = _random.nextInt(4);
        if (t == 0) {
          int v1=_random.nextInt(8)+2, v2=_random.nextInt(7)+2;
          q = "$v1  ×  $v2  =  ?";
          correctAnswer = "${v1*v2}";
          opts = _opts(correctAnswer, ["${v1*v2+v1}", "${v1*v2-v2}", "${v1*v2+4}"]);
        } else if (t == 1) {
          int v2=_random.nextInt(8)+2, ans=_random.nextInt(9)+2; int v1=v2*ans;
          q = "$v1  =  ?  ×  $v2";
          correctAnswer = "$ans";
          opts = _opts(correctAnswer, ["${ans+2}", "${ans-1}", "${ans+4}"]);
        } else if (t == 2) {
          int b=_random.nextInt(6)+2, p=_random.nextInt(8)+3;
          q = "$b boxes, $p pencils\neach. Total?";
          correctAnswer = "${b*p}";
          opts = _opts(correctAnswer, ["${b*p+b}", "${b+p}", "${b*p-p}"]);
        } else {
          int tbl=_random.nextInt(8)+2, m=_random.nextInt(9)+2;
          q = "$tbl  ×  $m  =  ?";
          correctAnswer = "${tbl*m}";
          opts = _opts(correctAnswer, ["${tbl*m+tbl}", "${tbl*(m-1)}", "${tbl*m+2}"]);
        }
        break;

      // ── 4: Division ────────────────────────────────────────────
      case 4:
        final t = _random.nextInt(4);
        if (t == 0) {
          int v2=_random.nextInt(4)+2, ans=_random.nextInt(5)+2; int v1=v2*ans;
          q = "$v1  ÷  $v2  =  ?";
          correctAnswer = "$ans";
          opts = _opts(correctAnswer, ["${ans+2}", "${ans-1}", "${ans*2}"]);
        } else if (t == 1) {
          int ans=_random.nextInt(8)+3, d=_random.nextInt(5)+2; int dd=ans*d;
          q = "$dd  ÷  ?  =  $ans";
          correctAnswer = "$d";
          opts = _opts(correctAnswer, ["${d+2}", "${d-1}", "${d+3}"]);
        } else if (t == 2) {
          int total=(_random.nextInt(5)+2)*(_random.nextInt(4)+2), g=_random.nextInt(4)+2;
          while(total%g!=0) total++;
          q = "$total sweets among\n$g children. Each?";
          correctAnswer = "${total~/g}";
          opts = _opts(correctAnswer, ["${total~/g+2}", "${total~/g-1}", "$g"]);
        } else {
          int v2=_random.nextInt(6)+3, ans=_random.nextInt(7)+3; int v1=v2*ans;
          q = "$v1 mangoes in\n$v2 baskets. Each?";
          correctAnswer = "$ans";
          opts = _opts(correctAnswer, ["${ans+3}", "${ans-2}", "$v2"]);
        }
        break;

      // ── 5: Fractions ───────────────────────────────────────────
      case 5:
        final t = _random.nextInt(5);
        if (t == 0) {
          q = "🍕 Pizza cut into 4.\n1 slice = ?";
          correctAnswer = "1/4";
          opts = _opts(correctAnswer, ["1/2","3/4","1/3"]);
        } else if (t == 1) {
          q = "Which is BIGGEST?";
          correctAnswer = "3/4";
          opts = _opts(correctAnswer, ["1/4","2/4","1/2"]);
        } else if (t == 2) {
          q = "Ribbon in 3 equal\nparts. 1 part = ?";
          correctAnswer = "1/3";
          opts = _opts(correctAnswer, ["1/2","2/3","1/4"]);
        } else if (t == 3) {
          q = "Which fraction =\nhalf of a whole?";
          correctAnswer = "1/2";
          opts = _opts(correctAnswer, ["2/3","1/4","3/4"]);
        } else {
          q = "🍫 6 pieces. Sara\nate 2. Fraction?";
          correctAnswer = "2/6";
          opts = _opts(correctAnswer, ["1/6","3/6","4/6"]);
        }
        break;

      // ── 6: Money ───────────────────────────────────────────────
      case 6:
        final t = _random.nextInt(5);
        if (t == 0) {
          int n=_random.nextInt(4)+2;
          q = "$n notes of Tk 10\n= how much?";
          correctAnswer = "Tk ${n*10}";
          opts = _opts(correctAnswer, ["Tk ${n+10}","Tk ${n*5}","Tk 100"]);
        } else if (t == 1) {
          int p=_random.nextInt(40)+10, pd=p+_random.nextInt(20)+5;
          q = "Cost Tk $p. Paid\nTk $pd. Change?";
          correctAnswer = "Tk ${pd-p}";
          opts = _opts(correctAnswer, ["Tk ${pd-p+5}","Tk ${pd-p-2}","Tk $p"]);
        } else if (t == 2) {
          int a=_random.nextInt(30)+10, b=_random.nextInt(30)+10;
          q = "Pen Tk $a + Book\nTk $b = Total?";
          correctAnswer = "Tk ${a+b}";
          opts = _opts(correctAnswer, ["Tk ${a+b+5}","Tk ${a+b-3}","Tk ${a*b}"]);
        } else if (t == 3) {
          int c=_random.nextInt(8)+3; int tp=c*50;
          q = "$c coins × 50 paisa\n= how many Taka?";
          correctAnswer = "${tp~/100} Tk ${tp%100} p";
          opts = _opts(correctAnswer, ["${c} Tk","${tp} p","${c*2} Tk"]);
        } else {
          int p=(_random.nextInt(5)+2)*10, q2=_random.nextInt(4)+2;
          q = "$q2 items × Tk $p\n= Total?";
          correctAnswer = "Tk ${p*q2}";
          opts = _opts(correctAnswer, ["Tk ${p*q2+10}","Tk ${p+q2}","Tk ${p*q2-5}"]);
        }
        break;

      // ── 7: Measurement ─────────────────────────────────────────
      case 7:
        final t = _random.nextInt(4);
        if (t == 0) {
          int m=_random.nextInt(4)+1;
          q = "$m m  =  ? cm\n(1 m = 100 cm)";
          correctAnswer = "${m*100} cm";
          opts = _opts(correctAnswer, ["${m}0 cm","${m*10} cm","500 cm"]);
        } else if (t == 1) {
          int cm=_random.nextInt(5)*100+100;
          q = "$cm cm  =  ? m";
          correctAnswer = "${cm~/100} m";
          opts = _opts(correctAnswer, ["$cm m","${cm~/10} m","${cm~/100+1} m"]);
        } else if (t == 2) {
          int kg=_random.nextInt(5)+1;
          q = "$kg kg  =  ? g\n(1 kg = 1000 g)";
          correctAnswer = "${kg*1000} g";
          opts = _opts(correctAnswer, ["${kg*100} g","${kg*10} g","${kg*1000+100} g"]);
        } else {
          int L=_random.nextInt(5)+1;
          q = "$L litre  =  ? ml\n(1 L = 1000 ml)";
          correctAnswer = "${L*1000} ml";
          opts = _opts(correctAnswer, ["${L*100} ml","${L*10} ml","${L*1000-100} ml"]);
        }
        break;

      // ── 8: Geometry ────────────────────────────────────────────
      default:
        final t = _random.nextInt(6);
        if (t == 0) { q = "Sides of a triangle?"; correctAnswer = "3"; opts = _opts("3",["4","5","6"]); }
        else if (t == 1) { q = "Sides of a square?"; correctAnswer = "4"; opts = _opts("4",["3","5","6"]); }
        else if (t == 2) { q = "Corners in a\nrectangle?"; correctAnswer = "4"; opts = _opts("4",["3","5","8"]); }
        else if (t == 3) { q = "A circle has how\nmany sides?"; correctAnswer = "0"; opts = _opts("0",["1","2","4"]); }
        else if (t == 4) { q = "Shape with\n3 vertices?"; correctAnswer = "Triangle"; opts = _opts("Triangle",["Circle","Square","Rectangle"]); }
        else { q = "Shape that looks\nlike a ball? 🏀"; correctAnswer = "Sphere"; opts = _opts("Sphere",["Cube","Cylinder","Cone"]); }
        break;
    }
    setState(() { generatedQuestion = q; currentOptions = opts; });
  }

  // ════════════════════════════════════════════════════════════════
  //  CLASS 4 — 11 chapters
  // ════════════════════════════════════════════════════════════════

  void _genClass4(int idx) {
    String q = ""; List<String> opts = [];
    switch (idx) {

      // ── 0: Large Numbers & Place Value ─────────────────────────
      case 0:
        final t = _random.nextInt(5);
        if (t == 0) {
          int th=_random.nextInt(8)+2;
          q = "In ${th}542, place\nvalue of '$th'?";
          correctAnswer = "${th}000";
          opts = _opts(correctAnswer, ["${th}00","${th}0","$th"]);
        } else if (t == 1) {
          int n=_random.nextInt(90000)+10000;
          int r=((n/1000).round()*1000);
          q = "$n rounded to\nnearest 1000?";
          correctAnswer = "$r";
          opts = _opts(correctAnswer, ["${r+1000}","${r-1000}","${r+500}"]);
        } else if (t == 2) {
          int n=_random.nextInt(9000)+1000;
          q = "THOUSANDS digit\nin $n?";
          correctAnswer = "${n~/1000}";
          opts = _opts(correctAnswer, ["${(n%1000)~/100}","${(n%100)~/10}","${n%10}"]);
        } else if (t == 3) {
          List<int> ns=[_random.nextInt(9000)+1000,_random.nextInt(9000)+1000,_random.nextInt(9000)+1000,_random.nextInt(9000)+1000];
          int mx=ns.reduce((a,b)=>a>b?a:b);
          q = "Greatest number?";
          correctAnswer = "$mx";
          opts = ns.map((e)=>"$e").toList()..shuffle(_random);
        } else {
          int n=_random.nextInt(9000)+1000;
          int th=n~/1000, hu=(n%1000)~/100, te=(n%100)~/10, on=n%10;
          q = "Expand: $n\n=?+?+?+?";
          correctAnswer = "${th*1000}+${hu*100}+${te*10}+$on";
          opts = _opts(correctAnswer, ["${th*100}+${hu*10}+$te+$on","${n}+0+0+0","$th+$hu+$te+$on"]);
        }
        break;

      // ── 1: Addition and Subtraction ────────────────────────────
      case 1:
        final t = _random.nextInt(4);
        if (t == 0) {
          int v1=_random.nextInt(400)+100, v2=_random.nextInt(300)+50;
          q = "$v1  +  $v2  =  ?";
          correctAnswer = "${v1+v2}";
          opts = _opts(correctAnswer, ["${v1+v2+25}","${v1+v2-10}","${v1+v2+100}"]);
        } else if (t == 1) {
          int v1=_random.nextInt(400)+300, v2=_random.nextInt(200)+50;
          q = "$v1  −  $v2  =  ?";
          correctAnswer = "${v1-v2}";
          opts = _opts(correctAnswer, ["${v1-v2+25}","${v1-v2-10}","1000"]);
        } else if (t == 2) {
          int tot=_random.nextInt(800)+500, p=_random.nextInt(300)+100;
          q = "?  +  $p  =  $tot";
          correctAnswer = "${tot-p}";
          opts = _opts(correctAnswer, ["${tot-p+50}","${tot-p-30}","${tot+p}"]);
        } else {
          int sp=_random.nextInt(300)+100, rm=_random.nextInt(300)+50; int tot=sp+rm;
          q = "Had Tk $tot.\nSpent Tk $sp. Left?";
          correctAnswer = "Tk $rm";
          opts = _opts(correctAnswer, ["Tk ${rm+50}","Tk ${rm-20}","Tk $sp"]);
        }
        break;

      // ── 2: Multiplication ──────────────────────────────────────
      case 2:
        final t = _random.nextInt(4);
        if (t == 0) {
          int v1=_random.nextInt(15)+10, v2=_random.nextInt(7)+3;
          q = "$v1  ×  $v2  =  ?";
          correctAnswer = "${v1*v2}";
          opts = _opts(correctAnswer, ["${v1*v2+12}","${v1*v2-5}","200"]);
        } else if (t == 1) {
          int v1=_random.nextInt(20)+10, v2=_random.nextInt(10)+5;
          q = "$v1 rows × $v2\nseats = Total?";
          correctAnswer = "${v1*v2}";
          opts = _opts(correctAnswer, ["${v1*v2+v1}","${v1+v2}","${v1*v2-v2}"]);
        } else if (t == 2) {
          int v2=_random.nextInt(8)+3, ans=_random.nextInt(10)+5; int v1=v2*ans;
          q = "$v1  ÷  $v2  =  ?\n(Use ×)";
          correctAnswer = "$ans";
          opts = _opts(correctAnswer, ["${ans+4}","${ans-3}","${ans+8}"]);
        } else {
          int v1=_random.nextInt(50)+20, v2=_random.nextInt(5)+2;
          q = "1 bag = $v1 kg.\n$v2 bags = ? kg";
          correctAnswer = "${v1*v2}";
          opts = _opts(correctAnswer, ["${v1*v2+10}","${v1+v2}","${v1*(v2+1)}"]);
        }
        break;

      // ── 3: Division ────────────────────────────────────────────
      case 3:
        final t = _random.nextInt(4);
        if (t == 0) {
          int v2=_random.nextInt(8)+3, ans=_random.nextInt(12)+5; int v1=v2*ans;
          q = "$v1  ÷  $v2  =  ?";
          correctAnswer = "$ans";
          opts = _opts(correctAnswer, ["${ans+4}","${ans-3}","${ans+10}"]);
        } else if (t == 1) {
          int d=_random.nextInt(6)+3, qr=_random.nextInt(10)+4; int dd=d*qr;
          q = "$dd  ÷  ?  =  $qr";
          correctAnswer = "$d";
          opts = _opts(correctAnswer, ["${d+2}","${d-1}","${d+4}"]);
        } else if (t == 2) {
          int tot=(_random.nextInt(8)+4)*(_random.nextInt(6)+3), g=_random.nextInt(6)+3;
          while(tot%g!=0) tot++;
          q = "$tot students in\n$g groups. Each?";
          correctAnswer = "${tot~/g}";
          opts = _opts(correctAnswer, ["${tot~/g+3}","${tot~/g-2}","$g"]);
        } else {
          int ans=_random.nextInt(15)+5, d=_random.nextInt(7)+3;
          int dd=ans*d, rem=_random.nextInt(d-1)+1;
          q = "${dd+rem}  ÷  $d  =  ?\n(with remainder)";
          correctAnswer = "$ans r $rem";
          opts = _opts(correctAnswer, ["$ans r ${rem+1}","${ans+1} r 0","$ans r 0"]);
        }
        break;

      // ── 4: Mathematical Relations ──────────────────────────────
      case 4:
        final t = _random.nextInt(4);
        if (t == 0) {
          int v1=_random.nextInt(200)+100, v2=_random.nextInt(200)+100;
          if(v1==v2) v2++;
          q = "$v1  [ ? ]  $v2";
          correctAnswer = v1>v2?">":"<";
          opts = _opts(correctAnswer, [v1>v2?"<":">","=","≠"]);
        } else if (t == 1) {
          int v1=_random.nextInt(50)+10;
          q = "$v1  [ ? ]  $v1";
          correctAnswer = "=";
          opts = _opts(correctAnswer, [">","<","≠"]);
        } else if (t == 2) {
          int v1=_random.nextInt(20)+5, v2=_random.nextInt(10)+2;
          int lhs=v1+v2, rhs=v1*2;
          q = "$v1+$v2 [ ? ] $v1×2\n($lhs [ ? ] $rhs)";
          correctAnswer = lhs>rhs?">":lhs<rhs?"<":"=";
          List<String> ot=[">","<","="].where((e)=>e!=correctAnswer).toList();
          opts = _opts(correctAnswer, [...ot,"≠"]);
        } else {
          int a=_random.nextInt(500)+500, b=a+_random.nextInt(50)+1;
          q = "Which is SMALLER?";
          correctAnswer = "$a";
          opts = _opts(correctAnswer, ["$b","${a+100}","${b+50}"]);
        }
        break;

      // ── 5: Factors and Multiples ───────────────────────────────
      case 5:
        final t = _random.nextInt(5);
        if (t == 0) {
          int base=[12,15,18,20,24][_random.nextInt(5)];
          List<int> facs=List.generate(base,(i)=>i+1).where((i)=>base%i==0).toList();
          int f=facs[_random.nextInt(facs.length)];
          q = "Factor of $base?";
          correctAnswer = "$f";
          List<String> wr=[]; for(int i=2;i<20;i++){if(base%i!=0)wr.add("$i");if(wr.length==3)break;}
          opts = _opts(correctAnswer, wr);
        } else if (t == 1) {
          int n=[6,8,10,12,15][_random.nextInt(5)];
          List<int> facs=List.generate(n,(i)=>i+1).where((i)=>n%i==0).toList();
          q = "Factors of $n?";
          correctAnswer = "${facs.length}";
          opts = _opts(correctAnswer, ["${facs.length+1}","${facs.length-1}","${facs.length+2}"]);
        } else if (t == 2) {
          int a=[2,3,5,7][_random.nextInt(4)];
          List<int> ms=List.generate(6,(i)=>a*(i+1));
          int i2=_random.nextInt(5)+1;
          q = "${i2}th multiple of $a?";
          correctAnswer = "${ms[i2-1]}";
          opts = _opts(correctAnswer, ["${ms[i2-1]+a}","${ms[i2-1]-a}","${a*(i2+2)}"]);
        } else if (t == 3) {
          int a=[2,3,5,7,11][_random.nextInt(5)];
          q = "Is $a prime?";
          correctAnswer = "Yes";
          opts = _opts(correctAnswer, ["No","Maybe","Not sure"]);
        } else {
          int n=[9,12,14,15,16][_random.nextInt(5)];
          q = "Is $n prime?";
          correctAnswer = "No";
          opts = _opts(correctAnswer, ["Yes","Maybe","Sometimes"]);
        }
        break;

      // ── 6: Fractions ───────────────────────────────────────────
      case 6:
        final t = _random.nextInt(5);
        if (t == 0) { q = "Which = 2/4?"; correctAnswer = "1/2"; opts = _opts("1/2",["1/4","3/4","2/3"]); }
        else if (t == 1) { q = "Largest fraction?"; correctAnswer = "7/8"; opts = _opts("7/8",["3/8","5/8","1/8"]); }
        else if (t == 2) { q = "3/5 + 1/5 = ?"; correctAnswer = "4/5"; opts = _opts("4/5",["4/10","3/10","2/5"]); }
        else if (t == 3) { q = "5/6 − 2/6 = ?"; correctAnswer = "3/6"; opts = _opts("3/6",["3/12","7/6","2/6"]); }
        else {
          int w=_random.nextInt(3)+1;
          q = "Convert $w whole\nto fraction (÷4):";
          correctAnswer = "${w*4}/4";
          opts = _opts(correctAnswer, ["$w/4","${w*2}/4","${w+1}/4"]);
        }
        break;

      // ── 7: Decimals ────────────────────────────────────────────
      case 7:
        final t = _random.nextInt(5);
        if (t == 0) {
          double d1=(_random.nextInt(20)+10)/10.0, d2=(_random.nextInt(15)+5)/10.0;
          q = "$d1  +  $d2  =  ?";
          correctAnswer = (d1+d2).toStringAsFixed(1);
          opts = _opts(correctAnswer, [(d1+d2+0.4).toStringAsFixed(1),(d1+d2-0.2).toStringAsFixed(1),"4.0"]);
        } else if (t == 1) {
          double d1=(_random.nextInt(30)+20)/10.0, d2=(_random.nextInt(15)+5)/10.0;
          q = "$d1  −  $d2  =  ?";
          correctAnswer = (d1-d2).toStringAsFixed(1);
          opts = _opts(correctAnswer, [(d1-d2+0.3).toStringAsFixed(1),(d1-d2-0.2).toStringAsFixed(1),d2.toStringAsFixed(1)]);
        } else if (t == 2) {
          q = "Greater: 3.7 or 3.2?"; correctAnswer = "3.7";
          opts = _opts("3.7",["3.2","Both equal","3.0"]);
        } else if (t == 3) {
          double n=(_random.nextInt(50)+10)/10.0; int num=(n*10).round();
          q = "${n.toStringAsFixed(1)} as fraction?";
          correctAnswer = "$num/10";
          opts = _opts(correctAnswer, ["$num/100","${num-1}/10","$num/1"]);
        } else {
          q = "0.5 = which fraction?"; correctAnswer = "1/2";
          opts = _opts("1/2",["1/4","1/5","2/5"]);
        }
        break;

      // ── 8: Measurement ─────────────────────────────────────────
      case 8:
        final t = _random.nextInt(5);
        if (t == 0) {
          int kg=_random.nextInt(5)+2;
          q = "$kg kg  =  ? g\n(1 kg = 1000 g)";
          correctAnswer = "${kg*1000} g";
          opts = _opts(correctAnswer, ["${kg*100} g","${kg}00 g","500 g"]);
        } else if (t == 1) {
          int m=_random.nextInt(5)+2;
          q = "$m m  =  ? cm\n(1 m = 100 cm)";
          correctAnswer = "${m*100} cm";
          opts = _opts(correctAnswer, ["${m*10} cm","${m}0 cm","${m*1000} cm"]);
        } else if (t == 2) {
          int L=_random.nextInt(4)+2;
          q = "$L L  =  ? ml\n(1 L = 1000 ml)";
          correctAnswer = "${L*1000} ml";
          opts = _opts(correctAnswer, ["${L*100} ml","${L}00 ml","${L*1000+100} ml"]);
        } else if (t == 3) {
          int km=_random.nextInt(5)+2;
          q = "$km km  =  ? m\n(1 km = 1000 m)";
          correctAnswer = "${km*1000} m";
          opts = _opts(correctAnswer, ["${km*100} m","${km}00 m","${km*1000-100} m"]);
        } else {
          int g1=_random.nextInt(800)+200, g2=_random.nextInt(500)+100;
          int tot=g1+g2;
          q = "${g1}g + ${g2}g in\nkg and g?";
          correctAnswer = "${tot~/1000} kg ${tot%1000} g";
          opts = _opts(correctAnswer, ["${tot} g","${tot~/1000+1} kg","${tot~/100} kg"]);
        }
        break;

      // ── 9: Time ────────────────────────────────────────────────
      case 9:
        final t = _random.nextInt(5);
        if (t == 0) {
          int h=_random.nextInt(3)+2;
          q = "$h hr${h>1?'s':''} = ? min\n(1 hr = 60 min)";
          correctAnswer = "${h*60} min";
          opts = _opts(correctAnswer, ["${h*10} min","100 min","${h*60+15} min"]);
        } else if (t == 1) {
          int m=[60,90,120,150,180][_random.nextInt(5)];
          q = "$m min  =  ? hrs\n(60 min = 1 hr)";
          correctAnswer = "${m~/60} hr${m~/60>1?'s':''}";
          opts = _opts(correctAnswer, ["$m hrs","${m~/60+1} hrs","${m~/30} hrs"]);
        } else if (t == 2) {
          int d=_random.nextInt(4)+2;
          q = "$d days  =  ? hrs\n(1 day = 24 hrs)";
          correctAnswer = "${d*24} hrs";
          opts = _opts(correctAnswer, ["${d*12} hrs","${d*60} hrs","${d*24+12} hrs"]);
        } else if (t == 3) {
          List<String> m31=["January","March","May","July","August","October","December"];
          List<String> m30=["April","June","September","November"];
          bool p=_random.nextBool();
          String mo=p?m31[_random.nextInt(m31.length)]:m30[_random.nextInt(m30.length)];
          q = "Days in $mo?";
          correctAnswer = p?"31":"30";
          opts = _opts(correctAnswer, ["28","29",p?"30":"31"]);
        } else {
          int sh=_random.nextInt(8)+8, sm=[0,15,30,45][_random.nextInt(4)];
          int dh=_random.nextInt(2)+1, dm=[0,30][_random.nextInt(2)];
          int em=sm+dm; int eh=sh+dh+em~/60; em=em%60;
          String fmt(int h,int m)=>"${h}:${m.toString().padLeft(2,'0')}";
          q = "Start: ${fmt(sh,sm)}\nDur: ${dh}h ${dm}m\nEnd time?";
          correctAnswer = fmt(eh,em);
          opts = _opts(correctAnswer, [fmt(eh+1,em),fmt(eh,(em+15)%60),fmt(eh-1,em)]);
        }
        break;

      // ── 10: Geometry ───────────────────────────────────────────
      default:
        final t = _random.nextInt(6);
        if (t == 0) { q = "Right angle = ?"; correctAnswer = "90°"; opts = _opts("90°",["45°","180°","360°"]); }
        else if (t == 1) { q = "Angles in a\ntriangle?"; correctAnswer = "180°"; opts = _opts("180°",["90°","270°","360°"]); }
        else if (t == 2) {
          int l=_random.nextInt(8)+3, w=_random.nextInt(5)+2;
          q = "Rect l=${l}cm w=${w}cm\nPerimeter?";
          correctAnswer = "${2*(l+w)} cm";
          opts = _opts(correctAnswer, ["${l*w} cm","${l+w} cm","${2*l+w} cm"]);
        } else if (t == 3) {
          int s=_random.nextInt(8)+3;
          q = "Square side ${s}cm\nPerimeter?";
          correctAnswer = "${4*s} cm";
          opts = _opts(correctAnswer, ["${s*s} cm","${s*2} cm","${3*s} cm"]);
        } else if (t == 4) {
          int l=_random.nextInt(8)+3, w=_random.nextInt(5)+2;
          q = "Rect l=${l}cm w=${w}cm\nArea?";
          correctAnswer = "${l*w} cm²";
          opts = _opts(correctAnswer, ["${2*(l+w)} cm²","${l+w} cm²","${l*w+l} cm²"]);
        } else {
          q = "Lines of symmetry\nin a circle?";
          correctAnswer = "Infinite";
          opts = _opts("Infinite",["1","2","4"]);
        }
        break;
    }
    setState(() { generatedQuestion = q; currentOptions = opts; });
  }

  // ════════════════════════════════════════════════════════════════
  //  FIREBASE SAVE  — per-chapter breakdown for dashboard
  // ════════════════════════════════════════════════════════════════

  Future<void> _saveToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      int totalCorrect = 0, totalWrong = 0;
      for (final s in _chapterStats.values) {
        totalCorrect += s.correct;
        totalWrong   += s.wrong;
      }
      double acc = (totalCorrect + totalWrong) == 0
          ? 0
          : totalCorrect / (totalCorrect + totalWrong);

      // Build per-chapter map for weak-chapter dashboard
      final Map<String, dynamic> chapterBreakdown = {};
      _chapterStats.forEach((key, stat) {
        final total = stat.correct + stat.wrong;
        chapterBreakdown[key] = {
          'correct':  stat.correct,
          'wrong':    stat.wrong,
          'total':    total,
          'accuracy': total == 0 ? 0.0 : stat.correct / total,
          'xp':       stat.xp,
          // Mark as "weak" if accuracy below 60%
          'isWeak':   total > 0 && (stat.correct / total) < 0.6,
        };
      });

      await _firestore.collection('quiz_stats').doc(user.uid).set({
        'studentName':  user.displayName ?? "No Name",
        'studentEmail': user.email ?? "No Email",
        'lastPlayed': FieldValue.serverTimestamp(),
        'Global Quiz (Class 3 & 4)': {
          'chapterName':        'Global Quiz (Class 3 & 4)',
          'classLevel':         'Mixed (3 & 4)',
          'correctAnswers':     totalCorrect,
          'wrongAnswers':       totalWrong,
          'averageAccuracy':    acc,
          'score':              score,
          'totalAnswered':      totalAnswered,
          'totalXP':            totalXP,       // ★ XP stars total
          'xp':                 totalXP * 10,  // legacy field
          'streak':             streak,
          'roundsCompleted':    _roundNumber,
          'chapterBreakdown':   chapterBreakdown, // ★ per-chapter for dashboard
          'time': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
    } catch (e) { debugPrint("❌ FIREBASE: $e"); }
  }

  // ════════════════════════════════════════════════════════════════
  //  GAME OVER
  // ════════════════════════════════════════════════════════════════

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
            const Text("GAME OVER!",
              style: TextStyle(color: Color(0xFFFFD166), fontSize: 28,
                fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 10),
            Text("Completed $_roundNumber round${_roundNumber>1?'s':''}!\nYou can do better! 💪",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18)),
              child: Column(children: [
                Text("⭐  $score  pts",
                  style: const TextStyle(color: Colors.amberAccent,
                    fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                // ★ XP stars display
                Text("✨  $totalXP  XP earned",
                  style: const TextStyle(color: Color(0xFFFFD166),
                    fontSize: 18, fontWeight: FontWeight.w800)),
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
                onPressed: () { Navigator.pop(context); Navigator.pop(context); },
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
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    score = 0; totalAnswered = 0; lives = 3; streak = 0;
                    totalXP = 0; _earnedXP = 0;
                    _maxTime = 30; _correctSinceReset = 0; _roundNumber = 1;
                    _chapterStats.clear();
                  });
                  _buildChapterOrder();
                  _showChapterBanner();
                },
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text("Retry 🔄",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              )),
            ]),
          ]),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) => Scaffold(body: _buildLayout());

  Widget _buildLayout() {
    if (_showingChapterBanner) return _buildChapterBanner();
    return _buildQuizCard();
  }

  // ── Chapter transition banner ────────────────────────────────
  Widget _buildChapterBanner() {
    final ch = _currentChapter;
    final bool isClass3 = ch.classLevel == 3;
    final int chapterNum = _chapterPointer + 1;
    final int totalChapters = _shuffledChapters.length;

    return Stack(children: [
      Container(decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF06021A), Color(0xFF0F0635), Color(0xFF1A0D52)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter))),
      AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) => CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _StarfieldPainter(blobs: _bgBlobs, t: _bgCtrl.value))),
      Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isClass3
                ? [const Color(0xFF00CEC9), const Color(0xFF0984E3)]
                : [const Color(0xFF6C5CE7), const Color(0xFFE84393)]),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(
              color: (isClass3
                ? const Color(0xFF00CEC9)
                : const Color(0xFF6C5CE7)).withOpacity(0.5),
              blurRadius: 40, spreadRadius: 4)],
          ),
          child: Column(children: [
            // Chapter counter pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Chapter  $chapterNum  of  $totalChapters  •  Round $_roundNumber",
                style: const TextStyle(color: Colors.white, fontSize: 12,
                  fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 20),
            Text(isClass3 ? "📗" : "📘",
              style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12)),
              child: Text("Class ${ch.classLevel}",
                style: const TextStyle(color: Colors.white, fontSize: 12,
                  fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
            const SizedBox(height: 12),
            Text(ch.name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 22,
                fontWeight: FontWeight.w900, height: 1.3)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30)),
              child: const Text("2 questions coming up! 🚀",
                style: TextStyle(color: Colors.white, fontSize: 13,
                  fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      ])),
    ]);
  }

  // ── Main quiz card ────────────────────────────────────────────
  Widget _buildQuizCard() {
    final ch = _currentChapter;
    final bool isClass3 = ch.classLevel == 3;
    final String mascot = isAnswerRevealed
        ? (_lastAnswerCorrect ? "🥳" : "😅")
        : (_timeLeft <= 8 ? "😱" : _timeLeft <= 15 ? "😰" : "🤔");
    final size = MediaQuery.of(context).size;

    final List<Widget> qDots = List.generate(2, (i) => Container(
      width: 10, height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: i < _qInChapter
            ? const Color(0xFF2ECC71)
            : i == _qInChapter
                ? Colors.white
                : Colors.white30,
        border: Border.all(
          color: i == _qInChapter ? Colors.white : Colors.transparent,
          width: 2)),
    ));

    // Timer colour thresholds adapted for 30 s scale
    Color timerColor = _timeLeft <= 8
        ? const Color(0xFFFF4757)
        : _timeLeft <= 15
            ? const Color(0xFFFF9F43)
            : const Color(0xFF2ECC71);

    String timerBadge = _maxTime <= 15 ? "⚡ MAX SPEED"
        : _maxTime <= 20 ? "🔥 FAST"
        : _maxTime <= 25 ? "⏩ SPEED UP" : "";

    return Stack(children: [
      Container(decoration: const BoxDecoration(gradient: LinearGradient(
        colors: [Color(0xFF06021A), Color(0xFF0F0635), Color(0xFF1A0D52)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter))),
      AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) => CustomPaint(
          size: size,
          painter: _StarfieldPainter(blobs: _bgBlobs, t: _bgCtrl.value))),

      if (isAnswerRevealed && _lastAnswerCorrect)
        AnimatedBuilder(
          animation: _confettiCtrl,
          builder: (_, __) => CustomPaint(
            size: size,
            painter: _ConfettiPainter(
              progress: _confettiCtrl.value, seed: totalAnswered))),

      SafeArea(child: Center(
        child: AnimatedBuilder(
          animation: _bounceAnim,
          builder: (_, child) => Transform.scale(scale: _bounceAnim.value, child: child),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            decoration: BoxDecoration(
              color: const Color(0xFF12093A).withOpacity(0.93),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: isAnswerRevealed
                    ? (_lastAnswerCorrect
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFFF4757))
                    : (_timeLeft <= 8
                        ? const Color(0xFFFF4757).withOpacity(0.9)
                        : const Color(0xFF6C5CE7).withOpacity(0.7)),
                width: 3),
              boxShadow: [BoxShadow(
                color: isAnswerRevealed
                    ? (_lastAnswerCorrect
                        ? const Color(0xFF2ECC71).withOpacity(0.35)
                        : const Color(0xFFFF4757).withOpacity(0.35))
                    : const Color(0xFF6C5CE7).withOpacity(0.25),
                blurRadius: 40, spreadRadius: 4)],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              // ── Top bar ───────────────────────────────────────
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                    child: Icon(
                      i < lives ? Icons.favorite_rounded : Icons.heart_broken_rounded,
                      key: ValueKey('h${i}_$lives'),
                      color: i < lives ? const Color(0xFFFF4757) : Colors.white24,
                      size: 28),
                  ),
                ))),
                Text("Q ${totalAnswered + 1}",
                  style: const TextStyle(color: Colors.white54,
                    fontSize: 13, fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () { _questionTimer?.cancel(); Navigator.pop(context); },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.09),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24)),
                    child: const Icon(Icons.close_rounded, color: Colors.white60, size: 20)),
                ),
              ]),

              const SizedBox(height: 8),

              // ── Chapter name strip ────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isClass3
                      ? [const Color(0xFF00CEC9).withOpacity(0.2),
                         const Color(0xFF0984E3).withOpacity(0.1)]
                      : [const Color(0xFF6C5CE7).withOpacity(0.2),
                         const Color(0xFFE84393).withOpacity(0.1)]),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isClass3
                      ? const Color(0xFF00CEC9).withOpacity(0.4)
                      : const Color(0xFF6C5CE7).withOpacity(0.4))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Row(children: [
                      Text(isClass3 ? "📗" : "📘",
                        style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 8),
                      Flexible(child: Text(ch.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isClass3
                            ? const Color(0xFF00CEC9)
                            : const Color(0xFFA29BFE),
                          fontSize: 12, fontWeight: FontWeight.w800))),
                    ])),
                    Row(children: [...qDots,
                      const SizedBox(width: 6),
                      Text("${_qInChapter+1}/2",
                        style: const TextStyle(color: Colors.white38,
                          fontSize: 10, fontWeight: FontWeight.w700)),
                    ]),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Adaptive timer bar ────────────────────────────
              AnimatedOpacity(
                opacity: isAnswerRevealed ? 0.35 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Text(
                          _timeLeft <= 8 ? "⏰ Hurry!" : "⏱ Time",
                          style: TextStyle(color: timerColor, fontSize: 11,
                            fontWeight: FontWeight.w700)),
                        if (timerBadge.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4757).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFFF4757).withOpacity(0.5))),
                            child: Text(timerBadge,
                              style: const TextStyle(color: Color(0xFFFF6B6B),
                                fontSize: 8, fontWeight: FontWeight.w900))),
                        ],
                      ]),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                        child: Text("$_timeLeft s",
                          key: ValueKey(_timeLeft),
                          style: TextStyle(color: timerColor,
                            fontSize: _timeLeft <= 8 ? 16 : 13,
                            fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _timeLeft / _maxTime,
                      minHeight: 8,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation(timerColor))),
                  const SizedBox(height: 2),
                  if (_maxTime > 15)
                    Text(
                      "${4 - (_correctSinceReset % 4)} more correct → timer −1s  (${_maxTime}s now)",
                      style: const TextStyle(color: Colors.white24,
                        fontSize: 9, fontWeight: FontWeight.w600)),
                ]),
              ),

              const SizedBox(height: 8),

              // ── Score + streak + XP ───────────────────────────
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF00B894)]),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(
                      color: const Color(0xFF6C5CE7).withOpacity(0.4),
                      blurRadius: 12, offset: const Offset(0, 4))]),
                  child: Text("⭐  $score pts",
                    style: const TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w900, fontSize: 14)),
                ),
                // ★ XP stars badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD166).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFFFD166).withOpacity(0.5), width: 1.5)),
                  child: Text("✨ $totalXP XP",
                    style: const TextStyle(color: Color(0xFFFFD166),
                      fontWeight: FontWeight.w900, fontSize: 13))),
                if (streak >= 2)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F43).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFFFF9F43).withOpacity(0.6), width: 2)),
                    child: Text("🔥 $streak streak!",
                      style: const TextStyle(color: Color(0xFFFF9F43),
                        fontWeight: FontWeight.w900, fontSize: 13))),
              ]),

              const SizedBox(height: 10),

              // ── Question card ─────────────────────────────────
              Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white12, width: 1.5)),
                  child: Text(generatedQuestion,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 22,
                      fontWeight: FontWeight.w900, height: 1.45)),
                ),
                // ★ XP pop-up after correct answer
                if (isAnswerRevealed && _lastAnswerCorrect && _earnedXP > 0)
                  Positioned(
                    top: -14, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD166),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(
                          color: const Color(0xFFFFD166).withOpacity(0.6),
                          blurRadius: 12)]),
                      child: Text("+$_earnedXP ✨ XP",
                        style: const TextStyle(
                          color: Color(0xFF1A0A50), fontSize: 12,
                          fontWeight: FontWeight.w900))),
                  ),
                Positioned(
                  top: -16, right: 12,
                  child: AnimatedBuilder(
                    animation: _mascotAnim,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, _mascotAnim.value),
                      child: Text(mascot, style: const TextStyle(fontSize: 36))),
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              // ── 2×2 Answer grid ───────────────────────────────
              SizedBox(
                height: 196,
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

              // ── Time's up notice ──────────────────────────────
              if (isAnswerRevealed && !_lastAnswerCorrect && tappedOption == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4757).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFF4757).withOpacity(0.4))),
                    child: const Text("⌛ Time's up! Correct answer highlighted.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 11,
                        fontWeight: FontWeight.w700))),
                ),

            ]),
          ),
        ),
      )),
    ]);
  }

  // ── Answer card ───────────────────────────────────────────────
  Widget _card(String option) {
    final bool isCorrect = option == correctAnswer;
    final bool isTapped  = option == tappedOption;
    Color bg, border, text; String icon = ""; List<BoxShadow> shadow = [];

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
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 2.5), boxShadow: shadow),
        child: Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (icon.isNotEmpty) ...[
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 3)],
            Text(option, textAlign: TextAlign.center,
              style: TextStyle(color: text, fontSize: 22,
                fontWeight: FontWeight.w900, height: 1.1)),
          ]),
        )),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  PAINTERS
// ════════════════════════════════════════════════════════════════

class _Blob {
  final double x, y, r, phase;
  _Blob({required this.x, required this.y, required this.r, required this.phase});
}

class _StarfieldPainter extends CustomPainter {
  final List<_Blob> blobs; final double t;
  _StarfieldPainter({required this.blobs, required this.t});
  @override void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < blobs.length; i++) {
      final b = blobs[i]; final phase = (t + b.phase) % 1.0;
      final dy = sin(phase * 2 * pi) * 15;
      p.color = Colors.white.withOpacity(0.04 + 0.03 * sin(phase * pi));
      canvas.drawCircle(Offset(b.x * size.width, b.y * size.height + dy), b.r, p);
    }
    final rng = Random(7);
    for (int i = 0; i < 60; i++) {
      final sx = rng.nextDouble() * size.width, sy = rng.nextDouble() * size.height;
      final flicker = (sin((t * 6 + i * 0.7) * pi)).abs();
      p.color = Colors.white.withOpacity(0.1 + 0.25 * flicker);
      canvas.drawCircle(Offset(sx, sy), 1.0 + rng.nextDouble() * 1.2, p);
    }
  }
  @override bool shouldRepaint(_StarfieldPainter o) => o.t != t;
}

class _ConfettiPainter extends CustomPainter {
  final double progress; final int seed;
  _ConfettiPainter({required this.progress, required this.seed});
  @override void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    const colors = [Color(0xFFFFD166),Color(0xFF2ECC71),Color(0xFF45B7D1),
      Color(0xFFFF6B6B),Color(0xFFA29BFE),Color(0xFFFF9F43),Color(0xFFFD79A8)];
    final paint = Paint();
    for (int i = 0; i < 55; i++) {
      paint.color = colors[i % colors.length].withOpacity((1 - progress) * 0.9);
      final cx = size.width * rng.nextDouble(), cy = size.height * 0.22;
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