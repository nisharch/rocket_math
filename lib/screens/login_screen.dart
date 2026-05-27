import 'package:flutter/material.dart';
import 'package:rocket_math/screens/class_selection_screen.dart';

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
          builder: (_) => const ClassSelectionScreen(),
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
                      style: TextStyle(fontSize: 80),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Rocket Math Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
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
                          return "Enter Email or ID";
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
                          return "Enter Password";
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
                            color: Colors.white,
                          ),
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