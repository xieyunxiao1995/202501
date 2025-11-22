import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/models/attention_api_model.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/api/attention_api.dart';
import 'package:zhenyu_flutter/screens/common/vip_dialog.dart';
import 'package:zhenyu_flutter/theme.dart';

class LookMeScreen extends StatefulWidget {
  const LookMeScreen({super.key});

  @override
  State<LookMeScreen> createState() => _LookMeScreenState();
}

class _LookMeScreenState extends State<LookMeScreen> {
  LookMeData? _meta;
  final List<LookMeVisitor> _visitors = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasNext = false;
  int _currentPage = 1;
  final int _pageSize = 20;
  int _userSex = 1;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadUserProfile();
    _fetchLookMeData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    if (currentUser != null) {
      setState(() {
        _userSex = currentUser.sex ?? _userSex;
      });
    }
  }

  void _onScroll() {
    if (!_hasNext || _isLoadingMore) return;
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;
    if (position.pixels >= position.maxScrollExtent - 100) {
      _fetchLookMeData(loadMore: true);
    }
  }

  Future<void> _fetchLookMeData({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasNext) return;
      setState(() => _isLoadingMore = true);
    } else {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _hasNext = false;
      });
    }

    try {
      final resp = await AttentionApi.lookMeList(
        LookMeListReq(pageNum: _currentPage, pageSize: _pageSize),
      );

      if (resp.code != 0) {
        _showMessage(resp.message ?? '获取数据失败');
        return;
      }

      final data = resp.data;
      if (data == null) {
        _showMessage('暂无数据');
        setState(() {
          _meta = null;
          _visitors.clear();
          _hasNext = false;
        });
        return;
      }

      setState(() {
        _hasNext = data.hasNext;
        if (loadMore) {
          final existingIds = _visitors.map((e) => e.uid).toSet();
          final newVisitors = data.visitors
              .where((visitor) => !existingIds.contains(visitor.uid))
              .toList();
          _visitors.addAll(newVisitors);
          _meta = (_meta ?? data).copyWith(
            vip: data.vip,
            vipMaturityDays: data.vipMaturityDays,
            totalCount: data.totalCount,
            hasNext: data.hasNext,
            distance: data.distance,
            visitors: data.visitors,
          );
        } else {
          _visitors
            ..clear()
            ..addAll(data.visitors);
          _meta = data;
        }
        if (_hasNext) {
          _currentPage += 1;
        }
      });
    } catch (e) {
      _showMessage('加载失败，请稍后重试');
    } finally {
      if (!mounted) return;
      setState(() {
        if (loadMore) {
          _isLoadingMore = false;
        } else {
          _isLoading = false;
        }
      });
    }
  }

  bool get _isVip => _meta?.isVip ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('谁看过我'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchLookMeData(loadMore: false),
              child: _buildVisitorList(),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildVisitorList() {
    if (_isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 160.h),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    final visitors = _visitors;
    if (visitors.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 160.h),
          Center(
            child: Text(
              '暂无数据~',
              style: TextStyle(fontSize: 26.sp, color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(37.5.w, 24.h, 37.5.w, 200.h),
      itemCount: visitors.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoadingMore && index == visitors.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final visitor = visitors[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 30.h),
          child: _buildVisitorTile(visitor),
        );
      },
    );
  }

  Widget _buildVisitorTile(LookMeVisitor visitor) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleVisitorTap(visitor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(visitor.avatar),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _isVip
                            ? (visitor.userName?.isNotEmpty == true
                                  ? visitor.userName!
                                  : '匿名用户')
                            : '******',
                        style: TextStyle(
                          fontSize: 31.sp,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      visitor.lookTimeFormat ?? '',
                      style: TextStyle(
                        fontSize: 21.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _buildGenderBadge(visitor),
                    SizedBox(width: 12.w),
                    Text(
                      '/${visitor.city ?? '深圳市'}',
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(height: 1.h, color: AppColors.backgroundWhite15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    Widget buildImage() {
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        return Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildAvatarFallback(),
        );
      }
      return _buildAvatarFallback();
    }

    Widget buildFilledImage() => SizedBox.expand(child: buildImage());

    return SizedBox(
      width: 93.75.w,
      height: 93.75.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(47.r),
        child: _isVip
            ? buildFilledImage()
            : Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: buildFilledImage(),
                  ),
                  Container(color: AppColors.primaryColor.withOpacity(0.2)),
                ],
              ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      color: AppColors.backgroundWhite10,
      alignment: Alignment.center,
      child: const Icon(Icons.person, color: AppColors.textSecondary),
    );
  }

  Widget _buildGenderBadge(LookMeVisitor visitor) {
    final isFemale = visitor.sex == 0;
    final baseColor = isFemale ? AppColors.accentPink : AppColors.accentBlue;
    final iconPath = isFemale
        ? 'assets/images/gender_girl.png'
        : 'assets/images/gender_boy.png';
    final hasAge = visitor.age > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(21.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 25.w, height: 25.w),
          if (hasAge) ...[
            SizedBox(width: 6.w),
            Text(
              visitor.age.toString(),
              style: TextStyle(fontSize: 19.sp, color: baseColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final data = _meta;
    if (data == null) {
      return const SizedBox.shrink();
    }

    final interestLabel = _userSex == 1 ? '小姐姐' : '小哥哥';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppGradients.footerGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 36.h),
          child: data.isVip
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '尊敬的VIP客户你好',
                      style: TextStyle(
                        fontSize: 27.sp,
                        color: AppColors.goldGradientEnd,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      '你的VIP还剩余${data.vipMaturityDays}天',
                      style: TextStyle(
                        fontSize: 27.sp,
                        color: AppColors.goldGradientEnd,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (data.totalCount > 0) ...[
                      Text(
                        '${data.totalCount}位$interestLabel对你感兴趣',
                        style: TextStyle(
                          fontSize: 27.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if ((data.distance ?? 0) > 0)
                        Text(
                          '其中有1位离你仅${_formatDistance(data.distance)}',
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      SizedBox(height: 30.h),
                    ],
                    GestureDetector(
                      onTap: _showVipDialog,
                      child: Container(
                        width: 625.w,
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(83.r),
                          gradient: AppGradients.secondaryGradient,
                        ),
                        child: Center(
                          child: Text(
                            '购买VIP查看谁看过我',
                            style: textStyleInButton.copyWith(fontSize: 27.sp),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
        ),
      ),
    );
  }

  String _formatDistance(double? distance) {
    if (distance == null || distance <= 0) {
      return '';
    }
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)}m';
    }
    final km = distance / 1000;
    final formatted = km >= 10 ? km.toStringAsFixed(0) : km.toStringAsFixed(1);
    return '${formatted}km';
  }

  void _handleVisitorTap(LookMeVisitor visitor) {
    if (_isVip) {
      debugPrint('Navigate to visitor ${visitor.uid}');
    } else {
      _showVipDialog();
    }
  }

  void _showVipDialog() {
    showDialog<void>(context: context, builder: (_) => const VipDialog());
  }

  void _showMessage(String message) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  }
}
