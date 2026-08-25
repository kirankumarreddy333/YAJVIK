import 'package:flutter/material.dart';
import '../models/exam_preparation.dart';
import '../data/exam_repository.dart';

class ExamProvider extends ChangeNotifier {
  final ExamRepository _repository;
  
  List<ExamPreparation> _exams = [];
  bool _isLoading = false;

  List<ExamPreparation> get exams => _exams;
  bool get isLoading => _isLoading;

  ExamProvider(this._repository);

  Future<void> loadExams() async {
    _isLoading = true;
    notifyListeners();

    try {
      _exams = await _repository.fetchExams();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getTopicProgress(String examId, String topicId) {
    return _repository.getTopicProgress(examId, topicId);
  }

  Future<void> updateTopicProgress(String examId, String topicId, int status) async {
    await _repository.saveTopicProgress(examId, topicId, status);
    notifyListeners();
  }
}
