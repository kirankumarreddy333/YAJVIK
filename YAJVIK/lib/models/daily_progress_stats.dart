

class SubjectStat {
  int attempted;
  int correct;

  SubjectStat({this.attempted = 0, this.correct = 0});

  factory SubjectStat.fromJson(Map<String, dynamic> json) {
    return SubjectStat(
      attempted: json['attempted'] ?? 0,
      correct: json['correct'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attempted': attempted,
      'correct': correct,
    };
  }
}

class DailyProgressStats {
  int questionsCompleted;
  int correctAnswers;
  int incorrectAnswers;
  int studyTimeSeconds;
  Map<String, SubjectStat> subjectStats;

  DailyProgressStats({
    this.questionsCompleted = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.studyTimeSeconds = 0,
    Map<String, SubjectStat>? subjectStats,
  }) : subjectStats = subjectStats ?? {};

  double get accuracy => questionsCompleted > 0 ? (correctAnswers / questionsCompleted) * 100 : 0.0;

  factory DailyProgressStats.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> subjectsJson = json['subjectStats'] ?? {};
    final Map<String, SubjectStat> parsedSubjects = {};
    subjectsJson.forEach((key, value) {
      parsedSubjects[key] = SubjectStat.fromJson(value);
    });

    return DailyProgressStats(
      questionsCompleted: json['questionsCompleted'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      incorrectAnswers: json['incorrectAnswers'] ?? 0,
      studyTimeSeconds: json['studyTimeSeconds'] ?? 0,
      subjectStats: parsedSubjects,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> subjectsJson = {};
    subjectStats.forEach((key, value) {
      subjectsJson[key] = value.toJson();
    });

    return {
      'questionsCompleted': questionsCompleted,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'studyTimeSeconds': studyTimeSeconds,
      'subjectStats': subjectsJson,
    };
  }
}
