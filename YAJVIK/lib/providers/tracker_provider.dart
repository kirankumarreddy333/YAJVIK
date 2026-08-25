import 'package:flutter/material.dart';
import '../models/application.dart';
import '../models/government_job.dart';

class TrackerProvider extends ChangeNotifier {
  final List<JobApplication> _applications = [];

  List<JobApplication> get applications =>
      List.unmodifiable(_applications..sort((a, b) => b.appliedDate.compareTo(a.appliedDate)));

  bool isTracked(String jobId) =>
      _applications.any((a) => a.jobId == jobId);

  void track(GovernmentJob job) {
    if (isTracked(job.id)) return;
    _applications.add(
      JobApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        jobId: job.id,
        jobTitle: job.title,
        organization: job.organization,
        status: ApplicationStatus.applied,
        appliedDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateStatus(String applicationId, ApplicationStatus status) {
    final app = _applications.firstWhere((a) => a.id == applicationId);
    app.status = status;
    notifyListeners();
  }

  void updateNotes(String applicationId, String notes) {
    final app = _applications.firstWhere((a) => a.id == applicationId);
    app.notes = notes;
    notifyListeners();
  }

  void remove(String applicationId) {
    _applications.removeWhere((a) => a.id == applicationId);
    notifyListeners();
  }

  Map<ApplicationStatus, int> get statusCounts {
    final map = <ApplicationStatus, int>{};
    for (final status in ApplicationStatus.values) {
      map[status] = _applications.where((a) => a.status == status).length;
    }
    return map;
  }
}
