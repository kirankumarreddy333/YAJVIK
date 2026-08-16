import 'package:flutter/material.dart';
import '../models/exam_result.dart';
import '../data/result_repository.dart';

class ResultProvider extends ChangeNotifier {
  final ResultRepository _repository;
  
  List<ExamResult> _results = [];
  bool _isLoading = false;

  List<ExamResult> get results => _results;
  bool get isLoading => _isLoading;

  ResultProvider(this._repository);

  Future<void> loadResults() async {
    _isLoading = true;
    notifyListeners();

    try {
      _results = await _repository.fetchResults();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ExamResult> get upcoming => _results.where((r) => r.status == 'Upcoming').toList();
  List<ExamResult> get released => _results.where((r) => r.status == 'Released').toList();
  List<ExamResult> get previous => _results.where((r) => r.status == 'Previous').toList();
}
