import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;
    final theme = Theme.of(context);

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit profile coming soon!')));
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Section
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  profile.mobileNumber,
                  style: TextStyle(color: theme.colorScheme.outline, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Education Details
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.school, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${profile.education} • ${profile.branch}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Text(
                    'Graduation: ${profile.graduationYear}',
                    style: TextStyle(color: theme.colorScheme.outline),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Target Details
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🎯 Target', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.targetJobs.isEmpty 
                    ? [const Text('No target selected. Exploring jobs.')]
                    : profile.targetJobs.map((e) => Chip(label: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text('📚 Study Goal', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                Text('${profile.dailyStudyTime} / Day', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Stats Section
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _StatCard(title: '🔥 Streak', value: '${profile.currentStreak} days', theme: theme),
              _StatCard(title: '⭐ XP', value: '${profile.xp}', theme: theme),
            ],
          ),
          const SizedBox(height: 32),

          // Notifications
          const Text('Alerts & Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('Job Alerts'),
            subtitle: const Text('Local notifications based on profile'),
            trailing: Switch(
              value: profile.notificationsEnabled,
              onChanged: (val) {
                profileProvider.saveProfile(profile.copyWith(notificationsEnabled: val));
              },
            ),
          ),
          const SizedBox(height: 32),
          // Settings Link
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            subtitle: const Text('Theme, About, Privacy, etc.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          const SizedBox(height: 60),

          // Signature Footer
          Center(
            child: Column(
              children: [
                const Text(
                  'YAJVIK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2),
                ),
                const SizedBox(height: 4),
                Text(
                  'A product by XK',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: [
                    Text('About', style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)),
                    Text('·', style: TextStyle(color: theme.colorScheme.outline)),
                    Text('Privacy', style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)),
                    Text('·', style: TextStyle(color: theme.colorScheme.outline)),
                    Text('Terms', style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)),
                    Text('·', style: TextStyle(color: theme.colorScheme.outline)),
                    Text('Disclaimer', style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)),
                    Text('·', style: TextStyle(color: theme.colorScheme.outline)),
                    Text('Contact', style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final ThemeData theme;

  const _StatCard({required this.title, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.outline)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

