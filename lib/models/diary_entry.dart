class DiaryEntry {
  final String id;
  final DateTime date;
  final String content;
  final String? image;
  final Mood mood;
  final String? aiInsight;
  final List<String>? aiTags;
  final String? location;

  DiaryEntry({
    required this.id,
    required this.date,
    required this.content,
    this.image,
    required this.mood,
    this.aiInsight,
    this.aiTags,
    this.location,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'content': content,
        'image': image,
        'mood': mood.name,
        'aiInsight': aiInsight,
        'aiTags': aiTags,
        'location': location,
      };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        id: json['id'],
        date: DateTime.parse(json['date']),
        content: json['content'],
        image: json['image'],
        mood: Mood.values.firstWhere((e) => e.name == json['mood']),
        aiInsight: json['aiInsight'],
        aiTags: json['aiTags'] != null ? List<String>.from(json['aiTags']) : null,
        location: json['location'],
      );

  DiaryEntry copyWith({
    String? id,
    DateTime? date,
    String? content,
    String? image,
    Mood? mood,
    String? aiInsight,
    List<String>? aiTags,
    String? location,
  }) =>
      DiaryEntry(
        id: id ?? this.id,
        date: date ?? this.date,
        content: content ?? this.content,
        image: image ?? this.image,
        mood: mood ?? this.mood,
        aiInsight: aiInsight ?? this.aiInsight,
        aiTags: aiTags ?? this.aiTags,
        location: location ?? this.location,
      );
}

enum Mood { joy, calm, anxiety, sadness }
