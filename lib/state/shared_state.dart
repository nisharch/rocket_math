class ChapterLog {
  int highPoints = 0;
  int currentLevel = 1;
  int totalAttempted = 0;
  int correctAnswers = 0;

  double get accuracy => totalAttempted == 0 ? 100.0 : (correctAnswers / totalAttempted) * 100;
}

class AppStateManager {
  // গ্লোবাল স্টেট ম্যাপ (সব চ্যাপ্টারের ডেটা ট্র্যাক রাখার জন্য)
  static final Map<String, ChapterLog> chapterLogs = {
    "subtraction": ChapterLog(),
    "multiplication": ChapterLog(),
    "division": ChapterLog(),
    "measurement": ChapterLog(),
    "time": ChapterLog(),
    "money": ChapterLog(),
    "shapes": ChapterLog(),
    "large numbers": ChapterLog(),
    "adv multiplication": ChapterLog(),
    "long division": ChapterLog(),
    "fractions": ChapterLog(),
    "perimeter area": ChapterLog(),
  };

  // কুইজ শেষে ডেটা লগ করার মেথড
  static void updateLog(String chapter, int points, int finalLevel, int attempted, int correct) {
    final log = chapterLogs[chapter.toLowerCase().trim()];
    if (log != null) {
      log.totalAttempted += attempted;
      log.correctAnswers += correct;
      log.currentLevel = finalLevel;
      if (points > log.highPoints) {
        log.highPoints = points;
      }
    }
  }

  // ড্যাশবোর্ডের জন্য সিঙ্গেল দুর্বল চ্যাপ্টার টেক্সট আকারে সনাক্ত করার মেথড
  static String getWeakestChapter() {
    String weakest = "None (Play some quizzes first!)";
    double lowestAccuracy = 101.0; 
    bool playedAny = false;

    chapterLogs.forEach((chapter, log) {
      if (log.totalAttempted > 0) {
        playedAny = true;
        if (log.accuracy < lowestAccuracy) {
          lowestAccuracy = log.accuracy;
          weakest = chapter.toUpperCase();
        }
      }
    });

    if (!playedAny) return "No data yet! Play quizzes to detect.";
    return "$weakest (${lowestAccuracy.toStringAsFixed(0)}% Accuracy)";
  }

  // ড্যাশবোর্ডের টোটাল এক্সপি (XP) ক্যালকুলেট করার মেথড
  static int getTotalXP() {
    int total = 0;
    chapterLogs.forEach((key, log) {
      total += log.highPoints;
    });
    return total;
  }

  // সব চ্যাপ্টারের লাইভ পারফরম্যান্স লিস্ট আকারে রিটার্ন করার মেথড (ড্যাশবোর্ড কার্ডের জন্য)
  static List<Map<String, dynamic>> getChapterPerformanceList() {
    List<Map<String, dynamic>> list = [];
    
    chapterLogs.forEach((chapter, log) {
      if (log.totalAttempted > 0) {
        list.add({
          "topic": chapter.toUpperCase(),
          "points": log.highPoints,
          "accuracy": log.accuracy,
          "correct": log.correctAnswers,
          "total": log.totalAttempted,
          "level": log.currentLevel,
        });
      }
    });
    
    return list;
  }
}