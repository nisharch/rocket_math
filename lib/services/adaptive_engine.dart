import '../models/student_model.dart';
import '../models/question_model.dart';

class AdaptiveEngine {

  // Update performance after each answer
  static void updatePerformance({
    required Student student,
    required Question question,
    required bool isCorrect,
  }) {

    String chapter = question.chapter;

    // Initialize if not exists
    student.correctCount.putIfAbsent(chapter, () => 0);
    student.wrongCount.putIfAbsent(chapter, () => 0);
    student.masteryScore.putIfAbsent(chapter, () => 0.0);

    if (isCorrect) {
      student.correctCount[chapter] =
          student.correctCount[chapter]! + 1;

      student.streak++;
      student.totalScore += 10;
    } else {
      student.wrongCount[chapter] =
          student.wrongCount[chapter]! + 1;

      student.streak = 0;
    }

    _calculateMastery(student, chapter);
  }

  // Calculate mastery score
  static void _calculateMastery(Student student, String chapter) {

    int correct = student.correctCount[chapter] ?? 0;
    int wrong = student.wrongCount[chapter] ?? 0;

    int total = correct + wrong;

    if (total == 0) return;

    double mastery = correct / total;

    student.masteryScore[chapter] = mastery;
  }

  // Decide next difficulty level
  static int getNextDifficulty(Student student, String chapter) {

    double mastery = student.masteryScore[chapter] ?? 0.0;

    if (mastery < 0.4) {
      return 1; // Easy
    } else if (mastery < 0.75) {
      return 2; // Medium
    } else {
      return 3; // Hard
    }
  }
}
