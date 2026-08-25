enum JobCategory {
  upsc,
  ssc,
  bank,
  railway,
  defence,
  police,
  psu,
  teaching,
  engineering,
  medical,
  statePsc,
  other,
}

extension JobCategoryLabel on JobCategory {
  String get label {
    switch (this) {
      case JobCategory.upsc:
        return 'UPSC';
      case JobCategory.ssc:
        return 'SSC';
      case JobCategory.bank:
        return 'Banking';
      case JobCategory.railway:
        return 'Railway';
      case JobCategory.defence:
        return 'Defence';
      case JobCategory.police:
        return 'Police & Paramilitary';
      case JobCategory.psu:
        return 'PSU';
      case JobCategory.teaching:
        return 'Teaching';
      case JobCategory.engineering:
        return 'Engineering';
      case JobCategory.medical:
        return 'Medical';
      case JobCategory.statePsc:
        return 'State PSC';
      case JobCategory.other:
        return 'Other Govt Jobs';
    }
  }
}

enum GovernmentType { central, state }

class GovernmentJob {
  final String id;
  final String title;
  final String organization;
  final String department;
  final GovernmentType govtType;
  final String state; // e.g., 'All India', 'Andhra Pradesh'
  final JobCategory category;
  
  final String examName;
  final String postName;
  final String notificationNumber;
  final int examYear;

  final int vacancies;
  final String qualification;
  final String ageLimit;
  final String ageRelaxation;
  final String salary;
  final String applicationFee;
  
  final DateTime? applicationStartDate;
  final DateTime? lastDate;
  final DateTime? examDate;
  final DateTime? admitCardDate;
  final DateTime? resultDate;

  final String selectionProcess;
  final String eligibility; // Detailed description

  final String officialNotification; // Link to PDF
  final String applyLink;
  final String officialResultLink;
  final String officialWebsite;
  final String sourceUrl;

  final DateTime lastVerifiedAt;
  final DateTime lastUpdated;
  
  bool isBookmarked;

  GovernmentJob({
    required this.id,
    required this.title,
    required this.organization,
    this.department = '',
    required this.govtType,
    required this.state,
    required this.category,
    this.examName = '',
    this.postName = '',
    this.notificationNumber = '',
    required this.examYear,
    required this.vacancies,
    required this.qualification,
    required this.ageLimit,
    this.ageRelaxation = '',
    required this.salary,
    this.applicationFee = '',
    this.applicationStartDate,
    required this.lastDate,
    this.examDate,
    this.admitCardDate,
    this.resultDate,
    required this.selectionProcess,
    required this.eligibility,
    this.officialNotification = '',
    required this.applyLink,
    this.officialResultLink = '',
    required this.officialWebsite,
    this.sourceUrl = '',
    required this.lastVerifiedAt,
    required this.lastUpdated,
    this.isBookmarked = false,
  });

  bool get isClosingSoon {
    if (lastDate == null) return false;
    final daysLeft = lastDate!.difference(DateTime.now()).inDays;
    return daysLeft >= 0 && daysLeft <= 5;
  }

  bool get isExpired {
    if (lastDate == null) return false;
    return lastDate!.isBefore(DateTime.now());
  }
}
