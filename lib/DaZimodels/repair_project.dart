import 'dart:convert';

class RepairProject {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> photoPaths;
  final String damageType;
  final String material;
  final String aesthetic;
  final String crackNarrative;
  final int techniqueProgress;
  final List<String> aiRecommendations;
  final bool isArchived;

  const RepairProject({
    required this.id,
    required this.title,
    this.description = '',
    required this.createdAt,
    required this.updatedAt,
    this.photoPaths = const [],
    this.damageType = 'crack',
    this.material = 'stoneware',
    this.aesthetic = 'classic-gold',
    this.crackNarrative = '',
    this.techniqueProgress = 0,
    this.aiRecommendations = const [],
    this.isArchived = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'photoPaths': photoPaths,
      'damageType': damageType,
      'material': material,
      'aesthetic': aesthetic,
      'crackNarrative': crackNarrative,
      'techniqueProgress': techniqueProgress,
      'aiRecommendations': aiRecommendations,
      'isArchived': isArchived,
    };
  }

  factory RepairProject.fromJson(Map<String, dynamic> json) {
    return RepairProject(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      photoPaths: (json['photoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      damageType: json['damageType'] as String? ?? 'crack',
      material: json['material'] as String? ?? 'stoneware',
      aesthetic: json['aesthetic'] as String? ?? 'classic-gold',
      crackNarrative: json['crackNarrative'] as String? ?? '',
      techniqueProgress: json['techniqueProgress'] as int? ?? 0,
      aiRecommendations: (json['aiRecommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static RepairProject fromJsonString(String jsonString) {
    return RepairProject.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>);
  }

  RepairProject copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? photoPaths,
    String? damageType,
    String? material,
    String? aesthetic,
    String? crackNarrative,
    int? techniqueProgress,
    List<String>? aiRecommendations,
    bool? isArchived,
  }) {
    return RepairProject(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoPaths: photoPaths ?? this.photoPaths,
      damageType: damageType ?? this.damageType,
      material: material ?? this.material,
      aesthetic: aesthetic ?? this.aesthetic,
      crackNarrative: crackNarrative ?? this.crackNarrative,
      techniqueProgress: techniqueProgress ?? this.techniqueProgress,
      aiRecommendations: aiRecommendations ?? this.aiRecommendations,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}