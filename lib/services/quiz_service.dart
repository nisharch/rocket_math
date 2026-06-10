import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>>
      watchWeakestChapters() {

    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    return _firestore
        .collection('quiz_stats')
        .doc(uid)
        .snapshots()
        .map((snapshot) {

      if (!snapshot.exists) {
        return [];
      }

      final data =
          snapshot.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> chapters = [];

      data.forEach((key, value) {

        if (value is Map<String, dynamic>) {

          int correct =
              value['correctAnswers'] ?? 0;

          int wrong =
              value['wrongAnswers'] ?? 0;

          int total = correct + wrong;

          double accuracy =
              total == 0
                  ? 0
                  : correct / total;

          chapters.add({

            'chapterName':
                value['chapterName'] ?? key,

            'classLevel':
                value['classLevel'] ?? 3,

            'averageAccuracy':
                accuracy,

            'correctAnswers':
                correct,

            'wrongAnswers':
                wrong,
          });
        }
      });

      return chapters;
    });
  }
}