enum QuestionCategory {
  aptitude,
  verbal,
  reasoning,
  currentAffairs,
}

extension QuestionCategoryLabel on QuestionCategory {
  String get label {
    switch (this) {
      case QuestionCategory.aptitude:
        return 'Aptitude';
      case QuestionCategory.verbal:
        return 'Verbal';
      case QuestionCategory.reasoning:
        return 'Reasoning';
      case QuestionCategory.currentAffairs:
        return 'Current Affairs';
    }
  }
}

class DailyQuestion {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final QuestionCategory category;
  final DateTime dateFor; // The date this question belongs to

  int? userSelectedIndex;
  bool get isAnswered => userSelectedIndex != null;
  bool get isCorrect => userSelectedIndex == correctOptionIndex;

  DailyQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.category,
    required this.dateFor,
    this.userSelectedIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userSelectedIndex': userSelectedIndex,
    };
  }
}
