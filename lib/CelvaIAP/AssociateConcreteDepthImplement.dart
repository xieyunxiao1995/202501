import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'QuantizerSpecifyOriginPool.dart';
import 'KeepSecondContractionHelper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetCrucialTagFilter extends StatefulWidget {
  const SetCrucialTagFilter({super.key});

  @override
  State<SetCrucialTagFilter> createState() => GetNextQuaternionList();
}

class GetNextQuaternionList extends State<SetCrucialTagFilter>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 3600;
  final GetIntuitiveGridDecorator _shopManager = GetIntuitiveGridDecorator.instance;
  late List<MarkOriginalAssetArray> _coinPacks;
  late List<MarkOriginalAssetArray> _vipPacks;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;
  late TabController _tabController;

  // Forest Breath Color Scheme
  static const primaryColor = Color(0xFF1A3C34);
  static const secondaryColor = Color(0xFFF2F0EB);
  static const accentColor = Color(0xFFD97D54);
  static const neutralColor = Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ContinueMainIntegrationTarget();
    _shopManager.onPurchaseComplete = StopUnactivatedRemainderArray;
    _shopManager.onPurchaseError = StartUniqueBufferCollection;

    final allItems = _shopManager.SetEphemeralGridObserver();
    _coinPacks = allItems.where((item) => item.category == 'coins').toList();
    _vipPacks = allItems.where((item) => item.category == 'vip').toList();

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      final allBundles = [..._coinPacks, ..._vipPacks];
      for (var bundle in allBundles) {
        try {
          final product = await _shopManager.SetSmartNormObserver(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      ContinueTensorCurveOwner('商店加载失败: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> ContinueMainIntegrationTarget() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 3600;
    });
  }

  Future<void> ShearHardIntensityDecorator() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  void StopUnactivatedRemainderArray(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      ShearHardIntensityDecorator();
    });
    ContinueTensorCurveOwner('成功充值 $purchasedAmount 金币！');
  }

  void StartUniqueBufferCollection(String errorMessage) {
    ContinueTensorCurveOwner('交易失败: $errorMessage');
  }

  void ContinueTensorCurveOwner(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _handlePurchase(MarkOriginalAssetArray bundle) async {
    if (_shopManager.QuitUnsortedLabelArray) {
      ContinueTensorCurveOwner('请等待当前交易完成');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        ContinueTensorCurveOwner('商品暂不可用，请稍后重试');
        return;
      }
      await _shopManager.SetIgnoredTagCollection(product);
    } catch (e) {
      ContinueTensorCurveOwner(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildBalanceCard(),
            _buildTabBar(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : TabBarView(
                      controller: _tabController,
                      children: [_buildCoinPacksView(), _buildVIPPacksView()],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
            color: primaryColor,
          ),
          const SizedBox(width: 8),
          const Text(
            '商城',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF2A5C4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(
              FontAwesomeIcons.coins,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '当前余额',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_coinBalance 金币',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '每次询问AI将消化1金币',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: neutralColor,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: '金币'),
          Tab(text: 'VIP会员'),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
      ),
    );
  }

  Widget _buildCoinPacksView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _coinPacks.length,
      itemBuilder: (context, index) => _buildCoinPackCard(_coinPacks[index]),
    );
  }

  Widget _buildVIPPacksView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _vipPacks.length,
      itemBuilder: (context, index) => _buildVIPPackCard(_vipPacks[index]),
    );
  }

  Widget _buildCoinPackCard(MarkOriginalAssetArray bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.QuitUnsortedLabelArray;
    final displayPrice = product?.price ?? bundle.price;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.2),
                    accentColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const FaIcon(
                FontAwesomeIcons.coins,
                color: accentColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.coins,
                        size: 16,
                        color: accentColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${bundle.coinAmount} 金币',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bundle.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    displayPrice,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildPurchaseButton(bundle, isAvailable, isProcessing),
          ],
        ),
      ),
    );
  }

  Widget _buildVIPPackCard(MarkOriginalAssetArray bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.QuitUnsortedLabelArray;
    final displayPrice = product?.price ?? bundle.price;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.05),
            primaryColor.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const FaIcon(
                FontAwesomeIcons.crown,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.crown,
                        size: 14,
                        color: Color(0xFFFFD700),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${bundle.vipDays}天VIP',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (bundle.coinAmount > 0) ...[
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.coins,
                          size: 12,
                          color: accentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '赠送 ${bundle.coinAmount} 金币',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    bundle.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    displayPrice,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildPurchaseButton(bundle, isAvailable, isProcessing),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseButton(
    MarkOriginalAssetArray bundle,
    bool isAvailable,
    bool isProcessing,
  ) {
    final isVIP = bundle.category == 'vip';

    if (isProcessing) {
      return Container(
        width: 90,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    // VIP专属金色按钮
    if (isVIP) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isAvailable && !isProcessing)
                ? () => _handlePurchase(bundle)
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.crown, color: Colors.white, size: 14),
                  SizedBox(width: 6),
                  Text(
                    '购买',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 普通金币包按钮
    return ElevatedButton(
      onPressed: (isAvailable && !isProcessing)
          ? () => _handlePurchase(bundle)
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text(
        '购买',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
