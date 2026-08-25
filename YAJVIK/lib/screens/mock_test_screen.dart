import 'dart:async';
import 'package:flutter/material.dart';

class MockTestScreen extends StatefulWidget {
  final String testName;
  const MockTestScreen({super.key, required this.testName});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final int _totalQuestions = 15;
  int _secondsRemaining = 15 * 60; // 15 mins
  Timer? _timer;

  // Track answers: null means unanswered
  final Map<int, int?> _answers = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _submitTest();
      }
    });
  }

  void _submitTest() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Test Submitted'),
        content: Text('You answered ${_answers.length} out of $_totalQuestions questions.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close mock test
            },
            child: const Text('View Results'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_secondsRemaining / 60).floor();
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showPalette() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Question Palette', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _totalQuestions,
                  itemBuilder: (context, i) {
                    final isAnswered = _answers.containsKey(i) && _answers[i] != null;
                    final isCurrent = _currentIndex == i;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _pageController.jumpToPage(i);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrent 
                              ? Theme.of(context).colorScheme.primaryContainer 
                              : isAnswered ? Colors.green : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrent ? Theme.of(context).colorScheme.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: isCurrent 
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : isAnswered ? Colors.white : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.testName),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _secondsRemaining < 60 ? Colors.red.withOpacity(0.1) : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, size: 16, color: _secondsRemaining < 60 ? Colors.red : Theme.of(context).colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  _formattedTime,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _secondsRemaining < 60 ? Colors.red : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemCount: _totalQuestions,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Question ${index + 1} of $_totalQuestions', style: TextStyle(color: Theme.of(context).colorScheme.outline, fontWeight: FontWeight.bold)),
                          IconButton(onPressed: _showPalette, icon: const Icon(Icons.grid_view)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This is a dummy mock test question. The real application will fetch this from the backend API. Which of the following is correct?',
                        style: TextStyle(fontSize: 18, height: 1.4, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 32),
                      ...List.generate(4, (optIdx) {
                        final isSelected = _answers[index] == optIdx;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _answers[index] = optIdx;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected ? Center(child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle))) : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text('Option ${optIdx + 1}', style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal))),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _currentIndex > 0 ? () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut) : null,
                  child: const Text('Previous'),
                ),
                if (_currentIndex < _totalQuestions - 1)
                  FilledButton(
                    onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                    child: const Text('Save & Next'),
                  )
                else
                  FilledButton(
                    onPressed: _submitTest,
                    style: FilledButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Submit Test'),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
