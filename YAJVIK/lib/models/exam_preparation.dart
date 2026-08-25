class VideoResource {
  final String title;
  final String url;
  final String duration;

  VideoResource({
    required this.title,
    required this.url,
    required this.duration,
  });
}

class SyllabusTopic {
  final String id;
  final String title;
  final List<String> subtopics;
  final List<VideoResource> videos;
  
  // Progress state could be 0 (Not Started), 1 (In Progress), 2 (Completed)
  // Kept in shared preferences

  SyllabusTopic({
    required this.id,
    required this.title,
    required this.subtopics,
    this.videos = const [],
  });
}

class ExamPreparation {
  final String id;
  final String name;
  final String category; // e.g., SSC, Banking
  final String overview;
  final String eligibility;
  final List<SyllabusTopic> syllabus;
  
  ExamPreparation({
    required this.id,
    required this.name,
    required this.category,
    required this.overview,
    required this.eligibility,
    required this.syllabus,
  });
}
