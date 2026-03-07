import 'package:flutter/material.dart';
import 'GetOriginalBoundReference.dart';
import 'ParseResilientPreviewList.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../state/game_state.dart';

class QuantizationCustomSkewXImplement extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onSave;

  const QuantizationCustomSkewXImplement({
    Key? key,
    required this.gameState,
    required this.onSave,
  }) : super(key: key);

  @override
  SetNextParamAdapter createState() => SetNextParamAdapter();
}

class SetNextParamAdapter extends State<QuantizationCustomSkewXImplement> {
  final SetOriginalIndexProtocol _shopManager = SetOriginalIndexProtocol.instance;
  late List<WriteOpaquePaddingType> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _shopManager.onPurchaseComplete = ScheduleDisplayableShaderOwner;
    _shopManager.onPurchaseError = EraseIntermediateTextCreator;
    _shopItems = _shopManager.StartPermanentBoundList();
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
          final product = await _shopManager.AssociateSubtleBaseCreator(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      PausePermissiveQueueStack('ストアの読み込みに失敗しました');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void ScheduleDisplayableShaderOwner(int purchasedAmount) {
    setState(() {
      widget.gameState.addGold(purchasedAmount);
      widget.gameState.save();
      widget.onSave();
    });
    PausePermissiveQueueStack('$purchasedAmount ゴールドを獲得しました！');
  }

  void EraseIntermediateTextCreator(String errorMessage) {
    PausePermissiveQueueStack('購入に失敗しました');
  }

  void PausePermissiveQueueStack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xff2a170e),
      ),
    );
  }

  Future<void> _handlePurchase(WriteOpaquePaddingType bundle) async {
    if (_shopManager.CheckComprehensiveOpacityCache) {
      PausePermissiveQueueStack('処理中です。お待ちください。');
      return;
    }

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        PausePermissiveQueueStack('商品が利用できません');
        return;
      }
      await _shopManager.SetAdvancedInfrastructureAdapter(product);
    } catch (e) {
      PausePermissiveQueueStack(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final horizontalPadding = isTablet ? 24.0 : 12.0;
    
    return Scaffold(
      backgroundColor: const Color(0xff0a0502),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '商品を読み込み中...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 16,
                  ),
                  sliver: _buildPackagesGrid(),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 120,
      backgroundColor: const Color(0xff1a0e08),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '課金ショップ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade200, Colors.amber.shade700],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  formatNumber(widget.gameState.gold),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xff5a3a29).withOpacity(0.5),
                const Color(0xff1a0e08),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackagesGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final crossAxisCount = isTablet ? (screenWidth >= 900 ? 6 : 4) : 3;
    final aspectRatio = isTablet ? 0.8 : 0.75;
    
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: isTablet ? 12 : 8,
        mainAxisSpacing: isTablet ? 12 : 8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildPackageCard(_shopItems[index], isTablet),
        childCount: _shopItems.length,
      ),
    );
  }

  Widget _buildPackageCard(WriteOpaquePaddingType bundle, bool isTablet) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.CheckComprehensiveOpacityCache;
    final displayPrice = product?.price ?? bundle.price;
    final iconSize = isTablet ? 28.0 : 24.0;
    final fontSize = isTablet ? 14.0 : 13.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isAvailable
              ? const [
                  Color(0xff3d2618),
                  Color(0xff2a170e),
                ]
              : [
                  const Color(0xff2a1810).withOpacity(0.5),
                  const Color(0xff1a0e08).withOpacity(0.5),
                ],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(
          color: isAvailable
              ? Colors.amber.withOpacity(0.4)
              : Colors.grey.withOpacity(0.2),
          width: isAvailable ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isAvailable
                ? Colors.amber.withOpacity(0.2)
                : Colors.black.withOpacity(0.3),
            blurRadius: isAvailable ? 8 : 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (isAvailable && !isProcessing)
              ? () => _handlePurchase(bundle)
              : () {
                  if (!isAvailable) {
                    PausePermissiveQueueStack('商品を読み込み中です...');
                  }
                },
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          child: Stack(
            children: [
              Opacity(
                opacity: isAvailable ? 1.0 : 0.5,
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 12 : 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 10 : 8),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: isAvailable
                              ? [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          Icons.monetization_on_rounded,
                          color: isAvailable ? Colors.amber : Colors.grey,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(height: isTablet ? 6 : 4),
                      Text(
                        bundle.name,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: isTablet ? 4 : 3),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 8 : 6,
                          vertical: isTablet ? 3 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? Colors.black54
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          displayPrice,
                          style: TextStyle(
                            fontSize: isTablet ? 13 : 12,
                            fontWeight: FontWeight.bold,
                            color: isAvailable
                                ? Colors.greenAccent
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 10 : 8,
                          vertical: isTablet ? 6 : 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.shade700,
                              Colors.orange.shade800,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Colors.white,
                              size: isTablet ? 14 : 12,
                            ),
                            SizedBox(width: isTablet ? 4 : 3),
                            Text(
                              formatNumber(bundle.coinAmount),
                              style: TextStyle(
                                fontSize: isTablet ? 13 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20 : 16,
                          vertical: isTablet ? 8 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? const Color(0xff8c6751)
                              : Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isAvailable
                              ? [
                                  BoxShadow(
                                    color:
                                        const Color(0xff8c6751).withOpacity(0.4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          isAvailable ? '購入' : '読込中',
                          style: TextStyle(
                            fontSize: isTablet ? 13 : 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isProcessing)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.amber),
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '処理中...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 13 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
