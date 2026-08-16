class ExamResult {
  final String id;
  final String examName;
  final String organization;
  final DateTime examDate;
  final DateTime? resultDate; // Expected or actual
  final String status; // 'Upcoming', 'Released', 'Previous'
  final String officialLink;
  final String? notificationLink;

  ExamResult({
    required this.id,
    required this.examName,
    required this.organization,
    required this.examDate,
    this.resultDate,
    required this.status,
    required this.officialLink,
    this.notificationLink,
  });
}
