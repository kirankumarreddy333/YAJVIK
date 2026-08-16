
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exam_preparation.dart';

abstract class ExamRepository {
  Future<List<ExamPreparation>> fetchExams();
  Future<int> getTopicProgress(String examId, String topicId);
  Future<void> saveTopicProgress(String examId, String topicId, int progressStatus);
}

class MockExamRepository implements ExamRepository {
  final SharedPreferences _prefs;

  MockExamRepository(this._prefs);

  @override
  Future<List<ExamPreparation>> fetchExams() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ExamPreparation(
        id: 'e_ssc_cgl',
        name: 'SSC CGL',
        category: 'SSC',
        overview: 'Combined Graduate Level Examination for Group B and C posts.',
        eligibility: 'Bachelor\'s Degree in any discipline.',
        syllabus: [
          SyllabusTopic(
            id: 'ssc_quant',
            title: 'Quantitative Aptitude',
            subtopics: ['Number System', 'Percentage', 'Profit & Loss', 'Ratio & Proportion', 'Time & Work'],
            videos: [
              VideoResource(title: 'Percentage Tricks', url: 'https://youtube.com/watch?v=dQw4w9WgXcQ', duration: '12:00'),
              VideoResource(title: 'Profit & Loss Basics', url: 'https://youtube.com/watch?v=dQw4w9WgXcQ', duration: '15:30'),
            ],
          ),
          SyllabusTopic(
            id: 'ssc_reas',
            title: 'Reasoning',
            subtopics: ['Analogy', 'Series', 'Coding-Decoding', 'Blood Relations', 'Syllogism'],
            videos: [
               VideoResource(title: 'Syllogism Masterclass', url: 'https://youtube.com/watch?v=dQw4w9WgXcQ', duration: '20:00'),
            ],
          ),
          SyllabusTopic(
            id: 'ssc_eng',
            title: 'English',
            subtopics: ['Grammar', 'Vocabulary', 'Error Detection', 'Reading Comprehension'],
          ),
          SyllabusTopic(
            id: 'ssc_ga',
            title: 'General Awareness',
            subtopics: ['History', 'Geography', 'Polity', 'Current Affairs'],
          ),
        ],
      ),
      ExamPreparation(
        id: 'e_ibps_po',
        name: 'IBPS PO',
        category: 'Banking',
        overview: 'Probationary Officer exam for public sector banks.',
        eligibility: 'Bachelor\'s Degree in any discipline.',
        syllabus: [
          SyllabusTopic(
            id: 'ibps_quant',
            title: 'Quantitative Aptitude',
            subtopics: ['Data Interpretation', 'Simplification', 'Number Series', 'Quadratic Equations'],
          ),
          SyllabusTopic(
            id: 'ibps_reas',
            title: 'Reasoning',
            subtopics: ['Puzzles', 'Seating Arrangement', 'Inequalities', 'Syllogism'],
          ),
        ],
      ),
    ];
  }

  @override
  Future<int> getTopicProgress(String examId, String topicId) async {
    final key = 'progress_${examId}_$topicId';
    return _prefs.getInt(key) ?? 0; // 0 = Not Started, 1 = In Progress, 2 = Completed
  }

  @override
  Future<void> saveTopicProgress(String examId, String topicId, int progressStatus) async {
    final key = 'progress_${examId}_$topicId';
    await _prefs.setInt(key, progressStatus);
  }
}
