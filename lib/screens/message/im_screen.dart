import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:zhenyu_flutter/api/chat_api.dart';
import 'package:zhenyu_flutter/api/report_api.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/chat_api_model.dart';
import 'package:zhenyu_flutter/models/report_api_model.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/common/photo_viewer_screen.dart';
import 'package:zhenyu_flutter/screens/common/vip_dialog.dart';
import 'package:zhenyu_flutter/screens/message/message_bubble.dart';
import 'package:zhenyu_flutter/screens/message/select_address_screen.dart';
import 'package:zhenyu_flutter/screens/profile/profile_screen.dart';
import 'package:zhenyu_flutter/services/im_manager.dart';
import 'package:zhenyu_flutter/shared/marquee_text.dart';
import 'package:zhenyu_flutter/theme.dart';

class ImScreen extends StatefulWidget {
  const ImScreen({
    super.key,
    required this.userId,
    this.displayName,
    this.avatarUrl,
  });

  final String userId;
  final String? displayName;
  final String? avatarUrl;

  bool get isSystem => userId.toLowerCase() == 'system';

  @override
  State<ImScreen> createState() => _ImScreenState();
}

class _ImScreenState extends State<ImScreen> {
  static const int _pageSize = 20;
  static const List<String> _reportReasons = [
    '垃圾广告',
    '色情骚扰',
    '暴力辱骂',
    '恶意欺诈',
    '政治敏感',
  ];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  final List<ChatMessage> _messages = <ChatMessage>[];

  late ChatHeaderInfo _headerInfo;
  CurrentUserInfo _currentUser = const CurrentUserInfo(
    sex: 1,
    isRealCertified: true,
  );

  V2TimAdvancedMsgListener? _msgListener;

  bool _isInitialLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _voiceMode = false;
  bool _isSending = false;
  bool _isHeaderLoading = false;
  bool _isUnlocking = false;

  int? _targetUid;
  bool _reviewEnvDisabled = false;

  // Voice recording states
  bool _isRecording = false;
  bool _isRecordingCancelled = false;
  String _recordingToastText = '按住说话';
  DateTime? _recordingStartTime;
  String? _currentRecordingPath;
  final AudioRecorder _audioRecorder = AudioRecorder();
  OverlayEntry? _recordingOverlay;
  StateSetter? _overlayStateSetter;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _headerInfo = ChatHeaderInfo.initial(
      userName: widget.displayName ?? (widget.isSystem ? '官方小助手' : '未知用户'),
      avatarUrl:
          widget.avatarUrl ??
          (widget.isSystem ? 'assets/images/official.png' : null),
      isVip: false,
      isReal: false,
      contactType: ContactType.wechat,
    );
    _initUserContext();
    _initMessageListener();
    _loadInitialMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _inputFocusNode.dispose();
    if (_msgListener != null) {
      TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .removeAdvancedMsgListener(listener: _msgListener);
    }
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _initUserContext() async {
    final toUid = int.tryParse(widget.userId);
    setState(() => _targetUid = toUid);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userMeInfo = userProvider.userMeInfo;
    if (userMeInfo != null) {
      _currentUser = CurrentUserInfo(
        sex: userMeInfo.sex ?? 1,
        isRealCertified: (userMeInfo.realType ?? 0) == 1,
        avatarUrl: userMeInfo.avatar,
      );
    }

    final initConfig = userProvider.initConfig;
    if (initConfig != null) {
      _reviewEnvDisabled = (initConfig.reviewEnvStatus ?? 0) != 0;
    }

    if (!widget.isSystem && _targetUid != null) {
      unawaited(_fetchChatHeader());
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMoreMessages();
      }
    });
  }

  void _initMessageListener() {
    _msgListener = V2TimAdvancedMsgListener(
      onRecvNewMessage: (message) {
        if (!_isSameConversation(message)) return;
        final mapped = ChatMessage.fromV2(
          message,
          currentUserId: ImManager.instance.currentUserId,
          fallbackAvatar: widget.avatarUrl,
        );
        if (mapped == null) return;
        setState(() {
          _messages.insert(0, mapped);
        });
        _scrollToBottom();
      },
    );
    TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(
      listener: _msgListener!,
    );
  }

  Future<void> _fetchChatHeader() async {
    if (_targetUid == null) return;
    setState(() => _isHeaderLoading = true);
    try {
      final resp = await UserApi.getChatHeadInfo(
        ChatHeadInfoReq(toUid: _targetUid!),
      );
      if (resp.code == 0 && resp.data != null) {
        setState(() {
          _headerInfo = ChatHeaderInfo.fromApi(
            resp.data!,
            fallbackName: _headerInfo.userName,
            fallbackAvatar: _headerInfo.avatarUrl,
            previous: _headerInfo,
          ).copyWith(reviewEnvDisabled: _reviewEnvDisabled);
        });
      } else {
        _showSnack(resp.message ?? '聊天信息获取失败');
      }
    } catch (_) {
      _showSnack('聊天信息获取失败');
    } finally {
      if (mounted) {
        setState(() => _isHeaderLoading = false);
      }
    }
  }

  Future<void> _loadInitialMessages() async {
    if (_isInitialLoading) return;
    setState(() => _isInitialLoading = true);
    await _loadMessages(lastMsg: null);
    if (mounted) {
      setState(() => _isInitialLoading = false);
    }
    _scrollToBottom();
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || !_hasMore) return;
    final lastMessage = _messages.isEmpty ? null : _messages.last.raw;
    setState(() => _isLoadingMore = true);
    await _loadMessages(lastMsg: lastMessage);
    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _loadMessages({V2TimMessage? lastMsg}) async {
    try {
      final result = await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .getHistoryMessageListV2(
            getType: HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_OLDER_MSG,
            userID: widget.userId,
            groupID: null,
            count: _pageSize,
            lastMsg: lastMsg,
          );

      if (result.code != 0) {
        final desc = result.desc;
        _showSnack(desc.isNotEmpty ? desc : '消息加载失败');
        return;
      }
      final data = result.data;
      if (data == null) return;

      final fetched = data.messageList
          .map(
            (msg) => ChatMessage.fromV2(
              msg,
              currentUserId: ImManager.instance.currentUserId,
              fallbackAvatar: widget.avatarUrl,
            ),
          )
          .whereType<ChatMessage>()
          .toList();

      fetched.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        if (lastMsg == null) {
          _messages
            ..clear()
            ..addAll(fetched);
        } else {
          final existingIds = _messages.map((m) => m.id).toSet();
          for (final message in fetched) {
            if (!existingIds.contains(message.id)) {
              _messages.add(message);
            }
          }
        }
        _hasMore = !data.isFinished;
      });
    } catch (_) {
      _showSnack('消息加载失败');
    }
  }

  bool _isSameConversation(V2TimMessage message) {
    final peerId = widget.userId;
    if (message.userID != null && message.userID!.isNotEmpty) {
      if (message.userID == peerId || message.sender == peerId) {
        return true;
      }
    }
    final convId = message.groupID ?? '';
    if (convId.isNotEmpty && convId == peerId) {
      return true;
    }
    return false;
  }

  Future<void> _handleSendText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      _showSnack('请输入聊天内容');
      return;
    }

    if (!widget.isSystem && _targetUid != null) {
      final unlock = await _checkUnlockForMessage('TEXT');
      if (unlock == null) {
        return;
      }
      if (unlock.unlockCode != 0) {
        _showUnlockSheet(unlock);
        return;
      }
    }

    await _sendTextMessage(text);
  }

  Future<CheckUnlockData?> _checkUnlockForMessage(String chatType) async {
    if (_targetUid == null) return null;
    try {
      final resp = await ChatApi.checkUnlock(
        CheckUnlockReq(
          scene: 'MESSAGE_SEND_CHAT',
          chatType: chatType,
          toUid: _targetUid!,
        ),
      );
      if (resp.code == 0) {
        return resp.data;
      }
      _showSnack(resp.message ?? '发送前校验失败');
    } catch (_) {
      _showSnack('发送前校验失败');
    }
    return null;
  }

  Future<void> _sendMessage(String messageId) async {
    if (_isSending) return;
    setState(() => _isSending = true);
    try {
      final sendMessageRes = await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .sendMessage(id: messageId, receiver: widget.userId, groupID: '');

      if (sendMessageRes.code != 0 || sendMessageRes.data == null) {
        _showSnack('发送失败: ${sendMessageRes.desc}');
        return;
      }

      final mapped = ChatMessage.fromV2(
        sendMessageRes.data!,
        currentUserId: ImManager.instance.currentUserId,
        fallbackAvatar: _currentUser.avatarUrl,
      );
      if (mapped != null) {
        setState(() {
          _messages.insert(0, mapped);
        });
        _scrollToBottom();
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _sendTextMessage(String text) async {
    final createRes = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(text: text);
    if (createRes.code != 0 || createRes.data?.id == null) {
      final desc = createRes.desc;
      _showSnack(desc.isNotEmpty ? desc : '消息创建失败');
      return;
    }
    await _sendMessage(createRes.data!.id!);
    _textController.clear();
  }

  Future<void> _handleUnlockContact() async {
    if (_targetUid == null || _isUnlocking) return;
    setState(() => _isUnlocking = true);
    try {
      final resp = await ChatApi.checkUnlock(
        CheckUnlockReq(scene: 'MESSAGE_GET_WX', toUid: _targetUid!),
      );
      if (resp.code != 0 || resp.data == null) {
        _showSnack(resp.message ?? '解锁失败');
        return;
      }
      final data = resp.data!;
      if (data.unlockCode == 0) {
        _showSnack('已解锁联系方式');
        await _fetchChatHeader();
      } else {
        _showUnlockSheet(data);
      }
    } catch (_) {
      _showSnack('解锁失败');
    } finally {
      if (mounted) {
        setState(() => _isUnlocking = false);
      }
    }
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      try {
        if (!await _audioRecorder.hasPermission()) {
          _showSnack('系统未授予麦克风权限');
          return;
        }
        if (await _audioRecorder.isRecording()) {
          await _audioRecorder.stop();
        }
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );
        _showRecordingOverlay();
        setState(() {
          _isRecording = true;
          _isRecordingCancelled = false;
          _recordingToastText = '松开 发送';
          _recordingStartTime = DateTime.now();
          _currentRecordingPath = filePath;
        });
      } catch (_) {
        _showSnack('开始录音失败，请重试');
      }
      return;
    }

    if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('需要麦克风权限'),
            content: const Text('我们需要您授予麦克风权限才能发送语音消息。请在系统设置中开启。'),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('去设置'),
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
              ),
            ],
          ),
        );
      }
    } else {
      _showSnack('需要麦克风权限才能发送语音');
    }
  }

  void _updateRecordingGesture(LongPressMoveUpdateDetails details) {
    if (!_isRecording) return;
    final screenHeight = MediaQuery.of(context).size.height;
    final isCancelled = details.globalPosition.dy < screenHeight * 0.8;

    if (isCancelled != _isRecordingCancelled) {
      setState(() {
        _isRecordingCancelled = isCancelled;
        _recordingToastText = isCancelled ? '松开 取消' : '松开 发送';
      });
      _overlayStateSetter?.call(() {});
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    final wasCancelled = _isRecordingCancelled;
    final startTime = _recordingStartTime;
    final plannedPath = _currentRecordingPath;

    _hideRecordingOverlay();
    setState(() {
      _isRecording = false;
      _recordingToastText = '按住说话';
      _recordingStartTime = null;
    });

    String? recordingPath;
    try {
      recordingPath = await _audioRecorder.stop();
    } catch (_) {
      recordingPath = null;
    }
    recordingPath ??= plannedPath;
    _currentRecordingPath = null;

    if (recordingPath == null) {
      if (!wasCancelled) {
        _showSnack('录音失败，请重试');
      }
      return;
    }

    final file = File(recordingPath);

    if (wasCancelled) {
      if (await file.exists()) {
        await file.delete();
      }
      return;
    }

    if (startTime == null) {
      if (await file.exists()) {
        await file.delete();
      }
      return;
    }

    final duration = DateTime.now().difference(startTime).inSeconds;
    if (duration < 1) {
      if (await file.exists()) {
        await file.delete();
      }
      _showSnack('录音时间太短');
      return;
    }

    if (!await file.exists() || await file.length() == 0) {
      if (await file.exists()) {
        await file.delete();
      }
      _showSnack('录音失败，请重试');
      return;
    }

    if (!widget.isSystem && _targetUid != null) {
      final unlock = await _checkUnlockForMessage('VOICE');
      if (unlock == null) {
        await file.delete();
        return;
      }
      if (unlock.unlockCode != 0) {
        await file.delete();
        _showUnlockSheet(unlock);
        return;
      }
    }

    final createSoundMessageRes = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createSoundMessage(soundPath: recordingPath, duration: duration);

    if (createSoundMessageRes.code != 0 || createSoundMessageRes.data == null) {
      await file.delete();
      _showSnack('创建语音消息失败: ${createSoundMessageRes.desc}');
      return;
    }

    final messageId = createSoundMessageRes.data!.id;
    if (messageId == null || messageId.isEmpty) {
      await file.delete();
      _showSnack('创建语音消息失败: 无效的消息ID');
      return;
    }

    await _sendMessage(messageId);
    await file.delete();
  }

  void _cancelRecording() {
    if (!_isRecording) return;
    _hideRecordingOverlay();
    setState(() {
      _isRecording = false;
      _isRecordingCancelled = true;
      _recordingToastText = '按住说话';
    });

    final plannedPath = _currentRecordingPath;
    _currentRecordingPath = null;

    unawaited(() async {
      try {
        await _audioRecorder.stop();
      } catch (_) {
        // ignore
      }
      if (plannedPath != null) {
        final file = File(plannedPath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }());
  }

  void _showRecordingOverlay() {
    _recordingOverlay = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            _overlayStateSetter = setState;
            final imagePath = _isRecordingCancelled
                ? 'assets/images/im/cancelRecording.png'
                : 'assets/images/im/recording.gif';
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 24.h,
                    horizontal: 48.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Image.asset(
                          imagePath,
                          width: 250.w,
                          height: 250.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    Overlay.of(context).insert(_recordingOverlay!);
  }

  void _hideRecordingOverlay() {
    _overlayStateSetter = null;
    _recordingOverlay?.remove();
    _recordingOverlay = null;
  }

  void _showUnlockSheet(CheckUnlockData data) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) {
        final actions = _buildUnlockActions(data);
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '解锁提示',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  _unlockHintText(data),
                  style: TextStyle(fontSize: 26.sp, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                ...actions,
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),

                  child: const Text('取消'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildUnlockActions(CheckUnlockData data) {
    final List<Widget> actions = [];

    void addAction(String label, VoidCallback onTap) {
      actions.add(
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldGradientStart,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 88.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(44.r),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onTap();
            },
            child: Text(label, style: TextStyle(fontSize: 28.sp)),
          ),
        ),
      );
    }

    switch (data.unlockCode) {
      case 1:
        addAction('开通会员，免费私聊', _showVipDialog);
        if (data.unlockCoinPrice > 0) {
          addAction('金币解锁（消耗${data.unlockCoinPrice}金币）', () {
            _rechargeUnlock('COIN');
          });
        }
        break;
      case 2:
        addAction('金币解锁（消耗${data.unlockCoinPrice}金币）', () {
          _rechargeUnlock('COIN');
        });
        break;
      case 3:
        addAction('免费解锁', () {
          _rechargeUnlock('FREE');
        });
        if (data.unlockCoinPrice > 0) {
          addAction('金币解锁（消耗${data.unlockCoinPrice}金币）', () {
            _rechargeUnlock('COIN');
          });
        }
        addAction('开通会员，尊享特权', _showVipDialog);
        break;
      case 4:
        addAction('使用会员解锁次数', () {
          _rechargeUnlock('VIP');
        });
        addAction('金币解锁（消耗${data.unlockCoinPrice}金币）', () {
          _rechargeUnlock('COIN');
        });
        break;
      default:
        addAction('我知道了', () {});
    }

    if (data.inviteObtainVipStatus == 1) {
      addAction('邀请好友获取VIP', _showVipDialog);
    }

    return actions;
  }

  String _unlockHintText(CheckUnlockData data) {
    switch (data.unlockCode) {
      case 1:
        return '开通会员即可免费解锁私聊/联系方式';
      case 2:
        return '需要消耗金币才能继续解锁';
      case 3:
        return '您拥有免费解锁次数，可直接免费解锁';
      case 4:
        return '今日会员解锁次数已用完，您可以使用会员次数或金币解锁';
      default:
        return '解锁提示';
    }
  }

  Future<void> _rechargeUnlock(String type) async {
    if (_targetUid == null) return;
    try {
      final resp = await ChatApi.rechargeUnlock(
        RechargeUnlockReq(
          scene: 'MESSAGE_GET_WX',
          toUid: _targetUid!,
          type: type,
        ),
      );
      if (resp.code != 0 || resp.data == null) {
        _showSnack(resp.message ?? '解锁失败');
        return;
      }
      final data = resp.data!;
      if (data.unlockCode == 0) {
        _showSnack('解锁成功');
        await _fetchChatHeader();
      } else {
        if ((data.errorMsg ?? '').isNotEmpty) {
          _showSnack(data.errorMsg!);
        } else {
          _showSnack('解锁未成功');
        }
      }
    } catch (_) {
      _showSnack('解锁失败');
    }
  }

  void _showVipDialog() {
    showDialog<void>(context: context, builder: (_) => const VipDialog());
  }

  Future<void> _handleCopyContact() async {
    final contact = _headerInfo.contactAccount;
    if (contact == null || contact.isEmpty) {
      _showSnack('暂无可复制的联系方式');
      return;
    }
    await Clipboard.setData(ClipboardData(text: contact));
    _showSnack('复制成功');
  }

  Future<void> _handleClearChat() async {
    try {
      final res = await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .clearC2CHistoryMessage(userID: widget.userId);
      if (res.code == 0) {
        setState(() => _messages.clear());
        _showSnack('聊天记录已清除');
      } else {
        final desc = res.desc;
        _showSnack(desc.isNotEmpty ? desc : '清除失败');
      }
    } catch (_) {
      _showSnack('清除失败');
    }
  }

  Future<void> _handleAddBlacklist() async {
    if (_targetUid == null) return;
    try {
      final resp = await UserApi.addBlacklistUser(
        BlacklistModifyRequest(toUid: _targetUid!),
      );
      if (resp.code == 0) {
        _showSnack('已拉黑对方，你将不再收到对方消息');
      } else {
        _showSnack(resp.message ?? '拉黑失败');
      }
    } catch (_) {
      _showSnack('拉黑失败');
    }
  }

  Future<void> _handleReport() async {
    if (_targetUid == null) return;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  '选择举报原因',
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ..._reportReasons.map(
                (reason) => ListTile(
                  title: Text(reason, style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.of(context).pop(reason),
                ),
              ),
              ListTile(
                title: const Text(
                  '取消',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) return;
    try {
      final resp = await ReportApi.reportUser(
        ReportUserReq(reason: selected, reportType: 'CHAT', toUid: _targetUid!),
      );
      if (resp is Map && (resp['code'] as int? ?? 0) != 0) {
        _showSnack(resp['message']?.toString() ?? '举报失败');
      } else {
        _showSnack('举报已提交，我们会尽快处理');
      }
    } catch (_) {
      _showSnack('举报失败');
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (!widget.isSystem) _buildTopNotice(),
          if (!widget.isSystem && _shouldShowContactPanel) _buildContactPanel(),
          Expanded(child: _buildMessageList()),
          if (!widget.isSystem) _buildInputArea(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.isSystem) return;
              final userIdInt = int.tryParse(widget.userId);
              if (userIdInt != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: userIdInt),
                  ),
                );
              }
            },
            child: Container(
              height: 34.h,
              alignment: Alignment.center,
              child: Text(
                _headerInfo.userName,
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          if (_headerInfo.isVip)
            _buildTag('VIP', gradient: AppGradients.secondaryGradient),
          if (_headerInfo.isReal)
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: _buildTag('真人', color: AppColors.accentGreen),
            ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.more_vert), onPressed: _showMoreMenu),
      ],
    );
  }

  Widget _buildTag(String text, {LinearGradient? gradient, Color? color}) {
    return Container(
      height: 34.h,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? color ?? AppColors.backgroundWhite10 : null,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18.sp, color: Colors.white),
      ),
    );
  }

  Widget _buildTopNotice() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1F1E24),
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
      child: Row(
        children: [
          const Icon(Icons.volume_up, color: Colors.white60, size: 18),
          SizedBox(width: 12.w),
          Expanded(
            child: MarqueeText(
              text: _headerInfo.noticeText,
              style: TextStyle(fontSize: 22.sp, color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }

  bool get _shouldShowContactPanel {
    if (_reviewEnvDisabled) return false;
    if (_currentUser.sex != 1) return false;
    if (_headerInfo.contactAccount == null ||
        _headerInfo.contactAccount!.isEmpty) {
      return false;
    }
    return true;
  }

  Widget _buildContactPanel() {
    final info = _headerInfo;
    return Padding(
      padding: EdgeInsets.fromLTRB(37.5.w, 24.h, 37.5.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: BoxDecoration(
          gradient: AppGradients.secondaryGradient,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.btnText.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(info.contactType.icon, color: AppColors.btnText),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.displayContact,
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.btnText,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _isHeaderLoading
                        ? '联系方式加载中…'
                        : info.contactUnlocked
                        ? '解锁时间还剩下${info.unlockRemainingLabel}'
                        : '成为 VIP 免费解锁${info.contactType.displayName}',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.btnText,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            GestureDetector(
              onTap: _isHeaderLoading
                  ? null
                  : info.contactUnlocked
                  ? _handleCopyContact
                  : _handleUnlockContact,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.btnText.withValues(
                    alpha: _isHeaderLoading ? 0.4 : 1,
                  ),
                  borderRadius: BorderRadius.circular(36.r),
                ),
                child: Text(
                  _isHeaderLoading
                      ? '加载中'
                      : info.contactUnlocked
                      ? '复制'
                      : '解锁',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isInitialLoading && _messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_messages.isEmpty) {
      return Center(
        child: Text(
          '暂时还没有消息~',
          style: TextStyle(fontSize: 26.sp, color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
      itemCount: _messages.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoadingMore && index == _messages.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final message = _messages[index];
        final showTime = _shouldShowTimeLabel(index);
        debugPrint(
          'MessageBubble message: id=${message.id}, type=${message.type}, isMine=${message.isMine}, text=${message.text}, imageUrl=${message.imageUrl}, mapUrl=${message.mapUrl}, locationArea=${message.locationArea}, locationAddress=${message.locationAddress}, latitude=${message.latitude}, longitude=${message.longitude}, audioDuration=${message.audioDuration}',
        );
        return Column(
          children: [
            if (showTime)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(message.timestamp),
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            MessageBubble(
              message: message,
              currentUserAvatar: _currentUser.avatarUrl,
              peerAvatar: _headerInfo.avatarUrl,
              onImageTap: _handlePreviewImage,
              onLocationTap: _openLocation,
              onPeerIdTap: _handleOpenProfile,
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowTimeLabel(int index) {
    if (index == _messages.length - 1) return true;
    final current = _messages[index];
    final previous = _messages[index + 1];
    return current.timestamp.difference(previous.timestamp).abs() >
        const Duration(minutes: 15);
  }

  Widget _buildInputArea() {
    return Container(
      color: AppColors.tabBarBackground,
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        12.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() => _voiceMode = !_voiceMode);
                  if (_voiceMode) {
                    FocusScope.of(context).unfocus();
                  } else {
                    FocusScope.of(context).requestFocus(_inputFocusNode);
                  }
                },
                icon: Icon(
                  _voiceMode ? Icons.keyboard_alt_outlined : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: _voiceMode
                    ? _buildVoicePlaceholder()
                    : _buildTextField(),
              ),
              if (!_voiceMode) ...[
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: _handleSendText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldGradientStart,
                    foregroundColor: Colors.white,
                    minimumSize: Size(120.w, 64.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                  ),
                  child: const Text('发送'),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _InputActionIcon(
                icon: Icons.photo,
                label: '相册',
                onTap: _handleSendImage,
              ),
              SizedBox(width: 24.w),
              // _InputActionIcon(
              //   icon: Icons.location_on,
              //   label: '位置',
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const SelectAddressScreen(),
              //     ),
              //   ),
              // ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoicePlaceholder() {
    return GestureDetector(
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) => _stopRecording(),
      onLongPressMoveUpdate: _updateRecordingGesture,
      onLongPressCancel: _cancelRecording,
      child: Container(
        height: 64.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isRecording
              ? AppColors.backgroundWhite10.withOpacity(0.5)
              : AppColors.backgroundWhite10,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Text(
          _recordingToastText,
          style: TextStyle(fontSize: 26.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        controller: _textController,
        focusNode: _inputFocusNode,
        style: TextStyle(fontSize: 28.sp),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '请输入聊天内容',
        ),
        onSubmitted: (_) => _handleSendText(),
      ),
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('拉黑', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _handleAddBlacklist();
                },
              ),
              ListTile(
                title: const Text(
                  '清除聊天记录',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _handleClearChat();
                },
              ),
              ListTile(
                title: const Text('举报', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _handleReport();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlePreviewImage(String url) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PhotoViewerScreen(imageUrls: [url]),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<void> _openLocation(ChatMessage message) async {
    _showSnack('无效的位置信息');
  }

  void _handleOpenProfile() {
    if (widget.isSystem) {
      _showSnack('isSystem');
      return;
    }
    final userIdInt = int.tryParse(widget.userId);
    if (userIdInt != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userId: userIdInt),
        ),
      );
    } else {
      _showSnack('else');
    }
  }

  Future<void> _handleSendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    if (!widget.isSystem && _targetUid != null) {
      final unlock = await _checkUnlockForMessage('IMAGE');
      if (unlock == null) {
        return;
      }
      if (unlock.unlockCode != 0) {
        _showUnlockSheet(unlock);
        return;
      }
    }

    final createRes = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createImageMessage(imagePath: image.path);

    if (createRes.code != 0 || createRes.data?.id == null) {
      final desc = createRes.desc;
      _showSnack(desc.isNotEmpty ? desc : '图片消息创建失败');
      return;
    }
    await _sendMessage(createRes.data!.id!);
  }
}

class _InputActionIcon extends StatelessWidget {
  const _InputActionIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite10,
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 20.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
