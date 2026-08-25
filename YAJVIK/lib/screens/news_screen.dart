import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News & Current Affairs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current Affairs'),
              Tab(text: 'Employment News'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NewsList(type: 'current_affairs'),
            _NewsList(type: 'employment_news'),
          ],
        ),
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  final String type;
  const _NewsList({required this.type});

  @override
  Widget build(BuildContext context) {
    // Dummy UI for News/Current Affairs
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type == 'current_affairs' ? 'National' : 'Job Alert',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This is a placeholder title for the news or current affair item to show how it wraps.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.3),
                ),
                const SizedBox(height: 8),
                Text(
                  'A short snippet of the news content goes here. It provides a quick overview of what the article is about before the user taps to read more.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).colorScheme.outline, height: 1.4),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2 hours ago', style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Read More'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
