import 'package:flutter/material.dart';

class PreparationScreen extends StatelessWidget {
  const PreparationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preparation')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Focus on your AIM', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Top requested study materials and previous papers for your target exams.'),
          const SizedBox(height: 24),
          _buildCategory(
            context,
            'Syllabus & Pattern',
            Icons.menu_book,
            [
              'UPSC CSE Prelims & Mains Syllabus',
              'SSC CGL Tier 1 & Tier 2 Pattern',
              'IBPS PO Prelims Pattern',
              'RRB JE Syllabus 2026',
            ],
          ),
          const SizedBox(height: 20),
          _buildCategory(
            context,
            'Previous Year Papers (PYQ)',
            Icons.history_edu,
            [
              'UPSC CSE 2025 Prelims Paper 1',
              'SSC CGL 2024 Tier 1 All Shifts',
              'IBPS PO 2024 Memory Based',
            ],
          ),
          const SizedBox(height: 20),
          _buildCategory(
            context,
            'Current Affairs',
            Icons.newspaper,
            [
              'August 2026 Monthly Digest',
              'Daily Current Affairs - 15 Aug',
              'Economic Survey 2026 Highlights',
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, IconData icon, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              child: ListTile(
                title: Text(item, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                trailing: Icon(Icons.download_rounded, color: Theme.of(context).colorScheme.secondary),
                onTap: () {},
              ),
            )),
      ],
    );
  }
}
