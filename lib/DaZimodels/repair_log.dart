import 'dart:convert';

/// 修复日志条目模型
class RepairLogEntry {
  final String id;
  final String projectId;
  final DateTime date;
  final String title;
  final String description;
  final List<String> photoPaths;
  final List<String> materials;
  final List<String> tools;
  final String notes;
  final DateTime createdAt;

  const RepairLogEntry({
    required this.id,
    required this.projectId,
    required this.date,
    required this.title,
    this.description = '',
    this.photoPaths = const [],
    this.materials = const [],
    this.tools = const [],
    this.notes = '',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'photoPaths': photoPaths,
      'materials': materials,
      'tools': tools,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RepairLogEntry.fromJson(Map<String, dynamic> json) {
    return RepairLogEntry(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      photoPaths:
          (json['photoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      materials:
          (json['materials'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tools:
          (json['tools'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static RepairLogEntry fromJsonString(String jsonString) {
    return RepairLogEntry.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  RepairLogEntry copyWith({
    String? id,
    String? projectId,
    DateTime? date,
    String? title,
    String? description,
    List<String>? photoPaths,
    List<String>? materials,
    List<String>? tools,
    String? notes,
    DateTime? createdAt,
  }) {
    return RepairLogEntry(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      photoPaths: photoPaths ?? this.photoPaths,
      materials: materials ?? this.materials,
      tools: tools ?? this.tools,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
