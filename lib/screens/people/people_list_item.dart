import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';
import 'package:zhenyu_flutter/screens/profile/profile_screen.dart';
import 'package:zhenyu_flutter/screens/common/vip_dialog.dart';
import 'package:zhenyu_flutter/api/attention_api.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class PeopleListItem extends StatefulWidget {
  final IndexUserInfo user;
  final int selectValue;
  final bool isVip;
  final VoidCallback onUpdate;

  const PeopleListItem({
    super.key,
    required this.user,
    required this.selectValue,
    required this.isVip,
    required this.onUpdate,
  });

  @override
  State<PeopleListItem> createState() => _PeopleListItemState();
}

class _PeopleListItemState extends State<PeopleListItem> {
  late bool _isLiked;
  late bool _newcomerLocked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.user.isLike ?? false;
    // 非 VIP 用户在 "新人" 列表中查看卡片时需要蒙层或拦截
    _newcomerLocked = !widget.isVip && widget.selectValue == 3;
  }

  void _handleLike() async {
    final originalIsLiked = _isLiked;
    setState(() {
      _isLiked = !originalIsLiked;
    });
    try {
      if (!originalIsLiked) {
        await AttentionApi.addAttention((widget.user.uid ?? '').toString());
      } else {
        await AttentionApi.delAttention((widget.user.uid ?? '').toString());
      }
    } catch (e) {
      setState(() {
        _isLiked = originalIsLiked;
      });
      // Optional: show an error message to the user
      debugPrint('Failed to update like status: $e');
    }
  }

  void _handleTap() {
    if (_newcomerLocked) {
      showDialog(context: context, builder: (context) => const VipDialog());
      return;
    }
    if (widget.user.uid != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            userId: int.tryParse(widget.user.uid.toString()) ?? 0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        height: 260.r,
        margin: EdgeInsets.only(bottom: 35.r),
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.04),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                _buildAvatar(),
                SizedBox(width: 20.r),
                _buildUserInfo(),
              ],
            ),
            Positioned(top: 8.r, right: 8.r, child: _buildLikeButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final bool shouldBlur = _newcomerLocked;
    return SizedBox(
      width: 240.r,
      height: 240.r,
      child: Stack(
        clipBehavior: Clip.none, // Allow the frame to overflow
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              widget.user.avatar ?? '',
              width: 208.r,
              height: 208.r,
              fit: BoxFit.cover,
            ),
          ),
          if (shouldBlur)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 208.r,
                height: 208.r,
                color: Colors.white.withOpacity(0.01),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          if (widget.user.vip == 1)
            Image.asset(
              'assets/images/vip_frame.png', // Placeholder
              width: 240.r, // Make the frame larger than the avatar
              height: 240.r,
              fit: BoxFit.contain,
            ),
          if (widget.user.avatarSimilarity != null &&
              widget.user.avatarSimilarity! > 0)
            Positioned(
              top: 16.r,
              left: 16.r,
              child: Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFAE3CD),
                      Color(0xFFF7D9BD),
                      Color(0xFFE6BC97),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
                child: Text(
                  '相似度：${widget.user.avatarSimilarity}%',
                  style: TextStyle(fontSize: 19.sp, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameAndTags(),
          SizedBox(height: 10.r),
          _buildInfoTags(),
          SizedBox(height: 10.r),
          _buildGpsInfo(),
          const Spacer(), // Pushes albums to the bottom
          _buildAlbums(),
        ],
      ),
    );
  }

  Widget _buildNameAndTags() {
    return Row(
      children: [
        Text(
          widget.user.userName ?? '',
          style: TextStyle(
            fontSize: 27.sp,
            color: widget.user.vip == 1 ? Colors.red : Colors.white,
          ),
        ),
        if (widget.user.vip == 1)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.r),
            child: Image.asset(
              'assets/images/VIP.png',
              height: 25.r,
            ), // Placeholder
          ),
        if (widget.user.realType == 1)
          Image.asset(
            'assets/images/authentication.png',
            height: 25.r,
          ), // Placeholder
      ],
    );
  }

  Widget _buildInfoTags() {
    final List<String> tags = [
      if (widget.user.age != null) '${widget.user.age}岁',
      if (widget.user.height != null) '${widget.user.height}cm',
      if (widget.user.occupation != null) widget.user.occupation!,
      if (widget.user.label != null) widget.user.label!,
      if (widget.user.figure != null) widget.user.figure!,
    ];

    return Text(
      tags.join(' | '),
      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 24.sp),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildGpsInfo() {
    final List<String> infoParts = [];
    if (widget.user.cityName != null && widget.user.cityName!.isNotEmpty) {
      infoParts.add(widget.user.cityName!);
    }
    final distance = formatDistance(widget.user.distance?.toDouble() ?? 0.0);
    if (distance.isNotEmpty && distance != '小于100m') {
      infoParts.add(distance);
    }
    if (widget.user.onlineTxt != null && widget.user.onlineTxt!.isNotEmpty) {
      infoParts.add(widget.user.onlineTxt!);
    }

    if (infoParts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(96, 80, 58, 0.5),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF65615c), width: 1.r),
      ),
      child: Text(
        infoParts.join(' · '),
        style: TextStyle(
          color: AppColors.secondaryGradientEnd,
          fontSize: 25.sp,
        ),
      ),
    );
  }

  Widget _buildAlbums() {
    final albums = widget.user.userAlbums ?? [];
    if (albums.isEmpty) return const SizedBox.shrink();

    final bool shouldBlur = _newcomerLocked;

    return SizedBox(
      height: 85.r,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length > 3 ? 3 : albums.length,
        itemBuilder: (context, index) {
          final isLastVisible = index == 2 && albums.length > 3;
          return Padding(
            padding: EdgeInsets.only(right: 10.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    albums[index].albumUrl ?? '',
                    width: 73.r,
                    height: 73.r,
                    fit: BoxFit.cover,
                  ),
                  if (shouldBlur)
                    Container(
                      width: 73.r,
                      height: 73.r,
                      color: Colors.white.withOpacity(0.01),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  if (isLastVisible)
                    Container(
                      width: 73.r,
                      height: 73.r,
                      color: Colors.black.withOpacity(0.65),
                      child: Center(
                        child: Text(
                          '+${albums.length - 3}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLikeButton() {
    return GestureDetector(
      onTap: _handleLike,
      child: Padding(
        padding: EdgeInsets.only(left: 20.r),
        child: Image.asset(
          _isLiked
              ? 'assets/images/like.png' // Placeholder
              : 'assets/images/like_empty.png', // Placeholder
          width: 35.r,
          height: 29.r,
        ),
      ),
    );
  }
}
