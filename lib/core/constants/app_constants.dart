/// 应用全局常量
///
/// 包含应用名称、存储 Key、网络超时、分页、Hive Box 名称等常量。
/// 所有常量统一在此定义，避免硬编码散落在各处。
class AppConstants {
  AppConstants._();

  /// 应用名称
  static const String appName = '一策定江山';

  /// 应用包名
  static const String appPackageName = 'com.sanguogame.app';

  // ==================== 存储 Key ====================

  /// 存储 Key 前缀
  static const String storagePrefix = 'sg_';

  /// 认证 Token Key
  static const String tokenKey = '${storagePrefix}auth_token';

  /// 刷新 Token Key
  static const String refreshTokenKey = '${storagePrefix}refresh_token';

  /// 用户 ID Key
  static const String userIdKey = '${storagePrefix}user_id';

  /// 语言设置 Key
  static const String languageKey = '${storagePrefix}language';

  /// 主题设置 Key
  static const String themeKey = '${storagePrefix}theme';

  /// 服务器选择 Key
  static const String serverKey = '${storagePrefix}server';

  /// 上次登录时间 Key
  static const String lastLoginTimeKey = '${storagePrefix}last_login_time';

  /// 新手引导完成标记 Key
  static const String tutorialCompletedKey =
      '${storagePrefix}tutorial_completed';

  // ==================== 网络超时 ====================

  /// 连接超时时间
  static const Duration connectTimeout = Duration(seconds: 15);

  /// 接收超时时间
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// 发送超时时间
  static const Duration sendTimeout = Duration(seconds: 15);

  /// 重试次数
  static const int maxRetries = 3;

  /// 重试间隔
  static const Duration retryInterval = Duration(seconds: 2);

  // ==================== 分页 ====================

  /// 默认每页数量
  static const int defaultPageSize = 20;

  /// 最大每页数量
  static const int maxPageSize = 100;

  // ==================== Hive Box 名称 ====================

  /// 武将数据 Box
  static const String generalBox = 'generals';

  /// 游戏进度 Box
  static const String progressBox = 'game_progress';

  /// 设置 Box
  static const String settingsBox = 'settings';

  /// 战斗回放 Box
  static const String replayBox = 'battle_replays';

  /// 草稿 Box
  static const String draftBox = 'drafts';

  /// 缓存 Box
  static const String cacheBox = 'cache';

  // ==================== 动画时长 ====================

  /// 默认动画时长（毫秒）
  static const int defaultAnimDuration = 300;

  /// 页面切换动画时长（毫秒）
  static const int pageTransitionDuration = 250;

  /// 战斗动画时长（毫秒）
  static const int battleAnimDuration = 500;

  // ==================== 其他 ====================

  /// 最小密码长度
  static const int minPasswordLength = 6;

  /// 最大昵称长度
  static const int maxNicknameLength = 12;

  /// 验证码长度
  static const int verifyCodeLength = 6;
}
