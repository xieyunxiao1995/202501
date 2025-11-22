import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/api/posts_api.dart';
import 'package:zhenyu_flutter/api/report_api.dart';
import 'package:zhenyu_flutter/models/posts_api_model.dart';
import 'package:zhenyu_flutter/models/report_api_model.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/screens/post/post_detail_screen.dart';
import 'package:zhenyu_flutter/screens/profile/profile_screen.dart';
import 'package:zhenyu_flutter/screens/common/photo_viewer_screen.dart';
import 'package:zhenyu_flutter/theme.dart';

class PostCard extends StatefulWidget {
  final PostInfo post;
  final Function(int postId) onPostDeleted;

  const PostCard({super.key, required this.post, required this.onPostDeleted});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _isLiked;
  late int _likeCount;

  final GlobalKey _moreButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked ?? false;
    _likeCount = widget.post.likeCount ?? 0;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Future<void> _handleLike() async {
    if (widget.post.id == null) return;

    // Optimistic UI update
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });

    try {
      final req = PostsLikeReq(
        isLike: _isLiked,
        targetId: widget.post.id!,
        targetType: 1, // 1 for post
      );
      await PostsApi.postsLike(req);
    } catch (e) {
      // Revert on error
      setState(() {
        _isLiked = !_isLiked;
        if (_isLiked) {
          _likeCount++;
        } else {
          _likeCount--;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('操作失败: $e')));
      }
    }
  }

  Future<void> _handleReport(String reason) async {
    if (widget.post.uid == null) return;
    try {
      final req = ReportUserReq(
        reason: reason,
        reportType: 'POST',
        toUid: widget.post.uid!,
      );
      await ReportApi.reportUser(req);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('举报成功')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('举报失败: $e')));
      }
    }
  }

  Future<void> _handleDelete() async {
    if (widget.post.id == null) return;
    try {
      final req = PostsDeleteReq(postId: widget.post.id!);
      await PostsApi.postsDelete(req);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('删除成功')));
        widget.onPostDeleted(widget.post.id!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
      }
    }
  }

  void _showReportSheet() {
    final reportReasons = ["垃圾广告", "色情骚扰", "暴力辱骂", "恶意欺诈", "政治敏感", "其他"];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ...reportReasons.map((reason) {
                return ListTile(
                  title: Center(child: Text(reason)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _handleReport(reason);
                  },
                );
              }).toList(),
              const Divider(height: 1),
              ListTile(
                title: const Center(child: Text('取消')),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showMoreMenu() {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    final RenderBox renderBox =
        _moreButtonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: _removeOverlay, // Dismiss on tap outside
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Positioned(
                top:
                    offset.dy + size.height - 10.h, // Position below the button
                right:
                    MediaQuery.of(context).size.width -
                    offset.dx -
                    size.width, // Align right edges
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      _removeOverlay(); // Dismiss the overlay first
                      if (widget.post.canDelete == true) {
                        _handleDelete();
                      } else {
                        _showReportSheet();
                      }
                    },
                    child: Image.asset(
                      widget.post.canDelete == true
                          ? 'assets/images/post_action_delete.png'
                          : 'assets/images/post_action_inform.png',
                      width: 120.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.post.avatar ?? ''),
            radius: 48.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    if (widget.post.id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailScreen(postId: widget.post.id!),
                        ),
                      );
                    }
                  },
                  child: StyledText.secondary(
                    widget.post.content ?? '',
                    fontSize: 25.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                if (widget.post.imageList != null &&
                    widget.post.imageList!.isNotEmpty)
                  _buildImageGrid(context, widget.post.imageList!),
                SizedBox(height: 12.h),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (widget.post.uid != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: widget.post.uid!),
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.post.userName ?? 'Unknown',
                    style:
                        (widget.post.vip == 1
                                ? textStylePrimaryBold
                                : textStylePrimary)
                            .copyWith(
                              fontSize: 29.sp,
                              color: widget.post.vip == 1
                                  ? AppColors.accentPink
                                  : AppColors.textPrimary,
                            ),
                  ),
                  if (widget.post.realType == 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Image.asset(
                        'assets/images/user_tag_real.png',
                        width: 66.w,
                      ),
                    ),
                  if (widget.post.vip == 1)
                    Image.asset('assets/images/user_tag_vip.png', width: 60.w),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: widget.post.sex == 1
                          ? AppColors.accentBlue
                          : AppColors.accentPink,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.post.sex == 1 ? Icons.male : Icons.female,
                          size: 24.sp,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${widget.post.age ?? ''}',
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StyledText.secondary(
                    ' ${widget.post.city ?? ''}',
                    fontSize: 24.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          key: _moreButtonKey,
          icon: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
          onPressed: _showMoreMenu,
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false, // Make the route transparent
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PhotoViewerScreen(imageUrls: images, initialIndex: index),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(images[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _actionButton(
          imagePath: _isLiked
              ? 'assets/images/post_good_selected.png'
              : 'assets/images/post_good_unselected.png',
          text: _likeCount.toString(),
          color: _isLiked ? AppColors.accentPink : AppColors.textSecondary,
          onTap: _handleLike,
        ),
        SizedBox(width: 40.w),
        _actionButton(
          imagePath: 'assets/images/post_comment.png',
          text: widget.post.commentCount?.toString() ?? '评论',
          color: AppColors.textSecondary,
          onTap: () {
            if (widget.post.id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PostDetailScreen(postId: widget.post.id!),
                ),
              );
            }
          },
        ),
      ],
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
          Image.asset(imagePath, width: 32.w, height: 32.h, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 28.sp),
          ),
        ],
      ),
    );
  }
}
