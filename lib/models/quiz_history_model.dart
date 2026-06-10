import 'package:cloud_firestore/cloud_firestore.dart';

class QuizHistory {
  final String chapterName;
  final int classLevel;
  final int score;
  final int totalQuestions;
  final int mistakes;
  final double accuracy;
  final DateTime timestamp;

  QuizHistory({
    required this.chapterName,
    required this.classLevel,
    required this.score,
    required this.totalQuestions,
    required this.mistakes,
    required this.accuracy,
    required this.timestamp,
  });

  /// Converts the Dart object properties into a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'chapterName': chapterName,
      'classLevel': classLevel,
      'score': score,
      'totalQuestions': totalQuestions,
      'mistakes': mistakes,
      'accuracy': accuracy,
      'timestamp': FieldValue.serverTimestamp(), // Uses database network clock time
    };
  }
}