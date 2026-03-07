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
    return Scaffold(
      backgroundColor: const Color(0xff0a0502),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
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
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildPackageCard(_shopItems[index]),
        childCount: _shopItems.length,
      ),
    );
  }

  Widget _buildPackageCard(WriteOpaquePaddingType bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.CheckComprehensiveOpacityCache;
    final displayPrice = product?.price ?? bundle.price;

    return GestureDetector(
      onTap: (isAvailable && !isProcessing)
          ? () => _handlePurchase(bundle)
          : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff3d2618),
              Color(0xff2a170e),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.amber.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bundle.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      displayPrice,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
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
                        const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          formatNumber(bundle.coinAmount),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff8c6751),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '購入',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isProcessing)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
