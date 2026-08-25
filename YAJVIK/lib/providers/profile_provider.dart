import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  final LocalStorageService _storageService;
  
  UserProfile? _profile;
  bool _isLoading = true;
  String? _error;

  ProfileProvider(this._storageService) {
    _init();
  }

  UserProfile? get profile => _profile;
  bool get hasProfile => _profile != null && _profile!.profileCompleted;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _storageService.getUserProfile();
    } catch (e) {
      _error = 'Failed to load local profile';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProfile(UserProfile profile) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final updatedProfile = profile.copyWith(profileCompleted: true);
      await _storageService.saveUserProfile(updatedProfile);
      _profile = updatedProfile;
    } catch (e) {
      _error = 'Failed to save local profile';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProfile() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _storageService.deleteUserProfile();
      _profile = null;
    } catch (e) {
      _error = 'Failed to delete local profile';
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
