import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/api/vip_api.dart';
import 'package:zhenyu_flutter/models/vip_api_model.dart';
import 'package:zhenyu_flutter/screens/common/agreement_link.dart';
import 'package:zhenyu_flutter/screens/people/banner_handler.dart';
import 'package:zhenyu_flutter/screens/wallet/bill_screen.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/purchase_manager.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // 购买管理器
  final PurchaseManager _purchaseManager = PurchaseManager();

  RechargeConfigData? _rechargeConfigData;
  int? _activeId;

  @override
  void initState() {
    super.initState();

    // 初始化购买管理器
    _purchaseManager.initialize(
      callbacks: PurchaseCallbacks(
        onCanceled: () {
          // 用户取消支付，关闭loading对话框
          if (mounted) {
            Navigator.of(context).pop(); // 关闭loading对话框
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('已取消支付')));
          }
        },
        onError: (message) {
          // 支付失败，关闭loading对话框
          if (mounted) {
            Navigator.of(context).pop(); // 关闭loading对话框
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('支付失败: $message')));
          }
        },
        onSuccess: (wasActivelyProcessing) {
          // 支付成功，关闭loading对话框并刷新余额
          if (mounted) {
            Navigator.of(context).pop(); // 关闭loading对话框
            _fetchData();
            final successMessage = wasActivelyProcessing
                ? '充值成功！'
                : '检测到未完成的订单，已自动完成充值';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(successMessage)));
          }
        },
        onVerificationFailed: (message) {
          // 支付验证失败，关闭loading对话框
          if (mounted) {
            Navigator.of(context).pop(); // 关闭loading对话框
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('支付验证失败: $message')));
          }
        },
      ),
    );

    _fetchData();
  }

  @override
  void dispose() {
    _purchaseManager.dispose(); // 释放购买管理器资源
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final resp = await VipApi.getRechargeConfig();
      if (resp.code == 0 && resp.data != null) {
        setState(() {
          _rechargeConfigData = resp.data;
          if (_rechargeConfigData!.list != null &&
              _rechargeConfigData!.list!.isNotEmpty) {
            _activeId = _rechargeConfigData!.list!.first.id;
          }
        });
      }
    } catch (e) {
      // Handle error
      print('Failed to load recharge config: $e');
    }
  }

  // 处理金币充值购买
  Future<void> _handleCoinPurchase() async {
    // 检查是否选中了充值项
    if (_activeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择一个充值项')));
      return;
    }

    // 查找选中的充值项
    final selectedItem = _rechargeConfigData?.list?.firstWhere(
      (item) => item.id == _activeId,
      orElse: () => throw Exception('未找到选中的充值项'),
    );

    if (selectedItem == null ||
        selectedItem.iosId == null ||
        selectedItem.iosId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('充值项配置错误，请重试')));
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

    // 发起购买
    final error = await _purchaseManager.startPurchase(
      productId: selectedItem.iosId!,
      planId: selectedItem.id!,
      orderTradeType: 'COIN', // 金币充值类型
      userId: userId,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的钱包'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BillScreen()),
              );
            },
            child: const Text(
              '账单',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody() {
    if (_rechargeConfigData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 20),
          const StyledText.primaryBold('充值'),
          const SizedBox(height: 10),
          _buildRechargeList(),
          const SizedBox(height: 20),
          if (_rechargeConfigData?.bannerList?.isNotEmpty ?? false)
            _buildBanner(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/wallet/wallet_bg.png'), // 替换为你的背景图
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '当前金币余额：',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/wallet/coin.png', // 替换为你的金币图标
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '${_rechargeConfigData?.balanceAmount ?? 0}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRechargeList() {
    final list = _rechargeConfigData?.list ?? [];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final isActive = _activeId == item.id;
        return GestureDetector(
          onTap: () {
            setState(() {
              _activeId = item.id;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
              border: isActive
                  ? Border.all(color: AppColors.secondaryGradientEnd, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/wallet/coin.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText.primaryBold('${item.totalAmount ?? 0}金币'),
                          if (item.giveAmount != null && item.giveAmount! > 0)
                            Text(
                              'VIP充值额外赠送${item.giveAmount}金币',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '￥${item.price ?? ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryGradientStart,
                      ),
                    ),
                  ],
                ),
                if (item.tag == '1')
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/wallet/recommend.png', // 推荐标签图片
                      width: 50,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    // Banner a swiper.
    // For simplicity, I'm using a simple image here.
    // You can replace this with a PageView or a carousel package.
    final banner = _rechargeConfigData!.bannerList!.first;
    final bannerUrl = banner.bannerUrl;

    // 如果 banner URL 为空或无效，返回空容器
    if (bannerUrl == null || bannerUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        BannerHandler.handleBannerTap(context, banner);
      },
      child: Image.network(
        bannerUrl,
        errorBuilder: (context, error, stackTrace) {
          // 加载失败时显示占位符
          return Container(
            height: 150,
            color: Colors.grey[800],
            child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          // 加载中显示进度指示器
          return Container(
            height: 150,
            color: Colors.grey[800],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(color: AppColors.tabBarBackground),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: _handleCoinPurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryGradientStart,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              '立即购买',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledText(
                '充值即代表同意',
                fontSize: 24.sp,
                style: textStyleSecondary.copyWith(color: Colors.white),
              ),
              AgreementLink(
                agreementKey: 'WEB_URL_PAY',
                style: TextStyle(color: AppColors.lightRed, fontSize: 25.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
