class Student {
  final String id;
  final int selectedClass; // 3 or 4
  int totalScore;
  int streak;

  // Track performance per chapter
  Map<String, int> correctCount;
  Map<String, int> wrongCount;
  Map<String, double> masteryScore;

  Student({
    required this.id,
    required this.selectedClass,
    this.totalScore = 0,
    this.streak = 0,
    Map<String, int>? correctCount,
    Map<String, int>? wrongCount,
    Map<String, double>? masteryScore,
  })  : correctCount = correctCount ?? {},
        wrongCount = wrongCount ?? {},
        masteryScore = masteryScore ?? {};
}
