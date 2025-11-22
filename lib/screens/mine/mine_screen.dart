import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/api/config_api.dart';
import 'package:zhenyu_flutter/api/real_api.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/common/new_user_discount_dialog.dart';
import 'package:zhenyu_flutter/screens/invate/invate_screen.dart';
import 'package:zhenyu_flutter/shared/styled_dialog.dart';
import 'package:zhenyu_flutter/screens/login/pre_login_screen.dart';
import 'package:zhenyu_flutter/screens/setting/setting_screen.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/screens/common/webview_screen.dart';
import 'package:zhenyu_flutter/screens/common/customer_service_webview.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';
import 'package:zhenyu_flutter/screens/vip/vip_screen.dart';
import 'package:zhenyu_flutter/screens/authentication/auth_center_screen.dart';
import 'package:zhenyu_flutter/screens/post/my_post_screen.dart';
import 'package:zhenyu_flutter/screens/wallet/diamond_screen.dart';
import 'package:zhenyu_flutter/screens/wallet/wallet_screen.dart';
import 'package:zhenyu_flutter/screens/user/user_info_screen.dart';
import 'package:zhenyu_flutter/screens/mine/like_me_screen.dart';
import 'package:zhenyu_flutter/screens/mine/look_me_screen.dart';
import 'package:zhenyu_flutter/screens/mine/wechat_service_dialog.dart';
import 'package:zhenyu_flutter/services/im_manager.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  bool _showDebugInfo = false;
  bool _loadingContact = false;
  bool _savingContact = false;
  String _contactType = 'WX';
  final TextEditingController _wxController = TextEditingController();
  final TextEditingController _qqController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The user info is now managed by UserProvider,
    // so we just need to listen for its changes.
    // We also trigger a refresh in case the data is stale.
    Provider.of<UserProvider>(context, listen: false).fetchUserMeInfo();
    ImManager.instance.addListener(_onImStatusChanged);
  }

  @override
  void dispose() {
    ImManager.instance.removeListener(_onImStatusChanged);
    _wxController.dispose();
    _qqController.dispose();
    super.dispose();
  }

  void _onImStatusChanged() {
    if (mounted) {
      setState(() {
        // Just rebuild the widget to reflect the new IM status.
      });
    }
  }

  Future<void> _handleCustomerService() async {
    try {
      debugPrint('[CustomerService] Fetching customer service URL...');

      // 获取客服URL
      final response = await ConfigApi.getCustomerService();
      debugPrint('[CustomerService] Response code: ${response.code}');

      if (response.code == 0 && response.data?.weChatWorkKfUrl != null) {
        final url = response.data!.weChatWorkKfUrl!;

        if (url.isEmpty) {
          if (mounted) {
            showMsg(context, '客服链接暂未配置');
          }
          return;
        }

        debugPrint('[CustomerService] Opening WebView with URL: $url');

        // 使用自定义的CustomerServiceWebView
        // 这个WebView会在app内打开，并自动处理跳转到微信（无确认对话框）
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerServiceWebView(url: url),
            ),
          );
        }
      } else {
        if (mounted) {
          showMsg(context, response.message ?? '获取客服信息失败');
        }
      }
    } catch (e) {
      debugPrint('[CustomerService] Error: $e');
      if (mounted) {
        showMsg(context, '获取客服信息失败，请稍后重试');
      }
    }
  }

  Future<void> _showBindInviteDialog() async {
    if (!mounted) return;

    final inviteCodeController = TextEditingController();

    await StyledDialog.show(
      context: context,
      barrierDismissible: true,
      title: Center(
        child: StyledText.primaryBold(
          '补绑邀请码',
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      showCancelButton: false,
      confirmText: '确定',
      dismissOnConfirm: false,
      content: TextField(
        controller: inviteCodeController,
        maxLength: 10,
        decoration: InputDecoration(
          hintText: '请输入邀请码~',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.goldGradientStart),
          ),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onConfirm: (dialogContext) async {
        final inviteCode = inviteCodeController.text.trim();

        if (inviteCode.isEmpty) {
          if (!dialogContext.mounted) return;
          showMsg(dialogContext, '请输入邀请码~');
          return;
        }

        try {
          final response = await UserApi.bindInvite(
            BindInviteReq(inviteCode: inviteCode),
          );

          if (!dialogContext.mounted) return;

          if (response.code == 0) {
            showMsg(dialogContext, '绑定成功~');
            // 刷新用户信息
            if (mounted) {
              await Provider.of<UserProvider>(
                context,
                listen: false,
              ).fetchUserMeInfo();
            }
            // 关闭对话框
            if (dialogContext.mounted && Navigator.of(dialogContext).canPop()) {
              Navigator.of(dialogContext).pop();
            }
          } else {
            showMsg(dialogContext, response.message ?? '绑定失败');
          }
        } catch (e) {
          if (!dialogContext.mounted) return;
          showMsg(dialogContext, '绑定失败，请稍后重试');
        }
      },
    );

    inviteCodeController.dispose();
  }

  Future<void> _logout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      // 先登出 IM
      await ImManager.instance.logout();
      // 再登出 App
      await UserApi.loginOut({});
    } catch (e) {
      // Ignore errors during logout
    } finally {
      // 清理本地状态并跳转
      await userProvider.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PreLoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> _showContactDialog() async {
    if (_loadingContact) return;
    setState(() => _loadingContact = true);
    try {
      final accountResp = await UserApi.getSocialAccount();
      if (accountResp.code == 0 && accountResp.data != null) {
        final data = accountResp.data!;
        final type = (data.accountType ?? 'WX').toUpperCase();
        final value = data.wxAccount ?? '';
        _contactType = type == 'QQ' ? 'QQ' : 'WX';
        if (_contactType == 'WX') {
          _wxController.text = value;
          _qqController.clear();
        } else {
          _qqController.text = value;
          _wxController.clear();
        }
      } else if (accountResp.message != null &&
          accountResp.message!.isNotEmpty) {
        showMsg(context, accountResp.message!);
      }

      final realResp = await RealApi.getRealStatus();
      if (!mounted) return;
      final status = realResp.data?.realNameStatus ?? 0;
      if (status == 1) {
        await _showContactEditDialog();
      } else {
        await _showAuthReminderDialog();
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '获取联系方式失败，请稍后重试');
      }
    } finally {
      if (mounted) {
        setState(() => _loadingContact = false);
      }
    }
  }

  Future<void> _showContactEditDialog() async {
    if (!mounted) return;
    String selectedType = _contactType;
    final wxController = _wxController;
    final qqController = _qqController;
    final FocusNode wxFocus = FocusNode();
    final FocusNode qqFocus = FocusNode();

    await StyledDialog.show(
      context: context,
      title: Center(
        child: StyledText.primaryBold(
          '我的联系方式',
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      showCancelButton: false,
      confirmText: '确定修改',
      dismissOnConfirm: false,
      content: StatefulBuilder(
        builder: (dialogContext, setStateSB) {
          Widget buildOption({
            required String type,
            required String asset,
            required TextEditingController controller,
            required String placeholder,
            required int maxLength,
            TextInputType keyboardType = TextInputType.text,
            FocusNode? focusNode,
          }) {
            final bool isSelected = selectedType == type;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (selectedType != type) {
                  setStateSB(() {
                    selectedType = type;
                  });
                  if (focusNode != null) {
                    Future.microtask(() => focusNode.requestFocus());
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 6.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.goldGradientStart
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? AppColors.goldGradientStart
                          : Colors.white,
                    ),
                    SizedBox(width: 10.w),
                    Image.asset(asset, width: 36.w, height: 36.w),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        enabled: isSelected && !_savingContact,
                        keyboardType: keyboardType,
                        maxLength: maxLength,
                        inputFormatters: type == 'QQ'
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null,
                        decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          border: InputBorder.none,
                          hintText: placeholder,
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildOption(
                type: 'WX',
                asset: 'assets/images/WXICON.png',
                controller: wxController,
                placeholder: '请输入微信号~',
                maxLength: 20,
                focusNode: wxFocus,
              ),
              buildOption(
                type: 'QQ',
                asset: 'assets/images/QQ.png',
                controller: qqController,
                placeholder: '请输入QQ号~',
                maxLength: 10,
                keyboardType: TextInputType.number,
                focusNode: qqFocus,
              ),
            ],
          );
        },
      ),
      onConfirm: (dialogContext) async {
        final value = selectedType == 'WX'
            ? wxController.text.trim()
            : qqController.text.trim();
        if (value.isEmpty) {
          showMsg(dialogContext, selectedType == 'WX' ? '请输入微信号~' : '请输入QQ号~');
          return;
        }
        final success = await _saveContact(selectedType, value);
        if (success && mounted) {
          Navigator.of(dialogContext).pop();
        }
      },
    );

    wxFocus.dispose();
    qqFocus.dispose();
  }

  Future<void> _showAuthReminderDialog() async {
    if (!mounted) return;
    await StyledDialog.show(
      context: context,
      title: Center(
        child: StyledText.primaryBold(
          '我的微信/QQ',
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      confirmText: '去认证',
      cancelText: '稍后再去',
      dismissOnConfirm: false,
      onConfirm: (dialogContext) {
        Navigator.of(dialogContext).pop();
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AuthCenterScreen()));
      },
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '完成真人认证，即可添加微信或QQ号',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 12.h),
          Text(
            '请先完成认证后再来完善联系方式',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _saveContact(String type, String value) async {
    if (_savingContact) return false;
    final trimmed = value.trim();
    if (type == 'WX') {
      if (trimmed.length < 6 || trimmed.length > 20) {
        showMsg(context, '微信长度6~20位');
        return false;
      }
    } else {
      if (trimmed.length < 5 || trimmed.length > 10) {
        showMsg(context, 'QQ长度5~10位');
        return false;
      }
    }

    setState(() => _savingContact = true);
    try {
      final response = await UserApi.updateUserProfile(
        UpdateUserProfileReq(
          updateDateType: 'WX_ACCOUNT',
          accountType: type,
          wxAccount: trimmed,
        ),
      );
      final data = response.data;
      final success =
          data is Map<String, dynamic> && (data['code'] as int? ?? -1) == 0;
      final message = data is Map<String, dynamic>
          ? data['message'] as String?
          : null;
      showMsg(context, message ?? (success ? '修改成功' : '修改失败'));
      if (success && mounted) {
        setState(() {
          _contactType = type;
          if (type == 'WX') {
            _wxController.text = trimmed;
            _qqController.clear();
          } else {
            _qqController.text = trimmed;
            _wxController.clear();
          }
        });
        await Provider.of<UserProvider>(
          context,
          listen: false,
        ).fetchUserMeInfo();
      }
      return success;
    } catch (_) {
      if (mounted) {
        showMsg(context, '保存失败，请稍后重试');
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _savingContact = false);
      }
    }
  }

  void _handleBannerTap(BannerInfo banner) {
    if (banner.redirectUrl == null || banner.redirectUrl!.isEmpty) {
      return;
    }

    final redirectUrl = banner.redirectUrl!;

    // 尝试解析为 JSON 对象
    try {
      final platformUrls = jsonDecode(redirectUrl);

      if (platformUrls is Map<String, dynamic>) {
        // 根据当前平台选择对应的 URL
        String? targetUrl;

        if (Platform.isIOS && platformUrls.containsKey('ios')) {
          targetUrl = platformUrls['ios'];
        } else if (Platform.isAndroid && platformUrls.containsKey('android')) {
          targetUrl = platformUrls['android'];
        } else if (platformUrls.containsKey('h5')) {
          targetUrl = platformUrls['h5'];
        }

        if (targetUrl != null && targetUrl.isNotEmpty) {
          debugPrint('=====> 解析后的目标URL: $targetUrl');

          if (targetUrl.startsWith('http')) {
            // 外部链接，使用 WebView
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WebViewScreen(
                  url: targetUrl ?? '',
                  title: banner.title ?? '',
                ),
              ),
            );
          } else {
            // 内部路由
            Navigator.of(context).pushNamed(targetUrl);
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('无法解析 Banner redirectUrl 为 JSON: $e');
    }

    // 如果 JSON 解析失败，当作普通 URL 处理
    if (redirectUrl.startsWith('http')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              WebViewScreen(url: redirectUrl, title: banner.title ?? ''),
        ),
      );
    } else {
      // 假定是内部命名路由
      Navigator.of(context).pushNamed(redirectUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes in UserProvider
    final userProvider = context.watch<UserProvider>();
    final userInfo = userProvider.currentUser;
    final userMeInfo = userProvider.userMeInfo;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('我的'),
            // debug
            // actions: [
            //   Switch(
            //     value: _showDebugInfo,
            //     onChanged: (value) {
            //       setState(() {
            //         _showDebugInfo = value;
            //       });
            //     },
            //   ),
            // ],
          ),
          body: userMeInfo == null
              ? const Center(child: CircularProgressIndicator())
              // debug
              // : _showDebugInfo
              // ? _DebugInfoView(userInfo: userInfo, userMeInfo: userMeInfo)
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 37.5.w),
                  child: Column(
                    children: [
                      _buildTopBox(userMeInfo),
                      SizedBox(height: 20.h),
                      _buildLikeBox(userMeInfo),
                      SizedBox(height: 20.h),
                      _buildVipBox(),
                      SizedBox(height: 0.h),
                      _buildMoneyBox(userMeInfo),
                      SizedBox(height: 20.h),
                      _buildBanner(userMeInfo),
                      SizedBox(height: 60.h),
                      _buildFooterBox(userMeInfo),
                      // SizedBox(height: 40.h),
                      // StyledButton(
                      //   onPressed: _logout,
                      //   gradient: AppGradients.secondaryGradient,
                      //   child: const Text('退出登录'),
                      // ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
        ),
        NewUserDiscountWidget(),
      ],
    );
  }

  Widget _buildTopBox(UserInfoMeData userMeInfo) {
    return GestureDetector(
      onTap: () {
        // Navigate to edit profile page
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 55.r,
              backgroundImage: userMeInfo.avatar != null
                  ? NetworkImage(userMeInfo.avatar!)
                  : null,
              child: userMeInfo.avatar == null
                  ? const Icon(Icons.camera_alt, size: 55)
                  : null,
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledText(
                    userMeInfo.userName ?? '',
                    fontSize: 31.sp,
                    style: userMeInfo.vip == 1
                        ? const TextStyle(color: Colors.red)
                        : textStylePrimary,
                  ),
                  StyledText.secondary(
                    userMeInfo.city ?? '',
                    fontSize: 21.sp,
                    color: AppColors.textPrimary,
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: userMeInfo.userNumber ?? ''),
                      );
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('ID已复制')));
                    },
                    child: StyledText(
                      'ID:${userMeInfo.userNumber ?? ''}',
                      fontSize: 21.sp,
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UserInfoScreen()),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  const StyledText.secondary('编辑资料', fontSize: 15),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 25.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeBox(UserInfoMeData userMeInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLikeItem(
          '我喜欢',
          userMeInfo.likeVo?.meLikeCount?.toString() ?? '0',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LikeMeScreen(type: 'ATTENTION'),
              ),
            );
          },
        ),
        _buildLikeItem(
          '喜欢我',
          userMeInfo.likeVo?.likeMeCount?.toString() ?? '0',
          unreadCount: userMeInfo.likeVo?.likeMeUnreadCount ?? 0,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LikeMeScreen(type: 'FANS'),
              ),
            );
          },
        ),
        _buildLikeItem(
          '看过我',
          userMeInfo.likeVo?.lookMeCount?.toString() ?? '0',
          unreadCount: userMeInfo.likeVo?.lookMeUnreadCount ?? 0,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LookMeScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLikeItem(
    String text,
    String count, {
    int unreadCount = 0,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              StyledText(count, fontSize: 38.sp),
              if (unreadCount > 0)
                Positioned(
                  top: 0,
                  right: -20.w,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 30.r,
                      minHeight: 30.r,
                    ),
                    child: Center(
                      child: StyledText(
                        unreadCount.toString(),
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          StyledText.secondary(text, fontSize: 23.sp),
        ],
      ),
    );
  }

  Widget _buildVipBox() {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const VipScreen()));
      },
      child: Container(
        width: 675.w,
        height: 135.42.h,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/mine/member_center_bg.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 35.h,
              left: 100.w,
              child: const StyledText.primaryBold(
                '会员中心',
                fontSize: 15,
                color: AppColors.primaryColor,
              ),
            ),
            Positioned(
              top: 70.h,
              left: 30.w,
              child: const StyledText.primaryBold(
                '开通会员尊享专属特权',
                fontSize: 13,
                color: AppColors.primaryColor,
              ),
            ),
            Positioned(
              right: 31.r,
              top: 40.r,
              child: Container(
                width: 125.w,
                height: 52.08.h,
                decoration: BoxDecoration(
                  color: AppColors.textFieldBackground,
                  borderRadius: BorderRadius.circular(83.r),
                ),
                child: const Center(
                  child: StyledText(
                    '5折优惠',
                    fontSize: 12,
                    style: TextStyle(color: AppColors.secondaryGradientStart),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyBox(UserInfoMeData userMeInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMoneyItem(
          '我的钱包',
          userMeInfo.coin?.toString() ?? '0',
          'assets/images/mine/wallet_bg.png',
          icon: 'assets/images/mine/coin.png',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const WalletScreen()),
            );
          },
        ),
        _buildMoneyItem(
          '邀请好礼',
          '尊享专属特权',
          'assets/images/mine/invite_bg.png',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const InvateScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMoneyItem(
    String title,
    String subtitle,
    String backgroundImage, {
    String? icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 330.w,
        height: 125.h,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledText.primaryBold(
              title,
              fontSize: 30.sp,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                if (icon != null) Image.asset(icon, width: 31.w, height: 31.h),
                if (icon != null) SizedBox(width: 10.w),
                StyledText(
                  subtitle,
                  fontSize: 25.sp,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(UserInfoMeData userMeInfo) {
    final bannerList = userMeInfo.adBanner?.bannerList;
    if (bannerList == null || bannerList.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 170.h,
      child: PageView.builder(
        itemCount: bannerList.length,
        itemBuilder: (context, index) {
          final banner = bannerList[index];
          return GestureDetector(
            onTap: () => _handleBannerTap(banner),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                banner.bannerUrl ?? '',
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooterBox(UserInfoMeData userMeInfo) {
    return Column(
      children: [
        // if (userMeInfo.partnerTeam?.status == 1 &&
        //     userMeInfo.partnerTeam?.partnerLevel != null)

        //   _buildFooterItem('我的团队', 'assets/images/mine/team_icon.png'),
        _buildFooterItem(
          '我的收益',
          'assets/images/mine/diamond_icon.png',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const DiamondScreen()),
            );
          },
        ),
        if (userMeInfo.wxMpQrCode != null)
          _buildFooterItem(
            '关注微信服务号',
            'assets/images/mine/fwh.png',
            onTap: () => showWechatServiceDialog(
              context,
              qrCodeUrl: userMeInfo.wxMpQrCode,
            ),
          ),
        _buildFooterItem(
          '我的动态',
          'assets/images/mine/feed_icon.png',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyPostScreen()),
            );
          },
        ),
        _buildFooterItem(
          '认证中心',
          'assets/images/mine/authentication_icon.png',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AuthCenterScreen()),
            );
          },
        ),
        if (userMeInfo.showBindInvite == 1)
          _buildFooterItem(
            '补绑邀请码',
            'assets/images/mine/info_icon.png',
            onTap: _showBindInviteDialog,
          ),
        _buildFooterItem(
          '联系客服',
          'assets/images/mine/connect_icon.png',
          onTap: _handleCustomerService,
        ),
        if (userMeInfo.sex == 0)
          _buildFooterItem(
            '我的微信/QQ',
            'assets/images/mine/wx_icon.png',
            onTap: _showContactDialog,
          ),
        _buildFooterItem(
          '设置',
          'assets/images/mine/setting_icon.png',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFooterItem(String text, String iconPath, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 52.h),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(iconPath, width: 41.w, height: 41.h),
            SizedBox(width: 20.w),
            Expanded(
              child: StyledText(
                text,
                fontSize: 29.sp,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
            Image.asset(
              'assets/images/mine/arrow.png',
              width: 40.w,
              height: 40.h,
            ), // Placeholder
          ],
        ),
      ),
    );
  }
}

class _DebugInfoView extends StatelessWidget {
  final LoginRespData? userInfo;
  final UserInfoMeData? userMeInfo;

  const _DebugInfoView({this.userInfo, this.userMeInfo});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const StyledText.primaryBold('IM Status', fontSize: 18),
        const Divider(),
        _buildUserInfoRow(
          'Is Logged In',
          ImManager.instance.isLoggedIn.toString(),
          valueColor: Colors.red,
        ),
        _buildUserInfoRow(
          'Current User ID',
          ImManager.instance.currentUserId,
          valueColor: Colors.red,
        ),
        const SizedBox(height: 30),
        if (userInfo != null) ...[
          const StyledText.primaryBold('User Info (From Login)', fontSize: 18),
          const Divider(),
          _buildUserInfoRow('Username', userInfo!.userName),
          _buildUserInfoRow('User ID', userInfo!.id?.toString()),
          _buildUserInfoRow('User Number', userInfo!.userNumber),
          _buildUserInfoRow('Mobile', userInfo!.mobile),
          _buildUserInfoRow('Sex', userInfo!.sex?.toString()),
          _buildUserInfoRow(
            'Has Bind Mobile',
            userInfo!.hasBindMobile?.toString(),
          ),
          _buildUserInfoRow('Union ID', userInfo!.unionId),
          _buildUserInfoRow(
            'Business Code',
            userInfo!.businessCode?.toString(),
          ),
          _buildUserInfoRow(
            'Review Status',
            userInfo!.reviewStatus?.toString(),
          ),
          _buildUserInfoRow('Review Type', userInfo!.reviewType?.toString()),
          _buildUserInfoRow('Review Message', userInfo!.reviewMessage),
          _buildUserInfoRow('Review Param', userInfo!.reviewParam),
          _buildUserInfoRow('Extra Param', userInfo!.extraParam),
          _buildUserInfoRow('User Sig', userInfo!.userSig),
          _buildUserInfoRow('User Token', userInfo!.userToken),
        ],
        if (userMeInfo != null) ...[
          const SizedBox(height: 30),
          const StyledText.primaryBold('User Me Info (From /me)', fontSize: 18),
          const Divider(),
          _buildUserInfoRow('Avatar', userMeInfo!.avatar),
          _buildUserInfoRow('Username', userMeInfo!.userName),
          _buildUserInfoRow('User Number', userMeInfo!.userNumber),
          _buildUserInfoRow('Signature', userMeInfo!.signature),
          _buildUserInfoRow('City', userMeInfo!.city),
          _buildUserInfoRow('Sex', userMeInfo!.sex?.toString()),
          _buildUserInfoRow('VIP', userMeInfo!.vip?.toString()),
          _buildUserInfoRow('Real Type', userMeInfo!.realType?.toString()),
          _buildUserInfoRow('Coin', userMeInfo!.coin?.toString()),
          _buildUserInfoRow(
            'Show Bind Invite',
            userMeInfo!.showBindInvite?.toString(),
          ),
          _buildUserInfoRow('Account Type', userMeInfo!.accountType),
          _buildUserInfoRow('WX Account', userMeInfo!.wxAccount),
          const SizedBox(height: 10),
          const StyledText.primaryBold('Likes Info', fontSize: 16),
          _buildUserInfoRow(
            'Like Me',
            userMeInfo!.likeVo?.likeMeCount?.toString(),
          ),
          _buildUserInfoRow(
            'Like Me Unread',
            userMeInfo!.likeVo?.likeMeUnreadCount?.toString(),
          ),
          _buildUserInfoRow(
            'Look Me',
            userMeInfo!.likeVo?.lookMeCount?.toString(),
          ),
          _buildUserInfoRow(
            'Look Me Unread',
            userMeInfo!.likeVo?.lookMeUnreadCount?.toString(),
          ),
          _buildUserInfoRow(
            'Me Like',
            userMeInfo!.likeVo?.meLikeCount?.toString(),
          ),
          const SizedBox(height: 10),
          const StyledText.primaryBold('Partner Info', fontSize: 16),
          _buildUserInfoRow(
            'Partner Level',
            userMeInfo!.partnerTeam?.partnerLevel,
          ),
          _buildUserInfoRow(
            'Partner Status',
            userMeInfo!.partnerTeam?.status?.toString(),
          ),
        ],
      ],
    );
  }

  Widget _buildUserInfoRow(String label, String? value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: StyledText.secondary('$label:', fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StyledText(
              value ?? 'N/A',
              fontSize: 16,
              style: TextStyle(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
