import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import 'syllabus_screen.dart';

class PreparationScreen extends StatefulWidget {
  const PreparationScreen({super.key});

  @override
  State<PreparationScreen> createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().loadExams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = context.watch<ExamProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Preparation')),
      body: examProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Choose Your Goal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Select an exam to view its complete syllabus, track progress, and access learning resources.'),
                const SizedBox(height: 24),
                ...examProvider.exams.map((exam) => Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SyllabusScreen(exam: exam)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  exam.category,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(exam.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(exam.overview, style: const TextStyle(height: 1.4)),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Text('${exam.syllabus.length} Topics', style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
    );
  }
}

