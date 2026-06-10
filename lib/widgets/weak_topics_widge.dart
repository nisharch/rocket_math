import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/quiz_service.dart';
import '../screens/unending_quiz_screen.dart';

class WeakTopicsWidget extends StatelessWidget {
  final Student student;

  const WeakTopicsWidget({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: QuizService().watchWeakestChapters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Silent loader for gameplay flow
        }

        // Filter: ONLY show chapters that match the student's current logged-in class level 
        // AND where their historical running average accuracy falls below 70%
        final weakChapters = snapshot.data?.where((chapter) {
          double accuracy = (chapter['averageAccuracy'] as double) * 100;
          int chapterClassLevel = chapter['classLevel'] ?? student.selectedClass;
          
          return accuracy < 70.0 && chapterClassLevel == student.selectedClass;
        }).toList() ?? [];

        // If the kid has excellent scores or hasn't played matches yet, return an encouraging empty state banner
        if (weakChapters.isEmpty) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD1E4E0), width: 1.5),
            ),
            child: const Row(
              children: [
                Text("🚀", style: TextStyle(fontSize: 26)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "All satellite shields optimal! No weak chapters found for your class track yet.",
                    style: TextStyle(color: Color(0xFF2F1B7A), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text("⚠️ ", style: TextStyle(fontSize: 16)),
                  Text(
                    "Targeted Weak Chapters Zone",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF4757)),
                  ),
                ],
              ),
            ),
            
            // Generate separate individual action tiles for each weak point uncovered
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: weakChapters.length,
              itemBuilder: (context, index) {
                final item = weakChapters[index];
                double accuracyPercent = item['averageAccuracy'] * 100;
                String rawName = item['chapterName'].toString();
                String cleanDisplayTitle = rawName.contains(':') ? rawName.split(':').last.trim() : rawName;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2E6), // Clear noticeable warning tint frame
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFB07C), width: 1.5),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFFF4757),
                      radius: 14,
                      child: Icon(Icons.trending_down_rounded, color: Colors.white, size: 16),
                    ),
                    title: Text(
                      cleanDisplayTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2F1B7A)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "Current Accuracy: ${accuracyPercent.toStringAsFixed(0)}% • Tap to practice!",
                        style: const TextStyle(color: Color(0xFFD35400), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFFF4757), size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UnendingQuizScreen(
                            chapterName: rawName,
                            classLevel: student.selectedClass,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}