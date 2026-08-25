import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/government_job.dart';
import '../providers/job_provider.dart';
import '../providers/tracker_provider.dart';
import '../providers/profile_provider.dart';

class JobDetailScreen extends StatelessWidget {
  final String jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final job = context.watch<JobProvider>().byId(jobId);
    final tracker = context.watch<TrackerProvider>();
    final profile = context.watch<ProfileProvider>().profile;
    final dateFmt = DateFormat('d MMM yyyy');

    if (job == null) {
      return const Scaffold(body: Center(child: Text('Job not found')));
    }

    final tracked = tracker.isTracked(job.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(job.organization),
        actions: [
          IconButton(
            onPressed: () => context.read<JobProvider>().toggleBookmark(job.id),
            icon: Icon(
              job.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    job.category.label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  job.title,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.2),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.business_center, size: 16, color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 6),
                    Text(
                      job.organization,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

          _InfoGrid(
            items: {
              'State': job.state,
              'Salary': job.salary,
              'Vacancies': job.vacancies.toString(),
              'Last date': job.lastDate == null
                  ? '—'
                  : dateFmt.format(job.lastDate!),
              'Exam date': job.examDate == null
                  ? '—'
                  : dateFmt.format(job.examDate!),
              'Qualification': job.qualification,
              'Age Limit': job.ageLimit,
            },
          ),
          const SizedBox(height: 20),
          _buildEligibilityChecker(context, job, profile),
          const SizedBox(height: 20),
          _Section(title: 'Eligibility Details', body: job.eligibility),
          _buildSelectionProcessTimeline(context, job.selectionProcess),
          const SizedBox(height: 8),
          Text(
            'Last updated ${DateFormat('d MMM, h:mm a').format(job.lastUpdated)}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
              ],
            ),
          ),
          const SizedBox(height: 90),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final uri = Uri.tryParse(job.officialWebsite);
                        if (uri != null) await launchUrl(uri);
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Notification'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        final uri = Uri.tryParse(job.applyLink);
                        if (uri != null) await launchUrl(uri);
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Apply Officially'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: tracked
                      ? null
                      : () => context.read<TrackerProvider>().track(job),
                  icon: Icon(tracked ? Icons.check : Icons.add_task),
                  label: Text(tracked ? 'In Tracker' : 'Track Application'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final Map<String, String> items;
  const _InfoGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.6,
      children: items.entries.map((e) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                e.key,
                style: TextStyle(fontSize: 11, color: scheme.outline),
              ),
              const SizedBox(height: 2),
              Text(
                e.value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }
}

  Widget _buildEligibilityChecker(BuildContext context, GovernmentJob job, profile) {
    if (profile == null) return const SizedBox.shrink();

    bool isEligible = true;
    List<String> issues = [];

    // Simple qualification check
    if (!job.qualification.toLowerCase().contains(profile.education.toLowerCase())) {
      isEligible = false;
      issues.add('Qualification mismatch (${profile.education})');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEligible ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isEligible ? Colors.green : Colors.orange),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isEligible ? Icons.check_circle : Icons.warning, color: isEligible ? Colors.green : Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEligible ? 'You appear eligible' : 'You may not be eligible',
                  style: TextStyle(fontWeight: FontWeight.bold, color: isEligible ? Colors.green.shade700 : Colors.orange.shade800),
                ),
                if (!isEligible) ...issues.map((i) => Text('• $i', style: const TextStyle(fontSize: 12))),
                const SizedBox(height: 8),
                const Text('Verify eligibility in the official notification before applying.', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionProcessTimeline(BuildContext context, String processStr) {
    final steps = processStr.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (steps.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selection Process', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        ...steps.asMap().entries.map((entry) {
          final isLast = entry.key == steps.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 24,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
