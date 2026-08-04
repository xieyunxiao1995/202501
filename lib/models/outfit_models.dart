class ClothingItem {
  final String id;
  final String name;
  final String type;
  final String image;
  final String color;
  final String style;
  final String season;
  final String occasion;
  final String note;
  final bool isLocalImage;

  const ClothingItem({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    this.color = '米色',
    this.style = '简约',
    this.season = '春秋',
    this.occasion = '通勤',
    this.note = '',
    this.isLocalImage = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'image': image,
    'color': color,
    'style': style,
    'season': season,
    'occasion': occasion,
    'note': note,
    'isLocalImage': isLocalImage,
  };

  factory ClothingItem.fromJson(Map<String, dynamic> json) => ClothingItem(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    image: json['image'] as String,
    color: json['color'] as String? ?? '米色',
    style: json['style'] as String? ?? '简约',
    season: json['season'] as String? ?? '春秋',
    occasion: json['occasion'] as String? ?? '通勤',
    note: json['note'] as String? ?? '',
    isLocalImage: json['isLocalImage'] as bool? ?? false,
  );

  ClothingItem copyWith({
    String? name,
    String? type,
    String? image,
    String? color,
    String? style,
    String? season,
    String? occasion,
    String? note,
    bool? isLocalImage,
  }) => ClothingItem(
    id: id,
    name: name ?? this.name,
    type: type ?? this.type,
    image: image ?? this.image,
    color: color ?? this.color,
    style: style ?? this.style,
    season: season ?? this.season,
    occasion: occasion ?? this.occasion,
    note: note ?? this.note,
    isLocalImage: isLocalImage ?? this.isLocalImage,
  );
}

class DiaryEntry {
  final String id;
  final String date;
  final String image;
  final bool isLocalImage;
  final String mood;
  final String weather;
  final List<String> tags;
  final List<String> clothingIds;
  final String note;
  final String occasion;
  final String source;

  const DiaryEntry({
    required this.id,
    required this.date,
    required this.image,
    required this.mood,
    required this.weather,
    required this.tags,
    this.isLocalImage = false,
    this.clothingIds = const [],
    this.note = '',
    this.occasion = '日常',
    this.source = 'manual',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'image': image,
    'isLocalImage': isLocalImage,
    'mood': mood,
    'weather': weather,
    'tags': tags,
    'clothingIds': clothingIds,
    'note': note,
    'occasion': occasion,
    'source': source,
  };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
    id: json['id'] as String? ?? json['date'] as String,
    date: json['date'] as String,
    image: json['image'] as String,
    isLocalImage: json['isLocalImage'] as bool? ?? false,
    mood: json['mood'] as String,
    weather: json['weather'] as String,
    tags: List<String>.from(json['tags'] as List? ?? const []),
    clothingIds: List<String>.from(json['clothingIds'] as List? ?? const []),
    note: json['note'] as String? ?? '',
    occasion: json['occasion'] as String? ?? '日常',
    source: json['source'] as String? ?? 'manual',
  );
}

class AiHistoryEntry {
  final String id;
  final String date;
  final String title;
  final String scene;
  final String style;
  final List<String> clothingIds;
  final String season;

  const AiHistoryEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.scene,
    required this.style,
    this.clothingIds = const [],
    this.season = '春秋',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'title': title,
    'scene': scene,
    'style': style,
    'clothingIds': clothingIds,
    'season': season,
  };

  factory AiHistoryEntry.fromJson(Map<String, dynamic> json) => AiHistoryEntry(
    id: json['id'] as String,
    date: json['date'] as String,
    title: json['title'] as String,
    scene: json['scene'] as String,
    style: json['style'] as String,
    clothingIds: List<String>.from(json['clothingIds'] as List? ?? const []),
    season: json['season'] as String? ?? '春秋',
  );
}
