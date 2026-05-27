import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../state/shared_state.dart';

// ── Chapter definitions ────────────────────────────────────────────────────
class QuizChapters {
  static const List<String> class3 = [
    "Addition", "Subtraction", "Multiplication", "Division",
    "Fractions", "Measurement", "Time", "Money", "Shapes",
  ];
  static const List<String> class4 = [
    "Large Numbers", "Adv Multiplication", "Long Division", "Fractions",
    "Perimeter Area", "Measurement", "Time", "Money", "Shapes",
  ];
}

// ── Question generator ────────────────────────────────────────────────────
class _QuestionData {
  final String text;
  final List<String> options;
  final String correct;
  _QuestionData(this.text, this.options, this.correct);
}

_QuestionData generateQuestion(String chapterName, int classLevel, int level) {
  final rand = Random();
  int rnd(int min, int max) => rand.nextInt(max - min + 1) + min;

  final ch = chapterName.toLowerCase().trim();
  String text = '';
  int ans = 0;

  if (ch == 'addition') {
    final m = classLevel == 4 ? level * 30 : level * 10;
    final a = rnd(10, 50 + m), b = rnd(10, 30 + m);
    text = '$a + $b = ?'; ans = a + b;

  } else if (ch == 'subtraction') {
    final m = classLevel == 4 ? level * 30 : level * 10;
    final a = rnd(20, 60 + m);
    final b = rnd(5, (a - 5) > 5 ? a - 5 : 10);
    text = '$a − $b = ?'; ans = a - b;

  } else if (ch == 'multiplication') {
    final top = classLevel == 4 ? 15 : 10;
    final a = rnd(2, top), b = rnd(2, 10);
    text = '$a × $b = ?'; ans = a * b;

  } else if (ch == 'adv multiplication') {
    final a = rnd(12, 50 + level * 5), b = rnd(2, 9 + level);
    text = '$a × $b = ?'; ans = a * b;

  } else if (ch == 'division') {
    final d = rnd(2, 5 + level), r = rnd(2, 10 + level);
    text = '${d * r} ÷ $d = ?'; ans = r;

  } else if (ch == 'long division') {
    final d = rnd(3, 9 + level), r = rnd(10, 40 + level * 5);
    text = '${d * r} ÷ $d = ?'; ans = r;

  } else if (ch == 'large numbers') {
    final a = rnd(1000, 9999), b = rnd(100, 999);
    final isAdd = rand.nextBool();
    text = isAdd ? '$a + $b = ?' : '$a − $b = ?';
    ans = isAdd ? a + b : a - b;

  } else if (ch == 'fractions') {
    final den = rnd(4, 8), n1 = rnd(1, 3);
    text = '$n1/$den + 2/$den = ?/$den\n(Find the top number)';
    ans = n1 + 2;

  } else if (ch == 'perimeter area') {
    final l = rnd(3, 10 + level), w = rnd(2, 6 + level);
    final isArea = rand.nextBool();
    text = 'Rectangle: length=$l, width=$w\nFind the ${isArea ? 'Area' : 'Perimeter'}!';
    ans = isArea ? l * w : 2 * (l + w);

  } else if (ch == 'measurement') {
    final pick = rnd(0, 2);
    if (pick == 0) { final m = rnd(2, 9 + level); text = '$m m = ? cm'; ans = m * 100; }
    else if (pick == 1) { final cm = rnd(1, 9) * 100; text = '$cm cm = ? m'; ans = cm ~/ 100; }
    else { final km = rnd(1, 5); text = '$km km = ? m'; ans = km * 1000; }

  } else if (ch == 'time') {
    if (rand.nextBool()) {
      final h = rnd(2, 8); text = '$h hours = ? minutes'; ans = h * 60;
    } else {
      final m = rnd(2, 5) * 60; text = '$m minutes = ? hours'; ans = m ~/ 60;
    }

  } else if (ch == 'money') {
    if (rand.nextBool()) {
      final r = rnd(2, 15 + level); text = '₹$r = ? paise'; ans = r * 100;
    } else {
      final p = rnd(2, 9) * 100; text = '$p paise = ? rupees'; ans = p ~/ 100;
    }

  } else {
    // shapes (default)
    final sides = rand.nextBool() ? 3 : 4;
    text = 'How many sides does a ${sides == 3 ? 'Triangle' : 'Square'} have?';
    ans = sides;
  }

  // Build 4 unique options around the correct answer
  final optSet = <int>{ans};
  int tries = 0;
  while (optSet.length < 4 && tries < 60) {
    final offset = rnd(1, (ans * 0.3).ceil().clamp(3, 999));
    final v = rand.nextBool() ? ans + offset : ans - offset;
    if (v > 0) optSet.add(v);
    tries++;
  }

  final opts = optSet.map((e) => '$e').toList()..shuffle();
  return _QuestionData(text, opts, '$ans');
}

// ── Screen ────────────────────────────────────────────────────────────────
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
    with SingleTickerProviderStateMixin {

  int _score = 0;
  int _level = 1;
  int _lives = 3;
  int _totalAttempted = 0;
  int _correctAnswers = 0;

  late _QuestionData _current;
  bool _answered = false;
  String? _selected;

  late AnimationController _popCtrl;
  late Animation<double> _popAnim;

  @override
  void initState() {
    super.initState();
    _popCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _popAnim = CurvedAnimation(parent: _popCtrl, curve: Curves.elasticOut);

    _current = _QuestionData('Loading…', ['…', '…', '…', '…'], '…');
    _nextQuestion();
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    final q = generateQuestion(widget.chapterName, widget.classLevel, _level);
    if (!mounted) return;
    setState(() {
      _current = q;
      _answered = false;
      _selected = null;
    });
    _popCtrl.reset();
    _popCtrl.forward();
  }

  void _answer(String val) {
    if (_answered || _lives <= 0) return;
    _totalAttempted++;

    setState(() {
      _answered = true;
      _selected = val;
      if (val == _current.correct) {
        _correctAnswers++;
        _score += 10;
        if (_score % 40 == 0) _level++;
      } else {
        _lives--;
      }
    });

    if (_lives <= 0) {
      _saveLog();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _showGameOver();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (mounted) _nextQuestion();
      });
    }
  }

  void _saveLog() {
    AppStateManager.updateLog(
      '${widget.chapterName} (Class ${widget.classLevel})',
      _score, _level, _totalAttempted, _correctAnswers,
    );
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16162A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        title: const Text(
          '🎮 Game Over!',
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'All lives lost!',
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Score: ⭐ $_score XP',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level reached: $_level',
                    style: const TextStyle(fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Accuracy: ${_totalAttempted > 0 ? (_correctAnswers * 100 ~/ _totalAttempted) : 0}%',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // ── Back button ──────────────────────────────────────────
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to chapter list
            },
            child: const Text(
              '⬅ Back',
              style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),
            ),
          ),
          // ── Home button ──────────────────────────────────────────
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              // Pop until you reach the first route (home screen)
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text(
              '🏠 Home',
              style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),
            ),
          ),
          // ── Try again button ─────────────────────────────────────
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0; _level = 1; _lives = 3;
                _totalAttempted = 0; _correctAnswers = 0;
              });
              _nextQuestion();
            },
            child: const Text(
              '🔄 Try Again',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: Text('Grade ${widget.classLevel} · ${widget.chapterName}'),
        backgroundColor: const Color(0xFF16162A),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            _saveLog();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHUD(),
                  const SizedBox(height: 24),
                  _buildQuestionCard(),
                  const SizedBox(height: 26),
                  _buildOptions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHUD() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('⭐ $_score XP',
              style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.w900)),
          Row(
            children: List.generate(3, (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedScale(
                scale: i < _lives ? 1.0 : 0.75,
                duration: const Duration(milliseconds: 300),
                child: Icon(Icons.favorite,
                    color: i < _lives ? Colors.redAccent : Colors.white12,
                    size: 22),
              ),
            )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.lightGreenAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('LVL $_level',
                style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return ScaleTransition(
      scale: _popAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C5CE7).withOpacity(_answered ? 0.1 : 0.3),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _current.text,
            style: const TextStyle(
                fontSize: 23, fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A2E), height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 2.3,
      ),
      itemCount: _current.options.length,
      itemBuilder: (_, i) {
        final opt = _current.options[i];
        Color bg = const Color(0xFF1E1E38);
        Color border = Colors.purpleAccent.withOpacity(0.18);

        if (_answered) {
          if (opt == _current.correct) { bg = Colors.green.shade600; border = Colors.greenAccent; }
          else if (opt == _selected) { bg = Colors.red.shade600; border = Colors.redAccent; }
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bg, elevation: _answered ? 1 : 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: border, width: 2),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: _answered ? null : () => _answer(opt),
            child: Text(opt,
                style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w900)),
          ),
        );
      },
    );
  }
}