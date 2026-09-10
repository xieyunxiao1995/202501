import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FinishNextCenterManager.dart';
import 'CancelConcurrentVectorFactory.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 内购商店页面 - 全新卡片式设计
class InitializeKeyCoordProtocol extends StatefulWidget {
  const InitializeKeyCoordProtocol({Key? key}) : super(key: key);

  @override
  GetStandaloneParameterBase createState() => GetStandaloneParameterBase();
}

class GetStandaloneParameterBase extends State<InitializeKeyCoordProtocol> {
  int _coinBalance = 3500;
  final FreeSpecifyTextHelper _shopManager = FreeSpecifyTextHelper.instance;
  late List<DetachUniqueNameContainer> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    ContinuePrevTailCache();
    _shopManager.onPurchaseComplete = KeepProtectedTopManager;
    _shopManager.onPurchaseError = RestartNormalMenuInstance;
    _shopItems = _shopManager.GetConsultativeMeshCreator();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.WrapSubstantialAxisInstance(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      GenerateSmallPriorityArray('加载商店失败: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> ContinuePrevTailCache() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 3500;
    });
  }

  Future<void> SetCommonVariableInstance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  void KeepProtectedTopManager(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      SetCommonVariableInstance();
    });
    GenerateSmallPriorityArray('成功获得 $purchasedAmount 代币！');
  }

  void RestartNormalMenuInstance(String errorMessage) {
    GenerateSmallPriorityArray('交易失败: $errorMessage');
  }

  void GenerateSmallPriorityArray(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handlePurchase(DetachUniqueNameContainer bundle) async {
    if (_shopManager.LimitSustainableTempleCache) {
      GenerateSmallPriorityArray('请等待当前交易完成');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        GenerateSmallPriorityArray('产品暂不可用，请稍后重试');
        return;
      }
      await _shopManager.CancelGranularFormatFilter(product);
    } catch (e) {
      GenerateSmallPriorityArray(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final horizontalPadding = isSmallScreen ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading && _productDetails.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 顶部导航栏
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    '代币充值',
                    style: AppTextStyles.headline3.copyWith(
                      fontSize: isSmallScreen ? 16 : 18,
                    ),
                  ),
                  centerTitle: true,
                ),
                // 余额展示区
                SliverToBoxAdapter(
                  child: _buildBalanceSection(isSmallScreen, horizontalPadding),
                ),
                // 余额说明
                SliverToBoxAdapter(
                  child: _buildBalanceDescription(
                    isSmallScreen,
                    horizontalPadding,
                  ),
                ),
                // 商品列表
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    32,
                  ),
                  sliver: _buildProductList(isSmallScreen),
                ),
              ],
            ),
    );
  }

  /// 余额展示区
  Widget _buildBalanceSection(bool isSmallScreen, double horizontalPadding) {
    return Container(
      margin: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 8),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(isSmallScreen ? 18 : 22),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withAlpha(80),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // 金币图标
          Container(
            width: isSmallScreen ? 48 : 56,
            height: isSmallScreen ? 48 : 56,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.monetization_on_rounded,
              color: Colors.white,
              size: isSmallScreen ? 28 : 32,
            ),
          ),
          SizedBox(width: isSmallScreen ? 14 : 18),
          // 余额信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '当前余额',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: isSmallScreen ? 12 : 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$_coinBalance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 28 : 34,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '代币',
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
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

  /// 余额说明区
  Widget _buildBalanceDescription(
    bool isSmallScreen,
    double horizontalPadding,
  ) {
    return Container(
      margin: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.textSecondary,
            size: isSmallScreen ? 14 : 16,
          ),
          SizedBox(width: 6),
          Text(
            '每次与AI助手聊天将消耗1代币',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isSmallScreen ? 12 : 13,
            ),
          ),
        ],
      ),
    );
  }

  /// 商品列表
  Widget _buildProductList(bool isSmallScreen) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final bundle = _shopItems[index];
        return Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
          child: _buildProductCard(bundle, index, isSmallScreen),
        );
      }, childCount: _shopItems.length),
    );
  }

  /// 商品卡片
  Widget _buildProductCard(DetachUniqueNameContainer bundle, int index, bool isSmallScreen) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.LimitSustainableTempleCache;
    final displayPrice = product?.price ?? bundle.price;

    // 根据价格等级决定渐变色
    final gradients = [
      AppColors.cyanGradient, // 小额
      AppColors.oceanGradient, // 中小
      AppColors.purpleGradient, // 中等
      AppColors.pinkGradient, // 中大
      AppColors.warmGradient, // 大额
      AppColors.sunsetGradient, // 超大
    ];
    final gradient = gradients[index % gradients.length];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.surfaceLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 18),
        border: Border.all(
          color: AppColors.surfaceLight.withAlpha(100),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
          child: Row(
            children: [
              // 左侧金币图标区
              Container(
                width: isSmallScreen ? 52 : 60,
                height: isSmallScreen ? 52 : 60,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withAlpha(60),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${bundle.coinAmount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 11 : 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              // 中间信息区
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bundle.name,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: isSmallScreen ? 15 : 16,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: gradient.colors.first,
                          size: isSmallScreen ? 14 : 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '获得 ${bundle.coinAmount} 代币',
                          style: TextStyle(
                            color: gradient.colors.first,
                            fontSize: isSmallScreen ? 12 : 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    Text(
                      displayPrice,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: isSmallScreen ? 12 : 13,
                      ),
                    ),
                  ],
                ),
              ),
              // 右侧购买按钮
              GestureDetector(
                onTap: (isAvailable && !isProcessing)
                    ? () => _handlePurchase(bundle)
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : 20,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(
                      isSmallScreen ? 12 : 14,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withAlpha(60),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: isProcessing
                      ? SizedBox(
                          width: isSmallScreen ? 14 : 16,
                          height: isSmallScreen ? 14 : 16,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          '购买',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
