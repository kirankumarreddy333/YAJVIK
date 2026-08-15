enum ApplicationStatus {
  applied,
  examScheduled,
  admitCard,
  result,
  interview,
  offer,
  rejected,
  selected,
}

extension ApplicationStatusLabel on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.examScheduled:
        return 'Exam';
      case ApplicationStatus.admitCard:
        return 'Admit Card';
      case ApplicationStatus.result:
        return 'Result';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offer:
        return 'Offer';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.selected:
        return 'Selected';
    }
  }
}

class JobApplication {
  final String id;
  final String jobId;
  final String jobTitle;
  final String organization;
  ApplicationStatus status;
  final DateTime appliedDate;
  String notes;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.organization,
    required this.status,
    required this.appliedDate,
    this.notes = '',
  });
}
