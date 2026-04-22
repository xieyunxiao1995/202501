// MoodStyle Mock Data & State Management
// 使用 ChangeNotifier 实现响应式状态管理

import 'package:flutter/material.dart';
import '../services/storage_service.dart';

enum MoodType { happy, sad, excited, chill }

class Mood {
  final String icon;
  final String label;
  final MoodType type;

  Mood({required this.icon, required this.label, required this.type});
}

class Weather {
  final String icon;
  final String label;

  Weather({required this.icon, required this.label});
}

class TimelineItem {
  final String id;
  final String dateLabel;
  final String timeLabel;
  final DateTime timestamp;
  final Mood mood;
  final Weather weather;
  final String content;
  final List<String> images;
  final List<String> tags;
  final bool isOotd;

  TimelineItem({
    required this.id,
    required this.dateLabel,
    required this.timeLabel,
    required this.timestamp,
    required this.mood,
    required this.weather,
    required this.content,
    this.images = const [],
    this.tags = const [],
    this.isOotd = false,
  });
}

// CommunityPost 模型 - 移除 shares 字段
class CommunityPost {
  final String id;
  final String type; // 'ootd', 'mood', 'flatlay'
  final String? imageUrl;
  final String? tag;
  final String? tagColor;
  final String? content;
  final String? timeAgo;
  final String? userName;
  final String? userAvatar;
  int likes; // 可变，支持点赞操作
  bool isLiked; // 跟踪当前用户是否点赞
  final String? gradientFrom;
  final String? gradientTo;
  int comments; // 评论数
  DateTime createdAt; // 创建时间

  CommunityPost({
    required this.id,
    required this.type,
    this.imageUrl,
    this.tag,
    this.tagColor,
    this.content,
    this.timeAgo,
    this.userName,
    this.userAvatar,
    this.likes = 0,
    this.isLiked = false,
    this.gradientFrom,
    this.gradientTo,
    this.comments = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class OutfitCard {
  final String imageUrl;
  final String matchPercentage;
  final String description;
  bool isSaved; // 跟踪是否已保存
  final String? scene; // 场景标签

  OutfitCard({
    required this.imageUrl,
    required this.matchPercentage,
    required this.description,
    this.isSaved = false,
    this.scene,
  });
}

class UserProfile {
  final String id;
  String name;
  String email;
  String? avatar;
  String? bio;
  int entriesCount;
  int followersCount;
  int followingCount;
  String? location;
  DateTime? joinDate;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    this.entriesCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.location,
    this.joinDate,
  });
}

// ============================================================
// 单例 AppState - 全局状态管理（集成 Hive 持久化）
// ============================================================

class AppState extends ChangeNotifier {
  static AppState? _instance;
  final StorageService _storage = StorageService();

  // 获取单例实例
  static AppState get instance {
    _instance ??= AppState._internal();
    return _instance!;
  }

  AppState._internal();

  // 私有数据列表 - 可变列表支持增删操作
  List<TimelineItem> _timelineData = [];
  List<CommunityPost> _communityPosts = [];
  List<OutfitCard> _outfits = [];
  List<UserProfile> _users = [];
  List<String> _blockedUsers = [];
  Set<int> _outfitFavorites = {};

  // 加载状态
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // 公开只读数据视图
  List<TimelineItem> get timelineData => List.unmodifiable(_timelineData);
  List<CommunityPost> get communityPosts => List.unmodifiable(_communityPosts);
  List<OutfitCard> get outfits => List.unmodifiable(_outfits);
  List<UserProfile> get users => List.unmodifiable(_users);
  List<String> get blockedUsers => List.unmodifiable(_blockedUsers);
  Set<int> get outfitFavorites => Set.unmodifiable(_outfitFavorites);

  // 当前用户（用于个人中心）
  UserProfile? _currentUser;
  UserProfile? get currentUser => _currentUser;

  bool isOutfitFavorite(int index) => _outfitFavorites.contains(index);
  int get favoriteCount => _outfitFavorites.length;

  /// 初始化数据（异步加载 Hive 数据）
  Future<void> initialize() async {
    try {
      // 初始化 Hive
      await _storage.init();

      // 尝试从 Hive 加载数据（返回的是 Map 列表）
      final timelineJson = _storage.getTimelineData();
      final communityJson = _storage.getCommunityPosts();
      final outfitsJson = _storage.getOutfits();
      final usersJson = _storage.getUsers();
      final blockedUsersJson = _storage.getBlockedUsers();

      // 如果有持久化数据则使用，否则使用 mock 数据
      _timelineData.clear();
      if (timelineJson != null && timelineJson.isNotEmpty) {
        for (var json in timelineJson) {
          _timelineData.add(timelineItemFromJson(json));
        }
      } else {
        _timelineData.addAll(mockTimelineData);
        await _storage.saveTimelineData(_timelineData);
      }

      _communityPosts.clear();
      if (communityJson != null && communityJson.isNotEmpty) {
        for (var json in communityJson) {
          _communityPosts.add(communityPostFromJson(json));
        }
      } else {
        _communityPosts.addAll(mockCommunityPosts);
        await _storage.saveCommunityPosts(_communityPosts);
      }

      _outfits.clear();
      if (outfitsJson != null && outfitsJson.isNotEmpty) {
        for (var json in outfitsJson) {
          _outfits.add(outfitCardFromJson(json));
        }
      } else {
        _outfits.addAll(mockOutfits);
        await _storage.saveOutfits(_outfits);
      }

      _users.clear();
      if (usersJson != null && usersJson.isNotEmpty) {
        for (var json in usersJson) {
          _users.add(userProfileFromJson(json));
        }
      } else {
        _users.addAll(mockUsers);
        await _storage.saveUsers(_users);
      }

      _blockedUsers.clear();
      if (blockedUsersJson != null && blockedUsersJson.isNotEmpty) {
        _blockedUsers.addAll(blockedUsersJson);
      }

      _outfitFavorites.clear();
      final favoritesJson = _storage.getOutfitFavorites();
      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        _outfitFavorites.addAll(favoritesJson);
      }

      _currentUser = _users.isNotEmpty ? _users[0] : null;

      // 标记为已初始化
      await _storage.setInitialized(true);
    } catch (e) {
      // 如果加载失败，使用 mock 数据作为后备
      _timelineData.addAll(mockTimelineData);
      _communityPosts.addAll(mockCommunityPosts);
      _outfits.addAll(mockOutfits);
      _users.addAll(mockUsers);
      _currentUser = _users.isNotEmpty ? _users[0] : null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Timeline 操作 ====================

  /// 添加新的 Timeline 条目（持久化）
  Future<void> addTimelineItem(TimelineItem item) async {
    _timelineData.insert(0, item);
    _currentUser?.entriesCount = _timelineData.length;
    // 保存为 JSON Map
    await _storage.addTimelineItem(timelineItemToJson(item));
    await _storage.saveUsers(_users.map((u) => userProfileToJson(u)).toList());
    notifyListeners();
  }

  /// 删除 Timeline 条目（持久化）
  Future<void> removeTimelineItem(String id) async {
    _timelineData.removeWhere((item) => item.id == id);
    _currentUser?.entriesCount = _timelineData.length;
    final jsonList = _timelineData
        .map((item) => timelineItemToJson(item))
        .toList();
    await _storage.removeTimelineItem(id);
    await _storage.saveTimelineData(jsonList);
    await _storage.saveUsers(_users.map((u) => userProfileToJson(u)).toList());
    notifyListeners();
  }

  /// 更新 Timeline 条目（持久化）
  Future<void> updateTimelineItem(String id, TimelineItem newItem) async {
    final index = _timelineData.indexWhere((item) => item.id == id);
    if (index != -1) {
      _timelineData[index] = newItem;
      final jsonList = _timelineData
          .map((item) => timelineItemToJson(item))
          .toList();
      await _storage.saveTimelineData(jsonList);
      notifyListeners();
    }
  }

  /// 根据月份过滤 Timeline
  List<TimelineItem> getTimelineByMonth(DateTime month) {
    return _timelineData.where((item) {
      return item.timestamp.year == month.year &&
          item.timestamp.month == month.month;
    }).toList();
  }

  /// 根据日期过滤 Timeline
  List<TimelineItem> getTimelineByDate(DateTime date) {
    return _timelineData.where((item) {
      return item.timestamp.year == date.year &&
          item.timestamp.month == date.month &&
          item.timestamp.day == date.day;
    }).toList();
  }

  /// 搜索 Timeline
  List<TimelineItem> searchTimeline(String query) {
    if (query.isEmpty) {
      return _timelineData;
    }
    final lowerQuery = query.toLowerCase();
    return _timelineData.where((item) {
      return item.content.toLowerCase().contains(lowerQuery) ||
          item.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          item.mood.label.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // ==================== Community Post 操作 ====================

  /// 拉黑用户
  Future<void> blockUser(String userName) async {
    if (!_blockedUsers.contains(userName)) {
      _blockedUsers.add(userName);
      await _storage.saveBlockedUsers(_blockedUsers);
      notifyListeners();
    }
  }

  /// 切换点赞状态（持久化）
  Future<void> togglePostLike(String postId) async {
    final post = _communityPosts.firstWhere(
      (p) => p.id == postId,
      orElse: () => throw Exception('帖子未找到'),
    );

    if (post.isLiked) {
      post.likes = (post.likes - 1).clamp(0, 9999);
    } else {
      post.likes = post.likes + 1;
    }
    post.isLiked = !post.isLiked;
    await _storage.updatePostLike(postId, post.likes, post.isLiked);
    notifyListeners();
  }

  /// 添加新帖子（持久化）
  Future<void> addCommunityPost(CommunityPost post) async {
    _communityPosts.insert(0, post);
    await _storage.addCommunityPost(communityPostToJson(post));
    notifyListeners();
  }

  /// 删除帖子（持久化）
  Future<void> removeCommunityPost(String id) async {
    _communityPosts.removeWhere((post) => post.id == id);
    final jsonList = _communityPosts
        .map((p) => communityPostToJson(p))
        .toList();
    await _storage.saveCommunityPosts(jsonList);
    notifyListeners();
  }

  /// 根据类型过滤帖子（过滤掉被拉黑用户的内容）
  List<CommunityPost> getPostsByType(String type) {
    // 过滤掉已被拉黑的作者发的内容
    final visiblePosts = _communityPosts.where((post) {
      final author = post.userName ?? '匿名用户';
      return !_blockedUsers.contains(author);
    }).toList();

    if (type == 'all') {
      return visiblePosts;
    }
    return visiblePosts.where((post) => post.type == type).toList();
  }

  // ==================== Outfit 操作 ====================

  /// 切换保存状态（持久化）
  Future<void> toggleOutfitSaved(int index) async {
    if (index >= 0 && index < _outfits.length) {
      _outfits[index].isSaved = !_outfits[index].isSaved;
      final jsonList = _outfits.map((o) => outfitCardToJson(o)).toList();
      await _storage.updateOutfitSaved(index, _outfits[index].isSaved);
      await _storage.saveOutfits(jsonList);
      notifyListeners();
    }
  }

  /// 添加新的 Outfit（用于 AI 生成）
  void addOutfit(OutfitCard outfit) {
    _outfits.insert(0, outfit);
    notifyListeners();
  }

  /// 获取已保存的 Outfit
  List<OutfitCard> get savedOutfits {
    return _outfits.where((outfit) => outfit.isSaved).toList();
  }

  /// 切换穿搭收藏状态（持久化）
  Future<void> toggleOutfitFavorite(int index) async {
    if (_outfitFavorites.contains(index)) {
      _outfitFavorites.remove(index);
    } else {
      _outfitFavorites.add(index);
    }
    await _storage.saveOutfitFavorites(_outfitFavorites.toList());
    notifyListeners();
  }

  // ==================== User 操作 ====================

  /// 更新当前用户资料（持久化）
  Future<void> updateCurrentUser({
    String? name,
    String? bio,
    String? location,
  }) async {
    if (_currentUser != null) {
      if (name != null) _currentUser!.name = name;
      if (bio != null) _currentUser!.bio = bio;
      if (location != null) _currentUser!.location = location;
      final jsonList = _users.map((u) => userProfileToJson(u)).toList();
      await _storage.updateUserProfile(
        _currentUser!.id,
        name: name,
        bio: bio,
        location: location,
      );
      await _storage.saveUsers(jsonList);
      notifyListeners();
    }
  }

  /// 切换深色模式（占位符，实际由主题系统管理）
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ==================== 登录状态管理 ====================

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  // ==================== EULA 同意状态管理 ====================

  bool _eulaAgreed = false;
  bool get eulaAgreed => _eulaAgreed;

  void setEulaAgreed(bool value) {
    _eulaAgreed = value;
    notifyListeners();
  }

  // ==================== 统计信息 ====================

  /// 获取心情统计
  Map<String, int> getMoodStats() {
    final stats = <String, int>{'happy': 0, 'chill': 0, 'excited': 0, 'sad': 0};

    for (final item in _timelineData) {
      switch (item.mood.type) {
        case MoodType.happy:
          stats['happy'] = stats['happy']! + 1;
          break;
        case MoodType.chill:
          stats['chill'] = stats['chill']! + 1;
          break;
        case MoodType.excited:
          stats['excited'] = stats['excited']! + 1;
          break;
        case MoodType.sad:
          stats['sad'] = stats['sad']! + 1;
          break;
      }
    }

    return stats;
  }

  /// 获取当前月份的心情统计
  Map<String, int> getCurrentMonthMoodStats() {
    final now = DateTime.now();
    final stats = <String, int>{'happy': 0, 'chill': 0, 'excited': 0, 'sad': 0};

    final monthData = getTimelineByMonth(now);
    for (final item in monthData) {
      switch (item.mood.type) {
        case MoodType.happy:
          stats['happy'] = stats['happy']! + 1;
          break;
        case MoodType.chill:
          stats['chill'] = stats['chill']! + 1;
          break;
        case MoodType.excited:
          stats['excited'] = stats['excited']! + 1;
          break;
        case MoodType.sad:
          stats['sad'] = stats['sad']! + 1;
          break;
      }
    }

    return stats;
  }
}

// ============================================================
// Mock Data - 初始数据 (修复了无效图片并且移除了 Shares)
// ============================================================

final List<TimelineItem> mockTimelineData = [];

// Community 帖子 - 使用穿搭创意图片
final List<CommunityPost> mockCommunityPosts = [
  CommunityPost(
    id: '1',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_01.png',
    tag: '#雅痞休闲 ☕',
    userName: '林深',
    userAvatar: 'assets/role2.png',
    likes: 256,
    content: '灰色休闲西装+黑色T恤，雅痞范十足的酒吧穿搭灵感',
    comments: 42,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  CommunityPost(
    id: '2',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_02.png',
    tag: '#初秋日常 🍂',
    userName: '秋叶',
    userAvatar: 'assets/role4.png',
    likes: 189,
    content: '银杏树下的灯芯绒外套，初秋温暖质感穿搭',
    comments: 35,
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  CommunityPost(
    id: '3',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_03.png',
    tag: '#高级极简 🖤',
    userName: 'Vera',
    userAvatar: 'assets/role6.png',
    likes: 342,
    content: '黑色V领裙的极简美学，会议室里的优雅力量',
    comments: 67,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  CommunityPost(
    id: '4',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_04.png',
    tag: '#海岛度假 🏖️',
    userName: '海风',
    userAvatar: 'assets/role8.png',
    likes: 421,
    content: '亚麻衬衫+牛仔短裤，海边度假的清爽公式',
    comments: 78,
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  CommunityPost(
    id: '5',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_05.png',
    tag: '#极简Cityboy ☕',
    userName: 'CityBoy',
    userAvatar: 'assets/role10.png',
    likes: 198,
    content: '一杯咖啡+一件白T，Cityboy的极简穿搭哲学',
    comments: 31,
    createdAt: DateTime.now().subtract(const Duration(hours: 10)),
  ),
  CommunityPost(
    id: '6',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_06.png',
    tag: '#互联网休闲 💻',
    userName: '科技女孩',
    userAvatar: 'assets/role12.png',
    likes: 276,
    content: '浅蓝条纹牛津纺衬衫，互联网人的舒适与专业',
    comments: 52,
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  CommunityPost(
    id: '7',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_07.png',
    tag: '#秋冬暖男 📚',
    userName: '暖男日记',
    userAvatar: 'assets/role14.png',
    likes: 312,
    content: '北欧风粗绞花毛衣，咖啡店里的秋冬温暖穿搭',
    comments: 58,
    createdAt: DateTime.now().subtract(const Duration(hours: 15)),
  ),
  CommunityPost(
    id: '8',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_08.png',
    tag: '#日系盐系 📖',
    userName: '盐系女孩',
    userAvatar: 'assets/role1.png',
    likes: 234,
    content: '藏青色半高领T恤，书店里的文艺盐系穿搭',
    comments: 45,
    createdAt: DateTime.now().subtract(const Duration(hours: 18)),
  ),
  CommunityPost(
    id: '9',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_09.png',
    tag: '#冬日氛围 ❄️',
    userName: '冬日暖阳',
    userAvatar: 'assets/role3.png',
    likes: 187,
    content: '深灰羊毛大衣，冬日阳台的温暖穿搭灵感',
    comments: 29,
    createdAt: DateTime.now().subtract(const Duration(hours: 20)),
  ),
  CommunityPost(
    id: '10',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_10.png',
    tag: '#晚间散步 🌙',
    userName: '夜行者',
    userAvatar: 'assets/role5.png',
    likes: 156,
    content: 'Oversize连帽卫衣，江边夜步的自在穿搭',
    comments: 24,
    createdAt: DateTime.now().subtract(const Duration(hours: 22)),
  ),
  CommunityPost(
    id: '11',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_11.png',
    tag: '#滑板少年 🛹',
    userName: '街头玩家',
    userAvatar: 'assets/role7.png',
    likes: 298,
    content: '印花T恤+阔腿牛仔裤，滑板公园的街头穿搭',
    comments: 56,
    createdAt: DateTime.now().subtract(const Duration(hours: 24)),
  ),
  CommunityPost(
    id: '12',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_12.png',
    tag: '#夏日办公 💼',
    userName: '职场精英',
    userAvatar: 'assets/role9.png',
    likes: 213,
    content: '浅蓝短袖衬衫，夏日会议室的清爽职场穿搭',
    comments: 38,
    createdAt: DateTime.now().subtract(const Duration(hours: 26)),
  ),
  CommunityPost(
    id: '13',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_13.png',
    tag: '#复古美式 🏍️',
    userName: '机车男孩',
    userAvatar: 'assets/role11.png',
    likes: 367,
    content: '水洗牛仔夹克，机车旁的复古美式穿搭',
    comments: 72,
    createdAt: DateTime.now().subtract(const Duration(hours: 28)),
  ),
  CommunityPost(
    id: '14',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_14.png',
    tag: '#复古街头 🖤',
    userName: '街头酷女孩',
    userAvatar: 'assets/role13.png',
    likes: 445,
    content: 'Oversize做旧皮夹克，城市街头的酷感穿搭',
    comments: 89,
    createdAt: DateTime.now().subtract(const Duration(hours: 30)),
  ),
  CommunityPost(
    id: '15',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_15.png',
    tag: '#痞帅机车 🏎️',
    userName: '痞帅先生',
    userAvatar: 'assets/role15.png',
    likes: 389,
    content: '棕色皮质飞行员夹克，跑车旁的痞帅穿搭',
    comments: 76,
    createdAt: DateTime.now().subtract(const Duration(hours: 32)),
  ),
  CommunityPost(
    id: '16',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_16.png',
    tag: '#公园野餐 🧺',
    userName: '法式女孩',
    userAvatar: 'assets/role2.png',
    likes: 512,
    content: '法式碎花连衣裙，公园野餐的浪漫穿搭',
    comments: 98,
    createdAt: DateTime.now().subtract(const Duration(hours: 34)),
  ),
  CommunityPost(
    id: '17',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_17.png',
    tag: '#居家慵懒 🛋️',
    userName: '宅家日记',
    userAvatar: 'assets/role4.png',
    likes: 178,
    content: '浅灰针织家居服，周末居家的慵懒穿搭',
    comments: 27,
    createdAt: DateTime.now().subtract(const Duration(hours: 36)),
  ),
  CommunityPost(
    id: '18',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_18.png',
    tag: '#工装机能 🪖',
    userName: '机能女孩',
    userAvatar: 'assets/role6.png',
    likes: 267,
    content: '军绿工装裤+印花T恤，酷帅机能风穿搭',
    comments: 51,
    createdAt: DateTime.now().subtract(const Duration(hours: 38)),
  ),
  CommunityPost(
    id: '19',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_19.png',
    tag: '#互联网风 💻',
    userName: '码农穿搭',
    userAvatar: 'assets/role8.png',
    likes: 198,
    content: '摇粒绒马甲+浅蓝衬衫，工位实用穿搭',
    comments: 34,
    createdAt: DateTime.now().subtract(const Duration(hours: 40)),
  ),
  CommunityPost(
    id: '20',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_20.png',
    tag: '#温柔韩系 ☕',
    userName: '韩系女孩',
    userAvatar: 'assets/role10.png',
    likes: 356,
    content: '米色粗针织毛衣，咖啡馆里的韩系温柔穿搭',
    comments: 68,
    createdAt: DateTime.now().subtract(const Duration(hours: 42)),
  ),
  CommunityPost(
    id: '21',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_21.png',
    tag: '#温柔知性 📚',
    userName: '知性小姐',
    userAvatar: 'assets/role12.png',
    likes: 289,
    content: '杏色V领开衫，图书馆的知性穿搭灵感',
    comments: 54,
    createdAt: DateTime.now().subtract(const Duration(hours: 44)),
  ),
  CommunityPost(
    id: '22',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_22.png',
    tag: '#清新春日 🌸',
    userName: '春日少女',
    userAvatar: 'assets/role14.png',
    likes: 423,
    content: '碎花裙+牛仔夹克，春日公园的清新穿搭',
    comments: 82,
    createdAt: DateTime.now().subtract(const Duration(hours: 46)),
  ),
  CommunityPost(
    id: '23',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_23.png',
    tag: '#周末咖啡馆 ☕',
    userName: '咖啡控',
    userAvatar: 'assets/role1.png',
    likes: 234,
    content: '粗麻花毛衣+碎花裙，露天咖啡座的惬意穿搭',
    comments: 43,
    createdAt: DateTime.now().subtract(const Duration(hours: 48)),
  ),
  CommunityPost(
    id: '24',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_24.png',
    tag: '#雅痞轻熟 ☕',
    userName: '轻熟男',
    userAvatar: 'assets/role3.png',
    likes: 312,
    content: '灰色休闲西装，商务区的轻熟雅痞穿搭',
    comments: 59,
    createdAt: DateTime.now().subtract(const Duration(hours: 50)),
  ),
  CommunityPost(
    id: '25',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_25.png',
    tag: '#商务出差 ✈️',
    userName: '空中飞人',
    userAvatar: 'assets/role5.png',
    likes: 187,
    content: '抗皱风衣+藏青Polo，机场候机的商务穿搭',
    comments: 31,
    createdAt: DateTime.now().subtract(const Duration(hours: 52)),
  ),
  CommunityPost(
    id: '26',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_26.png',
    tag: '#夏日度假 🎵',
    userName: '音乐节玩家',
    userAvatar: 'assets/role7.png',
    likes: 398,
    content: '印花丝绸衬衫，音乐节的夏日度假穿搭',
    comments: 76,
    createdAt: DateTime.now().subtract(const Duration(hours: 54)),
  ),
  CommunityPost(
    id: '27',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_27.png',
    tag: '#创意行业 🎨',
    userName: '设计师穿搭',
    userAvatar: 'assets/role9.png',
    likes: 276,
    content: 'Oversize黑色西装，设计工作室的创意穿搭',
    comments: 52,
    createdAt: DateTime.now().subtract(const Duration(hours: 56)),
  ),
  CommunityPost(
    id: '28',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_28.png',
    tag: '#周五半正式 💼',
    userName: '职场丽人',
    userAvatar: 'assets/role11.png',
    likes: 345,
    content: '粗花呢外套+真丝吊带，周五Smart Casual穿搭',
    comments: 65,
    createdAt: DateTime.now().subtract(const Duration(hours: 58)),
  ),
  CommunityPost(
    id: '29',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_29.png',
    tag: '#法式职场 🇫🇷',
    userName: '法式优雅',
    userAvatar: 'assets/role13.png',
    likes: 467,
    content: '米色双排扣风衣，通勤路上的法式优雅穿搭',
    comments: 89,
    createdAt: DateTime.now().subtract(const Duration(hours: 60)),
  ),
  CommunityPost(
    id: '30',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_30.png',
    tag: '#滑板街头 🛹',
    userName: '街头潮人',
    userAvatar: 'assets/role15.png',
    likes: 298,
    content: '黑色连帽卫衣，滑板场的街头酷感穿搭',
    comments: 56,
    createdAt: DateTime.now().subtract(const Duration(hours: 62)),
  ),
  CommunityPost(
    id: '31',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_31.png',
    tag: '#商场购物 🛍️',
    userName: '购物达人',
    userAvatar: 'assets/role2.png',
    likes: 345,
    content: '针织短袖+高腰牛仔裙，商场逛街的活力穿搭',
    comments: 62,
    createdAt: DateTime.now().subtract(const Duration(hours: 64)),
  ),
  CommunityPost(
    id: '32',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_32.png',
    tag: '#运动休闲 🏃‍♀️',
    userName: '运动女孩',
    userAvatar: 'assets/role4.png',
    likes: 267,
    content: '黑色防风运动套装，天台的利落运动穿搭',
    comments: 48,
    createdAt: DateTime.now().subtract(const Duration(hours: 66)),
  ),
  CommunityPost(
    id: '33',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_33.png',
    tag: '#运动高街 👟',
    userName: '高街玩家',
    userAvatar: 'assets/role6.png',
    likes: 312,
    content: '拼色防风外套+束脚裤，地铁站的运动高街穿搭',
    comments: 57,
    createdAt: DateTime.now().subtract(const Duration(hours: 68)),
  ),
  CommunityPost(
    id: '34',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_34.png',
    tag: '#干练商务 💼',
    userName: '职场女强人',
    userAvatar: 'assets/role8.png',
    likes: 423,
    content: '深灰西服套装+白衬衫，写字楼的专业气场穿搭',
    comments: 78,
    createdAt: DateTime.now().subtract(const Duration(hours: 70)),
  ),
  CommunityPost(
    id: '35',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_35.png',
    tag: '#老钱风职场 🎩',
    userName: '绅士穿搭',
    userAvatar: 'assets/role10.png',
    likes: 389,
    content: '米色羊毛开衫+牛津纺衬衫，写字楼大堂的低调奢华',
    comments: 71,
    createdAt: DateTime.now().subtract(const Duration(hours: 72)),
  ),
  CommunityPost(
    id: '36',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_36.png',
    tag: '#运动混搭 🏋️‍♀️',
    userName: '健身达人',
    userAvatar: 'assets/role12.png',
    likes: 278,
    content: '黑色短款夹克+瑜伽裤，健身房出来的时尚穿搭',
    comments: 52,
    createdAt: DateTime.now().subtract(const Duration(hours: 74)),
  ),
  CommunityPost(
    id: '37',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_37.png',
    tag: '#现代商务 💼',
    userName: '商务精英',
    userAvatar: 'assets/role14.png',
    likes: 356,
    content: '藏青色西装+白衬衫，办公室的经典商务穿搭',
    comments: 65,
    createdAt: DateTime.now().subtract(const Duration(hours: 76)),
  ),
  CommunityPost(
    id: '38',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_38.png',
    tag: '#创意总监 🎨',
    userName: '设计总监',
    userAvatar: 'assets/role1.png',
    likes: 298,
    content: '深棕灯芯绒衬衫，设计公司的质感穿搭',
    comments: 54,
    createdAt: DateTime.now().subtract(const Duration(hours: 78)),
  ),
  CommunityPost(
    id: '39',
    type: 'ootd',
    imageUrl: 'assets/dapei/dapei_39.png',
    tag: '#复古学院 📚',
    userName: '学院风男孩',
    userAvatar: 'assets/role3.png',
    likes: 234,
    content: '菱格纹针织开衫+白衬衫，书店里的文艺穿搭',
    comments: 43,
    createdAt: DateTime.now().subtract(const Duration(hours: 80)),
  ),
];

// Outfit 卡片 - 使用本地资源图片
final List<OutfitCard> mockOutfits = [
  OutfitCard(
    imageUrl: 'assets/role1.png',
    matchPercentage: '98% 匹配',
    description: '清新绿色系穿搭，完美呼应你的活力心情，浅色牛仔让你在阳光下更加耀眼！',
    scene: '春日郊游',
  ),
  OutfitCard(
    imageUrl: 'assets/role3.png',
    matchPercentage: '95% 匹配',
    description: '宽松舒适的亚麻套装，透气性极佳，让你的每一步都充满自在与优雅。',
    scene: '周末休闲',
  ),
  OutfitCard(
    imageUrl: 'assets/role5.png',
    matchPercentage: '92% 匹配',
    description: '随性又酷的街头风格，宽松版型平衡了你的高能量和最大舒适度。',
    scene: '城市漫步',
  ),
  OutfitCard(
    imageUrl: 'assets/role7.png',
    matchPercentage: '90% 匹配',
    description: '简约干练的通勤穿搭，优雅而不失专业感，职场女性的最佳选择。',
    scene: '职场通勤',
  ),
  OutfitCard(
    imageUrl: 'assets/role9.png',
    matchPercentage: '88% 匹配',
    description: '温柔浪漫的春日搭配，把春天穿在身上，让你成为最靓丽的风景线。',
    scene: '约会聚餐',
  ),
  OutfitCard(
    imageUrl: 'assets/role11.png',
    matchPercentage: '86% 匹配',
    description: '精致优雅的小黑裙，经典永不过时，让你在任何场合都闪闪发光。',
    scene: '晚宴派对',
  ),
  OutfitCard(
    imageUrl: 'assets/role13.png',
    matchPercentage: '85% 匹配',
    description: '活力运动风，舒适与时尚并存，让你在运动中也能展现最佳状态。',
    scene: '运动健身',
  ),
  OutfitCard(
    imageUrl: 'assets/role15.png',
    matchPercentage: '83% 匹配',
    description: '极简主义风格，少即是多，简单的搭配反而最耐看最有品味。',
    scene: '日常百搭',
  ),
];

// 用户资料数据 - 替换了失效链接
final List<UserProfile> mockUsers = [
  UserProfile(
    id: '1',
    name: 'Sarah',
    email: 'sarah@example.com',
    avatar:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
    bio: '时尚爱好者 | 咖啡控 | 一套穿搭一套生活 ✨',
    entriesCount: 156,
    followersCount: 1234,
    followingCount: 567,
    location: '旧金山，加州',
    joinDate: DateTime(2022, 3, 15),
  ),
  UserProfile(
    id: '2',
    name: 'Emma_Style',
    email: 'emma@style.com',
    avatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&auto=format&fit=crop',
    bio: 'Style blogger | Pastel lover | Spreading positivity 🌸',
    entriesCount: 89,
    followersCount: 5678,
    followingCount: 234,
    location: 'New York, NY',
    joinDate: DateTime(2021, 8, 22),
  ),
];

// 常用标签列表
final List<String> commonTags = [
  '#OOTD',
  '#Fashion',
  '#Style',
  '#Mood',
  '#SelfCare',
  '#Confident',
  '#Chill',
  '#Excited',
];

// ============================================================
// JSON 序列化/反序列化辅助函数 (已移除 shares)
// ============================================================

Map<String, dynamic> timelineItemToJson(TimelineItem item) {
  return {
    'id': item.id,
    'dateLabel': item.dateLabel,
    'timeLabel': item.timeLabel,
    'timestamp': item.timestamp.millisecondsSinceEpoch,
    'mood': moodToJson(item.mood),
    'weather': weatherToJson(item.weather),
    'content': item.content,
    'images': item.images,
    'tags': item.tags,
    'isOotd': item.isOotd,
  };
}

TimelineItem timelineItemFromJson(Map<String, dynamic> json) {
  return TimelineItem(
    id: json['id'] as String,
    dateLabel: json['dateLabel'] as String,
    timeLabel: json['timeLabel'] as String,
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    mood: moodFromJson(json['mood'] as Map<String, dynamic>),
    weather: weatherFromJson(json['weather'] as Map<String, dynamic>),
    content: json['content'] as String,
    images: (json['images'] as List?)?.cast<String>() ?? [],
    tags: (json['tags'] as List?)?.cast<String>() ?? [],
    isOotd: json['isOotd'] as bool? ?? false,
  );
}

Map<String, dynamic> moodToJson(Mood mood) {
  return {'icon': mood.icon, 'label': mood.label, 'type': mood.type.index};
}

Mood moodFromJson(Map<String, dynamic> json) {
  return Mood(
    icon: json['icon'] as String,
    label: json['label'] as String,
    type: MoodType.values[json['type'] as int],
  );
}

Map<String, dynamic> weatherToJson(Weather weather) {
  return {'icon': weather.icon, 'label': weather.label};
}

Weather weatherFromJson(Map<String, dynamic> json) {
  return Weather(icon: json['icon'] as String, label: json['label'] as String);
}

Map<String, dynamic> communityPostToJson(CommunityPost post) {
  return {
    'id': post.id,
    'type': post.type,
    'imageUrl': post.imageUrl,
    'tag': post.tag,
    'tagColor': post.tagColor,
    'content': post.content,
    'timeAgo': post.timeAgo,
    'userName': post.userName,
    'userAvatar': post.userAvatar,
    'likes': post.likes,
    'isLiked': post.isLiked,
    'gradientFrom': post.gradientFrom,
    'gradientTo': post.gradientTo,
    'comments': post.comments,
    'createdAt': post.createdAt.millisecondsSinceEpoch,
  };
}

CommunityPost communityPostFromJson(Map<String, dynamic> json) {
  return CommunityPost(
    id: json['id'] as String,
    type: json['type'] as String,
    imageUrl: json['imageUrl'] as String?,
    tag: json['tag'] as String?,
    tagColor: json['tagColor'] as String?,
    content: json['content'] as String?,
    timeAgo: json['timeAgo'] as String?,
    userName: json['userName'] as String?,
    userAvatar: json['userAvatar'] as String?,
    likes: json['likes'] as int? ?? 0,
    isLiked: json['isLiked'] as bool? ?? false,
    gradientFrom: json['gradientFrom'] as String?,
    gradientTo: json['gradientTo'] as String?,
    comments: json['comments'] as int? ?? 0,
    createdAt: json['createdAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
        : DateTime.now(),
  );
}

Map<String, dynamic> outfitCardToJson(OutfitCard outfit) {
  return {
    'imageUrl': outfit.imageUrl,
    'matchPercentage': outfit.matchPercentage,
    'description': outfit.description,
    'isSaved': outfit.isSaved,
    'scene': outfit.scene,
  };
}

OutfitCard outfitCardFromJson(Map<String, dynamic> json) {
  return OutfitCard(
    imageUrl: json['imageUrl'] as String,
    matchPercentage: json['matchPercentage'] as String,
    description: json['description'] as String,
    isSaved: json['isSaved'] as bool? ?? false,
    scene: json['scene'] as String?,
  );
}

Map<String, dynamic> userProfileToJson(UserProfile user) {
  return {
    'id': user.id,
    'name': user.name,
    'email': user.email,
    'avatar': user.avatar,
    'bio': user.bio,
    'entriesCount': user.entriesCount,
    'followersCount': user.followersCount,
    'followingCount': user.followingCount,
    'location': user.location,
    'joinDate': user.joinDate?.millisecondsSinceEpoch,
  };
}

UserProfile userProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    avatar: json['avatar'] as String?,
    bio: json['bio'] as String?,
    entriesCount: json['entriesCount'] as int? ?? 0,
    followersCount: json['followersCount'] as int? ?? 0,
    followingCount: json['followingCount'] as int? ?? 0,
    location: json['location'] as String?,
    joinDate: json['joinDate'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['joinDate'] as int)
        : null,
  );
}
