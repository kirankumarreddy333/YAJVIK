import 'package:flutter/material.dart';
import '../models/daily_question.dart';
import '../data/question_repository.dart';

class QuestionProvider extends ChangeNotifier {
  final QuestionRepository _repository;
  
  List<DailyQuestion> _todayQuestions = [];
  bool _isLoading = false;
  String? _error;

  List<DailyQuestion> get todayQuestions => _todayQuestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  QuestionProvider(this._repository);

  Future<void> loadTodayQuestions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todayQuestions = await _repository.fetchDailyQuestions(DateTime.now());
    } catch (e) {
      _error = 'Failed to load questions: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> answerQuestion(String questionId, int selectedIndex) async {
    final index = _todayQuestions.indexWhere((q) => q.id == questionId);
    if (index >= 0) {
      final q = _todayQuestions[index];
      if (q.isAnswered) return; // Prevent changing answer

      q.userSelectedIndex = selectedIndex;
      notifyListeners();

      await _repository.saveAnswer(questionId, selectedIndex, DateTime.now());
    }
  }

  int get completedCount => _todayQuestions.where((q) => q.isAnswered).length;
  bool get isGoalCompleted => _todayQuestions.isNotEmpty && completedCount == _todayQuestions.length;
}
