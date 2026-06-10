import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';
import 'chapter_screen.dart';
import 'dashboard_screen.dart';
import 'unending_quiz_screen.dart';
import '../models/student_model.dart';
 import 'auth_screen.dart'; 

class ClassSelectionScreen extends StatefulWidget {
  const ClassSelectionScreen({super.key});

  @override
  State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen>
    with TickerProviderStateMixin {

  late AnimationController _rocketController;
  late AnimationController _starController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  late Animation<double> _rocketBounce;
  late Animation<double> _starRotation;
  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;

  // Game Settings States
 
  String _selectedAvatar = "👨‍🚀"; 
  String _customName = "";

  // NEW: Multi-Language Support Tracking States
  // 'en' = English, 'bn' = Bengali, 'de' = German
  String _currentLanguage = 'en'; 

  // NEW: Simple Game Localization Dictionary Matrix
  final Map<String, Map<String, String>> _localizedText = {
    'en': {
      'title': 'MOJAR GONIT',
      'subtitle': '🛸 Select Your Mission Code!',
      'welcome': 'Welcome Back,',
      'level_label': '⚡ Choose Your Level ⚡',
      'c3_title': 'CLASS 3',
      'c3_sub': '9 Exciting Chapters',
      'c3_badge': 'BEGINNER',
      'c4_title': 'CLASS 4',
      'c4_sub': '11 Power Chapters',
      'c4_badge': 'ADVANCED',
      'class_wise_quiz': 'CLASS WISE QUIZ',
      'class_wise_quiz': 'Test ALL your skills! ⚡',
      'dashboard': 'View My Dashboard',
      'settings_title': '🚀 MISSION CONTROL SETTINGS',
      'captain_label': 'CAPTAIN NAME',
      'sfx': 'Sound Effects',
      'bgm': 'Background Music',
      'lang_label': 'Language Transmission',
      'logout': 'Log Out',
      'save': 'SAVE',
    },
    'bn': {
      'title': 'মজার গণিত',
      'subtitle': '🛸 তোমার মিশন কোড বেছে নাও!',
      'welcome': 'স্বাগতম ক্যাপ্টেন,',
      'level_label': '⚡ তোমার লেভেল বেছে নাও ⚡',
      'c3_title': 'ক্লাস ৩',
      'c3_sub': '৯টি উত্তেজনাপূর্ণ অধ্যায়',
      'c3_badge': 'শিক্ষানবিস',
      'c4_title': 'ক্লাস ৪',
      'c4_sub': '১১টি পাওয়ার অধ্যায়',
      'c4_badge': 'উন্নত লেভেল',
      'mega_quiz': 'মেগা কুইজ চ্যালেঞ্জ',
      'mega_quiz_sub': 'তোমার সব দক্ষতা যাচাই করো! ⚡',
      'dashboard': 'আমার ড্যাশবোর্ড দেখুন',
      'settings_title': '🚀 মিশন কন্ট্রোল সেটিংস',
      'captain_label': 'ক্যাপ্টেন এর নাম',
      'sfx': 'শব্দ প্রভাব (SFX)',
      'bgm': 'ব্যাকগ্রাউন্ড মিউজিক',
      'lang_label': 'ভাষা পরিবর্তন করুন',
      'logout': 'লগ আউট',
      'save': 'সংরক্ষণ করুন',
    },
    'de': {
      'title': 'MOJAR GONIT',
      'subtitle': '🛸 Wähle deinen Missionscode!',
      'welcome': 'Willkommen zurück,',
      'level_label': '⚡ Wähle dein Level ⚡',
      'c3_title': 'KLASSE 3',
      'c3_sub': '9 Spannende Kapitel',
      'c3_badge': 'ANFÄNGER',
      'c4_title': 'KLASSE 4',
      'c4_sub': '11 Power-Kapitel',
      'c4_badge': 'FORTGESCHRITTEN',
      'class_wise_quiz': 'CLASS_WISE-QUIZ-HERAUSFORDERUNG',
      'class_wise_quiz': 'Teste alle deine Fähigkeiten! ⚡',
      'dashboard': 'Mein Dashboard anzeigen',
      'settings_title': '🚀 MISSIONSKONTROLL-EINSTELLUNGEN',
      'captain_label': 'KAPITÄNSNAME',
      'sfx': 'Soundeffekte',
      'bgm': 'Hintergrundmusik',
      'lang_label': 'Übertragunssprache',
      'logout': 'Abmelden',
      'save': 'SPEICHERN',
    }
  };

  // Helper method to retrieve mapped translation strings easily
  String _getTxt(String key) {
    return _localizedText[_currentLanguage]?[key] ?? _localizedText['en']![key]!;
  }

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    _customName =
    user?.displayName ??
    user?.email?.split('@')[0] ??
    "Captain";
    // Rocket bouncing up and down
    _rocketController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _rocketBounce = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _rocketController, curve: Curves.easeInOut),
    );

    // Stars slowly rotating
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _starRotation = Tween<double>(begin: 0, end: 2 * pi).animate(_starController);

    // Pulse for buttons
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Float for cards
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rocketController.dispose();
    _starController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Animated starfield background ──
          _AnimatedStarfield(rotationAnim: _starRotation),

          // ── Main content layer ──
          SafeArea(
            child: Stack(
              children: [
                // Scrollable workspace content layer
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),

                      // ── Bouncing Rocket ──
                      AnimatedBuilder(
                        animation: _rocketBounce,
                        builder: (_, __) => Transform.translate(
                          offset: Offset(0, _rocketBounce.value),
                          child: const Text("🚀", style: TextStyle(fontSize: 70)),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ── Title with glow ──
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFFE066), Color(0xFFFF9F43), Color(0xFFFFE066)],
                        ).createShader(bounds),
                        child: Text(
                          _getTxt('title'), // Translated
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 4,
                            shadows: [
                              Shadow(color: Color(0xFFFFE066), blurRadius: 20),
                              Shadow(color: Color(0xFFFF9F43), blurRadius: 40),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // ── Subtitle ──
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Text(
                          _getTxt('subtitle'), // Translated
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── Welcome Banner ──
                      _WelcomeBanner(
                        welcomePrefix: _getTxt('welcome'), // Translated
                        userName: _customName, 
                        avatarEmoji: _selectedAvatar
                      ),

                      const SizedBox(height: 22),

                      // ── Floating label ──
                      Text(
                        _getTxt('level_label'), // Translated
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── CLASS 3 Card ──
                      AnimatedBuilder(
                        animation: _floatAnim,
                        builder: (_, __) => Transform.translate(
                          offset: Offset(0, _floatAnim.value),
                          child: _SuperClassCard(
                            classNum: 3,
                            emoji: "🌱",
                            titleText: _getTxt('c3_title'), // Translated
                            subtitle: _getTxt('c3_sub'), // Translated
                            badgeText: _getTxt('c3_badge'), // Translated
                            badgeColor: const Color(0xFF00FFCC),
                            color1: const Color(0xFF00C9A7),
                            color2: const Color(0xFF00A8FF),
                            color3: const Color(0xFF0066FF),
                            stars: "⭐⭐⭐",
                            onTap: () {
                              Navigator.push(
                                context,
                                _buildRoute(const ChapterScreen(selectedClass: 3)),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ── CLASS 4 Card ──
                      AnimatedBuilder(
                        animation: _floatAnim,
                        builder: (_, __) => Transform.translate(
                          offset: Offset(0, -_floatAnim.value),
                          child: _SuperClassCard(
                            classNum: 4,
                            emoji: "🔥",
                            titleText: _getTxt('c4_title'), // Translated
                            subtitle: _getTxt('c4_sub'), // Translated
                            badgeText: _getTxt('c4_badge'), // Translated
                            badgeColor: const Color(0xFFFF9F43),
                            color1: const Color(0xFFFF9F43),
                            color2: const Color(0xFFFF6B6B),
                            color3: const Color(0xFFAE1D1D),
                            stars: "⭐⭐⭐⭐⭐",
                            onTap: () {
                              Navigator.push(
                                context,
                                _buildRoute(const ChapterScreen(selectedClass: 4)),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      
                      // ── Class Wise Quiz ──
AnimatedBuilder(
  animation: _pulseAnim,
  builder: (_, child) => Transform.scale(
    scale: _pulseAnim.value,
    child: child,
  ),
  child: ClassWiseQuiz(
    title: "CLASS WISE QUIZ",
    subtitle: "Choose Class 3 or Class 4 🚀",
    onTap: () => _showQuizBottomSheet(context),
  ),
),

const SizedBox(height: 12),

// ── Global Quiz ──
AnimatedBuilder(
  animation: _pulseAnim,
  builder: (_, child) => Transform.scale(
    scale: _pulseAnim.value,
    child: child,
  ),
  child: ClassWiseQuiz(
    title: "GLOBAL QUIZ",
    subtitle: "Class 3 + Class 4 Mixed Questions 🌍",
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const UnendingQuizScreen(
            chapterName: "Global Quiz",
            classLevel: 0, // use 0 to indicate all classes
          ),
        ),
      );
    },
  ),
),

const SizedBox(height: 16),

                      // ── Dashboard Button ──
                      _DashboardButton(
                        buttonText: _getTxt('dashboard'), // Translated
                        onTap: () {
                          final student = Student(id: "S1", selectedClass: 3);
                          Navigator.push(
                            context,
                            _buildRoute(DashboardScreen(student: student)),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Settings layer fixed on top of scroll field
                Positioned(
                  top: 10,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => _showSettingsDialog(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PageRoute _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.elasticOut),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  void _showQuizBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _QuizBottomSheet(currentLanguage: _currentLanguage),
    );
  }

  // ── SPACE SYSTEM SETTINGS MODAL ──
  void _showSettingsDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Settings",
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1F1154), Color(0xFF0A0428)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.purpleAccent.withOpacity(0.5), width: 2),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getTxt('settings_title'), // Translated
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Profile Pic Selection Area
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: ["👨‍🚀", "👽", "🤖", "🐱‍🚀", "🛸"].map((emoji) {
                            final isSelected = _selectedAvatar == emoji;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedAvatar = emoji);
                                setModalState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.purpleAccent.withOpacity(0.4) : Colors.white10,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.purpleAccent : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Text(emoji, style: const TextStyle(fontSize: 28)),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Name Modification Field
                        TextField(
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            labelText: _getTxt('captain_label'), // Translated
                            labelStyle: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.08),
                            prefixIcon: const Icon(Icons.edit, color: Colors.purpleAccent),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.purpleAccent),
                            ),
                          ),
                          controller: TextEditingController(text: _customName),
                          onChanged: (val) {
                            _customName = val;
                          },
                        ),
                        const SizedBox(height: 15),

                       
                        // Game music configuration lines
                        
                        

                        // ── NEW: LOCALIZATION FLAG SELECTOR COMPONENT ──
                        Text(
                          _getTxt('lang_label'), // Translated
                          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLanguageFlagButton("🇺🇸", "English", "en", setModalState),
                            _buildLanguageFlagButton("🇧🇩", "বাংলা", "bn", setModalState),
                            _buildLanguageFlagButton("🇩🇪", "Deutsch", "de", setModalState),
                          ],
                        ),

                        const Divider(color: Colors.white24, height: 24),

                        // Bottom Utility Action Rows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                              icon: const Icon(Icons.logout_rounded),
                              label: Text(_getTxt('logout'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), // Translated
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.purpleAccent)),
                                );

                                try {
                                  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                                  if (currentUserId != null) {
                                    await FirebaseAuth.instance.currentUser?.updateDisplayName(_customName);
                                  }
                                } catch (error) {
                                  debugPrint("Auto-save configuration failed: $error");
                                }

                                if (context.mounted) Navigator.pop(context); // Clear loading spinner
                                await FirebaseAuth.instance.signOut();
                                
                                if (context.mounted) {

                                Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const AuthScreen()), // <-- Calls your real Auth screen class!
    (route) => false, // Clears screen memory stack so kids can't press back to return to the dashboard
  );
}
                              },
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(_getTxt('save'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)), // Translated
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Builder method for specialized cockpit language toggle options
  Widget _buildLanguageFlagButton(String flag, String name, String code, StateSetter setModalState) {
    final isSelected = _currentLanguage == code;
    return GestureDetector(
      onTap: () {
        // Triggers reactive updates simultaneously on backend dialog and core screen dashboard
        setModalState(() => _currentLanguage = code);
        setState(() => _currentLanguage = code);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.tealAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.tealAccent : Colors.white24,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 2),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ── Animated Starfield Background ──
class _AnimatedStarfield extends StatelessWidget {
  final Animation<double> rotationAnim;
  const _AnimatedStarfield({required this.rotationAnim});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: rotationAnim,
      builder: (_, __) => CustomPaint(
        size: size,
        painter: _StarfieldPainter(rotationAnim.value),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final double rotation;
  static final List<_Star> _stars = List.generate(60, (i) {
    final rand = Random(i * 73 + 13);
    return _Star(
      x: rand.nextDouble(), y: rand.nextDouble(),
      size: rand.nextDouble() * 3 + 1,
      opacity: rand.nextDouble() * 0.7 + 0.2,
      speed: rand.nextDouble() * 0.3 + 0.1,
    );
  });

  _StarfieldPainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint();
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    bgPaint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0A0428), Color(0xFF1A0A5E), Color(0xFF2F0F8F), Color(0xFF6C3FD4), Color(0xFF9B6FE8),
      ],
      stops: [0.0, 0.2, 0.45, 0.75, 1.0],
    ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    _drawNebula(canvas, size, 0.15, 0.25, 120, const Color(0x1500FFCC));
    _drawNebula(canvas, size, 0.8, 0.7, 100, const Color(0x15FF4757));
    _drawNebula(canvas, size, 0.5, 0.5, 150, const Color(0x0FFFFF00));

    for (final star in _stars) {
      final twinkle = (sin(rotation * star.speed * 8 + star.x * 10) * 0.3 + 0.7).clamp(0.2, 1.0);
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.opacity * twinkle)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
      canvas.drawCircle(Offset(star.x * size.width, star.y * size.height), star.size * twinkle, paint);
    }

    _drawPlanet(canvas, size, 0.88, 0.12, 28, const Color(0xFFFF6B9D), const Color(0xFFFF9F43));
    _drawPlanet(canvas, size, 0.08, 0.55, 20, const Color(0xFF00FFCC), const Color(0xFF00A8FF));
  }

  void _drawNebula(Canvas canvas, Size size, double cx, double cy, double r, Color color) {
    canvas.drawCircle(Offset(cx * size.width, cy * size.height), r, Paint()..color = color..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60));
  }

  void _drawPlanet(Canvas canvas, Size size, double cx, double cy, double r, Color c1, Color c2) {
    final center = Offset(cx * size.width, cy * size.height);
    final paint = Paint()..shader = RadialGradient(colors: [c1, c2]).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, paint);
    canvas.drawOval(Rect.fromCenter(center: center, width: r * 2.8, height: r * 0.7), Paint()..color = c1.withOpacity(0.4)..style = PaintingStyle.stroke..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => old.rotation != rotation;
}

class _Star {
  final double x, y, size, opacity, speed;
  const _Star({required this.x, required this.y, required this.size, required this.opacity, required this.speed});
}

// ── Welcome Banner ──
class _WelcomeBanner extends StatelessWidget {
  final String welcomePrefix;
  final String userName;
  final String avatarEmoji;
  const _WelcomeBanner({required this.welcomePrefix, required this.userName, required this.avatarEmoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(avatarEmoji, style: const TextStyle(fontSize: 34)),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  welcomePrefix.toUpperCase(),
                  style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                Text(
                  "Captain ${userName.toUpperCase()} 🚀",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Super Class Card ──
class _SuperClassCard extends StatefulWidget {
  final int classNum;
  final String emoji;
  final String titleText;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final Color color1; final Color color2; final Color color3;
  final String stars;
  final VoidCallback onTap;

  const _SuperClassCard({
    required this.classNum, required this.emoji, required this.titleText, required this.subtitle,
    required this.badgeText, required this.badgeColor, required this.color1, required this.color2,
    required this.color3, required this.stars, required this.onTap,
  });

  @override
  ThemeStateCard createState() => ThemeStateCard();
}

class ThemeStateCard extends State<_SuperClassCard> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmer;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedBuilder(
          animation: _shimmer,
          builder: (_, child) {
            return Container(
              width: double.infinity, padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.color1.withOpacity(0.8), Colors.white.withOpacity(0.6), widget.color2.withOpacity(0.8)],
                  stops: [(_shimmer.value - 0.5).clamp(0.0, 1.0), _shimmer.value.clamp(0.0, 1.0), (_shimmer.value + 0.5).clamp(0.0, 1.0)],
                  begin: Alignment.centerLeft, end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: widget.color1.withOpacity(0.6), blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [widget.color1, widget.color2, widget.color3]),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25), shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: Center(child: Text(widget.emoji, style: const TextStyle(fontSize: 38))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.badgeColor.withOpacity(0.3), borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: widget.badgeColor.withOpacity(0.7)),
                        ),
                        child: Text(widget.badgeText, style: TextStyle(fontSize: 10, color: widget.badgeColor, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      ),
                      const SizedBox(height: 6),
                      Text(widget.titleText, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1, shadows: [Shadow(color: Colors.black38, blurRadius: 8)])),
                      const SizedBox(height: 4),
                      Text(widget.subtitle, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(widget.stars, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mega Quiz Button ──
class ClassWiseQuiz extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const ClassWiseQuiz({required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)]),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: const Color(0xFFFF416C).withOpacity(0.6), blurRadius: 25, offset: const Offset(0, 10))],
          border: Border.all(color: Colors.white30, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Text("🎯", style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Padding(padding: EdgeInsets.only(right: 16), child: Text("🏆", style: TextStyle(fontSize: 26))),
          ],
        ),
      ),
    );
  }
}

// ── Dashboard Button ──
class _DashboardButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const _DashboardButton({required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [const Color(0xFF00FFCC).withOpacity(0.2), const Color(0xFF00A8FF).withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF00FFCC).withOpacity(0.7), width: 2.5),
          boxShadow: [BoxShadow(color: const Color(0xFF00FFCC).withOpacity(0.25), blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🏆", style: TextStyle(fontSize: 26)),
            const SizedBox(width: 10),
            Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF00FFCC).withOpacity(0.25), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF00FFCC).withOpacity(0.5), width: 1),
              ),
              child: const Text("STATS", style: TextStyle(color: Color(0xFF00FFCC), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quiz Bottom Sheet ──
class _QuizBottomSheet extends StatelessWidget {
  final String currentLanguage;
  const _QuizBottomSheet({required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    // Quick translated text values localized for the Bottom Sheet modal popup frame
    final String sheetTitle = currentLanguage == 'bn' ? "কুইজ ক্লাস নির্বাচন করুন" : (currentLanguage == 'de' ? "Quizklasse Wählen" : "Select Quiz Class");
    final String sheetSub = currentLanguage == 'bn' ? "আজ তুমি কোন গ্রহ জয় করতে যাচ্ছ?" : (currentLanguage == 'de' ? "Welchen Planeten eroberst du heute?" : "Which planet are you conquering today?");
    final String c3Label = currentLanguage == 'bn' ? "🌱   ক্লাস ৩ কুইজ" : (currentLanguage == 'de' ? "🌱   Klasse 3 Quiz" : "🌱   Class 3 Quiz");
    final String c4Label = currentLanguage == 'bn' ? "🔥   ক্লাস ৪ কুইজ" : (currentLanguage == 'de' ? "🔥   Klasse 4 Quiz" : "🔥   Class 4 Quiz");
    final String c3Sub = currentLanguage == 'bn' ? "৯টি অধ্যায় · সব বিষয়" : (currentLanguage == 'de' ? "9 Kapitel · Alle Themen" : "9 chapters · All topics");
    final String c4Sub = currentLanguage == 'bn' ? "১১টি অধ্যায় · সব বিষয়" : (currentLanguage == 'de' ? "11 Kapitel · Alle Themen" : "11 chapters · All topics");

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1A0A5E), Color(0xFF0A0428)]),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 20),
          const Text("🚀", style: TextStyle(fontSize: 44)),
          const SizedBox(height: 8),
          Text(sheetTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(sheetSub, style: const TextStyle(color: Colors.white60, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _QuizClassTile(
            label: c3Label, subtitle: c3Sub,
            color1: const Color(0xFF00C9A7), color2: const Color(0xFF00A8FF),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UnendingQuizScreen(chapterName: "Class Wise Quiz", classLevel: 3)));
            },
          ),
          const SizedBox(height: 14),
          _QuizClassTile(
            label: c4Label, subtitle: c4Sub,
            color1: const Color(0xFFFF9F43), color2: const Color(0xFFFF4757),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UnendingQuizScreen(chapterName: "Class Wise Quiz", classLevel: 4)));
            },
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _QuizClassTile extends StatelessWidget {
  final String label; final String subtitle; final Color color1; final Color color2; final VoidCallback onTap;
  const _QuizClassTile({required this.label, required this.subtitle, required this.color1, required this.color2, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1, color2]), borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: color1.withOpacity(0.5), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 36),
          ],
        ),
      ),
    );
  }
}