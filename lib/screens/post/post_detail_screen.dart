import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhenyu_flutter/api/posts_api.dart';
import 'package:zhenyu_flutter/models/posts_api_model.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostInfo? _post;
  List<CommentInfo> _comments = [];
  bool _isLoadingPost = true;
  bool _isLoadingComments = true;
  String? _error;

  // State for bottom bar actions
  late bool _isLiked;
  late int _likeCount;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? _replyingToCommentId;
  String? _replyingToUserName;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // If focus is lost, exit reply mode
        setState(() {
          _replyingToCommentId = null;
          _replyingToUserName = null;
        });
      }
      setState(() {}); // Rebuild to show/hide buttons
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchPostDetails(), _fetchComments()]);
  }

  Future<void> _fetchPostDetails() async {
    try {
      final req = PostsDetailReq(postId: widget.postId);
      final resp = await PostsApi.postsDetail(req);
      if (resp.code == 0 && resp.data != null) {
        setState(() {
          _post = resp.data;
          _isLiked = _post!.isLiked ?? false;
          _likeCount = _post!.likeCount ?? 0;
        });
      } else {
        throw Exception(resp.message ?? 'Failed to load post details');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingPost = false;
      });
    }
  }

  Future<void> _fetchComments({bool forceRefresh = false}) async {
    if (forceRefresh) {
      setState(() {
        _isLoadingComments = true;
      });
    }
    try {
      final req = PostsCommentListReq(
        postId: widget.postId,
        pageNum: 1,
        pageSize: 20,
      );
      final resp = await PostsApi.postsCommentList(req);
      if (resp.code == 0 && resp.data?.list != null) {
        setState(() {
          _comments = resp.data!.list!;
        });
      } else {
        throw Exception(resp.message ?? 'Failed to load comments');
      }
    } catch (e) {
      print('Failed to load comments: $e');
    } finally {
      setState(() {
        _isLoadingComments = false;
      });
    }
  }

  Future<void> _handleLike() async {
    if (_post == null) return;
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likeCount++ : _likeCount--;
    });
    try {
      final req = PostsLikeReq(
        isLike: _isLiked,
        targetId: widget.postId,
        targetType: 1,
      );
      await PostsApi.postsLike(req);
    } catch (e) {
      setState(() {
        _isLiked = !_isLiked;
        _isLiked ? _likeCount++ : _likeCount--;
      });
    }
  }

  Future<void> _handleAddComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      // Get location from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final locationString = prefs.getString('longitudeData');
      double latitude = 0.0;
      double longitude = 0.0;

      if (locationString != null && locationString.isNotEmpty) {
        try {
          final locationData = jsonDecode(locationString);
          latitude = locationData['latitude'] ?? 0.0;
          longitude = locationData['longitude'] ?? 0.0;
        } catch (e) {
          debugPrint('Failed to parse location data: $e');
        }
      }

      final req = PostsCommentsAddReq(
        content: content,
        latitude: latitude,
        longitude: longitude,
        postId: widget.postId,
        parentId: _replyingToCommentId,
      );
      await PostsApi.postsCommentsAdd(req);

      _commentController.clear();
      _focusNode.unfocus();
      await _fetchComments(forceRefresh: true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('评论失败: $e')));
      }
    }
  }

  void _handleReply(int commentId, String userName) {
    setState(() {
      _replyingToCommentId = commentId;
      _replyingToUserName = userName;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('动态详情')),
      body: _buildBody(),
      bottomNavigationBar: _post != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildBody() {
    if (_isLoadingPost) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('加载失败: $_error'));
    }
    if (_post == null) {
      return const Center(child: Text('动态不存在'));
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 60.h), // Avoid overlap with bottom bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostCardContent(_post!),
            Container(
              height: 1,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                '评论',
                style: textStylePrimaryBold.copyWith(fontSize: 28.sp),
              ),
            ),
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final isReplying = _replyingToUserName != null;
    final hintText = isReplying ? '回复 $_replyingToUserName' : '评论一下...';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor, // dont change!!!
        border: Border(
          top: BorderSide(color: AppColors.backgroundWhite10, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.textFieldBackground,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
              ),
              style: TextStyle(color: AppColors.textPrimary, fontSize: 24.sp),
            ),
          ),
          SizedBox(width: 16.w),
          if (_focusNode.hasFocus)
            TextButton(
              onPressed: _handleAddComment,
              style:
                  TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 6.h,
                    ),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
              child: Container(
                width: 100.w,
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.secondaryGradientStart,
                      AppColors.secondaryGradientEnd,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Text(
                  '评论',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else ...[
            _actionButton(
              imagePath: _isLiked
                  ? 'assets/images/post_good_selected.png'
                  : 'assets/images/post_good_unselected.png',
              text: _likeCount.toString(),
              color: _isLiked ? AppColors.accentPink : AppColors.textSecondary,
              onTap: _handleLike,
            ),
            SizedBox(width: 16.w),
            _actionButton(
              imagePath: 'assets/images/post_comment.png',
              text: _post?.commentCount?.toString() ?? '0',
              color: AppColors.textSecondary,
              onTap: () {},
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionButton({
    required String imagePath,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(imagePath, width: 20.w, height: 20.h, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    if (_isLoadingComments) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_comments.isEmpty) {
      return const Center(
        child: Padding(padding: EdgeInsets.all(20.0), child: Text('暂无评论')),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        return _CommentItem(
          comment: _comments[index],
          postId: widget.postId,
          onReply: (commentId, userName) {
            _handleReply(commentId, userName);
          },
        );
      },
    );
  }

  Widget _buildPostCardContent(PostInfo post) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(post.avatar ?? ''),
            radius: 48.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(post),
                SizedBox(height: 8.h),
                StyledText.secondary(post.content ?? '', fontSize: 25.sp),
                SizedBox(height: 12.h),
                if (post.imageList != null && post.imageList!.isNotEmpty)
                  _buildImageGrid(context, post.imageList!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(PostInfo post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              post.userName ?? 'Unknown',
              style: (post.vip == 1 ? textStylePrimaryBold : textStylePrimary)
                  .copyWith(
                    fontSize: 29.sp,
                    color: post.vip == 1
                        ? AppColors.accentPink
                        : AppColors.textPrimary,
                  ),
            ),
            if (post.realType == 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Image.asset(
                  'assets/images/user_tag_real.png',
                  width: 66.w,
                ),
              ),
            if (post.vip == 1)
              Image.asset('assets/images/user_tag_vip.png', width: 60.w),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: post.sex == 1
                    ? AppColors.accentBlue.withOpacity(0.2)
                    : AppColors.accentPink.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    post.sex == 1 ? Icons.male : Icons.female,
                    size: 12.sp,
                    color: post.sex == 1
                        ? AppColors.accentBlue
                        : AppColors.accentPink,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${post.age ?? ''}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: post.sex == 1
                          ? AppColors.accentBlue
                          : AppColors.accentPink,
                    ),
                  ),
                ],
              ),
            ),
            StyledText.secondary(' / ${post.city ?? ''}', fontSize: 24.sp),
          ],
        ),
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: images.length == 1
            ? 1
            : (images.length == 2 || images.length == 4 ? 2 : 3),
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(images[index], fit: BoxFit.cover),
        );
      },
    );
  }
}

class _CommentItem extends StatefulWidget {
  final CommentInfo comment;
  final int postId;
  final Function(int parentId, String userName) onReply;
  const _CommentItem({
    required this.comment,
    required this.postId,
    required this.onReply,
  });

  @override
  State<_CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<_CommentItem> {
  late bool _isLiked;
  late int _likeCount;
  bool _isRepliesExpanded = false;
  bool _isLoadingReplies = false;
  List<CommentInfo> _replies = [];

  @override
  void initState() {
    super.initState();
    _isLiked = widget.comment.isLiked ?? false;
    _likeCount = widget.comment.likeCount ?? 0;
  }

  Future<void> _toggleReplies() async {
    setState(() {
      _isRepliesExpanded = !_isRepliesExpanded;
    });

    if (_isRepliesExpanded && _replies.isEmpty) {
      setState(() {
        _isLoadingReplies = true;
      });
      try {
        final req = PostsCommentListReq(
          postId: widget.postId,
          pageNum: 1,
          pageSize: 10,
          rootId: widget.comment.commentId,
        );
        final resp = await PostsApi.postsCommentList(req);
        if (resp.code == 0 && resp.data?.list != null) {
          setState(() {
            _replies = resp.data!.list!;
          });
        }
      } catch (e) {
        // handle error
      } finally {
        setState(() {
          _isLoadingReplies = false;
        });
      }
    }
  }

  Future<void> _handleCommentLike() async {
    if (widget.comment.commentId == null) return;
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likeCount++ : _likeCount--;
    });
    try {
      await PostsApi.postsLike(
        PostsLikeReq(
          isLike: _isLiked,
          targetId: widget.comment.commentId!,
          targetType: 2,
        ),
      );
    } catch (e) {
      setState(() {
        _isLiked = !_isLiked;
        _isLiked ? _likeCount++ : _likeCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.comment.avatar ?? ''),
            radius: 32.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comment.userName ?? 'Unknown',
                  style: textStylePrimary,
                ),
                if (widget.comment.city != null &&
                    widget.comment.city!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: StyledText.secondary(
                      widget.comment.city!,
                      fontSize: 20.sp,
                    ),
                  ),
                SizedBox(height: 4.h),
                Text(widget.comment.content ?? '', style: textStyleSecondary),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    StyledText.secondary(
                      widget.comment.createTimeTxt ?? '',
                      fontSize: 20.sp,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        if (widget.comment.commentId != null &&
                            widget.comment.userName != null) {
                          widget.onReply(
                            widget.comment.commentId!,
                            widget.comment.userName!,
                          );
                        }
                      },
                      child: StyledText.secondary('回复', fontSize: 22.sp),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: _handleCommentLike,
                      child: Row(
                        children: [
                          Image.asset(
                            _isLiked
                                ? 'assets/images/post_good_selected.png'
                                : 'assets/images/post_good_unselected.png',
                            width: 20.w,
                            height: 20.h,
                            color: _isLiked
                                ? AppColors.accentPink
                                : AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _likeCount.toString(),
                            style: TextStyle(
                              color: _isLiked
                                  ? AppColors.accentPink
                                  : AppColors.textSecondary,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildRepliesSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepliesSection() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // StyledText(
          //   'widget.comment.commentCount${widget.comment.commentCount}',
          // ),
          if (_isRepliesExpanded)
            _isLoadingReplies
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite6,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _replies.length,
                      itemBuilder: (context, index) {
                        return _ReplyItem(
                          reply: _replies[index],
                          parentComment: widget.comment,
                          onReply: (parentId, userName) {
                            widget.onReply(parentId, userName);
                          },
                        );
                      },
                    ),
                  ),
          if (widget.comment.commentCount != null &&
              widget.comment.commentCount! > 0)
            TextButton(
              onPressed: _toggleReplies,
              child: StyledText.secondary(
                _isRepliesExpanded
                    ? '收起'
                    : '-- 展开 ${widget.comment.commentCount} 条回复',
                fontSize: 22.sp,
              ),
            ),
        ],
      ),
    );
  }
}

class _ReplyItem extends StatefulWidget {
  final CommentInfo reply;
  final CommentInfo parentComment;
  final Function(int parentId, String userName) onReply;
  const _ReplyItem({
    required this.reply,
    required this.parentComment,
    required this.onReply,
  });

  @override
  State<_ReplyItem> createState() => _ReplyItemState();
}

class _ReplyItemState extends State<_ReplyItem> {
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.reply.isLiked ?? false;
    _likeCount = widget.reply.likeCount ?? 0;
  }

  Future<void> _handleReplyLike() async {
    if (widget.reply.commentId == null) return;
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likeCount++ : _likeCount--;
    });
    try {
      await PostsApi.postsLike(
        PostsLikeReq(
          isLike: _isLiked,
          targetId: widget.reply.commentId!,
          targetType: 2,
        ),
      );
    } catch (e) {
      setState(() {
        _isLiked = !_isLiked;
        _isLiked ? _likeCount++ : _likeCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetName =
        widget.reply.targetNickname ?? widget.parentComment.userName;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.reply.avatar ?? ''),
            radius: 24.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: textStylePrimary.copyWith(fontSize: 22.sp),
                    children: [
                      TextSpan(text: widget.reply.userName ?? 'Unknown'),
                      TextSpan(
                        text: ' 回复 $targetName',
                        style: textStyleSecondary.copyWith(fontSize: 22.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.reply.content ?? '',
                  style: textStyleSecondary.copyWith(fontSize: 22.sp),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    StyledText.secondary(
                      widget.reply.createTimeTxt ?? '',
                      fontSize: 20.sp,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        if (widget.reply.commentId != null &&
                            widget.reply.userName != null) {
                          widget.onReply(
                            widget.reply.commentId!,
                            widget.reply.userName!,
                          );
                        }
                      },
                      child: StyledText.secondary('回复', fontSize: 22.sp),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: _handleReplyLike,
                      child: Row(
                        children: [
                          Image.asset(
                            _isLiked
                                ? 'assets/images/post_good_selected.png'
                                : 'assets/images/post_good_unselected.png',
                            width: 20.w,
                            height: 20.h,
                            color: _isLiked
                                ? AppColors.accentPink
                                : AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _likeCount.toString(),
                            style: TextStyle(
                              color: _isLiked
                                  ? AppColors.accentPink
                                  : AppColors.textSecondary,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
