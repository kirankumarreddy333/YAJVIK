import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exam_preparation.dart';
import '../providers/exam_provider.dart';
import 'topic_detail_screen.dart';

class SyllabusScreen extends StatelessWidget {
  final ExamPreparation exam;
  const SyllabusScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${exam.name} Syllabus')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: exam.syllabus.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final topic = exam.syllabus[index];
          return _TopicCard(examId: exam.id, topic: topic);
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final String examId;
  final SyllabusTopic topic;

  const _TopicCard({required this.examId, required this.topic});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: context.read<ExamProvider>().getTopicProgress(examId, topic.id),
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0;
        
        Color statusColor = Colors.grey;
        String statusText = 'Not Started';
        
        if (progress == 1) {
          statusColor = Colors.orange;
          statusText = 'In Progress';
        } else if (progress == 2) {
          statusColor = Colors.green;
          statusText = 'Completed';
        }

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TopicDetailScreen(examId: examId, topic: topic)));
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(topic.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('${topic.subtopics.length} Subtopics • ${topic.videos.length} Videos', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
