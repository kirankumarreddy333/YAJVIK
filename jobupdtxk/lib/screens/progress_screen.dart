import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/progress_provider.dart';
import '../providers/question_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/progress/premium_stat_card.dart';
import '../widgets/progress/activity_calendar.dart';
import '../widgets/progress/practice_breakdown_card.dart';
import '../widgets/progress/premium_footer.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
  }

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        if (_selectedYear > 2026) {
          _selectedYear--;
          _selectedMonth = 12;
        }
      } else {
        _selectedMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedYear++;
        _selectedMonth = 1;
      } else {
        _selectedMonth++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = context.watch<ProgressProvider>();
    final questionProvider = context.watch<QuestionProvider>();
    
    final calendarData = progressProvider.getActivityCalendar();
    final monthSummary = progressProvider.getMonthSummary(_selectedYear, _selectedMonth);
    final activeDays = progressProvider.getActiveDaysInMonth(_selectedYear, _selectedMonth);
    
    // Overall accuracy for the top stats based on total calendar
    int totalAttempted = 0;
    int totalCorrect = 0;
    for (var stats in calendarData.values) {
      totalAttempted += stats.questionsCompleted;
      totalCorrect += stats.correctAnswers;
    }
    final overallAccuracy = totalAttempted > 0 ? (totalCorrect / totalAttempted) * 100 : 0.0;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('My Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    'Track your preparation journey',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              floating: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Top Statistics
                  Row(
                    children: [
                      Expanded(
                        child: PremiumStatCard(
                          title: 'Current Streak',
                          value: '${progressProvider.currentStreak} days',
                          icon: Icons.local_fire_department,
                          accentColor: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PremiumStatCard(
                          title: 'Best Streak',
                          value: '${progressProvider.bestStreak} days',
                          icon: Icons.emoji_events,
                          accentColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PremiumStatCard(
                          title: "Today's Goal",
                          value: '${questionProvider.completedCount} / ${questionProvider.todayQuestions.isNotEmpty ? questionProvider.todayQuestions.length : 4}',
                          icon: Icons.check_circle,
                          accentColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PremiumStatCard(
                          title: 'Accuracy',
                          value: '${overallAccuracy.toStringAsFixed(0)}%',
                          icon: Icons.percent,
                          accentColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Month Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: (_selectedYear == 2026 && _selectedMonth == 1) ? null : _previousMonth,
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(DateTime(_selectedYear, _selectedMonth)),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Calendar
                  ActivityCalendar(
                    year: _selectedYear,
                    month: _selectedMonth,
                    calendarData: calendarData,
                  ),
                  const SizedBox(height: 32),
                  
                  // Month Summary
                  const Text(
                    'Month Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF262436)
                            : const Color(0xFFE7E5F0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SummaryItem(title: 'Questions', value: '${monthSummary.questionsCompleted}'),
                            _SummaryItem(title: 'Accuracy', value: '${monthSummary.accuracy.toStringAsFixed(0)}%'),
                            _SummaryItem(title: 'Active Days', value: '$activeDays'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SummaryItem(
                              title: 'Study Time', 
                              value: monthSummary.studyTimeSeconds > 3600 
                                ? '${(monthSummary.studyTimeSeconds / 3600).floor()}h ${((monthSummary.studyTimeSeconds % 3600) / 60).floor()}m'
                                : '${(monthSummary.studyTimeSeconds / 60).floor()}m'
                            ),
                            _SummaryItem(title: 'Correct', value: '${monthSummary.correctAnswers}'),
                            _SummaryItem(title: 'Incorrect', value: '${monthSummary.incorrectAnswers}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Practice Breakdown
                  PracticeBreakdownCard(subjectStats: monthSummary.subjectStats),
                  
                  const SizedBox(height: 24),
                  
                  // Footer
                  const PremiumFooter(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
