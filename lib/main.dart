import 'package:flutter/material.dart';
import 'screens/class_selection_screen.dart';

void main() {
  runApp(const RocketMathApp());
}

class RocketMathApp extends StatelessWidget {
  const RocketMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rocket Math',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _obscurePassword = true;

  void _login() {

    if (_formKey.currentState!.validate()) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF0F0C29),

      body: Center(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24),

          child: Card(

            elevation: 10,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: Padding(

              padding: const EdgeInsets.all(24),

              child: Form(

                key: _formKey,

                child: Column(

                  mainAxisSize: MainAxisSize.min,

                  children: [

                    const Text(
                      "🚀",
                      style: TextStyle(fontSize: 90),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "ROCKET MATH",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Student Login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextFormField(

                      controller: _emailController,

                      decoration: InputDecoration(

                        labelText: "Student Email / ID",

                        prefixIcon: const Icon(Icons.person),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),

                      validator: (value) {

                        if (value == null || value.isEmpty) {
                          return "Please enter Email or ID";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(

                      controller: _passwordController,

                      obscureText: _obscurePassword,

                      decoration: InputDecoration(

                        labelText: "Password",

                        prefixIcon: const Icon(Icons.lock),

                        suffixIcon: IconButton(

                          icon: Icon(

                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),

                          onPressed: () {

                            setState(() {

                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),

                      validator: (value) {

                        if (value == null || value.isEmpty) {
                          return "Please enter Password";
                        }

                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(

                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(

                        onPressed: _login,

                        style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.deepPurple,

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(

                          "LOGIN",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(

                      onPressed: () {},

                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _scaleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    Future.delayed(const Duration(seconds: 3), () {

      if (mounted) {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) => const ClassSelectionScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF0F0C29),

      body: Center(

        child: FadeTransition(

          opacity: _fadeAnim,

          child: ScaleTransition(

            scale: _scaleAnim,

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                const Text(
                  "🚀",
                  style: TextStyle(fontSize: 90),
                ),

                const SizedBox(height: 20),

                const Text(
                  "ROCKET MATH",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Class 3 & 4 Math Adventure",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(height: 50),

                const CircularProgressIndicator(
                  color: Colors.orangeAccent,
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}