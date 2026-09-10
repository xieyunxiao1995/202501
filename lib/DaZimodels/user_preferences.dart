import 'dart:convert';

class UserPreferences {
  final bool hasAcceptedEula;
  final bool hasCompletedOnboarding;
  final String preferredAesthetic;
  final int totalProjectsCompleted;

  const UserPreferences({
    this.hasAcceptedEula = false,
    this.hasCompletedOnboarding = false,
    this.preferredAesthetic = 'classic-gold',
    this.totalProjectsCompleted = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'hasAcceptedEula': hasAcceptedEula,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'preferredAesthetic': preferredAesthetic,
      'totalProjectsCompleted': totalProjectsCompleted,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      hasAcceptedEula: json['hasAcceptedEula'] as bool? ?? false,
      hasCompletedOnboarding:
          json['hasCompletedOnboarding'] as bool? ?? false,
      preferredAesthetic:
          json['preferredAesthetic'] as String? ?? 'classic-gold',
      totalProjectsCompleted: json['totalProjectsCompleted'] as int? ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static UserPreferences fromJsonString(String jsonString) {
    return UserPreferences.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>);
  }

  UserPreferences copyWith({
    bool? hasAcceptedEula,
    bool? hasCompletedOnboarding,
    String? preferredAesthetic,
    int? totalProjectsCompleted,
  }) {
    return UserPreferences(
      hasAcceptedEula: hasAcceptedEula ?? this.hasAcceptedEula,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      preferredAesthetic: preferredAesthetic ?? this.preferredAesthetic,
      totalProjectsCompleted:
          totalProjectsCompleted ?? this.totalProjectsCompleted,
    );
  }
}