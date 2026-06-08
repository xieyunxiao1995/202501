import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全存储工具类
///
/// 基于 flutter_secure_storage 封装，用于存储 Token、账号密码等敏感信息。
/// iOS 使用 Keychain，Android 使用 EncryptedSharedPreferences。
class SecureStorage {
  SecureStorage() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  late final FlutterSecureStorage _storage;

  /// 存储前缀
  static const String _prefix = 'sanguogame_';

  /// 添加前缀
  String _addPrefix(String key) => '$_prefix$key';

  // ==================== 读写操作 ====================

  /// 安全写入
  ///
  /// [key] 键名
  /// [value] 值
  Future<void> write(String key, String value) async {
    await _storage.write(key: _addPrefix(key), value: value);
  }

  /// 安全读取
  ///
  /// [key] 键名
  /// 返回值，如果 key 不存在返回 null
  Future<String?> read(String key) async {
    return _storage.read(key: _addPrefix(key));
  }

  /// 判断 key 是否存在
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key: _addPrefix(key));
  }

  /// 删除指定 key
  Future<void> delete(String key) async {
    await _storage.delete(key: _addPrefix(key));
  }

  // ==================== 批量操作 ====================

  /// 读取所有安全存储的数据
  Future<Map<String, String>> readAll() async {
    final all = await _storage.readAll();
    // 过滤出带前缀的 key，并去除前缀
    final result = <String, String>{};
    all.forEach((key, value) {
      if (key.startsWith(_prefix)) {
        result[key.substring(_prefix.length)] = value;
      }
    });
    return result;
  }

  /// 删除所有安全存储的数据
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // ==================== 常用快捷方法 ====================

  /// 存储访问 Token
  Future<void> saveAccessToken(String token) async {
    await write('access_token', token);
  }

  /// 读取访问 Token
  Future<String?> getAccessToken() async {
    return read('access_token');
  }

  /// 存储刷新 Token
  Future<void> saveRefreshToken(String token) async {
    await write('refresh_token', token);
  }

  /// 读取刷新 Token
  Future<String?> getRefreshToken() async {
    return read('refresh_token');
  }

  /// 存储账号
  Future<void> saveAccount(String account) async {
    await write('account', account);
  }

  /// 读取账号
  Future<String?> getAccount() async {
    return read('account');
  }

  /// 存储密码（加密存储）
  Future<void> savePassword(String password) async {
    await write('password', password);
  }

  /// 读取密码
  Future<String?> getPassword() async {
    return read('password');
  }

  /// 存储用户 ID
  Future<void> saveUserId(String userId) async {
    await write('user_id', userId);
  }

  /// 读取用户 ID
  Future<String?> getUserId() async {
    return read('user_id');
  }

  /// 清除登录相关数据（退出登录时调用）
  Future<void> clearAuthData() async {
    await delete('access_token');
    await delete('refresh_token');
    await delete('password');
  }

  // ==================== 配置 ====================

  /// 修改存储配置（如需要更改加密选项）
  void updateOptions({
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? wOptionsWeb,
    MacOsOptions? mOptions,
  }) {
    _storage = FlutterSecureStorage(
      aOptions: aOptions ?? const AndroidOptions(encryptedSharedPreferences: true),
      iOptions: iOptions ?? const IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
      lOptions: lOptions ?? const LinuxOptions(),
      wOptions: wOptions ?? const WindowsOptions(),
      webOptions: wOptionsWeb ?? const WebOptions(),
      mOptions: mOptions ?? const MacOsOptions(),
    );
  }
}
