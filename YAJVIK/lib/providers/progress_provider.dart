import 'package:flutter/material.dart';
import '../data/progress_repository.dart';
import '../models/daily_progress_stats.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressRepository _repository;
  
  ProgressProvider(this._repository);

  int get currentStreak => _repository.currentStreak;
  int get bestStreak => _repository.bestStreak;
  DateTime? get lastCompletedDate => _repository.lastCompletedDate;

  Map<String, DailyProgressStats> getActivityCalendar() => _repository.getActivityCalendar();

  Future<void> logPracticeAttempt(DateTime date, String subject, bool isCorrect, int timeSeconds) async {
    await _repository.logPracticeAttempt(date, subject, isCorrect, timeSeconds);
    notifyListeners();
  }

  // Calculate totals for a specific month
  DailyProgressStats getMonthSummary(int year, int month) {
    final calendar = getActivityCalendar();
    final summary = DailyProgressStats();
    
    calendar.forEach((dateStr, stats) {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final dYear = int.parse(parts[0]);
        final dMonth = int.parse(parts[1]);
        if (dYear == year && dMonth == month) {
          summary.questionsCompleted += stats.questionsCompleted;
          summary.correctAnswers += stats.correctAnswers;
          summary.incorrectAnswers += stats.incorrectAnswers;
          summary.studyTimeSeconds += stats.studyTimeSeconds;
          
          stats.subjectStats.forEach((subj, subjStat) {
            final existing = summary.subjectStats[subj] ?? SubjectStat();
            existing.attempted += subjStat.attempted;
            existing.correct += subjStat.correct;
            summary.subjectStats[subj] = existing;
          });
        }
      }
    });
    
    return summary;
  }

  int getActiveDaysInMonth(int year, int month) {
    final calendar = getActivityCalendar();
    int count = 0;
    calendar.forEach((dateStr, stats) {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final dYear = int.parse(parts[0]);
        final dMonth = int.parse(parts[1]);
        if (dYear == year && dMonth == month && stats.questionsCompleted > 0) {
          count++;
        }
      }
    });
    return count;
  }
}
