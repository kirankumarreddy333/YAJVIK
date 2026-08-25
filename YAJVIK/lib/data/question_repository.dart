import '../models/daily_question.dart';

abstract class QuestionRepository {
  Future<List<DailyQuestion>> fetchDailyQuestions(DateTime date);
  Future<void> saveAnswer(String questionId, int selectedIndex, DateTime date);
  Future<Map<String, int>> fetchSavedAnswers(DateTime date);
}
