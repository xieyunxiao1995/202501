// MoodStyle 数据持久化服务
// 使用 Hive 实现本地存储

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// 存储键常量
class StorageKeys {
  static const String timelineData = 'timeline_data';
  static const String communityPosts = 'community_posts';
  static const String outfits = 'outfits';
  static const String users = 'users';
  static const String isInitialized = 'is_initialized';
  static const String blockedUsers = 'blocked_users';
}

/// 数据持久化服务类
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Box<dynamic> _box;

  /// 初始化 Hive 数据库
  Future<void> init() async {
    await Hive.initFlutter();
    // 打开数据库
    _box = await Hive.openBox('moodstyle_db');
  }

  // ==================== TimelineItem 操作 ====================

  /// 保存 Timeline 列表
  Future<void> saveTimelineData(List<dynamic> items) async {
    // items 已经是 Map 列表，直接 jsonEncode
    final jsonData = items.map((item) {
      if (item is Map<String, dynamic>) {
        return jsonEncode(item);
      }
      return jsonEncode(item);
    }).toList();
    await _box.put(StorageKeys.timelineData, jsonData);
  }

  /// 读取 Timeline 列表
  List<dynamic>? getTimelineData() {
    final jsonData = _box.get(StorageKeys.timelineData) as List?;
    if (jsonData == null) return null;
    return jsonData
        .map((data) => jsonDecode(data) as Map<String, dynamic>)
        .toList();
  }

  /// 添加单个 Timeline 项
  Future<void> addTimelineItem(dynamic item) async {
    final items = getTimelineData() ?? [];
    items.insert(0, item);
    await saveTimelineData(items);
  }

  /// 删除 Timeline 项
  Future<void> removeTimelineItem(String id) async {
    final items = getTimelineData() ?? [];
    items.removeWhere((item) => item['id'] == id);
    await saveTimelineData(items);
  }

  // ==================== CommunityPost 操作 ====================

  /// 保存 CommunityPost 列表
  Future<void> saveCommunityPosts(List<dynamic> posts) async {
    final jsonData = posts.map((post) {
      if (post is Map<String, dynamic>) {
        return jsonEncode(post);
      }
      return jsonEncode(post);
    }).toList();
    await _box.put(StorageKeys.communityPosts, jsonData);
  }

  /// 读取 CommunityPost 列表
  List<dynamic>? getCommunityPosts() {
    final jsonData = _box.get(StorageKeys.communityPosts) as List?;
    if (jsonData == null) return null;
    return jsonData
        .map((data) => jsonDecode(data) as Map<String, dynamic>)
        .toList();
  }

  /// 更新帖子点赞状态
  Future<void> updatePostLike(String postId, int likes, bool isLiked) async {
    final posts = getCommunityPosts() ?? [];
    final index = posts.indexWhere((post) => post['id'] == postId);
    if (index != -1) {
      posts[index]['likes'] = likes;
      posts[index]['isLiked'] = isLiked;
      await saveCommunityPosts(posts);
    }
  }

  /// 添加新帖子
  Future<void> addCommunityPost(dynamic post) async {
    final posts = getCommunityPosts() ?? [];
    posts.insert(0, post);
    await saveCommunityPosts(posts);
  }

  // ==================== OutfitCard 操作 ====================

  /// 保存 Outfit 列表
  Future<void> saveOutfits(List<dynamic> outfits) async {
    final jsonData = outfits.map((outfit) {
      if (outfit is Map<String, dynamic>) {
        return jsonEncode(outfit);
      }
      return jsonEncode(outfit);
    }).toList();
    await _box.put(StorageKeys.outfits, jsonData);
  }

  /// 读取 Outfit 列表
  List<dynamic>? getOutfits() {
    final jsonData = _box.get(StorageKeys.outfits) as List?;
    if (jsonData == null) return null;
    return jsonData
        .map((data) => jsonDecode(data) as Map<String, dynamic>)
        .toList();
  }

  /// 更新 Outfit 保存状态
  Future<void> updateOutfitSaved(int index, bool isSaved) async {
    final outfits = getOutfits() ?? [];
    if (index >= 0 && index < outfits.length) {
      outfits[index]['isSaved'] = isSaved;
      await saveOutfits(outfits);
    }
  }

  // ==================== UserProfile 操作 ====================

  /// 保存用户列表
  Future<void> saveUsers(List<dynamic> users) async {
    final jsonData = users.map((user) {
      if (user is Map<String, dynamic>) {
        return jsonEncode(user);
      }
      return jsonEncode(user);
    }).toList();
    await _box.put(StorageKeys.users, jsonData);
  }

  /// 读取用户列表
  List<dynamic>? getUsers() {
    final jsonData = _box.get(StorageKeys.users) as List?;
    if (jsonData == null) return null;
    return jsonData
        .map((data) => jsonDecode(data) as Map<String, dynamic>)
        .toList();
  }

  /// 更新当前用户资料
  Future<void> updateUserProfile(
    String userId, {
    String? name,
    String? bio,
    String? location,
  }) async {
    final users = getUsers() ?? [];
    final index = users.indexWhere((user) => user['id'] == userId);
    if (index != -1) {
      if (name != null) users[index]['name'] = name;
      if (bio != null) users[index]['bio'] = bio;
      if (location != null) users[index]['location'] = location;
      await saveUsers(users);
    }
  }

  // ==================== Blocked Users 操作 ====================

  /// 保存被拉黑用户列表
  Future<void> saveBlockedUsers(List<String> users) async {
    await _box.put(StorageKeys.blockedUsers, users);
  }

  /// 读取被拉黑用户列表
  List<String>? getBlockedUsers() {
    final data = _box.get(StorageKeys.blockedUsers) as List?;
    return data?.cast<String>();
  }

  // ==================== 初始化状态 ====================

  /// 检查是否已初始化
  bool isInitialized() {
    return _box.get(StorageKeys.isInitialized, defaultValue: false);
  }

  /// 设置已初始化状态
  Future<void> setInitialized(bool value) async {
    await _box.put(StorageKeys.isInitialized, value);
  }

  /// 清除所有数据（用于重置）
  Future<void> clearAll() async {
    await _box.clear();
  }
}
