import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/job_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/question_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';
import 'daily_questions_screen.dart';
import 'progress_screen.dart';
import 'results_screen.dart';
import 'admit_cards_screen.dart';
import 'mock_test_screen.dart';
import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _getGreetingTitle(String userName) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning, $userName 👋';
    if (hour >= 12 && hour < 17) return 'Good afternoon, $userName 👋';
    if (hour >= 17 && hour < 21) return 'Good evening, $userName 👋';
    return 'Good night, $userName 🌙';
  }

  String _getGreetingSubtitle() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Stay consistent. Stay prepared. Succeed.';
    if (hour >= 12 && hour < 17) return 'Keep the momentum going.';
    if (hour >= 17 && hour < 21) return 'A little progress today builds a better tomorrow.';
    return 'Rest well. Come back stronger tomorrow.';
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionProvider>().loadTodayQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final allJobs = context.watch<JobProvider>().jobs;
    final progressProvider = context.watch<ProgressProvider>();
    final questionProvider = context.watch<QuestionProvider>();
    
    final recommendedJobs = allJobs.where((j) {
      if (profile == null) return false;
      bool matchesTarget = profile.targetJobs.isEmpty || profile.targetJobs.contains(j.category.name);
      bool matchesState = j.state == 'All India' || j.state == profile.state;
      return matchesTarget && matchesState;
    }).take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('YAJVIK', style: AppTheme.brandTextStyle(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Notification mock
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(_getGreetingTitle(profile?.name.split(' ').first ?? 'User'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_getGreetingSubtitle(), style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 24),
          
          // Dashboard Top Row: Streak and Progress
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text('Streak', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${progressProvider.currentStreak} Days', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontSize: 18, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Icon(Icons.timeline, color: Theme.of(context).colorScheme.onSecondaryContainer),
                            const SizedBox(width: 8),
                            Text('Progress', style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('View Details', style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer, fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Daily Question Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('🧠 Daily Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${questionProvider.completedCount} / 4', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                if (questionProvider.isLoading)
                   const Center(child: CircularProgressIndicator())
                else if (questionProvider.isGoalCompleted)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🎉 Daily Goal Complete!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyQuestionsScreen()));
                          },
                          child: const Text('Review Answers'),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Boost your prep with 4 quick questions.', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyQuestionsScreen()));
                          },
                          child: const Text('Attempt Today\'s Goal'),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('QUICK ACTIONS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 8,
            children: [
              _buildQuickAction(context, 'Jobs', '🔎', () {}),
              _buildQuickAction(context, 'Preparation', '📚', () {}),
              _buildQuickAction(context, 'News', '📰', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen()));
              }),
              _buildQuickAction(context, 'Mock Tests', '📝', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MockTestScreen(testName: 'Full Mock Test 1')));
              }),
              _buildQuickAction(context, 'Prev. Papers', '📄', () {}),
              _buildQuickAction(context, 'Results', '🏆', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultsScreen()));
              }),
              _buildQuickAction(context, 'Admit Cards', '🎫', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdmitCardsScreen()));
              }),
              _buildQuickAction(context, 'Calendar', '📅', () {}),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Upcoming Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultsScreen()));
                }, 
                child: const Text('See all')
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
            ),
            child: const Row(
              children: [
                Icon(Icons.event_available, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SSC CGL 2025 Tier 1', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Expected by 26 Aug 2026', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recommended Jobs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              TextButton(onPressed: () {}, child: const Text('See all')),
            ],
          ),
          const SizedBox(height: 12),
          if (recommendedJobs.isEmpty)
            const Center(child: Text('No recommendations yet.'))
          else
            ...recommendedJobs.map((job) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: JobCard(
                job: job,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(jobId: job.id))),
                onBookmarkTap: () => context.read<JobProvider>().toggleBookmark(job.id),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

