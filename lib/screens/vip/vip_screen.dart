import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhenyu_flutter/api/vip_api.dart';
import 'package:zhenyu_flutter/models/vip_api_model.dart';
import 'package:zhenyu_flutter/screens/common/agreement_link.dart';
import 'package:zhenyu_flutter/screens/vip/vip_data.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/purchase_manager.dart';

class VipScreen extends StatefulWidget {
  const VipScreen({super.key});

  @override
  State<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends State<VipScreen> {
  // 购买管理器
  final PurchaseManager _purchaseManager = PurchaseManager();

  bool _isLoading = true;
  VipConfigData? _vipConfigData;
  VipPlanInfo? _selectedPlan; // 当前选中的 VIP 套餐
  int? _userSex; // 用户性别：0 女 1 男

  @override
  void initState() {
    super.initState();

    _loadUserSex(); // 加载用户性别

    // 初始化购买管理器，配置回调
    _purchaseManager.initialize(
      callbacks: PurchaseCallbacks(
        onCanceled: () {
          // 用户取消支付，关闭加载框，显示"已取消支付"
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('已取消支付')));
          }
        },
        onError: (message) {
          // 支付失败，关闭加载框，显示错误信息
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('支付失败: $message')));
          }
        },
        onSuccess: (wasActivelyProcessing) {
          // 支付成功，更新vip信息
          _fetchVipConfig();

          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop(); // 关闭加载对话框
          }

          if (mounted) {
            // 区分主动购买和自动恢复
            final successMessage = wasActivelyProcessing
                ? '支付成功！'
                : '检测到未完成的订单，已自动恢复会员权益';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(successMessage)));
          }
        },
        onVerificationFailed: (message) {
          // 后端验证失败，关闭加载框
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('支付验证失败: $message')));
          }
        },
      ),
    );

    _fetchVipConfig();
  }

  @override
  void dispose() {
    _purchaseManager.dispose(); // 释放购买管理器资源
    super.dispose();
  }

  Future<void> _loadUserSex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('userMeInfo');
      if (raw != null && raw.isNotEmpty) {
        final userInfo = json.decode(raw) as Map<String, dynamic>;
        setState(() {
          _userSex = userInfo['sex'] as int?;
        });
      } else {
        // 数据为空时默认为男生
        setState(() {
          _userSex = 1;
        });
      }
    } catch (e) {
      debugPrint('Failed to load user sex: $e');
      // 读取失败时默认为男生
      setState(() {
        _userSex = 1;
      });
    }
  }

  Future<void> _fetchVipConfig() async {
    try {
      final resp = await VipApi.getVipConfig();
      if (mounted && resp.code == 0 && resp.data != null) {
        setState(() {
          _vipConfigData = resp.data;
          if (_vipConfigData!.list != null &&
              _vipConfigData!.list!.isNotEmpty) {
            _selectedPlan = _vipConfigData!.list!.firstWhere(
              (p) => p.recommend == 1,
              orElse: () => _vipConfigData!.list!.first,
            );
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resp.message ?? 'Failed to load VIP config'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    }
  }

  // 发起支付流程
  Future<void> _handleIosPayment() async {
    if (_selectedPlan == null ||
        _selectedPlan!.iosId == null ||
        _selectedPlan!.iosId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择一个有效的套餐')));
      return;
    }

    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // 获取当前用户 ID
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.currentUser?.id?.toString();

    // 根据套餐的 iosId（如 "com.yourapp.vip.30days"）发起购买
    final error = await _purchaseManager.startPurchase(
      productId: _selectedPlan!.iosId!,
      planId: _selectedPlan!.id!,
      orderTradeType: 'VIP', // VIP 购买类型
      userId: userId, // 当前登录用户的 ID
    );

    // 如果有错误（如平台不支持、App Store 不可用等），关闭加载框并显示错误
    if (error != null && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_vipConfigData == null)
            const Center(
              child: Text('加载失败', style: TextStyle(color: Colors.white)),
            )
          else
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildContent(),
                    SizedBox(height: 150.h),
                  ],
                ),
              ),
            ),
          _buildCustomAppBar(statusBarHeight),
          if (!_isLoading && _vipConfigData != null) _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(double statusBarHeight) {
    return Positioned(
      top: statusBarHeight,
      left: 0,
      right: 0,
      child: Container(
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Text(
              '会员中心',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isVip = _vipConfigData?.vip == 1;
    String vipExpiryDate = '';
    if (isVip && _vipConfigData?.vipInvalidTime != null) {
      try {
        final date = DateTime.parse(_vipConfigData!.vipInvalidTime!);
        vipExpiryDate = DateFormat('yyyy年MM月dd日').format(date);
      } catch (e) {
        vipExpiryDate = '日期格式错误';
      }
    }

    return Container(
      height: 468.75.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/vip/vipbj.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/vip/vipbj2.png',
              height: 281.25.h,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            right: 32.w,
            bottom: 240.h,
            child: Image.asset(
              isVip ? 'assets/images/vip/kt.png' : 'assets/images/vip/wkt.png',
              width: 104.17.w,
              height: 41.67.h,
            ),
          ),
          Positioned(
            bottom: 98.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  isVip ? '尊贵的VIP会员' : '成为VIP会员',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = AppGradients.secondaryGradient.createShader(
                        const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                      ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  isVip ? '您的会员有效期至$vipExpiryDate' : '尊享会员专属特权',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    foreground: Paint()
                      ..shader = AppGradients.secondaryGradient.createShader(
                        const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                      ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 37.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.h),
          _buildVipPlans(),
          SizedBox(height: 62.5.h),
          Text(
            '会员特权',
            style: TextStyle(
              fontSize: 31.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          _buildPrivilegesGrid(),
        ],
      ),
    );
  }

  Widget _buildVipPlans() {
    final plans = _vipConfigData?.list ?? [];
    if (plans.isEmpty) {
      return SizedBox(
        height: 250.h,
        child: const Center(
          child: Text('暂无会员套餐', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return SizedBox(
      height: 250.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - (37.5.w * 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: plans.map((plan) {
              final isSelected = _selectedPlan?.id == plan.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPlan = plan;
                  });
                },
                child: Container(
                  width: 208.33.w,
                  margin: EdgeInsets.only(right: 20.83.w),
                  decoration: BoxDecoration(
                    color: AppColors.containerBlackColor,
                    borderRadius: BorderRadius.circular(17.r),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.secondaryGradientEnd,
                            width: 3.r,
                          )
                        : null,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              '${plan.days}天',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 31.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            width: double.infinity,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '¥',
                                    style: TextStyle(fontSize: 30.sp),
                                  ),
                                  TextSpan(
                                    text: '${plan.price}',
                                    style: TextStyle(fontSize: 41.67.sp),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = AppGradients.secondaryGradient
                                      .createShader(
                                        const Rect.fromLTWH(
                                          0.0,
                                          0.0,
                                          100.0,
                                          50.0,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          if (plan.originalPrice != null &&
                              plan.originalPrice!.isNotEmpty)
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                '原价${plan.originalPrice}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 21.sp,
                                  color: Colors.white.withOpacity(0.4),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              '约${plan.unitPrice}元/天',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 31.h),
                        ],
                      ),
                      if (plan.recommend == 1)
                        Positioned(
                          top: -10.r,
                          left: 0,
                          child: Image.asset(
                            'assets/images/vip/discount.png',
                            width: 145.83.w,
                            height: 41.67.h,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivilegesGrid() {
    // 根据性别过滤权益
    final filteredPrivileges =
        _userSex ==
            0 // 0 表示女生
        ? vipPrivileges.where((privilege) {
            // 女生过滤掉这三个权益
            return privilege.title != '解锁女士' &&
                privilege.title != '优质新人' &&
                privilege.title != '同城女生';
          }).toList()
        : vipPrivileges; // 男生显示所有权益

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 30.w,
        mainAxisSpacing: 0.h,
        childAspectRatio: 150 / 220,
      ),
      itemCount: filteredPrivileges.length,
      itemBuilder: (context, index) {
        final privilege = filteredPrivileges[index];
        return Column(
          children: [
            Image.asset(privilege.iconPath, width: 83.33.w, height: 83.33.h),
            SizedBox(height: 10.h),
            Text(
              privilege.title,
              style: TextStyle(fontSize: 25.sp, color: Colors.white),
            ),
            SizedBox(height: 14.h),
            Text(
              privilege.subtitle,
              style: TextStyle(
                fontSize: 23.sp,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 20.h,
          top: 20.h,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (Platform.isIOS) {
                  _handleIosPayment();
                } else if (Platform.isAndroid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Android 支付功能暂未实现')),
                  );
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('不支持的平台')));
                }
              },
              child: Container(
                width: 687.5.w,
                height: 100.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  borderRadius: BorderRadius.circular(83.r),
                ),
                child: Text(
                  '¥${_selectedPlan?.price ?? '0'} 立即开通',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '开通会员即视为同意',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 25.sp,
                  ),
                ),
                AgreementLink(
                  agreementKey: 'WEB_URL_VIP',
                  style: TextStyle(color: AppColors.lightRed, fontSize: 25.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
