import 'package:flutter/material.dart';

class AdmitCardsScreen extends StatelessWidget {
  const AdmitCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admit Cards'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Available'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AdmitCardList(isAvailable: true),
            _AdmitCardList(isAvailable: false),
          ],
        ),
      ),
    );
  }
}

class _AdmitCardList extends StatelessWidget {
  final bool isAvailable;
  const _AdmitCardList({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    // Dummy UI for Phase 3
    final count = isAvailable ? 2 : 3;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
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
                Text('Organization $index', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text('Exam $index 2026', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    const Text('Exam: 15 Sep 2026', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isAvailable ? () {} : null,
                    icon: Icon(isAvailable ? Icons.download : Icons.schedule),
                    label: Text(isAvailable ? 'Download Admit Card' : 'Expected soon'),
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
