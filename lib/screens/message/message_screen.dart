import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:zhenyu_flutter/screens/common/new_user_discount_dialog.dart';
import 'package:zhenyu_flutter/screens/message/im_screen.dart';
import 'package:zhenyu_flutter/screens/mine/look_me_screen.dart';
import 'package:zhenyu_flutter/services/im_manager.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<V2TimConversation> _conversations = [];
  V2TimConversation? _systemConversation;
  // final List _conversations = [];
  // dynamic _systemConversation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Add listener for real-time updates
    ImManager.instance.addListener(_onImUpdate);
    _fetchConversations();
  }

  @override
  void dispose() {
    // Clean up the listener
    ImManager.instance.removeListener(_onImUpdate);
    super.dispose();
  }

  void _onImUpdate() {
    // When ImManager notifies, refresh the conversation list
    _fetchConversations();
  }

  Future<void> _markAllConversationsAsRead() async {
    final manager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final conversationsById = <String, V2TimConversation>{};

    if (_systemConversation != null &&
        _systemConversation!.conversationID.isNotEmpty) {
      conversationsById[_systemConversation!.conversationID] =
          _systemConversation!;
    }

    for (final conversation in _conversations) {
      if (conversation.conversationID.isNotEmpty) {
        conversationsById[conversation.conversationID] = conversation;
      }
    }

    for (final entry in conversationsById.entries) {
      final conversation = entry.value;
      final lastMessage = conversation.lastMessage;
      final timestamp = lastMessage?.timestamp ?? nowSeconds;
      final sequence = int.tryParse(lastMessage?.seq ?? '') ?? 0;

      try {
        await manager.cleanConversationUnreadMessageCount(
          conversationID: entry.key,
          cleanTimestamp: timestamp,
          cleanSequence: sequence,
        );
      } catch (e) {
        debugPrint('Failed to clean unread count for ${entry.key}: $e');
      }
    }

    if (!mounted) return;

    await _fetchConversations();
  }

  String _buildConversationSubtitle(
    dynamic conversation, {
    required String fallback,
  }) {
    // return fallback;
    final message = conversation?.lastMessage;
    if (message == null) {
      return fallback;
    }

    switch (message.elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return '[照片]';
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        return '[位置]';
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return '[语音]';
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
      case MessageElemType.V2TIM_ELEM_TYPE_NONE:
      default:
        break;
    }

    final raw = message.textElem?.text;
    if (raw == null || raw.trim().isEmpty) {
      return fallback;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map && decoded['content'] is String) {
        final content = (decoded['content'] as String).trim();
        if (content.isNotEmpty) {
          return content;
        }
      }
    } catch (_) {
      // ignore, fall back to raw text
    }

    return raw;
  }

  Future<void> _fetchConversations() async {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final res = await TencentImSDKPlugin.v2TIMManager
          .getConversationManager()
          .getConversationList(count: 100, nextSeq: '0');

      if (res.code == 0 && res.data != null) {
        final allConversations = res.data!.conversationList;

        if (allConversations != null && allConversations.isNotEmpty) {
          // Separate system messages
          final systemConv = allConversations.firstWhere(
            (c) => c.userID == 'system',
            orElse: () => V2TimConversation(
              conversationID: '',
            ), // Return a dummy object if no system conversation is found
          );

          if (mounted) {
            setState(() {
              _systemConversation = systemConv.conversationID.isNotEmpty
                  ? systemConv
                  : null;
              _conversations = allConversations
                  .where((c) => c.userID != 'system')
                  .toList();
              // Sort by last message time
              _conversations.sort(
                (a, b) => (b.lastMessage?.timestamp ?? 0).compareTo(
                  a.lastMessage?.timestamp ?? 0,
                ),
              );
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to get conversations: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleMenuClick(int value) async {
    if (value == 1) {
      await _markAllConversationsAsRead();
    } else if (value == 2) {
      // Clear list
      _showClearConfirmationDialog();
    }
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('温馨提示'),
        content: const Text('消息清空后不可恢复,您确定清除吗?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // 先关闭对话框

              // 显示加载提示
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }

              final conversationIds = _conversations
                  .map((c) => c.conversationID)
                  .toList();

              // 异步删除所有对话
              for (var id in conversationIds) {
                if (id.isNotEmpty) {
                  try {
                    await TencentImSDKPlugin.v2TIMManager
                        .getConversationManager()
                        .deleteConversation(conversationID: id);
                  } catch (e) {
                    debugPrint('删除对话失败 $id: $e');
                  }
                }
              }

              // 删除完成后，清空列表并刷新 UI
              if (mounted) {
                setState(() {
                  _conversations.clear();
                  _isLoading = false;
                });
              }
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            onRefresh: () => _fetchConversations(),
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                _buildSystemConversation(),
                // 测试
                // if (_systemConversation != null) _buildSystemConversationDetails(),
                _buildWhoSawMe(),
                _buildDivider(),
                if (_isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_conversations.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        '暂无数据~',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                else
                  _buildConversationList(),
              ],
            ),
          ),
        ),
        NewUserDiscountWidget(),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      title: const Text('消息'),
      actions: [
        PopupMenuButton<int>(
          onSelected: _handleMenuClick,
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 1, child: Text('全部已读')),
            const PopupMenuItem(value: 2, child: Text('清空列表')),
          ],
        ),
      ],
    );
  }

  Widget _buildSystemConversation() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 37.5.w),
        child: _ConversationTile(
          avatarUrl:
              'assets/images/official.png', // Use a local asset for official helper
          isAsset: true,
          title: '官方小助手',
          subtitle: _buildConversationSubtitle(
            _systemConversation,
            fallback: '暂无消息',
          ),
          time: null, //_systemConversation?.lastMessage?.timestamp,
          unreadCount: 0, //_systemConversation?.unreadCount ?? 0,
          // unreadCount: 3,
          onTap: () async {
            final conversation = _systemConversation;
            if (conversation != null &&
                conversation.conversationID.isNotEmpty) {
              final lastMessage = conversation.lastMessage;
              final timestamp =
                  lastMessage?.timestamp ??
                  (DateTime.now().millisecondsSinceEpoch ~/ 1000);
              final sequence = int.tryParse(lastMessage?.seq ?? '') ?? 0;
              await TencentImSDKPlugin.v2TIMManager
                  .getConversationManager()
                  .cleanConversationUnreadMessageCount(
                    conversationID: conversation.conversationID,
                    cleanTimestamp: timestamp,
                    cleanSequence: sequence,
                  );
            }
            if (!mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ImScreen(
                  userId: 'system',
                  displayName: '官方小助手',
                  avatarUrl: 'assets/images/official.png',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSystemConversationDetails() {
    final conversation = _systemConversation;
    if (conversation == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 37.5.w),
        child: _ConversationDetailCard(
          conversation: conversation,
          margin: EdgeInsets.only(top: 12.h),
        ),
      ),
    );
  }

  Widget _buildWhoSawMe() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 37.5.w, vertical: 20.h),
        child: _ConversationTile(
          avatarUrl: 'assets/images/blur_avatar.png', // Placeholder
          isAsset: true,
          title: '谁看过我',
          subtitle: '查看访客记录',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const LookMeScreen()));
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF1F1E24),
        height: 10.h,
        margin: EdgeInsets.symmetric(vertical: 31.r),
      ),
    );
  }

  Widget _buildConversationList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final conversation = _conversations[index];

        // 打印这条会话的基本信息
        try {
          debugPrint('===>${jsonEncode(conversation.toJson())}');
        } catch (e, s) {
          debugPrint('Failed to encode conversation: $e\n$s');
        }

        debugPrint(
          '[conversation@$index] faceUrl: ${conversation.faceUrl ?? 'null'}',
        );
        debugPrint(
          '[conversation@$index] showName: ${conversation.showName ?? 'null'}',
        );
        debugPrint(
          '[conversation@$index] lastMessage: ${conversation.lastMessage}',
        );

        final bool isVip = _conversationIsVip(conversation);
        debugPrint('[conversation@$index] isVip: ${isVip}');
        final bool isReal = _conversationIsReal(conversation);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 37.5.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ConversationTile(
                avatarUrl: conversation.faceUrl,
                isVip: isVip,
                isReal: isReal,
                title: conversation.showName ?? '未知用户',
                subtitle: _buildConversationSubtitle(
                  conversation,
                  fallback: '',
                ),
                time: conversation.lastMessage?.timestamp,
                unreadCount: conversation.unreadCount ?? 0,
                onTap: () async {
                  final conversationID = conversation.conversationID;
                  if (conversationID.isNotEmpty) {
                    final lastMessage = conversation.lastMessage;
                    final timestamp =
                        lastMessage?.timestamp ??
                        (DateTime.now().millisecondsSinceEpoch ~/ 1000);
                    final sequence = int.tryParse(lastMessage?.seq ?? '') ?? 0;
                    await TencentImSDKPlugin.v2TIMManager
                        .getConversationManager()
                        .cleanConversationUnreadMessageCount(
                          conversationID: conversationID,
                          cleanTimestamp: timestamp,
                          cleanSequence: sequence,
                        );
                  }

                  if (!mounted) return;

                  final targetId =
                      conversation.userID ??
                      conversation.groupID ??
                      conversation.conversationID;
                  final name =
                      conversation.showName ?? conversation.userID ?? '未知用户';
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ImScreen(
                        userId: targetId,
                        displayName: name,
                        avatarUrl: conversation.faceUrl,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }, childCount: _conversations.length),
    );
  }

  bool _conversationIsVip(V2TimConversation conversation) {
    final value = _getCustomInfoString(conversation, 'vip');
    debugPrint('[conversation@$value] isVip: ${value}');
    if (value == null) {
      return false;
    }
    final normalized = value.trim().toLowerCase();
    debugPrint('[conversation@$normalized] isVip: ${normalized}');
    return normalized == '1' || normalized == 'true' || normalized == 'yes';
  }

  bool _conversationIsReal(V2TimConversation conversation) {
    final value =
        _getCustomInfoString(conversation, 'realType') ??
        _getCustomInfoString(conversation, 'real_type');
    if (value == null) {
      return false;
    }
    final normalized = value.trim().toLowerCase();
    return normalized == '1' || normalized == 'true';
  }

  String? _getCustomInfoString(V2TimConversation conversation, String key) {
    final Map<String, dynamic> json = conversation.toJson();
    final dynamic userProfileRaw = json['userProfile'];
    if (userProfileRaw is! Map) {
      return null;
    }

    final dynamic customInfoRaw = userProfileRaw['customInfo'];
    if (customInfoRaw is! Map) {
      return null;
    }

    final Map<dynamic, dynamic> customInfo = customInfoRaw;

    String? decodeDynamic(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is String) {
        return value;
      }
      if (value is List) {
        try {
          final List<int> ints = value.cast<int>();
          return utf8.decode(ints);
        } catch (_) {
          return null;
        }
      }
      return value.toString();
    }

    String? readDirect(String candidate) {
      return decodeDynamic(customInfo[candidate]);
    }

    for (final candidate in {key, key.toLowerCase(), key.toUpperCase()}) {
      final direct = readDirect(candidate);
      if (direct != null && direct.isNotEmpty) {
        return direct;
      }
    }

    const jsonCarrierKeys = ['userDataInfo', 'user_data_info'];
    for (final carrier in jsonCarrierKeys) {
      final payload = decodeDynamic(customInfo[carrier]);
      if (payload == null || payload.isEmpty) {
        continue;
      }
      try {
        final dynamic decoded = jsonDecode(payload);
        if (decoded is Map) {
          final dynamic value =
              decoded[key] ??
              decoded[key.toLowerCase()] ??
              decoded[key.toUpperCase()];
          if (value != null) {
            return value.toString();
          }
        }
      } catch (_) {
        // Ignore JSON parse failures
      }
    }

    return null;
  }
}

class _ConversationTile extends StatelessWidget {
  final String? avatarUrl;
  final bool isAsset;
  final String title;
  final String subtitle;
  final int? time;
  final int unreadCount;
  final VoidCallback? onTap;
  final bool isVip;
  final bool isReal;

  const _ConversationTile({
    this.avatarUrl,
    this.isAsset = false,
    required this.title,
    required this.subtitle,
    this.time,
    this.unreadCount = 0,
    this.onTap,
    this.isVip = false,
    this.isReal = false,
  });

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    if (now.year == dt.year && now.month == dt.month && now.day == dt.day) {
      return DateFormat('HH:mm').format(dt);
    }
    return DateFormat('MM-dd').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 47.r,
                backgroundImage: isAsset
                    ? AssetImage(avatarUrl!) as ImageProvider
                    : (avatarUrl != null && avatarUrl!.isNotEmpty
                          ? NetworkImage(avatarUrl!)
                          : null),
                child: (avatarUrl == null || avatarUrl!.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -2.r,
                  right: -2.r,
                  child: Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 31.r,
                      minHeight: 31.r,
                    ),
                    child: Center(
                      child: Text(
                        unreadCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 27.sp,
                          color: isVip ? Colors.red : Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVip)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Image.asset(
                          'assets/images/user_tag_vip.png',
                          height: 30.h,
                          width: 80.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (isReal)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Image.asset(
                          'assets/images/user_tag_real.png',
                          height: 30.h,
                          width: 80.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 25.sp, color: Colors.white54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (time != null)
            Text(
              _formatTimestamp(time),
              style: TextStyle(fontSize: 21.sp, color: Colors.white54),
            ),
        ],
      ),
    );
  }
}

class _ConversationDetailCard extends StatelessWidget {
  final V2TimConversation conversation;
  // final dynamic conversation;
  final EdgeInsetsGeometry? margin;

  const _ConversationDetailCard({required this.conversation, this.margin});

  @override
  Widget build(BuildContext context) {
    final formatted = const JsonEncoder.withIndent(
      '  ',
    ).convert(conversation.toJson());

    return Container(
      margin: margin,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2930),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SelectionArea(
        child: Text(
          'formatted',
          style: TextStyle(fontSize: 22.sp, color: Colors.white70, height: 1.4),
        ),
      ),
    );
  }
}
