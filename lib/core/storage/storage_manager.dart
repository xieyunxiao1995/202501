import 'draft_storage.dart';
import 'hive_storage.dart';
import 'local_storage.dart';
import 'secure_storage.dart';

/// 存储管理总入口
///
/// 统一管理 LocalStorage、HiveStorage、SecureStorage、DraftStorage，
/// 提供初始化和清除所有数据的入口。
class StorageManager {
  StorageManager({
    LocalStorage? localStorage,
    HiveStorage? hiveStorage,
    SecureStorage? secureStorage,
    DraftStorage? draftStorage,
  })  : localStorage = localStorage ?? LocalStorage(),
        hiveStorage = hiveStorage ?? HiveStorage(),
        secureStorage = secureStorage ?? SecureStorage(),
        draftStorage = draftStorage ?? DraftStorage();

  /// SharedPreferences 封装
  final LocalStorage localStorage;

  /// Hive 封装
  final HiveStorage hiveStorage;

  /// 安全存储封装
  final SecureStorage secureStorage;

  /// 草稿存储封装
  final DraftStorage draftStorage;

  /// 是否已初始化
  bool _initialized = false;

  /// 是否已初始化
  bool get isInitialized => _initialized;

  /// 初始化所有存储
  ///
  /// 应在 App 启动时调用，确保所有存储模块可用。
  Future<void> init() async {
    if (_initialized) return;

    await localStorage.init();
    await hiveStorage.init();
    await draftStorage.init();
    // SecureStorage 不需要额外初始化

    _initialized = true;
  }

  /// 清除所有本地数据（退出登录时调用）
  ///
  /// 注意：此操作不可逆，会清除所有本地存储数据。
  Future<void> clearAll() async {
    await localStorage.clear();
    await hiveStorage.closeAllBoxes();
    await secureStorage.deleteAll();
    await draftStorage.clearAll();
  }

  /// 清除非敏感数据（保留 Token 和账号信息）
  Future<void> clearNonSensitive() async {
    await localStorage.clear();
    await draftStorage.clearAll();
  }
}
