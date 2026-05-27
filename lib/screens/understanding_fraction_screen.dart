import 'dart:math';
import 'package:flutter/material.dart';

class UnderstandingFractionsScreen extends StatefulWidget {
  const UnderstandingFractionsScreen({super.key});

  @override
  State<UnderstandingFractionsScreen> createState() => _UnderstandingFractionsScreenState();
}

class _UnderstandingFractionsScreenState extends State<UnderstandingFractionsScreen> {
  int _step = 0;

  final List<String> _instructions = [
    "Step 1: What is a Fraction? 🍰\nA fraction represents part of a whole group or shape. It has two main numbers!",
    "Step 2: Meet the Top Number (Numerator) 🔝\nThe numerator shows how many equal parts we are talking about or have shaded.",
    "Step 3: Meet the Bottom Number (Denominator) 🛑\nThe denominator shows the TOTAL number of equal parts the whole is cut into.",
    "Step 4: Let's read this fraction:\nIf a pizza has 4 total slices, and you eat 3 of them...\nYou ate 3 / 4 of the pizza! 🍕"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text("Fraction Lab 🍕"),
        backgroundColor: Colors.orange.shade800,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // ---------------- VISUAL WORKSPACE ----------------
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.orangeAccent,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Fraction visual stacking text layout
                      _step >= 1 
                          ? Column(
                              children: [
                                Text(
                                  "3", 
                                  style: TextStyle(
                                    fontSize: 50, 
                                    fontWeight: FontWeight.bold, 
                                    color: _step == 1 ? Colors.blue.shade700 : Colors.black87
                                  )
                                ),
                                Container(width: 60, height: 4, color: Colors.black),
                                Text(
                                  "4", 
                                  style: TextStyle(
                                    fontSize: 50, 
                                    fontWeight: FontWeight.bold, 
                                    color: _step == 2 ? Colors.red.shade700 : Colors.black87
                                  )
                                ),
                              ],
                            )
                          : const Text(
                              "3 / 4",
                              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                      const Divider(thickness: 2, height: 35),
                      
                      // LABEL LABELS HELPERS
                      if (_step >= 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 12, height: 12, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            const Text("Numerator (Parts we have)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      const SizedBox(height: 8),
                      if (_step >= 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 12, height: 12, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            const Text("Denominator (Total parts)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- INSTRUCTION CARD ----------------
              _buildInstructionCard(),

              const SizedBox(height: 20),

              // ---------------- QUIZ BUTTON ----------------
              _buildQuizButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade900,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.orangeAccent, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            "Fraction Bot 🤖",
            style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            _instructions[_step % _instructions.length],
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: () {
              setState(() {
                _step = (_step + 1) % _instructions.length;
              });
            },
            child: const Text("Next Step ⚙️", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () => _openQuizDialog(context),
          child: const Text(
            "QUIZ MODE ✍️",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FRACTIONS QUIZ DIALOG
  // =========================================================
  void _openQuizDialog(BuildContext context) {
    final random = Random();

    // Challenge values
    late int totalParts;
    late int selectedParts;
    late List<String> options;
    late int correctIndex;
    late String wordProblem;

    int chancesLeft = 3;
    String feedbackMessage = "";
    Color borderColor = Colors.orangeAccent;
    bool gameEnded = false;
    int selectedAnswerIndex = -1;

    void generateNewQuestion() {
      selectedAnswerIndex = -1;
      chancesLeft = 3;
      gameEnded = false;
      borderColor = Colors.orangeAccent;

      // Class 4 standard denominators: 3, 4, 5, 6, 8, 10
      List<int> denominators = [3, 4, 5, 6, 8, 10];
      totalParts = denominators[random.nextInt(denominators.length)];
      // Selected parts must be less than total parts
      selectedParts = random.nextInt(totalParts - 1) + 1;

      List<String> items = ["pizza", "cake", "chocolate bar", "garden plot", "watermelon"];
      String selectedItem = items[random.nextInt(items.length)];

      wordProblem = "A $selectedItem is cut into $totalParts equal slices. You eat $selectedParts parts. What fraction did you eat?";
      feedbackMessage = "Pick the correct matching fraction match!";

      options = [];
      String correctFraction = "$selectedParts/$totalParts";
      options.add(correctFraction);

      // Generate wrong random alternate fractions
      while (options.length < 4) {
        int wrongNum = random.nextInt(9) + 1;
        int wrongDen = random.nextInt(9) + 2;
        String wrongFraction = "$wrongNum/$wrongDen";
        
        if (wrongNum != wrongDen && !options.contains(wrongFraction) && wrongFraction != correctFraction) {
          options.add(wrongFraction);
        }
      }

      options.shuffle();
      correctIndex = options.indexOf(correctFraction);
    }

    // Initialize first challenge question run
    generateNewQuestion();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {

            void checkCurrentAnswer() {
              if (selectedAnswerIndex == -1) {
                setDialogState(() {
                  feedbackMessage = "Please choose a fraction card option first! 🤔";
                });
                return;
              }

              if (selectedAnswerIndex == correctIndex) {
                setDialogState(() {
                  feedbackMessage = "Spot on! That's correct! 🎉";
                  borderColor = Colors.green;
                  gameEnded = true;
                });
              } else {
                setDialogState(() {
                  chancesLeft--;
                  if (chancesLeft > 0) {
                    feedbackMessage = "Oops! Wrong fraction ❌ Try again! ($chancesLeft chances left)";
                    borderColor = Colors.red;
                    selectedAnswerIndex = -1; // Reset tap focus selection active state
                  } else {
                    feedbackMessage = "Game Over! 😭 Correct answer was: $selectedParts/$totalParts";
                    borderColor = Colors.red;
                    gameEnded = true;
                  }
                });
              }
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: borderColor, width: 4),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Fraction Quiz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  if (!gameEnded)
                    Text("❤️ x$chancesLeft", style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dynamic Story Question Card
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        wordProblem,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.3),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      feedbackMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: borderColor == Colors.orangeAccent ? Colors.white : borderColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Multi Option 2x2 Grid Selection block layout
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.6,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final bool isSelected = selectedAnswerIndex == index;
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.cyanAccent : Colors.white,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: gameEnded ? null : () {
                            setDialogState(() {
                              selectedAnswerIndex = index;
                            });
                          },
                          child: Text(
                            options[index],
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 25),

                    // Evaluation Submit Handler
                    if (!gameEnded)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: checkCurrentAnswer,
                          child: const Text("Check Answer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),

                    // Post Game controls (Back & Play Again layout configurations)
                    if (gameEnded)
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Back", style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: () {
                                  setDialogState(() {
                                    generateNewQuestion();
                                  });
                                },
                                child: const Text("Play Again", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}