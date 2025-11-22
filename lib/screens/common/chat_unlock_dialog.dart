import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/api/chat_api.dart';
import 'package:zhenyu_flutter/models/chat_api_model.dart';
import 'package:zhenyu_flutter/screens/common/vip_detail_dialog.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/theme.dart';

class ChatUnlockDialog extends StatefulWidget {
  const ChatUnlockDialog({
    super.key,
    required this.avatarUrl,
    required this.userSex,
    required this.currentUserSex,
    required this.unlockCode,
    required this.unlockType,
    required this.toUid,
    this.unlockData,
    this.onUnlockUpdated,
    this.onNavigateToWallet,
    this.onNavigateToGetVip,
  });

  final String? avatarUrl;
  final int userSex;
  final int currentUserSex;
  final int unlockCode;
  final String unlockType;
  final int toUid;
  final CheckUnlockData? unlockData;
  final VoidCallback? onUnlockUpdated;
  final VoidCallback? onNavigateToWallet;
  final VoidCallback? onNavigateToGetVip;

  static Future<void> show(
    BuildContext context, {
    Key? key,
    required String? avatarUrl,
    required int userSex,
    required int currentUserSex,
    required int unlockCode,
    required String unlockType,
    required int toUid,
    CheckUnlockData? unlockData,
    VoidCallback? onUnlockUpdated,
    VoidCallback? onNavigateToWallet,
    VoidCallback? onNavigateToGetVip,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ChatUnlockDialog(
        key: key,
        avatarUrl: avatarUrl,
        userSex: userSex,
        currentUserSex: currentUserSex,
        unlockCode: unlockCode,
        unlockType: unlockType,
        toUid: toUid,
        unlockData: unlockData,
        onUnlockUpdated: onUnlockUpdated,
        onNavigateToWallet: onNavigateToWallet,
        onNavigateToGetVip: onNavigateToGetVip,
      ),
    );
  }

  @override
  State<ChatUnlockDialog> createState() => _ChatUnlockDialogState();
}

class _ChatUnlockDialogState extends State<ChatUnlockDialog> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              _buildCard(),
              _buildAvatar(),
              if (_isSubmitting)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: 562.5.w,
      margin: EdgeInsets.only(top: 72.r),
      padding: EdgeInsets.only(
        top: 90.h,
        left: 32.w,
        right: 32.w,
        bottom: 32.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._buildBody(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final image = widget.avatarUrl;
    return Positioned(
      top: 0,
      child: Container(
        width: 145.83.r,
        height: 145.83.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.secondaryGradientEnd, width: 2.r),
        ),
        child: ClipOval(
          child: image != null && image.isNotEmpty
              ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
                )
              : _buildAvatarPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: Colors.grey.shade700,
      child: Icon(Icons.person, size: 64.r, color: Colors.white70),
    );
  }

  List<Widget> _buildBody() {
    switch (widget.unlockCode) {
      case 0:
        if (widget.currentUserSex == 1) {
          return _buildUnlockedView();
        }
        return _buildFallbackMessage('暂无可显示的联系方式');
      case 1:
        return _buildVipOrCoinOptions();
      case 2:
        return _buildVipQuotaUsedView();
      case 3:
        return _buildFreeOrVipOptions();
      case 4:
        return _buildVipUnlockConfirmation();
      default:
        return _buildFallbackMessage('暂不支持的解锁方式');
    }
  }

  List<Widget> _buildUnlockedView() {
    final unlockData = widget.unlockData;
    final contactLabel = unlockData?.accountType?.toUpperCase() == 'QQ'
        ? 'QQ'
        : '微信';
    final contactValue = unlockData?.wxAccount ?? '--';
    final remainingLabel = _formatRemaining(
      unlockData?.unlockRemainingSecond ?? 0,
    );

    return [
      Text(
        widget.userSex == 1 ? '解锁私聊' : '解锁联系方式，同时解锁私聊',
        style: TextStyle(fontSize: 30.sp, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 28.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              contactLabel == 'QQ' ? Icons.chat_bubble_outline : Icons.wechat,
              color: AppColors.secondaryGradientStart,
              size: 32.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              contactValue,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryGradientStart,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 18.h),
      Text(
        '解锁${contactLabel}时间还剩余$remainingLabel',
        style: TextStyle(fontSize: 24.sp, color: Colors.white.withOpacity(0.6)),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 28.h),
      _buildPrimaryButton('复制', _copyContact),
    ];
  }

  List<Widget> _buildVipOrCoinOptions() {
    final coinPrice = widget.unlockData?.unlockCoinPrice ?? 0;
    return [
      Text(
        widget.userSex == 1 ? '解锁私聊' : '解锁联系方式，同时解锁私聊',
        style: TextStyle(fontSize: 30.sp, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 28.h),
      _buildPrimaryButton('会员免费', () => _handleUnlock('VIP')),
      SizedBox(height: 20.h),
      _buildPrimaryButton('邀请2人注册，获得3天会员', () => _handleNavToGetVip()),
      SizedBox(height: 20.h),
      _buildOutlineButton('直接联系($coinPrice金币)', () => _handleUnlock('COIN')),
    ];
  }

  List<Widget> _buildFreeOrVipOptions() {
    return [
      Text(
        widget.userSex == 1 ? '解锁私聊' : '解锁联系方式，同时解锁私聊',
        style: TextStyle(fontSize: 30.sp, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 28.h),
      _buildPrimaryButton('使用免费次数', () => _handleUnlock('FREE')),
      SizedBox(height: 20.h),
      _buildOutlineButton('开通VIP', () => _handleUnlock('VIP')),
    ];
  }

  List<Widget> _buildVipQuotaUsedView() {
    final coinPrice = widget.unlockData?.unlockCoinPrice ?? 0;
    return [
      Text(
        '尊敬的VIP，您当日解锁次数已用完',
        style: TextStyle(fontSize: 30.sp, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 28.h),
      _buildPrimaryButton('直接联系($coinPrice金币)', () => _handleUnlock('COIN')),
      SizedBox(height: 24.h),
      GestureDetector(
        onTap: _isSubmitting ? null : () => Navigator.of(context).pop(),
        child: Text(
          '取消',
          style: TextStyle(fontSize: 26.sp, color: Colors.white70),
        ),
      ),
    ];
  }

  List<Widget> _buildVipUnlockConfirmation() {
    return [
      Text(
        widget.currentUserSex == 1 ? '是否确认解锁联系方式，解锁联系方式同时解锁私信' : '是否确认解锁联系方式',
        style: TextStyle(fontSize: 30.sp, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 28.h),
      _buildPrimaryButton('解锁', () => _handleUnlock('VIP')),
      SizedBox(height: 24.h),
      GestureDetector(
        onTap: _isSubmitting ? null : () => Navigator.of(context).pop(),
        child: Text(
          '取消',
          style: TextStyle(fontSize: 26.sp, color: Colors.white70),
        ),
      ),
    ];
  }

  List<Widget> _buildFallbackMessage(String message) {
    return [
      Text(
        message,
        style: TextStyle(fontSize: 28.sp, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Widget _buildPrimaryButton(String label, VoidCallback onTap) {
    return StyledButton(
      onPressed: _isSubmitting ? null : onTap,
      width: 458.33.w,
      height: 72.92.h,
      borderRadius: BorderRadius.circular(83.r),
      gradient: AppGradients.primaryGradient,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 27.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String label, VoidCallback onTap) {
    final bool enabled = !_isSubmitting;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(83.r),
      child: Container(
        width: 458.33.w,
        height: 72.92.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(83.r),
          border: Border.all(color: AppColors.secondaryGradientEnd, width: 2.r),
          color: enabled ? Colors.transparent : Colors.white12,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 27.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryGradientStart.withOpacity(
              enabled ? 1 : 0.5,
            ),
          ),
        ),
      ),
    );
  }

  void _handleNavToGetVip() {
    widget.onNavigateToGetVip?.call();
  }

  Future<void> _handleUnlock(String type) async {
    // 如果是VIP解锁，实时检查用户当前是否是VIP
    if (type == 'VIP') {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final isCurrentlyVip = userProvider.userMeInfo?.vip == 1;

      // 如果当前不是VIP，显示VIP购买对话框
      if (!isCurrentlyVip) {
        await showVipDetailDialog(context);

        // 购买对话框关闭后，刷新用户信息以获取最新的VIP状态
        if (!mounted) return;
        await userProvider.fetchUserMeInfo(); // 刷新用户信息

        // 异步操作后再次检查 mounted
        if (!mounted) return;

        // 重新检查用户是否已成为VIP
        final isNowVip = userProvider.userMeInfo?.vip == 1;

        // 如果用户购买后仍不是VIP（取消了购买），直接返回
        if (!isNowVip) {
          return;
        }

        // 用户已成为VIP，继续执行解锁逻辑
      }
    }

    // 检查 mounted 后再使用 setState 和 context
    if (!mounted) return;

    setState(() {
      _isSubmitting = true;
    });

    final messenger = ScaffoldMessenger.of(context);

    try {
      final resp = await ChatApi.rechargeUnlock(
        RechargeUnlockReq(
          scene: widget.unlockType,
          toUid: widget.toUid,
          type: type,
        ),
      );
      final data = resp.data;
      if (resp.code != 0) {
        if (data?.unlockCode == 1) {
          messenger.showSnackBar(
            SnackBar(content: Text(data!.errorMsg ?? '操作失败')),
          );
          widget.onNavigateToWallet?.call();
          return;
        }
        final message = resp.message?.isNotEmpty == true
            ? resp.message!
            : '操作失败';
        messenger.showSnackBar(SnackBar(content: Text(message)));
        return;
      }
      if (data?.unlockCode == 1) {
        messenger.showSnackBar(
          SnackBar(content: Text(data!.errorMsg ?? '操作失败')),
        );
        widget.onNavigateToWallet?.call();
        return;
      }
      widget.onUnlockUpdated?.call();
      // final successMsg = resp.message?.isNotEmpty == true
      //     ? resp.message!
      //     : '操作成功';
      messenger.showSnackBar(SnackBar(content: Text('解锁成功')));

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('操作失败: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _copyContact() async {
    final account = widget.unlockData?.wxAccount;
    if (account == null || account.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('暂无可复制的联系方式')));
      return;
    }

    await Clipboard.setData(ClipboardData(text: account));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('复制成功')));
  }

  String _formatRemaining(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hours 小时 $minutes 分钟';
  }
}
