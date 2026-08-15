import 'package:flutter/material.dart';
import '../data/job_repository.dart';
import '../models/government_job.dart';

class JobProvider extends ChangeNotifier {
  final JobRepository repository;

  JobProvider(this.repository) {
    loadJobs();
  }

  List<GovernmentJob> _jobs = [];
  bool _isLoading = false;
  String? _error;
  String _query = '';
  JobCategory? _categoryFilter;
  String? _stateFilter;
  String? _qualificationFilter;
  GovernmentType? _govtTypeFilter;
  bool _bookmarksOnly = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get bookmarksOnly => _bookmarksOnly;
  JobCategory? get categoryFilter => _categoryFilter;
  String? get stateFilter => _stateFilter;
  String? get qualificationFilter => _qualificationFilter;
  GovernmentType? get govtTypeFilter => _govtTypeFilter;
  String get query => _query;

  List<GovernmentJob> get jobs {
    return _jobs.where((job) {
      final matchesQuery = _query.isEmpty ||
          job.title.toLowerCase().contains(_query.toLowerCase()) ||
          job.organization.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _categoryFilter == null || job.category == _categoryFilter;
      final matchesState =
          _stateFilter == null || job.state.toLowerCase() == _stateFilter!.toLowerCase() || job.state.toLowerCase() == 'all india';
      final matchesQualification =
          _qualificationFilter == null || job.qualification.toLowerCase().contains(_qualificationFilter!.toLowerCase());
      final matchesGovtType =
          _govtTypeFilter == null || job.govtType == _govtTypeFilter;
      final matchesBookmark = !_bookmarksOnly || job.isBookmarked;
      
      return matchesQuery &&
          matchesCategory &&
          matchesState &&
          matchesQualification &&
          matchesGovtType &&
          matchesBookmark;
    }).toList()
      ..sort((a, b) => (a.lastDate ?? DateTime(2100))
          .compareTo(b.lastDate ?? DateTime(2100)));
  }

  Future<void> loadJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _jobs = await repository.fetchJobs();
    } catch (e) {
      _error = 'Could not load jobs. Pull to refresh to try again.';
    }
    _isLoading = false;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategoryFilter(JobCategory? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setAdvancedFilters({
    String? state,
    String? qualification,
    GovernmentType? govtType,
  }) {
    _stateFilter = state;
    _qualificationFilter = qualification;
    _govtTypeFilter = govtType;
    notifyListeners();
  }

  void toggleBookmarksOnly() {
    _bookmarksOnly = !_bookmarksOnly;
    notifyListeners();
  }

  void toggleBookmark(String jobId) {
    final job = _jobs.firstWhere((j) => j.id == jobId);
    job.isBookmarked = !job.isBookmarked;
    notifyListeners();
  }

  GovernmentJob? byId(String id) {
    try {
      return _jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }
}
