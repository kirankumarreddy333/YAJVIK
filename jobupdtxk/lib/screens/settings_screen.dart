import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(theme.brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: theme.brightness == Brightness.dark,
              onChanged: (_) => context.read<ThemeProvider>().toggle(),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: context.watch<LocaleProvider>().locale.languageCode,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  context.read<LocaleProvider>().setLocale(Locale(newValue));
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _ActionTile(icon: Icons.info_outline, title: 'About YAJVIK', onTap: () {}),
          _ActionTile(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () {}),
          _ActionTile(icon: Icons.description_outlined, title: 'Terms of Service', onTap: () {}),
          _ActionTile(icon: Icons.gavel_outlined, title: 'Disclaimer', onTap: () {}),
          _ActionTile(icon: Icons.mail_outline, title: 'Contact Us', onTap: () {}),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'YAJVIK v1.0.1+2',
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          )
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
