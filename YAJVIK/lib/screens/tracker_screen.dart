import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/application.dart';
import '../providers/tracker_provider.dart';
import '../widgets/status_chip.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackerProvider>();
    final apps = tracker.applications;

    return Scaffold(
      appBar: AppBar(title: const Text('Application Tracker')),
      body: apps.isEmpty
          ? const _EmptyTracker()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: apps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final app = apps[index];
                return _ApplicationTile(app: app);
              },
            ),
    );
  }
}

class _EmptyTracker extends StatelessWidget {
  const _EmptyTracker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.checklist_rtl,
              size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          const Text('No applications tracked yet'),
          const SizedBox(height: 4),
          Text(
            'Open a job and tap "Track Application"',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _ApplicationTile extends StatelessWidget {
  final JobApplication app;
  const _ApplicationTile({required this.app});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('d MMM yyyy');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.organization,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      app.jobTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<ApplicationStatus>(
                onSelected: (status) => context
                    .read<TrackerProvider>()
                    .updateStatus(app.id, status),
                itemBuilder: (context) => ApplicationStatus.values
                    .map((s) => PopupMenuItem(value: s, child: Text(s.label)))
                    .toList(),
                child: StatusChip(status: app.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 13, color: Theme.of(context).colorScheme.outline),
              const SizedBox(width: 6),
              Text(
                'Applied ${dateFmt.format(app.appliedDate)}',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline),
              ),
              const Spacer(),
              IconButton(
                iconSize: 18,
                onPressed: () =>
                    context.read<TrackerProvider>().remove(app.id),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
