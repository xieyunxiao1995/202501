/// Camp log entry model
class LogEntry {
  final String id;
  final DateTime date;
  final String? location;
  final List<String> photoUrls;
  final String content;
  final String? mood;
  final String? weather;
  final bool isPublished;

  const LogEntry({
    required this.id,
    required this.date,
    this.location,
    this.photoUrls = const [],
    required this.content,
    this.mood,
    this.weather,
    this.isPublished = false,
  });

  /// Create LogEntry from JSON
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      photoUrls:
          (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      content: json['content'] as String,
      mood: json['mood'] as String?,
      weather: json['weather'] as String?,
      isPublished: json['isPublished'] as bool? ?? false,
    );
  }

  /// Convert LogEntry to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'location': location,
      'photoUrls': photoUrls,
      'content': content,
      'mood': mood,
      'weather': weather,
      'isPublished': isPublished,
    };
  }

  /// Create a copy with updated fields
  LogEntry copyWith({
    String? id,
    DateTime? date,
    String? location,
    List<String>? photoUrls,
    String? content,
    String? mood,
    String? weather,
    bool? isPublished,
  }) {
    return LogEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      location: location ?? this.location,
      photoUrls: photoUrls ?? this.photoUrls,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      weather: weather ?? this.weather,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  String toString() => 'LogEntry(id: $id, date: $date, location: $location)';
}

/// Mood constants
class Mood {
  static const String happy = 'happy';
  static const String excited = 'excited';
  static const String peaceful = 'peaceful';
  static const String tired = 'tired';
  static const String adventurous = 'adventurous';
}
