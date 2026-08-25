import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/daily_question.dart';
import '../providers/question_provider.dart';
import '../providers/progress_provider.dart';

class DailyQuestionsScreen extends StatelessWidget {
  const DailyQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questionProvider = context.watch<QuestionProvider>();
    final progressProvider = context.read<ProgressProvider>();

    if (questionProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Today's Questions")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final questions = questionProvider.todayQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Questions"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${questionProvider.completedCount} / 4 Completed',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (questionProvider.isGoalCompleted)
                  const Text('🎉 Goal Achieved', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.category, size: 16, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              q.category.name.toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4)),
                        const SizedBox(height: 20),
                        ...List.generate(q.options.length, (i) {
                          final isSelected = q.userSelectedIndex == i;
                          final isCorrectOption = q.correctOptionIndex == i;
                          
                          Color borderColor = Theme.of(context).colorScheme.outlineVariant;
                          Color bgColor = Colors.transparent;
                          IconData? icon;
                          Color iconColor = Colors.transparent;

                          if (q.isAnswered) {
                            if (isCorrectOption) {
                              borderColor = Colors.green;
                              bgColor = Colors.green.withOpacity(0.1);
                              icon = Icons.check_circle;
                              iconColor = Colors.green;
                            } else if (isSelected && !isCorrectOption) {
                              borderColor = Colors.red;
                              bgColor = Colors.red.withOpacity(0.1);
                              icon = Icons.cancel;
                              iconColor = Colors.red;
                            }
                          } else if (isSelected) {
                            borderColor = Theme.of(context).colorScheme.primary;
                            bgColor = Theme.of(context).colorScheme.primaryContainer;
                          }

                          return InkWell(
                            onTap: q.isAnswered ? null : () async {
                              final currentContext = context;
                              final qProvider = currentContext.read<QuestionProvider>();
                              await qProvider.answerQuestion(q.id, i);
                              if (currentContext.mounted) {
                                // Assume ~30 seconds for mock study time
                                await progressProvider.logPracticeAttempt(DateTime.now(), q.category.label, q.userSelectedIndex == q.correctOptionIndex, 30);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: bgColor,
                                border: Border.all(color: borderColor, width: isSelected || (q.isAnswered && isCorrectOption) ? 2 : 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      q.options[i],
                                      style: TextStyle(
                                        fontWeight: isSelected || (q.isAnswered && isCorrectOption) ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (icon != null) Icon(icon, color: iconColor),
                                ],
                              ),
                            ),
                          );
                        }),
                        if (q.isAnswered) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Explanation', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(q.explanation, style: const TextStyle(height: 1.4)),
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
