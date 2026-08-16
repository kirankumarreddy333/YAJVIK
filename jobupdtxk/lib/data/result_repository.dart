import '../models/exam_result.dart';

abstract class ResultRepository {
  Future<List<ExamResult>> fetchResults();
}

class MockResultRepository implements ResultRepository {
  @override
  Future<List<ExamResult>> fetchResults() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();

    return [
      ExamResult(
        id: 'r1',
        examName: 'SSC CGL 2025 Tier 1',
        organization: 'SSC',
        examDate: now.subtract(const Duration(days: 45)),
        resultDate: now.add(const Duration(days: 10)),
        status: 'Upcoming',
        officialLink: 'https://ssc.nic.in',
      ),
      ExamResult(
        id: 'r2',
        examName: 'IBPS PO Prelims',
        organization: 'IBPS',
        examDate: now.subtract(const Duration(days: 20)),
        resultDate: now.subtract(const Duration(days: 2)),
        status: 'Released',
        officialLink: 'https://ibps.in',
      ),
      ExamResult(
        id: 'r3',
        examName: 'UPSC Civil Services Prelims 2025',
        organization: 'UPSC',
        examDate: now.subtract(const Duration(days: 120)),
        resultDate: now.subtract(const Duration(days: 60)),
        status: 'Previous',
        officialLink: 'https://upsc.gov.in',
      ),
    ];
  }
}
