import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/exam_preparation.dart';
import '../providers/exam_provider.dart';

class TopicDetailScreen extends StatelessWidget {
  final String examId;
  final SyllabusTopic topic;

  const TopicDetailScreen({super.key, required this.examId, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ProgressSelector(examId: examId, topic: topic),
          const SizedBox(height: 24),
          const Text('Subtopics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...topic.subtopics.map((st) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.circle, size: 8, color: Theme.of(context).colorScheme.primary),
            title: Text(st),
          )),
          const SizedBox(height: 24),
          const Text('YouTube Resources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (topic.videos.isEmpty)
            const Text('No videos available yet.')
          else
            ...topic.videos.map((video) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              child: ListTile(
                leading: const Icon(Icons.play_circle_fill, color: Colors.red, size: 32),
                title: Text(video.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(video.duration),
                trailing: const Icon(Icons.open_in_new),
                onTap: () async {
                  final uri = Uri.tryParse(video.url);
                  if (uri != null) await launchUrl(uri);
                },
              ),
            )),
        ],
      ),
    );
  }
}

class _ProgressSelector extends StatefulWidget {
  final String examId;
  final SyllabusTopic topic;

  const _ProgressSelector({required this.examId, required this.topic});

  @override
  State<_ProgressSelector> createState() => _ProgressSelectorState();
}

class _ProgressSelectorState extends State<_ProgressSelector> {
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  void _loadProgress() async {
    final val = await context.read<ExamProvider>().getTopicProgress(widget.examId, widget.topic.id);
    if (mounted) setState(() => _progress = val);
  }

  void _updateProgress(int val) async {
    setState(() => _progress = val);
    await context.read<ExamProvider>().updateTopicProgress(widget.examId, widget.topic.id, val);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Progress', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Not Started')),
              ButtonSegment(value: 1, label: Text('In Progress')),
              ButtonSegment(value: 2, label: Text('Completed')),
            ],
            selected: {_progress},
            onSelectionChanged: (set) {
              if (set.isNotEmpty) _updateProgress(set.first);
            },
          ),
        ],
      ),
    );
  }
}
