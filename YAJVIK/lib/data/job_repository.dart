import '../models/government_job.dart';

/// Contract for any job data source.
///
/// Swap [MockJobRepository] for a real implementation (e.g. `ApiJobRepository`
/// that hits your scraper/backend) without touching any UI code — inject the
/// new implementation wherever `JobRepository` is provided (see `main.dart`).
abstract class JobRepository {
  Future<List<GovernmentJob>> fetchJobs();
}
