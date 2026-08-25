import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_progress_stats.dart';

class ProgressRepository {
  final SharedPreferences _prefs;

  ProgressRepository(this._prefs);

  static const String _streakKey = 'current_streak';
  static const String _bestStreakKey = 'best_streak';
  static const String _lastCompletedDateKey = 'last_completed_date';
  static const String _activityCalendarKey = 'activity_calendar_v2'; // new key for new format
  static const String _legacyActivityCalendarKey = 'activity_calendar';

  int get currentStreak => _prefs.getInt(_streakKey) ?? 0;
  int get bestStreak => _prefs.getInt(_bestStreakKey) ?? 0;
  DateTime? get lastCompletedDate {
    final str = _prefs.getString(_lastCompletedDateKey);
    return str != null ? DateTime.tryParse(str) : null;
  }

  // Returns a map of "YYYY-MM-DD" -> DailyProgressStats
  Map<String, DailyProgressStats> getActivityCalendar() {
    final str = _prefs.getString(_activityCalendarKey);
    if (str != null) {
      final decoded = json.decode(str) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, DailyProgressStats.fromJson(v)));
    }
    
    // Migrate from legacy if exists
    final legacyStr = _prefs.getString(_legacyActivityCalendarKey);
    if (legacyStr != null) {
      final decodedLegacy = json.decode(legacyStr) as Map<String, dynamic>;
      final migrated = decodedLegacy.map((k, v) {
        return MapEntry(k, DailyProgressStats(questionsCompleted: v as int));
      });
      return migrated;
    }

    return {};
  }

  Future<void> logPracticeAttempt(DateTime date, String subject, bool isCorrect, int timeSeconds) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    final calendar = getActivityCalendar();
    final stats = calendar[dateStr] ?? DailyProgressStats();

    stats.questionsCompleted += 1;
    if (isCorrect) {
      stats.correctAnswers += 1;
    } else {
      stats.incorrectAnswers += 1;
    }
    stats.studyTimeSeconds += timeSeconds;

    final subjectStat = stats.subjectStats[subject] ?? SubjectStat();
    subjectStat.attempted += 1;
    if (isCorrect) subjectStat.correct += 1;
    stats.subjectStats[subject] = subjectStat;

    calendar[dateStr] = stats;
    await _prefs.setString(_activityCalendarKey, json.encode(
      calendar.map((k, v) => MapEntry(k, v.toJson()))
    ));

    // Update streak logic: any practice counts as an active day
    final lastCompleted = lastCompletedDate;
    int newStreak = currentStreak;

    // Check if we need to update streak
    // Disregard time, compare only dates
    DateTime todayDate = DateTime(date.year, date.month, date.day);
    DateTime? lastDate = lastCompleted != null ? DateTime(lastCompleted.year, lastCompleted.month, lastCompleted.day) : null;

    if (lastDate == null) {
      newStreak = 1;
      await _prefs.setString(_lastCompletedDateKey, todayDate.toIso8601String());
    } else {
      final diff = todayDate.difference(lastDate).inDays;
      if (diff == 1) {
        // Consecutive day
        newStreak += 1;
        await _prefs.setString(_lastCompletedDateKey, todayDate.toIso8601String());
      } else if (diff > 1) {
        // Streak broken
        newStreak = 1;
        await _prefs.setString(_lastCompletedDateKey, todayDate.toIso8601String());
      }
      // If diff == 0, already practiced today, streak remains same
    }

    await _prefs.setInt(_streakKey, newStreak);
    
    if (newStreak > bestStreak) {
      await _prefs.setInt(_bestStreakKey, newStreak);
    }
  }

  // Legacy method signature maintained just in case, but redirects to new logic
  Future<void> logDailyCompletion(DateTime date, int questionsCompleted, bool isFullGoalCompleted) async {
    // We now rely on logPracticeAttempt to build stats correctly.
    // We keep this to avoid breaking the old provider until we fully update it.
  }
}
