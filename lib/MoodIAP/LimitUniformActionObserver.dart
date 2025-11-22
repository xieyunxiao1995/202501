import 'package:flutter/material.dart';
import 'StartDirectlyNumberCache.dart';
import 'FindAgileIntensityArray.dart';
import 'InsteadRespectiveLeftHandler.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SetComprehensiveFormatFilter extends StatefulWidget {
  const SetComprehensiveFormatFilter({Key? key}) : super(key: key);

  @override
  StartConcreteScalabilityImplement createState() => StartConcreteScalabilityImplement();
}

class StartConcreteScalabilityImplement extends State<SetComprehensiveFormatFilter>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 2800;
  final EncapsulateEphemeralBoundFactory _shopManager = EncapsulateEphemeralBoundFactory.instance;
  late List<ResetIndependentBorderObserver> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;
  // Modern color scheme
  static const primaryColor = Color(0xFFFF6B81);
  static const secondaryColor = Color(0xFFFFD166);
  static const backgroundColor = Color(0xFF1A1A2E);
  static const surfaceColor = Color(0xFF16213E);

  late TabController _tabController;
  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    AddDirectSignDelegate();
    _shopManager.onPurchaseComplete = PauseCommonTailCreator;
    _shopManager.onPurchaseError = RenamePrevMapContainer;
    _shopItems = _shopManager.FinishDelicateNodeReference();
    _loadProducts();

    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.PrepareCrudeParamReference(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      InitializePrevColorHandler('Failed to load store: ${e.toString()}');
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

  Future<void> AddDirectSignDelegate() async {
    final balance = await GetAccordionGraphOwner.SetOtherTagObserver();
    setState(() {
      _coinBalance = balance;
    });
  }

  void PauseCommonTailCreator(int purchasedAmount) {
    AddDirectSignDelegate();
    InitializePrevColorHandler('购买成功！已添加 $purchasedAmount 个金币');
  }

  void RenamePrevMapContainer(String errorMessage) {
    InitializePrevColorHandler('购买失败: $errorMessage');
  }

  void InitializePrevColorHandler(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<void> _handlePurchase(ResetIndependentBorderObserver bundle) async {
    if (_shopManager.ReflectNewestResolverDecorator) {
      InitializePrevColorHandler('请等待当前交易完成');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        InitializePrevColorHandler('商品暂时不可用，请稍后再试');
        return;
      }
      await _shopManager.ClipRapidBottomObserver(product);
    } catch (e) {
      InitializePrevColorHandler(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          '商城',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          tabs: const [
            Tab(text: '金币'),
            Tab(text: '特惠套餐'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            )
          : Column(
              children: [
                _buildWalletBalance(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildCoinPackages(), _buildAllVipPackages()],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildWalletBalance() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E3B55), Color(0xFF1A2238)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              color: secondaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '我的金币',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_coinBalance',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '每10次使用ai助手将消耗1金币。',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPackages() {
    final coinBundles = _shopItems
        .where((bundle) => bundle.category == 'coins')
        .toList();

    return coinBundles.isEmpty
        ? const Center(
            child: Text('暂无可用的金币包', style: TextStyle(color: Colors.white)),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: coinBundles.length,
            itemBuilder: (context, index) => _buildCoinCard(coinBundles[index]),
          );
  }

  Widget _buildAllVipPackages() {
    // First get sale bundles (regardless of gender)
    final vipSaleBundles = _shopItems
        .where((bundle) => bundle.category == 'vip_sale')
        .toList();

    // Then get regular bundles sorted by price (lowest first)
    final vipBundles =
        _shopItems.where((bundle) => bundle.category == 'vip').toList()..sort(
          (a, b) => int.parse(
            a.price.replaceAll('¥', ''),
          ).compareTo(int.parse(b.price.replaceAll('¥', ''))),
        );

    // Combine sale bundles first, then regular bundles
    final allBundles = [...vipSaleBundles, ...vipBundles];

    return allBundles.isEmpty
        ? const Center(
            child: Text('暂无可用的特惠套餐', style: TextStyle(color: Colors.white)),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allBundles.length,
            itemBuilder: (context, index) => _buildVipCard(allBundles[index]),
          );
  }

  Widget _buildCoinCard(ResetIndependentBorderObserver bundle) {
    final bool isProcessing = _shopManager.ReflectNewestResolverDecorator;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monetization_on_rounded,
                      color: secondaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bundle.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bundle.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bundle.price,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: isProcessing
                          ? null
                          : () => _handlePurchase(bundle),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Buy',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVipCard(ResetIndependentBorderObserver bundle) {
    final bool isProcessing = _shopManager.ReflectNewestResolverDecorator;
    final bool isSale = bundle.category == 'vip_sale';
    final Color cardColor = isSale ? const Color(0xFF2D3250) : surfaceColor;
    final Color iconColor = isSale ? const Color(0xFFFFD700) : secondaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isSale
            ? Border.all(color: const Color(0xFFFFD700), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (isSale)
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (isSale)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '限时特惠',
                    style: TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.card_giftcard,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bundle.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bundle.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          bundle.price,
                          style: TextStyle(
                            color: isSale
                                ? const Color(0xFFFFD700)
                                : secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: isProcessing
                              ? null
                              : () => _handlePurchase(bundle),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSale
                                ? const Color(0xFFFFD700)
                                : primaryColor,
                            foregroundColor: isSale
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: isProcessing
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isSale ? Colors.black : Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Buy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      ),
    );
  }
}
