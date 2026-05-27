

class Question {
  final String id;
  final String chapter;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final int difficulty; // 1 = Easy, 2 = Medium, 3 = Hard

  Question({
    required this.id,
    required this.chapter,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
  });
}