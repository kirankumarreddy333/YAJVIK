import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  static const _prefsKey = 'yajvik_locale';

  LocaleProvider(this.prefs) {
    final code = prefs.getString(_prefsKey);
    if (code != null) {
      _locale = Locale(code);
    }
  }

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'hi', 'te'].contains(locale.languageCode)) return;
    _locale = locale;
    prefs.setString(_prefsKey, locale.languageCode);
    notifyListeners();
  }
}
