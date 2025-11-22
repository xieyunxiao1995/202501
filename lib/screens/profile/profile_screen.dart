import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/api/attention_api.dart';
import 'package:zhenyu_flutter/api/chat_api.dart';
import 'package:zhenyu_flutter/api/posts_api.dart';
import 'package:zhenyu_flutter/api/report_api.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/chat_api_model.dart';
import 'package:zhenyu_flutter/models/posts_api_model.dart';
import 'package:zhenyu_flutter/models/report_api_model.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/common/post_card.dart';
import 'package:zhenyu_flutter/screens/common/chat_unlock_dialog.dart';
import 'package:zhenyu_flutter/screens/invate/get_vip_screen.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/screens/common/photo_viewer_screen.dart';
import 'package:zhenyu_flutter/screens/common/video_player_screen.dart';
import 'package:zhenyu_flutter/api/videos_api.dart';
import 'package:zhenyu_flutter/models/videos_api_model.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/screens/message/im_screen.dart';
import 'package:zhenyu_flutter/screens/wallet/wallet_screen.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/shared/picker_utils.dart';

enum MediaType { album, video }

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  OtherUserInfo? _userInfo;
  List<PostInfo> _posts = [];
  List<VideoInfo> _videos = [];
  bool _isLoadingUser = true;
  bool _isLoadingPosts = true;
  // bool _isLoadingVideos = true;
  String? _error;
  bool _isLiked = false;
  int _likeCount = 0;
  bool _isUpdatingLike = false;
  WxAccountData? _wxAccountData;
  bool _isLoadingWxAccount = false;
  bool _isUnlockingWx = false;

  late TabController _mediaTabController;
  late TabController _mainTabController;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _mediaTabController = TabController(length: 2, vsync: this);
    _mainTabController = TabController(length: 2, vsync: this);
    _mediaTabController.addListener(() {
      setState(() {});
    });
    _mainTabController.addListener(() {
      setState(() {});
    });
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserProvider>(context);
    _fetchWxAccount();
  }

  @override
  void dispose() {
    _mediaTabController.dispose();
    _mainTabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchUserInfo(),
      _fetchUserPosts(),
      _fetchUserVideos(),
    ]);
  }

  Future<void> _fetchUserInfo() async {
    try {
      final req = GetOtherUserInfoReq(toUid: widget.userId);
      final resp = await UserApi.getOtherUserInfo(req);
      if (resp.code == 0 && resp.data != null) {
        final fetchedUser = resp.data!;
        setState(() {
          _userInfo = fetchedUser;
          _isLiked = (fetchedUser.likeStatus ?? 0) == 1;
          _likeCount = fetchedUser.likeCount ?? 0;
        });
        _fetchWxAccount();
      } else {
        throw Exception(resp.message ?? 'Failed to load user info');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _fetchUserPosts() async {
    try {
      final req = PostsMyListReq(uid: widget.userId, pageNum: 1, pageSize: 20);
      final resp = await PostsApi.postsMyList(req);
      if (resp.code == 0 && resp.data?.list != null) {
        setState(() {
          _posts = resp.data!.list!;
        });
      }
    } catch (e) {
      print('请求用户我的动态列表: $e');
    } finally {
      setState(() {
        _isLoadingPosts = false;
      });
    }
  }

  Future<void> _fetchUserVideos() async {
    try {
      final req = VideoRecommendReq(
        toUid: widget.userId,
        pageNum: 1,
        pageSize: 10, // Load 10 videos for the horizontal list
      );
      final resp = await VideosApi.getRecommendVideos(req);
      if (resp.code == 0 && resp.data?.list != null) {
        setState(() {
          _videos = resp.data!.list!;
        });
      }
    } catch (e) {
      print('Failed to load user videos: $e');
    }
  }

  Future<void> _handleReport(String reason) async {
    try {
      final req = ReportUserReq(
        reason: reason,
        reportType: 'HOMEPAGE',
        toUid: widget.userId,
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

  Future<void> _handleLike() async {
    if (_isUpdatingLike) {
      return;
    }
    final targetUid = (widget.userId).toString();
    final previousIsLiked = _isLiked;
    final previousCount = _likeCount;

    setState(() {
      _isLiked = !previousIsLiked;
      _likeCount = max(0, previousCount + (_isLiked ? 1 : -1));
      _isUpdatingLike = true;
    });

    try {
      if (!previousIsLiked) {
        await AttentionApi.addAttention(targetUid);
      } else {
        await AttentionApi.delAttention(targetUid);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLiked = previousIsLiked;
        _likeCount = previousCount;
      });
      print('Failed to update like status: $e');
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isUpdatingLike = false;
      });
    }
  }

  Future<WxAccountData?> _fetchWxAccount({bool force = false}) async {
    if (!mounted) {
      return _wxAccountData;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? meId = userProvider.currentUser?.id;
    final int? meSex =
        userProvider.userMeInfo?.sex ?? userProvider.currentUser?.sex;

    if (meId != null && meId == widget.userId) {
      return _wxAccountData;
    }
    if (meSex != 1) {
      return _wxAccountData;
    }
    if (_isLoadingWxAccount) {
      return _wxAccountData;
    }
    if (!force && _wxAccountData != null) {
      return _wxAccountData;
    }

    setState(() {
      _isLoadingWxAccount = true;
    });

    WxAccountData? fetched;
    try {
      final resp = await ChatApi.getWxAccount(
        GetWxAccountReq(toUid: widget.userId),
      );
      if (resp.code == 0) {
        fetched = resp.data;
      } else {
        debugPrint('Failed to fetch wx account: ${resp.message}');
      }
    } catch (e) {
      debugPrint('Failed to fetch wx account: $e');
    }

    if (!mounted) {
      return fetched ?? _wxAccountData;
    }

    setState(() {
      _isLoadingWxAccount = false;
      if (fetched != null) {
        _wxAccountData = fetched;
      }
    });

    return _wxAccountData;
  }

  Future<void> _handleWxUnlock() async {
    if (_isUnlockingWx) {
      return;
    }
    setState(() {
      _isUnlockingWx = true;
    });

    try {
      final resp = await ChatApi.checkUnlock(
        CheckUnlockReq(scene: 'SPACE_GET_WX', toUid: widget.userId),
      );
      if (resp.code != 0 || resp.data == null) {
        _showSnack(resp.message ?? '获取解锁信息失败');
        return;
      }

      final data = resp.data!;
      if (data.unlockCode == 0) {
        await _fetchWxAccount(force: true);
        await _copyWxAccount(_wxAccountData?.wxAccount);
        return;
      }
      if (!mounted) {
        return;
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final int currentSex =
          userProvider.userMeInfo?.sex ?? userProvider.currentUser?.sex ?? 0;

      await ChatUnlockDialog.show(
        context,
        avatarUrl: _userInfo?.avatar,
        userSex: _userInfo?.sex ?? 0,
        currentUserSex: currentSex,
        unlockCode: data.unlockCode,
        unlockType: 'SPACE_GET_WX',
        toUid: widget.userId,
        unlockData: data,
        onUnlockUpdated: () async {
          await _fetchWxAccount(force: true);
        },
        onNavigateToWallet: () {
          if (!mounted) {
            return;
          }
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const WalletScreen()));
        },
        onNavigateToGetVip: () {
          if (!mounted) {
            return;
          }
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const GetVipScreen()));
        },
      );
    } catch (e) {
      _showSnack('获取解锁信息失败');
      debugPrint('Failed to check unlock: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUnlockingWx = false;
        });
      }
    }
  }

  Future<void> _copyWxAccount(String? account) async {
    if (account == null || account.isEmpty) {
      _showSnack('暂无可复制的联系方式');
      return;
    }
    await Clipboard.setData(ClipboardData(text: account));
    _showSnack('复制成功');
  }

  void _openChatScreen() {
    final targetId = widget.userId.toString();
    final displayName = _userInfo?.userName ?? '未知用户';
    final avatar = _userInfo?.avatar;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImScreen(
          userId: targetId,
          displayName: displayName,
          avatarUrl: avatar,
        ),
      ),
    );
  }

  Future<void> _handleChatUnlock() async {
    // Similar logic to _handleWxUnlock, but for chat
    try {
      final resp = await ChatApi.checkUnlock(
        CheckUnlockReq(scene: 'SPACE_GO_CHAT', toUid: widget.userId),
      );
      if (resp.code != 0 || resp.data == null) {
        _showSnack(resp.message ?? '获取解锁信息失败');
        return;
      }
      final data = resp.data!;
      if (data.unlockCode == 0) {
        _openChatScreen();
        return;
      }
      if (!mounted) return;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final int currentSex =
          userProvider.userMeInfo?.sex ?? userProvider.currentUser?.sex ?? 0;

      await ChatUnlockDialog.show(
        context,
        avatarUrl: _userInfo?.avatar,
        userSex: _userInfo?.sex ?? 0,
        currentUserSex: currentSex,
        unlockCode: data.unlockCode,
        unlockType: 'SPACE_GO_CHAT',
        toUid: widget.userId,
        unlockData: data,
        onUnlockUpdated: () {
          _openChatScreen();
        },
        onNavigateToWallet: () {
          if (!mounted) return;
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const WalletScreen()));
        },
        onNavigateToGetVip: () {
          if (!mounted) {
            return;
          }
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const GetVipScreen()));
        },
      );
    } catch (e) {
      _showSnack('操作失败');
      debugPrint('Failed to check chat unlock: $e');
    }
  }

  Future<void> _handleEvaluate() async {
    final labelsString = _userInfo?.defaultImpLabels;
    final commentOptions = (labelsString == null || labelsString.isEmpty)
        ? <String>[]
        : labelsString.split(',').where((s) => s.isNotEmpty).toList();

    if (commentOptions.isEmpty) {
      _showSnack('暂无点评标签');
      return;
    }
    final selectedComment = await PickerUtils.showCommentDialog(
      context,
      null,
      commentOptions,
    );

    if (selectedComment != null) {
      try {
        final req = AddLabelsReq(labels: selectedComment, toUid: widget.userId);
        final resp = await UserApi.addLabels(req);
        if (resp.code == 0) {
          _showSnack('点评成功');
          // Optionally, refresh user info to show the new label
          _fetchUserInfo();
        } else {
          _showSnack(resp.message ?? '点评失败');
        }
      } catch (e) {
        _showSnack('点评失败: $e');
      }
    }
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  Widget _buildInfoTag(String text) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 5.r),
      margin: EdgeInsets.only(right: 10.r),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.secondaryGradientEnd,
          fontSize: 25.sp,
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String iconPath,
    String title,
    Widget content, {
    double verticalPadding = 12,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 31.25.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(iconPath, width: 31.25.w, height: 31.25.h),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 27.sp,
                    color: AppColors.goldGradientEnd,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(child: content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoadingUser) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('加载失败: $_error'));
    }
    if (_userInfo == null) {
      return const Center(child: Text('用户不存在'));
    }

    return Stack(
      children: [
        // Scrollable Content
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 140.h), // Space for bottom bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderImage(),
              _buildTopInfo(),
              // 个人相册
              _buildMediaSection(),
              // 社交账号
              _buildWxAccountSection(),
              // 收到的印象
              _buildImpressionLabelsSection(),
              // 关于TA / 动态
              _buildMainContentSection(),
            ],
          ),
        ),
        // 顶部导航栏
        _buildFixedNav(),
        // 底部功能按钮
        _buildBottomActionBar(),
      ],
    );
  }

  Widget _buildHeaderImage() {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (_userInfo?.avatar != null && _userInfo!.avatar!.isNotEmpty) {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PhotoViewerScreen(imageUrls: [_userInfo!.avatar!]),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          );
        }
      },
      child: Image.network(
        _userInfo!.avatar ?? '',
        width: screenWidth,
        height: screenWidth,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFixedNav() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset(
                  'assets/images/common_back_white.png',
                  width: 48.w,
                  height: 48.h,
                ),
              ),
              GestureDetector(
                onTap: _showReportSheet,
                child: Image.asset(
                  'assets/images/common_more_white.png',
                  width: 48.w,
                  height: 48.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bool isMe = userProvider.currentUser?.id == widget.userId;

    if (isMe) {
      return _buildMyActionBar();
    } else {
      return _buildOtherUserActionBar(userProvider);
    }
  }

  Widget _buildMyActionBar() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 675.w,
          child: StyledButton(
            onPressed: () {
              // TODO: Navigate to edit profile page
            },
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(23.r),
            height: 83.33.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/profile/siliao.png',
                  width: 41.67.w,
                  height: 41.67.h,
                ),
                SizedBox(width: 8.w),
                const Text('编辑资料'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherUserActionBar(UserProvider userProvider) {
    final meSex = userProvider.userMeInfo?.sex ?? userProvider.currentUser?.sex;
    final userSex = _userInfo?.sex;
    final bool showSocialButton =
        meSex != userSex &&
        _wxAccountData?.wxAccount != null &&
        _wxAccountData!.wxAccount!.isNotEmpty;
    final bool showChatButton = meSex != userSex;
    final bool showEvaluateButton = _userInfo?.checkAllowEvaluate == 1;
    final accountType = _wxAccountData?.accountType ?? 'WX';

    Widget socialButton = StyledButton(
      onPressed: _handleWxUnlock,
      gradient: accountType == 'WX'
          ? const LinearGradient(colors: [Color(0xFF41A751), Color(0xFF0A861E)])
          : const LinearGradient(
              colors: [Color(0xFF0075FF), Color(0xFF419EF4)],
            ),
      borderRadius: BorderRadius.circular(23.r),
      height: 83.33.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            accountType == 'WX'
                ? 'assets/images/profile/wx.png'
                : 'assets/images/profile/qq_1.png',
            width: 41.67.w,
            height: 41.67.h,
          ),
          SizedBox(width: 8.w),
          Text('她的${accountType == 'WX' ? '微信' : 'QQ'}'),
        ],
      ),
    );

    Widget buildChatButton({EdgeInsetsGeometry? padding}) {
      return StyledButton(
        onPressed: _handleChatUnlock,
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(23.r),
        height: 83.33.h,
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/profile/siliao.png',
              width: 41.67.w,
              height: 41.67.h,
            ),
            SizedBox(width: 8.w),
            const Text('私聊'),
          ],
        ),
      );
    }

    Widget evaluateButton = StyledButton(
      onPressed: _handleEvaluate,
      backgroundColor: const Color(0xFF3A3A3A),
      borderRadius: BorderRadius.circular(23.r),
      height: 83.33.h,
      child: const Text('点评', style: TextStyle(color: Colors.white)),
    );

    List<Widget> buttons = [];
    if (showSocialButton && showChatButton && showEvaluateButton) {
      buttons = [
        Expanded(flex: 2, child: socialButton),
        SizedBox(width: 10.w),
        Expanded(
          flex: 1,
          child: buildChatButton(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 1.w),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(flex: 1, child: evaluateButton),
      ];
    } else if (showSocialButton && showChatButton) {
      buttons = [
        Expanded(flex: 1, child: socialButton),
        SizedBox(width: 20.w),
        Expanded(flex: 1, child: buildChatButton()),
      ];
    } else if (showChatButton) {
      buttons = [
        const Spacer(),
        Expanded(flex: 2, child: buildChatButton()),
        const Spacer(),
      ];
    }

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 675.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons,
          ),
        ),
      ),
    );
  }

  Widget _buildTopInfo() {
    final user = _userInfo!;
    final distanceKm = user.distance != null
        ? (user.distance! / 1000).toStringAsFixed(2)
        : null;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.userName ?? 'Unknown',
                    style: textStylePrimaryBold.copyWith(fontSize: 32.sp),
                  ),
                  if (user.realType == 1)
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Image.asset(
                        'assets/images/user_tag_real.png',
                        height: 30.h,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 0,
                runSpacing: 10.h,
                children: [
                  if (user.age != null) _buildInfoTag('${user.age}岁'),
                  if ((user.locationCity ?? '').isNotEmpty)
                    _buildInfoTag(user.locationCity!),
                  if (distanceKm != null) _buildInfoTag('$distanceKm km'),
                ],
              ),
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isUpdatingLike ? null : _handleLike,
            child: Column(
              children: [
                Image.asset(
                  _isLiked
                      ? 'assets/images/like.png' // Placeholder
                      : 'assets/images/like_empty.png', // Placeholder
                  width: 35.r,
                  height: 29.r,
                ),
                SizedBox(height: 4.h),
                Text('$_likeCount人喜欢', style: textStyleSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection() {
    final albumsCount = _userInfo?.albumsList?.length ?? 0;
    // final videosCount = _userInfo?.videoList?.length ?? 0;

    return Column(
      children: [
        TabBar(
          controller: _mediaTabController,
          tabs: [
            Tab(text: '个人相册${albumsCount > 0 ? '($albumsCount)' : ''}'),
            // Tab(text: '视频${videosCount > 0 ? '($videosCount)' : ''}'),
          ],
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelStyle: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 26.sp),
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
        ),
        SizedBox(height: 8.h),
        // 有视频的时候。
        // SizedBox(
        //   height: 180.h, // Adjust height as needed
        //   child: _mediaTabController.index == 0
        //       ? _buildHorizontalList(
        //           _userInfo?.albumsList?.map((e) => e).toList(),
        //           MediaType.album,
        //         )
        // : _isLoadingVideos
        // ? const Center(child: CircularProgressIndicator())
        // : _buildHorizontalList(_videos, MediaType.video),
        // ),
        // 没有视频的时候。
        SizedBox(
          height: 180.h, // Adjust height as needed
          child: _isLoadingPosts
              ? const Center(child: CircularProgressIndicator())
              : _buildHorizontalList(
                  _userInfo?.albumsList?.map((e) => e).toList(),
                  MediaType.album,
                ),
        ),
      ],
    );
  }

  Widget _buildWxAccountSection() {
    if (_isLoadingWxAccount && _wxAccountData == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final data = _wxAccountData;
    if (data == null ||
        (data.unlockStatus ?? 0) == 2 ||
        (data.wxAccount ?? '').isEmpty) {
      return const SizedBox.shrink();
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser?.sex != 1) {
      return const SizedBox.shrink();
    }

    final accountValue = data.wxAccount!;
    final accountType = (data.accountType ?? 'WX').toUpperCase();
    final label = accountType == 'QQ' ? 'QQ号：' : '微信号：';
    final isUnlocked = (data.unlockStatus ?? 0) == 1;

    return Container(
      width: 670.w,
      height: 121.h,
      margin: EdgeInsets.only(top: 51.h, left: 40.w, right: 40.w),
      padding: EdgeInsets.only(left: 20.w, right: 10.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21.r),
        image: const DecorationImage(
          image: AssetImage('assets/images/social_account_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Transform(
                      transform: Matrix4.skewX(-0.26), // ~15 degrees
                      child: Text(
                        'TA的社交账号',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Text(
                        '已通过人工校验微信真实性',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                RichText(
                  text: TextSpan(
                    text: label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 27.sp,
                    ),
                    children: [
                      TextSpan(
                        text: accountValue,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildWxActionButton(isUnlocked),
        ],
      ),
    );
  }

  Widget _buildWxActionButton(bool isUnlocked) {
    final VoidCallback? onTap = _isUnlockingWx
        ? null
        : (isUnlocked
              ? () => _copyWxAccount(_wxAccountData?.wxAccount)
              : _handleWxUnlock);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: _isUnlockingWx ? 0.6 : 1,
        child: Container(
          width: 125.w,
          height: 52.08.h,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(83.r),
          ),
          child: Center(
            child: Text(
              isUnlocked ? '复制' : '点击查看',
              style: TextStyle(
                fontSize: 21.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImpressionLabelsSection() {
    final impLabels = _userInfo?.impLabels?.list;
    if (impLabels == null || impLabels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '收到的印象',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            children: impLabels.map((label) {
              final labelText = '${label.labelsName}(${label.markCount ?? 0})';
              return Container(
                margin: EdgeInsets.only(left: 10.w, top: 20.h, bottom: 10.h),
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  labelText,
                  style: TextStyle(color: Colors.white, fontSize: 25.sp),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<dynamic>? items, MediaType type) {
    if (items == null || items.isEmpty) {
      return const Center(child: StyledText('暂无内容'));
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final String imageUrl = type == MediaType.album
            ? item.albumsUrl
            : item.coverUrl;
        final int? similarity = type == MediaType.album
            ? item.similarity
            : null;

        return Padding(
          padding: EdgeInsets.all(8.w),
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: () {
                if (type == MediaType.album) {
                  final imageUrls =
                      _userInfo?.albumsList
                          ?.map((e) => e.albumsUrl)
                          .whereType<String>()
                          .toList() ??
                      [];
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          PhotoViewerScreen(
                            imageUrls: imageUrls,
                            initialIndex: index,
                          ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                    ),
                  );
                }
                if (type == MediaType.video) {
                  final videoUrl = (item as VideoInfo).videoUrl;
                  if (videoUrl != null && videoUrl.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerScreen(videoUrl: videoUrl),
                      ),
                    );
                  }
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(imageUrl, fit: BoxFit.cover),
                    if (type == MediaType.video)
                      Center(
                        child: Image.asset(
                          'assets/images/video_play.png',
                          width: 62.5.w,
                          height: 62.5.h,
                        ),
                      ),
                    if (type == MediaType.album &&
                        similarity != null &&
                        similarity != 0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          height: 37.5.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFAE3CD),
                                Color(0xFFF7D9BD),
                                Color(0xFFE6BC97),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '相似度 $similarity%',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContentSection() {
    return Column(
      children: [
        TabBar(
          controller: _mainTabController,
          tabs: const [
            Tab(text: '关于TA'),
            Tab(text: '动态'),
          ],
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelStyle: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 32.sp),
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
        ),
        // Use a Column instead of TabBarView to avoid nested scrolling issues
        _mainTabController.index == 0
            ? _buildDetailedInfoSection()
            : _buildPostsList(),
      ],
    );
  }

  Widget _buildPostsList() {
    return ListView.builder(
      padding: EdgeInsets.zero, // <- removes the extra gap
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return PostCard(
          post: post,
          onPostDeleted: (postId) {
            setState(() {
              _posts.removeWhere((p) => p.id == postId);
            });
          },
        );
      },
    );
  }

  Widget _buildDetailedInfoSection() {
    final user = _userInfo!;
    final List<String> characterLabels = user.characterLabel?.split(',') ?? [];
    final List<String> interestLabels = user.interestLabel?.split(',') ?? [];

    final Map<String, String> iconMap = {
      'ID:': 'assets/images/profile/id.png',
      '身高:': 'assets/images/profile/height.png',
      '体重:': 'assets/images/profile/weight.png',
      '身材:': 'assets/images/profile/figure.png',
      '职业:': 'assets/images/profile/occupation.png',
      '所在地:': 'assets/images/profile/location.png',
      '活跃城市:': 'assets/images/profile/city.png',
      '标签:': 'assets/images/profile/label.png',
      '兴趣爱好:': 'assets/images/profile/hobby.png',
    };

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('个人介绍', style: textStylePrimaryBold.copyWith(fontSize: 32.sp)),
          SizedBox(height: 8.h),
          Text(
            user.signature ?? (user.sex == 0 ? '她很懒，什么都没留下~' : '他很懒，什么都没留下~'),
            style: textStyleSecondary,
          ),
          SizedBox(height: 24.h),
          Text('个人信息', style: textStylePrimaryBold.copyWith(fontSize: 32.sp)),
          SizedBox(height: 12.h),
          _buildInfoRow(iconMap['ID:']!, 'ID:', user.userNumber ?? ''),
          _buildInfoRow(
            iconMap['身高:']!,
            '身高:',
            user.height != null ? '${user.height}cm' : '保密',
          ),
          _buildInfoRow(
            iconMap['体重:']!,
            '体重:',
            user.weight != null ? '${user.weight}kg' : '保密',
          ),
          if (user.figure != null && user.figure!.isNotEmpty)
            _buildInfoRow(iconMap['身材:']!, '身材:', user.figure!),
          _buildInfoRow(iconMap['职业:']!, '职业:', user.occupation ?? '保密'),
          if (user.locationCity != null && user.locationCity!.isNotEmpty)
            _buildInfoRow(iconMap['所在地:']!, '所在地:', user.locationCity!),
          if (user.activeCityList != null && user.activeCityList!.isNotEmpty)
            _buildInfoRow(
              iconMap['活跃城市:']!,
              '活跃城市:',
              user.activeCityList!.map((e) => e.name).join(', '),
            ),
          if (characterLabels.isNotEmpty)
            _buildTagsRow(iconMap['标签:']!, '标签:', characterLabels),
          if (interestLabels.isNotEmpty)
            _buildTagsRow(
              iconMap['兴趣爱好:']!,
              '兴趣爱好:',
              interestLabels,
              useRandomColor: true,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String iconPath, String title, String value) {
    return _buildInfoItem(
      iconPath,
      title,
      SizedBox(
        height: 31.25.h,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 27.sp,
              color: AppColors.textPrimary.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagsRow(
    String iconPath,
    String title,
    List<String> tags, {
    bool useRandomColor = false,
  }) {
    return _buildInfoItem(
      iconPath,
      title,
      Wrap(
        spacing: 20.w,
        runSpacing: 8.h,
        children: tags
            .map(
              (tag) => Text(
                tag,
                style: TextStyle(
                  fontSize: 27.sp,
                  color: useRandomColor
                      ? _getRandomColor()
                      : AppColors.textPrimary.withOpacity(0.7),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
