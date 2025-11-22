import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhenyu_flutter/api/config_api.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/models/config_api_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zhenyu_flutter/services/im_manager.dart';

enum LoginResultType {
  success,
  needsProfileCompletion,
  needsInvitationCode,
  failed,
}

class LoginResult {
  final LoginResultType type;
  final String? message;
  final LoginRespData? data;

  LoginResult({required this.type, this.message, this.data});
}

class UserProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  LoginRespData? _currentUser;
  UserInfoMeData? _userMeInfo;
  AppInitConfig? _initConfig;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginRespData? get currentUser => _currentUser;
  UserInfoMeData? get userMeInfo => _userMeInfo;
  AppInitConfig? get initConfig => _initConfig;
  String? get token => _currentUser?.userToken;

  UserProvider();

  Future<void> loadUserFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('userInfo');
    if (raw != null) {
      try {
        _currentUser = LoginRespData.fromJson(jsonDecode(raw));
      } catch (e) {
        debugPrint('Failed to load user from cache: $e');
      }
    }
    final rawMe = prefs.getString('userMeInfo');
    if (rawMe != null) {
      try {
        _userMeInfo = UserInfoMeData.fromJson(jsonDecode(rawMe));
      } catch (e) {
        debugPrint('Failed to load userMeInfo from cache: $e');
      }
    }
    final rawConfig = prefs.getString('initConfig');
    if (rawConfig != null) {
      try {
        _initConfig = AppInitConfig.fromJson(jsonDecode(rawConfig));
      } catch (e) {
        debugPrint('Failed to load initConfig from cache: $e');
      }
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
  }

  Future<LoginResult> login(LoginData data) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await UserApi.login(data);
      if (response.code == 0 && response.data != null) {
        final loginData = response.data!;

        // 1. 保存 Token 和用户信息
        await saveUser(loginData);

        // 逻辑 1: 需要补全资料
        if (loginData.extraParam != null && loginData.extraParam!.isNotEmpty) {
          _setLoading(false);
          return LoginResult(
            type: LoginResultType.needsProfileCompletion,
            data: loginData,
          );
        }

        // 逻辑 2: 需要填写邀请码
        if (loginData.businessCode == 2005 || loginData.reviewStatus == 2005) {
          _setLoading(false);
          return LoginResult(
            type: LoginResultType.needsInvitationCode,
            data: loginData,
          );
        }

        // 逻辑 3: 正常登录，获取详细信息并跳转主页
        await fetchUserMeInfo();
        await fetchInitConfig();

        // IM 初始化和登录
        await _setupIm(loginData, _initConfig);

        // 获取地理位置
        await _determinePosition();

        _setLoading(false);
        return LoginResult(type: LoginResultType.success);
      } else {
        _setError(response.message ?? '登录失败，请稍后重试');
        _setLoading(false);
        return LoginResult(
          type: LoginResultType.failed,
          message: _errorMessage,
        );
      }
    } catch (e) {
      debugPrint('登录失败: $e');
      _setError('登录失败，请检查网络或输入');
      _setLoading(false);
      return LoginResult(type: LoginResultType.failed, message: _errorMessage);
    }
  }

  Future<void> _setupIm(LoginRespData loginData, AppInitConfig? config) async {
    AppInitConfig? effectiveConfig = config;
    if (effectiveConfig == null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final cached = prefs.getString('initConfig');
        if (cached != null && cached.isNotEmpty) {
          effectiveConfig = AppInitConfig.fromJson(
            jsonDecode(cached) as Map<String, dynamic>,
          );
        }
      } catch (e) {
        debugPrint('Failed to parse cached initConfig for IM: $e');
      }
    }

    final sdkAppId = effectiveConfig?.imAppId;
    final userSig = loginData.userSig;
    final userId = loginData.id;

    if (sdkAppId == null || userSig == null || userId == null) {
      debugPrint(
        'IM setup skipped due to missing sdkAppId, userSig, or userId.',
      );
      return;
    }

    try {
      await ImManager.instance.ensureInitialised(sdkAppId);
      await ImManager.instance.login(
        userId: userId.toString(),
        userSig: userSig,
      );
      debugPrint('IM setup successful for user $userId.');
    } catch (e) {
      debugPrint('IM setup failed: $e');
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('位置服务已禁用');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('位置权限被拒绝');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('位置权限被永久拒绝');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final prefs = await SharedPreferences.getInstance();
      final locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
      await prefs.setString('longitudeData', jsonEncode(locationData));
      debugPrint('地理位置已保存: $locationData');
    } catch (e) {
      debugPrint('获取地理位置失败: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userInfo');
    await prefs.remove('userMeInfo');
    await prefs.remove('initConfig');
    await prefs.remove('longitudeData'); // 清理地理位置缓存
    _currentUser = null;
    _userMeInfo = null;
    _initConfig = null;
    notifyListeners();
  }

  Future<void> saveUser(LoginRespData loginData) async {
    if (loginData.userToken != null && loginData.userToken!.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginData.userToken!);
      await prefs.setString('userInfo', jsonEncode(loginData.toJson()));
      _currentUser = loginData;
      notifyListeners();
    }
  }

  Future<void> fetchUserMeInfo() async {
    try {
      final userInfoResponse = await UserApi.getUserInfoMe();
      if (userInfoResponse.code == 0 && userInfoResponse.data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'userMeInfo',
          jsonEncode(userInfoResponse.data!.toJson()),
        );
        _userMeInfo = userInfoResponse.data;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to fetch userMeInfo: $e');
    }
  }

  Future<void> fetchInitConfig() async {
    try {
      final configResponse = await ConfigApi.getAppInitConfig();
      if (configResponse.code == 0 && configResponse.data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'initConfig',
          jsonEncode(configResponse.data!.toJson()),
        );
        _initConfig = configResponse.data;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to fetch initConfig: $e');
    }
  }

  /// Setup IM after registration or login
  /// Call this after saveUser, fetchUserMeInfo, and fetchInitConfig
  Future<void> setupImAfterAuth() async {
    if (_currentUser == null) {
      debugPrint('setupImAfterAuth: No current user, skipping IM setup');
      return;
    }
    await _setupIm(_currentUser!, _initConfig);
  }
}
