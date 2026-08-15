import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/government_job.dart';
import '../providers/job_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/job_card.dart';
import '../widgets/job_filters_sheet.dart';
import 'job_detail_screen.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('jobupdtxk'),
        actions: [
          IconButton(
            tooltip: 'Bookmarks',
            onPressed: () => context.read<JobProvider>().toggleBookmarksOnly(),
            icon: Icon(
              jobProvider.bookmarksOnly
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
          ),
          IconButton(
            tooltip: 'Filter',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const JobFiltersSheet(),
              );
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<JobProvider>().loadJobs(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  onChanged: (v) => context.read<JobProvider>().setQuery(v),
                  decoration: InputDecoration(
                    hintText: 'Search jobs, organizations…',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    CategoryChip(
                      label: 'All',
                      selected: jobProvider.categoryFilter == null,
                      onTap: () =>
                          context.read<JobProvider>().setCategoryFilter(null),
                    ),
                    const SizedBox(width: 8),
                    ...JobCategory.values.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          label: c.label,
                          selected: jobProvider.categoryFilter == c,
                          onTap: () => context
                              .read<JobProvider>()
                              .setCategoryFilter(c),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            if (jobProvider.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (jobProvider.error != null)
              SliverFillRemaining(
                child: Center(child: Text(jobProvider.error!)),
              )
            else if (jobProvider.jobs.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('No jobs match your filters.')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.separated(
                  itemCount: jobProvider.jobs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final job = jobProvider.jobs[index];
                    return JobCard(
                      job: job,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailScreen(jobId: job.id),
                        ),
                      ),
                      onBookmarkTap: () =>
                          context.read<JobProvider>().toggleBookmark(job.id),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
