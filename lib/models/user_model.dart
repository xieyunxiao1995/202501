/// User model representing a user profile
class User {
  final String id;
  final String username;
  final String? displayName;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final int followers;
  final int trips;
  final int plans;
  final List<String> tags;
  final bool isVerified;

  const User({
    required this.id,
    required this.username,
    this.displayName,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    required this.followers,
    required this.trips,
    required this.plans,
    this.tags = const [],
    this.isVerified = false,
  });

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      followers: json['followers'] as int? ?? 0,
      trips: json['trips'] as int? ?? 0,
      plans: json['plans'] as int? ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'coverUrl': coverUrl,
      'followers': followers,
      'trips': trips,
      'plans': plans,
      'tags': tags,
      'isVerified': isVerified,
    };
  }

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? bio,
    String? avatarUrl,
    String? coverUrl,
    int? followers,
    int? trips,
    int? plans,
    List<String>? tags,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      followers: followers ?? this.followers,
      trips: trips ?? this.trips,
      plans: plans ?? this.plans,
      tags: tags ?? this.tags,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() => 'User(id: $id, username: $username)';
}
