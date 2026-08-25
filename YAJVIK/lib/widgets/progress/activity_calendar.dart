import 'package:flutter/material.dart';
import '../../models/daily_progress_stats.dart';
import '../../theme/app_theme.dart';
import 'date_activity_sheet.dart';

class ActivityCalendar extends StatelessWidget {
  final int year;
  final int month;
  final Map<String, DailyProgressStats> calendarData;

  const ActivityCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.calendarData,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstDayOfMonth = DateTime(year, month, 1);
    // Sunday = 7 in DateTime, but we often want Sunday=0 or Monday=1.
    // In Dart, weekday is 1(Mon) to 7(Sun). Let's start week on Sunday (0) to Saturday (6).
    int firstDayWeekday = firstDayOfMonth.weekday;
    if (firstDayWeekday == 7) firstDayWeekday = 0;

    final now = DateTime.now();
    final isCurrentMonth = now.year == year && now.month == month;
    final todayDay = isCurrentMonth ? now.day : null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF262436) : const Color(0xFFE7E5F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayHeaders(context),
          const SizedBox(height: 12),
          _buildCalendarGrid(context, daysInMonth, firstDayWeekday, todayDay),
          const SizedBox(height: 24),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildDayHeaders(BuildContext context) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        return SizedBox(
          width: 32,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, int daysInMonth, int firstDayWeekday, int? todayDay) {
    final totalCells = ((daysInMonth + firstDayWeekday) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final dayIndex = index - firstDayWeekday;
        if (dayIndex < 0 || dayIndex >= daysInMonth) {
          return const SizedBox.shrink();
        }

        final dayNumber = dayIndex + 1;
        final dateStr = '$year-${month.toString().padLeft(2, '0')}-${dayNumber.toString().padLeft(2, '0')}';
        final stats = calendarData[dateStr] ?? DailyProgressStats();
        final count = stats.questionsCompleted;

        final isToday = dayNumber == todayDay;

        return _ActivityCell(
          dayNumber: dayNumber,
          isToday: isToday,
          activityLevel: _getLevel(count),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => DateActivitySheet(
                date: DateTime(year, month, dayNumber),
                stats: stats,
              ),
            );
          },
        );
      },
    );
  }

  int _getLevel(int count) {
    if (count == 0) return 0;
    if (count <= 2) return 1;
    if (count <= 5) return 2;
    if (count <= 9) return 3;
    return 4;
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Less', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline)),
        const SizedBox(width: 8),
        _LegendBox(level: 0),
        const SizedBox(width: 4),
        _LegendBox(level: 1),
        const SizedBox(width: 4),
        _LegendBox(level: 2),
        const SizedBox(width: 4),
        _LegendBox(level: 3),
        const SizedBox(width: 4),
        _LegendBox(level: 4),
        const SizedBox(width: 8),
        Text('More', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline)),
      ],
    );
  }
}

class _ActivityCell extends StatelessWidget {
  final int dayNumber;
  final bool isToday;
  final int activityLevel;
  final VoidCallback onTap;

  const _ActivityCell({
    required this.dayNumber,
    required this.isToday,
    required this.activityLevel,
    required this.onTap,
  });

  Color _getColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (activityLevel == 0) {
      return isDark ? const Color(0xFF1E1C29) : const Color(0xFFF0EFF5);
    }
    
    // Purple accent scales
    final baseColor = AppColors.primary;
    if (activityLevel == 1) return baseColor.withOpacity(0.3);
    if (activityLevel == 2) return baseColor.withOpacity(0.5);
    if (activityLevel == 3) return baseColor.withOpacity(0.8);
    return baseColor; // Level 4
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget cell = Container(
      decoration: BoxDecoration(
        color: _getColor(context),
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: AppColors.primary, width: 2)
            : Border.all(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                width: 1,
              ),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$dayNumber',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
            color: activityLevel > 2
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );

    if (isToday) {
      // Add 'TODAY' badge logic if needed, but since cell is small,
      // the glow and thick border usually suffice. Let's just use the glow.
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: cell,
    );
  }
}

class _LegendBox extends StatelessWidget {
  final int level;

  const _LegendBox({required this.level});

  Color _getColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (level == 0) {
      return isDark ? const Color(0xFF1E1C29) : const Color(0xFFF0EFF5);
    }
    
    final baseColor = AppColors.primary;
    if (level == 1) return baseColor.withOpacity(0.3);
    if (level == 2) return baseColor.withOpacity(0.5);
    if (level == 3) return baseColor.withOpacity(0.8);
    return baseColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getColor(context),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
