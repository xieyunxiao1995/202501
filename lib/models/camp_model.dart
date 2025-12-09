import 'gear_model.dart';

/// Camp plan model
class CampPlan {
  final String id;
  final String title;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final double? temperature;
  final String? weatherCondition;
  final String status;
  final String season;
  final double? estimatedWeight;
  final List<GearItem> gearList;
  final String? creatorId;
  final bool isPublic;

  const CampPlan({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.temperature,
    this.weatherCondition,
    required this.status,
    required this.season,
    this.estimatedWeight,
    this.gearList = const [],
    this.creatorId,
    this.isPublic = false,
  });

  /// Calculate completion percentage
  double get completionPercentage {
    if (gearList.isEmpty) return 0;
    final packed = gearList.where((item) => item.isPacked).length;
    return (packed / gearList.length) * 100;
  }

  /// Get total gear count
  int get totalGearCount => gearList.length;

  /// Get packed gear count
  int get packedGearCount => gearList.where((item) => item.isPacked).length;

  /// Create CampPlan from JSON
  factory CampPlan.fromJson(Map<String, dynamic> json) {
    return CampPlan(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      temperature: (json['temperature'] as num?)?.toDouble(),
      weatherCondition: json['weatherCondition'] as String?,
      status: json['status'] as String,
      season: json['season'] as String,
      estimatedWeight: (json['estimatedWeight'] as num?)?.toDouble(),
      gearList:
          (json['gearList'] as List<dynamic>?)
              ?.map((e) => GearItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      creatorId: json['creatorId'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
    );
  }

  /// Convert CampPlan to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'temperature': temperature,
      'weatherCondition': weatherCondition,
      'status': status,
      'season': season,
      'estimatedWeight': estimatedWeight,
      'gearList': gearList.map((e) => e.toJson()).toList(),
      'creatorId': creatorId,
      'isPublic': isPublic,
    };
  }

  /// Create a copy with updated fields
  CampPlan copyWith({
    String? id,
    String? title,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    double? temperature,
    String? weatherCondition,
    String? status,
    String? season,
    double? estimatedWeight,
    List<GearItem>? gearList,
    String? creatorId,
    bool? isPublic,
  }) {
    return CampPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      temperature: temperature ?? this.temperature,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      status: status ?? this.status,
      season: season ?? this.season,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      gearList: gearList ?? this.gearList,
      creatorId: creatorId ?? this.creatorId,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  @override
  String toString() => 'CampPlan(id: $id, title: $title, location: $location)';
}

/// Plan status constants
class PlanStatus {
  static const String goodToGo = 'good_to_go';
  static const String checkWeather = 'check_weather';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
}

/// Season constants
class Season {
  static const String spring = 'spring';
  static const String summer = 'summer';
  static const String autumn = 'autumn';
  static const String winter = 'winter';
}
