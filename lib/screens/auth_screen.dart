import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'class_selection_screen.dart';

// ─────────────────────────────────────────
//  AUTH SCREEN
// ─────────────────────────────────────────
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  bool obscurePassword = true;

  late TabController _tabController;
  late AnimationController _fadeController;
  late AnimationController _bgController;
  late Animation<double> _fadeAnim;
  late Animation<Alignment> _bgAnim;

  // Password strength
  double _passStrength = 0;
  Color _strengthColor = Colors.red;
  String _strengthLabel = '';

  // OTP
  String _storedOtp = '';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => isLogin = _tabController.index == 0);
      }
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _bgAnim = AlignmentTween(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _bgController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength(String value) {
    double strength = 0;
    Color color = Colors.red;
    String label = '';

    if (value.isEmpty) {
      setState(() {
        _passStrength = 0;
        _strengthColor = Colors.red;
        _strengthLabel = '';
      });
      return;
    }

    if (value.length >= 6) strength += 0.25;
    if (value.length >= 10) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(value) &&
        RegExp(r'[!@#\$&*~]').hasMatch(value)) strength += 0.25;

    if (strength <= 0.25) {
      color = Colors.red;
      label = 'Weak';
    } else if (strength <= 0.5) {
      color = Colors.orange;
      label = 'Fair';
    } else if (strength <= 0.75) {
      color = Colors.yellow.shade700;
      label = 'Good';
    } else {
      color = Colors.green;
      label = 'Strong';
    }

    setState(() {
      _passStrength = strength;
      _strengthColor = color;
      _strengthLabel = label;
    });
  }

  // ── SIGN UP ──────────────────────────────
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      // 1. Create the Firebase account
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Save display name
      await credential.user?.updateDisplayName(_nameController.text.trim());

      // 3. Sign out — user must pass OTP before being let in
      await FirebaseAuth.instance.signOut();

      // 4. Generate & send OTP
      final otp = _generateOTP();
      _storedOtp = otp;
      final email = _emailController.text.trim();
      final name = _nameController.text.trim();

      await _sendOtpEmail(email, otp);

      if (mounted) {
        setState(() => isLoading = false);
        // 5. Show OTP dialog; on success sign-in and navigate
        _showOtpDialog(
          email: email,
          userName: name,
          onSuccess: () async {
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email,
                password: _passwordController.text.trim(),
              );
              _onOtpSuccess(name);
            } catch (_) {
              _showErrorSnack(
                  'Verification passed! Please log in manually.');
              setState(() {
                isLogin = true;
                _tabController.animateTo(0);
              });
            }
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnack(_mapFirebaseError(e.code));
      if (mounted) setState(() => isLoading = false);
    } catch (e) {
      _showErrorSnack(e.toString());
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ── LOGIN ─────────────────────────────────
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user!;
      await user.reload();
      final freshUser = FirebaseAuth.instance.currentUser!;

      if (!freshUser.emailVerified) {
        // Account was created but never OTP-verified via our flow.
        // We treat unverified accounts as needing OTP still.
        await FirebaseAuth.instance.signOut();
        if (mounted) _showEmailNotVerifiedDialog(freshUser.email ?? '');
        setState(() => isLoading = false);
        return;
      }

      // Verified → send OTP for 2FA
      final otp = _generateOTP();
      _storedOtp = otp;
      await _sendOtpEmail(freshUser.email!, otp);

      if (mounted) {
        setState(() => isLoading = false);
        _showOtpDialog(
          email: freshUser.email!,
          userName: freshUser.displayName ?? freshUser.email ?? 'Student',
          onSuccess: () => _onOtpSuccess(
            freshUser.displayName ?? freshUser.email ?? 'Student',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnack(_mapFirebaseError(e.code));
      if (mounted) setState(() => isLoading = false);
    } catch (e) {
      _showErrorSnack(e.toString());
      if (mounted) setState(() => isLoading = false);
    }
  }

  
  // ── OTP helpers ───────────────────────────
  String _generateOTP() {
    final rng = Random.secure();
    return (100000 + rng.nextInt(900000)).toString();
  }

  Future<void> _sendOtpEmail(String email, String otp) async {
    const serviceId = 'service_l7bfilv';
    const templateId = 'template_rfu79md';
    const publicKey = 'Pna7F3vG6_-rpr_OH';

    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'email': email,
          'passcode': otp,
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to send OTP: ${response.body}',
      );
    }
  }

  // ── UNIFIED OTP DIALOG ────────────────────
  void _showOtpDialog({
    required String email,
    required String userName,
    required VoidCallback onSuccess,
  }) {
    final otpControllers = List.generate(6, (_) => TextEditingController());
    final focusNodes = List.generate(6, (_) => FocusNode());
    int secondsLeft = 120;
    Timer? countdownTimer;
    bool canResend = false;
    bool otpError = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            countdownTimer ??=
                Timer.periodic(const Duration(seconds: 1), (t) {
              if (secondsLeft <= 0) {
                t.cancel();
                setDialogState(() => canResend = true);
              } else {
                setDialogState(() => secondsLeft--);
              }
            });

            String formatTime(int s) =>
                '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

            void verify() {
              final entered =
                  otpControllers.map((c) => c.text).join();
              if (entered == _storedOtp) {
                countdownTimer?.cancel();
                Navigator.of(ctx).pop();
                onSuccess();
              } else {
                setDialogState(() => otpError = true);
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📧', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 12),
                    const Text(
                      'Verify Your Email',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C3489),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We sent a 6-digit code to\n$email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),

                    // OTP boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (i) {
                        return SizedBox(
                          width: 34,
                          height: 40,
                          child: TextField(
                            controller: otpControllers[i],
                            focusNode: focusNodes[i],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3C3489)),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: otpError
                                  ? Colors.red.shade50
                                  : const Color(0xFFF3F2FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: otpError
                                      ? Colors.red
                                      : const Color(0xFFCECBF6),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: otpError
                                      ? Colors.red
                                      : const Color(0xFFCECBF6),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFF534AB7), width: 2),
                              ),
                            ),
                            onChanged: (v) {
                              setDialogState(() => otpError = false);
                              if (v.isNotEmpty && i < 5) {
                                focusNodes[i + 1].requestFocus();
                              } else if (v.isEmpty && i > 0) {
                                focusNodes[i - 1].requestFocus();
                              }
                              // Auto-verify when last digit entered
                              if (i == 5 && v.isNotEmpty) verify();
                            },
                          ),
                        );
                      }),
                    ),

                    if (otpError) ...[
                      const SizedBox(height: 8),
                      Text('Incorrect code. Try again.',
                          style: TextStyle(
                              color: Colors.red.shade600, fontSize: 12)),
                    ],

                    const SizedBox(height: 20),

                    canResend
                        ? TextButton(
                            onPressed: () async {
                              final newOtp = _generateOTP();
                              _storedOtp = newOtp;
                              await _sendOtpEmail(email, newOtp);
                              setDialogState(() {
                                canResend = false;
                                secondsLeft = 120;
                                otpError = false;
                                for (final c in otpControllers) c.clear();
                                focusNodes[0].requestFocus();
                                countdownTimer = Timer.periodic(
                                    const Duration(seconds: 1), (t) {
                                  if (secondsLeft <= 0) {
                                    t.cancel();
                                    setDialogState(() => canResend = true);
                                  } else {
                                    setDialogState(() => secondsLeft--);
                                  }
                                });
                              });
                            },
                            child: const Text(
                              'Resend Code',
                              style: TextStyle(
                                  color: Color(0xFF534AB7),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Text(
                            'Resend in ${formatTime(secondsLeft)}',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500),
                          ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: verify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF534AB7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'VERIFY & CONTINUE',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) => countdownTimer?.cancel());
  }

  void _onOtpSuccess(String userName) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => WelcomeScreen(userName: userName),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── DIALOGS ───────────────────────────────
  void _showEmailNotVerifiedDialog(String email) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              const Text(
                'Email Not Verified',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C3489),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please complete OTP verification for\n$email\nbefore logging in.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF534AB7)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('CANCEL',
                          style: TextStyle(color: Color(0xFF534AB7))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        final otp = _generateOTP();
                        _storedOtp = otp;
                        await _sendOtpEmail(email, otp);
                        if (mounted) {
                          _showOtpDialog(
                            email: email,
                            userName: email,
                            onSuccess: () async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password:
                                      _passwordController.text.trim(),
                                );
                                _onOtpSuccess(email);
                              } catch (_) {
                                _showErrorSnack(
                                    'Please try logging in again.');
                              }
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF534AB7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('SEND OTP',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── UTILITIES ─────────────────────────────
  void _showErrorSnack(String message, {bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess
            ? Colors.green.shade700
            : Colors.deepPurple.shade700,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'too-many-requests':
        return 'Too many attempts. Please wait.';
      default:
        return 'Authentication failed';
    }
  }

  Future<void> submitAuthForm() async {
    if (isLogin) {
      await _handleLogin();
    } else {
      await _handleSignUp();
    }
  }

  // ── BUILD ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnim,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _bgAnim.value,
                end: Alignment(-_bgAnim.value.x, -_bgAnim.value.y),
                colors: const [
                  Color(0xFF0F0C29),
                  Color(0xFF302b63),
                  Color(0xFF1a1050),
                ],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            ...List.generate(12, (i) => _StarParticle(index: i)),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(_fadeAnim),
                    child: _buildCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FloatingRocket(),
            const SizedBox(height: 16),
            Text(
              isLogin ? 'Student Login' : 'Create Account',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C3489),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isLogin
                  ? 'Sign in to your account'
                  : 'Start your math adventure',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),

            // Flow indicator
            const SizedBox(height: 14),
            _buildFlowIndicator(),

            const SizedBox(height: 20),
            _buildTabBar(),
            const SizedBox(height: 24),

            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  _buildInputField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Your name',
                    icon: Icons.person_outline_rounded,
                    validator: (v) =>
                        !isLogin && (v == null || v.trim().isEmpty)
                            ? 'Enter your name'
                            : null,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              crossFadeState: isLogin
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),

            _buildInputField(
              controller: _emailController,
              label: 'Student Email',
              hint: 'you@school.edu',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty || !v.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: isLogin
                  ? const SizedBox.shrink()
                  : _passStrength > 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _passStrength,
                                  color: _strengthColor,
                                  backgroundColor: Colors.grey.shade200,
                                  minHeight: 4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _strengthLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _strengthColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
            ),

            AnimatedCrossFade(
              firstChild: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  ),
                  child: const Text(
                    'Forgot password?',
                    style:
                        TextStyle(color: Color(0xFF7F77DD), fontSize: 13),
                  ),
                ),
              ),
              secondChild: const SizedBox(height: 16),
              crossFadeState: isLogin
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 200),
            ),

            isLoading
                ? const CircularProgressIndicator(
                    color: Color(0xFF534AB7))
                : _buildSubmitButton(),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin
                      ? "Don't have an account?"
                      : 'Already have an account?',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 13),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                      _tabController.animateTo(isLogin ? 0 : 1);
                    });
                  },
                  style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6)),
                  child: Text(
                    isLogin ? 'Sign up' : 'Login',
                    style: const TextStyle(
                      color: Color(0xFF534AB7),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Flow indicator ────────────────────────
  Widget _buildFlowIndicator() {
    final steps = isLogin
        ? [
            ('1', 'Login', true),
            ('2', 'OTP Code', true),
            ('3', 'Enter', false),
          ]
        : [
            ('1', 'Sign Up', true),
            ('2', 'OTP Code', true),
            ('3', 'Enter', false),
          ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCECBF6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            _stepChip(steps[i].$1, steps[i].$2, steps[i].$3),
            if (i < steps.length - 1) _stepArrow(),
          ],
        ],
      ),
    );
  }

  Widget _stepChip(String num, String label, bool done) {
    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: done
                ? const Color(0xFF534AB7)
                : const Color(0xFFCECBF6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              num,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(label,
            style: TextStyle(
                fontSize: 9,
                color: done
                    ? const Color(0xFF534AB7)
                    : Colors.grey.shade400,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _stepArrow() => Padding(
        padding: const EdgeInsets.only(bottom: 14, left: 4, right: 4),
        child: Icon(Icons.chevron_right,
            size: 16, color: Colors.grey.shade400),
      );

  // ── Forgot password ───────────────────────
  void _showForgotPasswordDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔑', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text(
                'Reset Password',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C3489)),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your email and we\'ll send a reset link.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'you@school.edu',
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: Color(0xFFAFA9EC), size: 20),
                  filled: true,
                  fillColor: const Color(0xFFFAFAFF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFCECBF6)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFCECBF6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF534AB7), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () async {
                    if (ctrl.text.trim().isEmpty) return;
                    Navigator.of(ctx).pop();
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: ctrl.text.trim());
                      _showErrorSnack('Reset email sent!',
                          isSuccess: true);
                    } catch (_) {
                      _showErrorSnack('Could not send reset email.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF534AB7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('SEND RESET LINK',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEEDFE),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF534AB7),
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF534AB7).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF7F77DD),
        labelStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14),
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: 'Login'), Tab(text: 'Sign Up')],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7F77DD),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon,
                color: const Color(0xFFAFA9EC), size: 20),
            filled: true,
            fillColor: const Color(0xFFFAFAFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFCECBF6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFCECBF6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFF534AB7), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.redAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7F77DD),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _passwordController,
          obscureText: obscurePassword,
          onChanged: isLogin ? null : _updatePasswordStrength,
          validator: (v) {
            if (v == null || v.trim().length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle:
                TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(Icons.lock_outline_rounded,
                color: Color(0xFFAFA9EC), size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFFAFA9EC),
                size: 20,
              ),
              onPressed: () =>
                  setState(() => obscurePassword = !obscurePassword),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFCECBF6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFCECBF6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFF534AB7), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.redAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: submitAuthForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF534AB7),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 6,
          shadowColor: const Color(0xFF534AB7).withOpacity(0.5),
        ),
        child: Text(
          isLogin ? 'LOGIN' : 'SIGN UP',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  FLOATING ROCKET WIDGET
// ─────────────────────────────────────────
class _FloatingRocket extends StatefulWidget {
  @override
  State<_FloatingRocket> createState() => _FloatingRocketState();
}

class _FloatingRocketState extends State<_FloatingRocket>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: const Text('🚀', style: TextStyle(fontSize: 72)),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  STAR PARTICLE WIDGET
// ─────────────────────────────────────────
class _StarParticle extends StatefulWidget {
  final int index;
  const _StarParticle({required this.index});

  @override
  State<_StarParticle> createState() => _StarParticleState();
}

class _StarParticleState extends State<_StarParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacityAnim;
  late double _x, _y, _size;

  @override
  void initState() {
    super.initState();
    final rng = Random(widget.index * 31);
    _x = rng.nextDouble();
    _y = rng.nextDouble();
    _size = rng.nextDouble() * 2 + 1;

    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500 + rng.nextInt(2000)),
    )..repeat(reverse: true);

    _opacityAnim = Tween<double>(begin: 0.1, end: 0.8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x * MediaQuery.of(context).size.width,
      top: _y * MediaQuery.of(context).size.height,
      child: FadeTransition(
        opacity: _opacityAnim,
        child: Container(
          width: _size,
          height: _size,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  WELCOME SCREEN
// ─────────────────────────────────────────
class WelcomeScreen extends StatefulWidget {
  final String userName;
  const WelcomeScreen({super.key, required this.userName});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _scaleAnim =
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fadeAnim =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ClassSelectionScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Stack(
        children: [
          ...List.generate(16, (i) => _StarParticle(index: i + 20)),
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🚀',
                        style: TextStyle(fontSize: 120)),
                    const SizedBox(height: 24),
                    const Text(
                      'WELCOME',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '🎉 Ready For Math Adventure? 🎉',
                      style: TextStyle(
                          fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}