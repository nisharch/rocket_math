import 'dart:math';
import 'package:flutter/material.dart';

class NumbersQuizScreen extends StatefulWidget {
  const NumbersQuizScreen({super.key});

  @override
  State<NumbersQuizScreen> createState() =>
      _NumbersQuizScreenState();
}

class _NumbersQuizScreenState extends State<NumbersQuizScreen> {

  final Random random = Random();

  int score = 0;
  int lives = 3;

  String question = "";
  int correctAnswer = 0;
  List<int> options = [];

  int? selectedIndex;
  bool showCelebration = false;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  // ✅ FIXED QUESTION LOGIC
  void generateQuestion() {
    int type = random.nextInt(2);
    int num = 100 + random.nextInt(900);

    if (type == 0) {
      // 🔥 PLACE VALUE (CORRECT)
      int hundreds = (num ~/ 100) * 100;
      int tens = ((num ~/ 10) % 10) * 10;
      int ones = num % 10;

      int digitIndex = random.nextInt(3);

      if (digitIndex == 0) {
        question = "Place value of $num in Hundreds?";
        correctAnswer = hundreds;

        options = [hundreds, tens, ones, hundreds + 100];
      } 
      else if (digitIndex == 1) {
        question = "Place value of $num in Tens?";
        correctAnswer = tens;

        options = [tens, hundreds, ones, tens + 10];
      } 
      else {
        question = "Place value of $num in Ones?";
        correctAnswer = ones;

        options = [ones, tens, hundreds, ones + 1];
      }
    } 
    else {
      // 🔥 EXPANDED FORM (CORRECT)
      int h = (num ~/ 100) * 100;
      int t = ((num ~/ 10) % 10) * 10;
      int o = num % 10;

      String expandedText = "$h + $t + $o";

      question = "Which number is $expandedText ?";
      correctAnswer = num;

      options = [
        num,
        h + t,
        t + o,
        h + o,
      ];
    }

    options = options.toSet().toList(); // remove duplicates
    options.shuffle();

    selectedIndex = null;

    setState(() {});
  }

  void checkAnswer(int index) {
    setState(() {
      selectedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 400), () {

      if (options[index] == correctAnswer) {
        score++;

        setState(() {
          showCelebration = true;
        });

        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            showCelebration = false;
          });
        });

      } else {
        lives--;
      }

      if (lives == 0) {
        showGameOver();
        return;
      }

      generateQuestion();
    });
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Game Over 💀"),
        content: Text("Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0;
                lives = 3;
              });
              generateQuestion();
            },
            child: const Text("Restart"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B1B3F),

      appBar: AppBar(
        title: const Text("Monster Quiz"),
        backgroundColor: const Color(0xFF2B1B3F),
        elevation: 0,
      ),

      body: Stack(
        children: [

          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF3B2352),
                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text("❤️ $lives",
                          style: const TextStyle(
                              color: Colors.red)),
                      Text("⭐ $score",
                          style: const TextStyle(
                              color: Colors.yellow)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Icon(Icons.android,
                      size: 50,
                      color: Colors.purpleAccent),

                  const SizedBox(height: 20),

                  Text(
                    question,
                    style: const TextStyle(
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {

                      Color color = Colors.purpleAccent;

                      if (selectedIndex != null) {
                        if (index == selectedIndex) {
                          color = options[index] ==
                                  correctAnswer
                              ? Colors.green
                              : Colors.red;
                        }
                      }

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                        ),
                        onPressed: () =>
                            checkAnswer(index),
                        child: Text(
                          options[index].toString(),
                          style: const TextStyle(
                              fontSize: 20),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ),

          if (showCelebration)
            Center(
              child: Text(
                "🎉 Correct!",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
            ),
        ],
      ),
    );
  }
}