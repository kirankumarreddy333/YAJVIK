import 'dart:convert';

class UserProfile {
  final String name;
  final String mobileNumber;
  final String dateOfBirth;
  final String education;
  final String branch;
  final String graduationYear;
  final String dailyStudyTime;
  final List<String> targetJobs;
  
  final String state;
  final String district;

  final int currentStreak;
  final int xp;
  final int level;

  final bool profileCompleted;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.name,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.education,
    required this.branch,
    required this.graduationYear,
    required this.dailyStudyTime,
    required this.targetJobs,
    this.state = '',
    this.district = '',
    this.currentStreak = 0,
    this.xp = 0,
    this.level = 1,
    this.profileCompleted = false,
    this.notificationsEnabled = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
      'education': education,
      'branch': branch,
      'graduationYear': graduationYear,
      'dailyStudyTime': dailyStudyTime,
      'targetJobs': targetJobs,
      'state': state,
      'district': district,
      'currentStreak': currentStreak,
      'xp': xp,
      'level': level,
      'profileCompleted': profileCompleted,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      education: map['education'] ?? '',
      branch: map['branch'] ?? '',
      graduationYear: map['graduationYear'] ?? '',
      dailyStudyTime: map['dailyStudyTime'] ?? '',
      targetJobs: List<String>.from(map['targetJobs'] ?? []),
      state: map['state'] ?? '',
      district: map['district'] ?? '',
      currentStreak: map['currentStreak'] ?? 0,
      xp: map['xp'] ?? 0,
      level: map['level'] ?? 1,
      profileCompleted: map['profileCompleted'] ?? false,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));

  UserProfile copyWith({
    String? name,
    String? mobileNumber,
    String? dateOfBirth,
    String? education,
    String? branch,
    String? graduationYear,
    String? dailyStudyTime,
    List<String>? targetJobs,
    String? state,
    String? district,
    int? currentStreak,
    int? xp,
    int? level,
    bool? profileCompleted,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      education: education ?? this.education,
      branch: branch ?? this.branch,
      graduationYear: graduationYear ?? this.graduationYear,
      dailyStudyTime: dailyStudyTime ?? this.dailyStudyTime,
      targetJobs: targetJobs ?? this.targetJobs,
      state: state ?? this.state,
      district: district ?? this.district,
      currentStreak: currentStreak ?? this.currentStreak,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
