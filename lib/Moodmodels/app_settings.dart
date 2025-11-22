class AppSettings {
  final bool aiAnalysisEnabled;
  final bool anonymousInPublic;
  final bool diaryRemindersEnabled;
  final bool aiInteractionRemindersEnabled;
  final String themeMode; // 'light', 'dark', 'auto'
  final List<String> blockedUserIds; // 拉黑的用户ID列表

  AppSettings({
    required this.aiAnalysisEnabled,
    required this.anonymousInPublic,
    required this.diaryRemindersEnabled,
    required this.aiInteractionRemindersEnabled,
    required this.themeMode,
    this.blockedUserIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'aiAnalysisEnabled': aiAnalysisEnabled,
      'anonymousInPublic': anonymousInPublic,
      'diaryRemindersEnabled': diaryRemindersEnabled,
      'aiInteractionRemindersEnabled': aiInteractionRemindersEnabled,
      'themeMode': themeMode,
      'blockedUserIds': blockedUserIds,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      aiAnalysisEnabled: json['aiAnalysisEnabled'] ?? true,
      anonymousInPublic: json['anonymousInPublic'] ?? false,
      diaryRemindersEnabled: json['diaryRemindersEnabled'] ?? true,
      aiInteractionRemindersEnabled: json['aiInteractionRemindersEnabled'] ?? false,
      themeMode: json['themeMode'] ?? 'auto',
      blockedUserIds: List<String>.from(json['blockedUserIds'] ?? []),
    );
  }

  AppSettings copyWith({
    bool? aiAnalysisEnabled,
    bool? anonymousInPublic,
    bool? diaryRemindersEnabled,
    bool? aiInteractionRemindersEnabled,
    String? themeMode,
    List<String>? blockedUserIds,
  }) {
    return AppSettings(
      aiAnalysisEnabled: aiAnalysisEnabled ?? this.aiAnalysisEnabled,
      anonymousInPublic: anonymousInPublic ?? this.anonymousInPublic,
      diaryRemindersEnabled: diaryRemindersEnabled ?? this.diaryRemindersEnabled,
      aiInteractionRemindersEnabled:
          aiInteractionRemindersEnabled ?? this.aiInteractionRemindersEnabled,
      themeMode: themeMode ?? this.themeMode,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
    );
  }
}
