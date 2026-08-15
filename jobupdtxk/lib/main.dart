import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'data/mock_job_repository.dart';
import 'services/local_storage_service.dart';
import 'providers/job_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/tracker_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = LocalStorageService();
  await storageService.init();

  runApp(JobUpdtxkApp(storageService: storageService));
}

class JobUpdtxkApp extends StatelessWidget {
  final LocalStorageService storageService;
  
  const JobUpdtxkApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider(MockJobRepository())),
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider(storageService)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'jobupdtxk',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.mode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('te'),
            ],
            home: Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
                if (!profileProvider.hasProfile) {
                  return const OnboardingScreen();
                }
                return const MainShell();
              },
            ),
          );
        },
      ),
    );
  }
}
