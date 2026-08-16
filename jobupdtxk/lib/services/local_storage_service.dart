import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class LocalStorageService {
  static const String _profileKey = 'user_profile_data';
  SharedPreferences? _prefs;

  SharedPreferences get prefs => _prefs!;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<UserProfile?> getUserProfile() async {
    if (_prefs == null) await init();
    final String? profileJson = _prefs!.getString(_profileKey);
    if (profileJson != null && profileJson.isNotEmpty) {
      try {
        return UserProfile.fromJson(profileJson);
      } catch (e) {
        // If parsing fails (e.g. format changed), return null
        return null;
      }
    }
    return null;
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_profileKey, profile.toJson());
  }

  Future<void> deleteUserProfile() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_profileKey);
  }
}
