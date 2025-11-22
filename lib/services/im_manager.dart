import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/login_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';

/// Singleton wrapper around Tencent Cloud Chat SDK for app-wide usage.
class ImManager extends ChangeNotifier {
  ImManager._() {
    _conversationListener = V2TimConversationListener(
      onConversationChanged: (List<V2TimConversation> conversationList) {
        // This callback is triggered when a conversation is added or updated.
        // We can recalculate the total unread count here.
        _updateTotalUnreadCount();
        notifyListeners(); // Notify listeners that conversation data has changed.
      },
      onNewConversation: (List<V2TimConversation> conversationList) {
        // This callback is triggered when a new conversation is created.
        _updateTotalUnreadCount();
        notifyListeners(); // Notify listeners that conversation data has changed.
      },
      onTotalUnreadMessageCountChanged: (int totalUnreadCount) {
        // This is the most direct callback for unread count changes.
        unreadCount.value = totalUnreadCount;
        // Note: We might not need to call notifyListeners() here if UI components
        // that show individual conversation lists are also listening for this.
        // However, for consistency and to ensure all parts of the app can react,
        // it's safer to notify.
        notifyListeners();
      },
    );
  }

  static final ImManager instance = ImManager._();

  bool _isInitialised = false;
  bool _isLoggingIn = false;
  String? _currentUserId;
  late final V2TimConversationListener _conversationListener;

  /// Notifier for the total number of unread messages across all conversations.
  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);

  bool get isInitialised => _isInitialised;
  bool get isLoggedIn => _currentUserId != null;
  String? get currentUserId => _currentUserId;

  Future<void> _updateTotalUnreadCount() async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getTotalUnreadMessageCount();
    if (result.code == 0 && result.data != null) {
      unreadCount.value = result.data!;
    }
  }

  Future<void> ensureInitialised(int sdkAppId) async {
    if (_isInitialised) {
      return;
    }

    final listener = V2TimSDKListener(
      onKickedOffline: () {
        _currentUserId = null;
        // TODO: Handle kicked offline event, e.g., navigate to login screen.
      },
      onUserSigExpired: () {
        _currentUserId = null;
        // TODO: Handle user sig expired event, e.g., re-login.
      },
    );

    final result = await TencentImSDKPlugin.v2TIMManager.initSDK(
      sdkAppID: sdkAppId,
      loglevel: kDebugMode
          ? LogLevelEnum.V2TIM_LOG_DEBUG
          : LogLevelEnum.V2TIM_LOG_WARN,
      listener: listener,
    );

    if (result.code != 0) {
      throw ImException('InitSDK failed', result.code, result.desc);
    }

    TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .addConversationListener(listener: _conversationListener);

    _isInitialised = true;
  }

  Future<void> login({required String userId, required String userSig}) async {
    if (_isLoggingIn) return;
    if (_currentUserId == userId) {
      final status = await TencentImSDKPlugin.v2TIMManager.getLoginStatus();
      if (status == LoginStatus.V2TIM_STATUS_LOGINED) {
        return;
      }
    }
    if (!_isInitialised) {
      throw const ImException('IM SDK not initialised before login');
    }

    _isLoggingIn = true;
    try {
      final result = await TencentImSDKPlugin.v2TIMManager.login(
        userID: userId,
        userSig: userSig,
      );
      if (result.code != 0) {
        throw ImException('Login failed', result.code, result.desc);
      }
      _currentUserId = userId;
      await _updateTotalUnreadCount(); // Get initial unread count after login
      notifyListeners();
    } finally {
      _isLoggingIn = false;
    }
  }

  Future<void> logout() async {
    if (_currentUserId == null) return;
    final result = await TencentImSDKPlugin.v2TIMManager.logout();
    if (result.code != 0) {
      throw ImException('Logout failed', result.code, result.desc);
    }
    _currentUserId = null;
    unreadCount.value = 0; // Reset unread count on logout
    notifyListeners();
  }

  Future<void> unInit() async {
    if (!_isInitialised) return;
    await logout();
    TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .removeConversationListener(listener: _conversationListener);
    await TencentImSDKPlugin.v2TIMManager.unInitSDK();
    _isInitialised = false;
  }

  Future<void> restoreFromCache(UserProvider userProvider) async {
    final config = userProvider.initConfig;
    final loginData = userProvider.currentUser;

    if (config == null || loginData == null) {
      return;
    }

    final sdkAppId = config.imAppId;
    final userSig = loginData.userSig;
    final userId = loginData.id;

    if (sdkAppId == null || userSig == null || userId == null) {
      return;
    }

    try {
      await ensureInitialised(sdkAppId);
      await login(userId: userId.toString(), userSig: userSig);
    } catch (e) {
      debugPrint('IM restoreFromCache failed: $e');
    }
  }
}

class ImException implements Exception {
  final String message;
  final int? code;
  final String? detail;

  const ImException(this.message, [this.code, this.detail]);

  @override
  String toString() =>
      'ImException(message: $message, code: $code, detail: $detail)';
}
