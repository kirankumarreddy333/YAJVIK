import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../models/exam_result.dart';
import '../providers/result_provider.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResultProvider>().loadResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Results'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Released'),
              Tab(text: 'Previous'),
            ],
          ),
        ),
        body: Consumer<ResultProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: [
                _ResultList(results: provider.upcoming),
                _ResultList(results: provider.released),
                _ResultList(results: provider.previous),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  final List<ExamResult> results;

  const _ResultList({required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(child: Text('No results found.'));
    }

    final dateFmt = DateFormat('d MMM yyyy');

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final r = results[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.organization, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text(r.examName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text('Exam: ${dateFmt.format(r.examDate)}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                if (r.resultDate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Text('${r.status == 'Upcoming' ? 'Expected' : 'Released'}: ${dateFmt.format(r.resultDate!)}', 
                        style: const TextStyle(color: Colors.green, fontSize: 13)),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      final uri = Uri.tryParse(r.officialLink);
                      if (uri != null) await launchUrl(uri);
                    },
                    child: const Text('Official Website'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
