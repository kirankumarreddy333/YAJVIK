import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_question.dart';
import 'question_repository.dart';

class MockQuestionRepository implements QuestionRepository {
  final SharedPreferences _prefs;

  MockQuestionRepository(this._prefs);

  @override
  Future<List<DailyQuestion>> fetchDailyQuestions(DateTime date) async {
    // Generate deterministic questions based on the date so they remain consistent.
    final daySeed = date.year * 10000 + date.month * 100 + date.day;
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final questions = [
      DailyQuestion(
        id: 'apt_${daySeed}_1',
        text: 'If A and B can do a piece of work in 10 days and 15 days respectively, in how many days can they complete it together?',
        options: ['5 days', '6 days', '8 days', '12 days'],
        correctOptionIndex: 1, // 6 days
        explanation: 'Work done by A in 1 day = 1/10. Work done by B in 1 day = 1/15. Total work in 1 day = 1/10 + 1/15 = 5/30 = 1/6. Hence, 6 days.',
        category: QuestionCategory.aptitude,
        dateFor: date,
      ),
      DailyQuestion(
        id: 'verb_${daySeed}_1',
        text: 'Choose the correct synonym for "Benevolent".',
        options: ['Cruel', 'Kind', 'Arrogant', 'Lazy'],
        correctOptionIndex: 1,
        explanation: '"Benevolent" means well meaning and kindly.',
        category: QuestionCategory.verbal,
        dateFor: date,
      ),
      DailyQuestion(
        id: 'reas_${daySeed}_1',
        text: 'Find the next number in the series: 2, 6, 12, 20, 30, ...',
        options: ['40', '42', '44', '48'],
        correctOptionIndex: 1, // 42
        explanation: 'The difference between consecutive numbers is increasing by 2: 4, 6, 8, 10. The next difference is 12. So 30 + 12 = 42.',
        category: QuestionCategory.reasoning,
        dateFor: date,
      ),
      DailyQuestion(
        id: 'curr_${daySeed}_1',
        text: 'Who recently won the Nobel Prize in Physics (mock)?',
        options: ['Alice', 'Bob', 'Charlie', 'Diana'],
        correctOptionIndex: 0,
        explanation: 'Alice won it for her discoveries in Quantum computing. (Mock data)',
        category: QuestionCategory.currentAffairs,
        dateFor: date,
      ),
    ];

    // Load saved answers
    final saved = await fetchSavedAnswers(date);
    for (var q in questions) {
      if (saved.containsKey(q.id)) {
        q.userSelectedIndex = saved[q.id];
      }
    }

    return questions;
  }

  @override
  Future<void> saveAnswer(String questionId, int selectedIndex, DateTime date) async {
    final dateKey = '${date.year}_${date.month}_${date.day}';
    final key = 'daily_questions_$dateKey';
    
    final currentStr = _prefs.getString(key);
    Map<String, dynamic> current = {};
    if (currentStr != null) {
      current = json.decode(currentStr);
    }
    
    current[questionId] = selectedIndex;
    await _prefs.setString(key, json.encode(current));
  }

  @override
  Future<Map<String, int>> fetchSavedAnswers(DateTime date) async {
    final dateKey = '${date.year}_${date.month}_${date.day}';
    final key = 'daily_questions_$dateKey';
    
    final currentStr = _prefs.getString(key);
    if (currentStr != null) {
      final decoded = json.decode(currentStr) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as int));
    }
    return {};
  }
}
