import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/api/posts_api.dart';
import 'package:zhenyu_flutter/models/posts_api_model.dart';
import 'package:zhenyu_flutter/screens/post/post_detail_screen.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class ExploreMessageScreen extends StatefulWidget {
  const ExploreMessageScreen({super.key});

  @override
  State<ExploreMessageScreen> createState() => _ExploreMessageScreenState();
}

class _ExploreMessageScreenState extends State<ExploreMessageScreen> {
  final List<NotificationItem> _messages = [];
  final ScrollController _scrollController = ScrollController();
  int _pageNum = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasNext = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchMessages(refresh: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 120 &&
        !_isLoading &&
        _hasNext) {
      _fetchMessages();
    }
  }

  Future<void> _fetchMessages({bool refresh = false}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      if (refresh) {
        _error = null;
      }
    });

    final int targetPage = refresh ? 1 : _pageNum;

    try {
      final resp = await PostsApi.msglist(
        MsgListReq(pageNum: targetPage, pageSize: _pageSize),
      );

      if (resp.code != 0) {
        throw Exception(resp.message ?? '加载失败');
      }

      final data = resp.data;
      final List<NotificationItem> fetched =
          List<NotificationItem>.from(data?.list ?? <NotificationItem>[]);

      setState(() {
        if (refresh) {
          _messages
            ..clear()
            ..addAll(fetched);
        } else {
          _messages.addAll(fetched);
        }
        _hasNext = data?.hasNext ?? false;
        _pageNum = targetPage + 1;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchMessages(refresh: true);
  }

  void _openPostDetail(NotificationItem item) {
    final postId = item.postId;
    if (postId == null || postId == 0) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PostDetailScreen(postId: postId)),
    );
  }

  String _buildRelativeTime(NotificationItem item) {
    final raw = item.createTime;
    if (raw == null || raw.isEmpty) {
      return '';
    }
    int? timestamp;
    final trimmed = raw.trim();
    final maybeNumber = int.tryParse(trimmed);
    if (maybeNumber != null) {
      timestamp = trimmed.length > 10 ? maybeNumber ~/ 1000 : maybeNumber;
    } else {
      final parsed = DateTime.tryParse(trimmed);
      if (parsed != null) {
        timestamp = parsed.millisecondsSinceEpoch ~/ 1000;
      }
    }
    if (timestamp == null) {
      return raw;
    }
    return formatTimeAgo(timestamp);
  }

  Widget _buildBody() {
    if (_isLoading && _messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _messages.isEmpty) {
      return Center(
        child: Text(
          _error!,
          style: TextStyle(fontSize: 26.sp, color: AppColors.textSecondary),
        ),
      );
    }

    if (_messages.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Center(
            child: Text(
              '暂无消息~',
              style:
                  TextStyle(fontSize: 26.sp, color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: _messages.length + (_hasNext ? 1 : 0),
      itemBuilder: (context, index) {
        if (_hasNext && index == _messages.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final item = _messages[index];
        return _NotificationTile(
          item: item,
          onTap: () => _openPostDetail(item),
          relativeTime: _buildRelativeTime(item),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动态消息'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _buildBody(),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.onTap,
    required this.relativeTime,
  });

  final NotificationItem item;
  final VoidCallback onTap;
  final String relativeTime;

  @override
  Widget build(BuildContext context) {
    final triggerName = item.triggerName ?? '匿名用户';
    final action = item.notificationType == 1 ? '动态' : '评论';

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(url: item.triggerAvatar),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: triggerName,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: ' 回复了你$action',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((item.photoPreview ?? '').isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  item.photoPreview!,
                                  width: 120.w,
                                  height: 120.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 120.w,
                                    height: 120.w,
                                    color: Colors.white12,
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.image_not_supported,
                                        color: Colors.white54),
                                  ),
                                ),
                              ),
                            if ((item.photoPreview ?? '').isNotEmpty)
                              SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                item.content ?? item.contentPreview ?? '',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if ((item.commentContent ?? '').isNotEmpty)
                      Text(
                        item.commentContent!,
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.white,
                        ),
                      ),
                    SizedBox(height: 8.h),
                    Text(
                      relativeTime,
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(28.r),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person, color: Colors.white54),
    );

    if (url == null || url!.isEmpty) {
      return placeholder;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: Image.network(
        url!,
        width: 56.w,
        height: 56.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      ),
    );
  }
}
