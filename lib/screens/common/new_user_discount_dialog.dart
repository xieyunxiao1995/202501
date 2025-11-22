import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/api/vip_api.dart';
import 'package:zhenyu_flutter/models/vip_api_model.dart';
import 'package:zhenyu_flutter/screens/vip/vip_screen.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/shared/styled_toast.dart';
import 'package:zhenyu_flutter/utils/purchase_manager.dart';

// Floating discount widget for new users
// Can be placed in the bottom-right corner of multiple pages
class NewUserDiscountWidget extends StatefulWidget {
  final double? top;
  final double bottom;
  final double? left;
  final double right;

  NewUserDiscountWidget({
    super.key,
    this.top,
    double? bottom,
    this.left,
    double? right,
  }) : bottom = bottom ?? 30.h, // ✅ 在初始化列表中计算
       right = right ?? 30.w;

  @override
  State<NewUserDiscountWidget> createState() => _NewUserDiscountWidgetState();
}

class _NewUserDiscountWidgetState extends State<NewUserDiscountWidget> {
  VipDiscountPopUpData? _discountData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDiscountData();
  }

  Future<void> _loadDiscountData() async {
    try {
      final resp = await VipApi.getVipDiscountPopUp();
      if (resp.code == 0 && resp.data != null) {
        if (mounted) {
          setState(() {
            _discountData = resp.data;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to load discount data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDiscountDialog() {
    if (_discountData == null) return;

    if (_discountData!.eligibleStatus == 1) {
      showDialog(
        context: context,
        builder: (context) => _VipDiscountDialog(data: _discountData!),
      );
    } else {
      StyledToast.show(context, message: '已购买过或优惠过期...');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading ||
        _discountData == null ||
        _discountData!.eligibleStatus != 1) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: GestureDetector(
        onTap: _showDiscountDialog,
        child: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/hd.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF1B873), Color(0xFFF2DBA8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '优惠',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VipDiscountDialog extends StatefulWidget {
  final VipDiscountPopUpData data;

  const _VipDiscountDialog({required this.data});

  @override
  State<_VipDiscountDialog> createState() => _VipDiscountDialogState();
}

class _VipDiscountDialogState extends State<_VipDiscountDialog> {
  final PurchaseManager _purchaseManager = PurchaseManager();
  Timer? _timer;
  int _remainingSeconds = 0;
  VipPlanInfo? _vipPlan; // VIP plan details with iosId

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.data.countdownTime ?? 0;
    _startCountdown();
    _initializePurchaseManager();
    _fetchVipPlanDetails();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _purchaseManager.dispose();
    super.dispose();
  }

  void _initializePurchaseManager() {
    _purchaseManager.initialize(
      callbacks: PurchaseCallbacks(
        onCanceled: () {
          debugPrint('💳 支付回调: 用户取消支付');
          // Close loading dialog
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          if (mounted) {
            StyledToast.show(context, message: '已取消支付');
          }
        },
        onError: (message) {
          debugPrint('💳 支付回调: 支付失败 - $message');
          // Close loading dialog
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          if (mounted) {
            StyledToast.show(context, message: '支付失败: $message');
          }
        },
        onSuccess: (wasActivelyProcessing) {
          debugPrint('💳 支付回调: 支付成功 - wasActivelyProcessing: $wasActivelyProcessing');
          // Close loading dialog
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          if (mounted) {
            final successMessage = wasActivelyProcessing
                ? '支付成功！'
                : '检测到未完成的订单，已自动恢复会员权益';
            StyledToast.show(context, message: successMessage);

            // Close the discount dialog
            Navigator.of(context).pop();
          }
        },
        onVerificationFailed: (message) {
          debugPrint('💳 支付回调: 验证失败 - $message');
          // Close loading dialog
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          if (mounted) {
            StyledToast.show(context, message: '支付验证失败: $message');
          }
        },
      ),
    );
  }

  Future<void> _fetchVipPlanDetails() async {
    try {
      debugPrint('===== 开始获取VIP套餐详情 =====');
      debugPrint('configId: ${widget.data.configId}');

      final resp = await VipApi.getVipConfig();
      debugPrint('VIP配置响应 code: ${resp.code}');

      if (resp.code == 0 && resp.data?.list != null) {
        debugPrint('套餐列表长度: ${resp.data!.list!.length}');

        // 打印所有套餐的ID
        for (var p in resp.data!.list!) {
          debugPrint('套餐ID: ${p.id}, iosId: ${p.iosId}, 名称: ${p.vipName}');
        }

        // 查找匹配的套餐
        VipPlanInfo? plan;
        try {
          plan = resp.data!.list!.firstWhere(
            (p) => p.id == widget.data.configId,
          );
          debugPrint('找到匹配的套餐: ${plan.id}, iosId: ${plan.iosId}');
        } catch (e) {
          debugPrint('未找到匹配的套餐，使用第一个套餐');
          if (resp.data!.list!.isNotEmpty) {
            plan = resp.data!.list!.first;
            debugPrint('使用第一个套餐: ${plan.id}, iosId: ${plan.iosId}');
          }
        }

        if (mounted && plan != null) {
          setState(() {
            _vipPlan = plan;
          });
          debugPrint('✅ VIP套餐设置成功');
        } else {
          debugPrint('❌ 未找到可用的VIP套餐');
        }
      } else {
        debugPrint('❌ 获取VIP配置失败: ${resp.message}');
      }
    } catch (e) {
      debugPrint('❌ 获取VIP套餐详情失败: $e');
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Map<String, String> _formatCountdown() {
    final days = _remainingSeconds ~/ (3600 * 24);
    final hours = (_remainingSeconds % (3600 * 24)) ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;

    return {
      'days': days.toString().padLeft(2, '0'),
      'hours': hours.toString().padLeft(2, '0'),
      'minutes': minutes.toString().padLeft(2, '0'),
      'seconds': seconds.toString().padLeft(2, '0'),
    };
  }

  void _buyVip() async {
    debugPrint('===== 点击购买按钮 =====');
    debugPrint('_vipPlan: $_vipPlan');
    debugPrint('_vipPlan?.iosId: ${_vipPlan?.iosId}');

    if (_vipPlan == null || _vipPlan!.iosId == null || _vipPlan!.iosId!.isEmpty) {
      debugPrint('❌ 套餐信息不完整');
      StyledToast.show(context, message: '正在加载套餐信息，请稍候...');
      return;
    }

    debugPrint('✅ 套餐信息完整，开始购买流程');

    if (Platform.isIOS) {
      debugPrint('iOS平台，显示loading对话框');
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Get current user ID
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.currentUser?.id?.toString();
      debugPrint('用户ID: $userId');

      // Start iOS purchase
      debugPrint('调用 PurchaseManager.startPurchase');
      debugPrint('productId: ${_vipPlan!.iosId}');
      debugPrint('planId: ${_vipPlan!.id}');

      // Start purchase
      final error = await _purchaseManager.startPurchase(
        productId: _vipPlan!.iosId!,
        planId: _vipPlan!.id!,
        orderTradeType: 'VIP',
        userId: userId,
      );

      debugPrint('startPurchase 返回，error: $error');

      // If there's an error, close loading dialog and show error
      if (error != null && mounted) {
        debugPrint('❌ 购买出错，关闭loading对话框');
        Navigator.of(context).pop();
        StyledToast.show(context, message: error);
      }
      // If no error, wait for callbacks (onSuccess, onCanceled, onError, etc.)
    } else if (Platform.isAndroid) {
      debugPrint('Android平台');
      StyledToast.show(context, message: 'Android 支付功能暂未实现');
    } else {
      debugPrint('不支持的平台');
      StyledToast.show(context, message: '不支持的平台');
    }
  }

  void _viewVipBenefits() {
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const VipScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final countdown = _formatCountdown();
    final pricePerDay = widget.data.price != null
        ? (widget.data.price! / 7).toStringAsFixed(2)
        : '0.00';

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 275,
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF141516),
          borderRadius: BorderRadius.circular(10.5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 35, 20, 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCountdown(countdown),
                  const SizedBox(height: 10),
                  _buildVipCard(pricePerDay),
                  const SizedBox(height: 25),
                  _buildButtons(),
                ],
              ),
            ),
            Positioned(
              top: -15,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/shouyexinren.png',
                  width: 203,
                  height: 31.25,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF1B873), Color(0xFFF2DBA8)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        '新人专享优惠',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdown(Map<String, String> countdown) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeBox(countdown['days']!),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            '天',
            style: TextStyle(color: Color(0xFFF1C88B), fontSize: 12),
          ),
        ),
        _buildTimeBox(countdown['hours']!),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            ':',
            style: TextStyle(color: Color(0xFFF1C88B), fontSize: 12),
          ),
        ),
        _buildTimeBox(countdown['minutes']!),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            ':',
            style: TextStyle(color: Color(0xFFF1C88B), fontSize: 12),
          ),
        ),
        _buildTimeBox(countdown['seconds']!),
      ],
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0xFFF1C88B),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVipCard(String pricePerDay) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1E26),
        borderRadius: BorderRadius.circular(8.5),
        border: Border.all(color: const Color(0xFFF2DBA8), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.data.vipName ?? 'VIP',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            '¥${widget.data.price ?? 0}',
            style: const TextStyle(
              color: Color(0xFFF2DBA8),
              fontSize: 17.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '约$pricePerDay元/天',
            style: const TextStyle(color: Color(0xFFF2DBA8), fontSize: 12.5),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: _buyVip,
          child: Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF1B873), Color(0xFFF2DBA8)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: const Text(
              '购买',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _viewVipBenefits,
          child: Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1E26),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFFFF4E2), width: 0.5),
            ),
            alignment: Alignment.center,
            child: const Text(
              '查看VIP权益',
              style: TextStyle(color: Color(0xFFFFF4E2), fontSize: 12.5),
            ),
          ),
        ),
      ],
    );
  }
}
